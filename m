Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 33B9C7FF0
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 15:41:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2CBDC8F8037
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 13:41:36 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	B8GwjUC43DxYvpMJ for <xfs@oss.sgi.com>;
	Mon, 03 Feb 2014 13:41:33 -0800 (PST)
Date: Tue, 4 Feb 2014 08:41:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question regarding XFS on LVM over hardware RAID.
Message-ID: <20140203214128.GR13997@dastard>
References: <52E91923.4070706@sandeen.net>
	<1391022066-sup-5863@al.wesleyan.edu>
	<52E99504.4030902@hardwarefreak.com>
	<1391090527-sup-4664@al.wesleyan.edu>
	<20140130202819.GO2212@dastard>
	<52EB3B96.7000103@hardwarefreak.com>
	<1391202273-sup-9265@al.wesleyan.edu>
	<52ED61C9.8060504@hardwarefreak.com>
	<20140202212152.GP2212@dastard>
	<1391443675-sup-1730@al.wesleyan.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391443675-sup-1730@al.wesleyan.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "C. Morgan Hamill" <chamill@wesleyan.edu>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs <xfs@oss.sgi.com>

On Mon, Feb 03, 2014 at 11:12:39AM -0500, C. Morgan Hamill wrote:
> Excerpts from Dave Chinner's message of 2014-02-02 16:21:52 -0500:
> > On Sat, Feb 01, 2014 at 03:06:17PM -0600, Stan Hoeppner wrote:
> > > On 1/31/2014 3:14 PM, C. Morgan Hamill wrote:
> > > > So, basically, --dataalignment is my friend during pvcreate and
> > > > lvcreate.
> > > 
> > > If the logical sector size reported by your RAID controller is 512
> > > bytes, then "--dataalignment=9216s" should start your data section on a
> > > RAID60 stripe boundary after the metadata section.
> > > 
> > > Tthe PhysicalExtentSize should probably also match the 4608KB stripe
> > > width, but this is apparently not possible.  PhysicalExtentSize must be
> > > a power of 2 value.  I don't know if or how this will affect XFS aligned
> > > write out.  You'll need to consult with someone more knowledgeable of LVM.
> > 
> > You can't do single IOs of that size, anyway, so this is where the
> > BBWC on the raid controller does it's magic and caches sequntial IOs
> > until it has full stripe writes cached....
> 
> So I am probably missing something here, could you clarify?  Are you
> saying that I can't do single IOs of that size (by which I take your
> meaning to be IOs as small as 9216 sectors) because my RAID controllers
> controller won't let me (i.e., it will cache anything smaller than the
> stripe size anyway)?

Typical limitations on IO size are the size of the hardware DMA
scatter-gather rings of the HBA/raid controller. For example, the
two hardware RAID controllers in my largest test box have
limitations of 70 and 80 segments and maximum IO sizes of 280k and
320k.

And looking at the IO being dispatched with blktrace, I see the
maximum size is:

  8,80   2       61     0.769857112 44866  D  WS 12423408 + 560 [qemu-system-x86]
  8,80   2       71     0.769877563 44866  D  WS 12423968 + 560 [qemu-system-x86]
  8,80   2       72     0.769889767 44866  D  WS 12424528 + 560 [qemu-system-x86]
                                                            ^^^

560 sectors or 280k. So for this hardware, sequential 280k writes
are hitting the BBWC. And because they are sequential, the BBWC is
writing them back as fully stripe writes after aggregating them in
NVRAM. Hence there are no performance diminishing RMW cycles
occurring, even though the individual IO size is much smaller than
the stripe unit/width....

> Or are you saying that XFS with these given
> settings won't make writes that small (which seems false, since I'm
> essentially telling it to do writes of precisely that size).  I'm a bit
> unclear on that.

What su/sw tells XFs is how to align allocation of files, so that
when we dispatch sequential IO to that file it is aligned to the
underlying storage because the extents that the filesystem allocated
for it are aligned. This means that if you write exactly one stripe
width of data, it will hit each disk exactly once. It might take 10
IOs to get the data to the storage, but it will only hit each disk
once.

The function of the stripe cache (in software raid) and the BBWC (in
hardware RAID) is to prevent RMW cycles while the
filesystem/hardware is still flinging data at the RAID lun. Only
once the controller has complete stripe widths will it calculate
parity and write back the data, thereby avoiding a RMW cycle....

> In addition, does this in effect mean that when it comes to LVM, extent
> size makes no difference for alignment purposes?  So I don't have to
> worry about anything other that aligning the beginning and ending of
> logical volumes, volume groups, etc. to 9216 sector multiples?

No, you still have to align everything to the underlying storage so
that the filesystem on top of the volumes is correctly aligned.
Where the data will be written (i.e. howthe filesystem allocates the
underlying blocks) determines the IO alignment of sequential/large
user IOs, and that matters far more than the size of the sequntial
IOs the kernel uses to write the data.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
