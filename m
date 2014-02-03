Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 702447FD6
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 10:12:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B22430406A
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 08:12:44 -0800 (PST)
Received: from internal-smtp4.wesleyan.edu (internal-smtp4.wesleyan.edu
	[129.133.6.200]) by cuda.sgi.com with ESMTP id EodGAgKc3BMyFFTo
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 03 Feb 2014 08:12:42 -0800 (PST)
From: "C. Morgan Hamill" <chamill@wesleyan.edu>
In-reply-to: <20140202212152.GP2212@dastard>
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <1391005406-sup-1881@al.wesleyan.edu>
	<52E91923.4070706@sandeen.net>
	<1391022066-sup-5863@al.wesleyan.edu>
	<52E99504.4030902@hardwarefreak.com>
	<1391090527-sup-4664@al.wesleyan.edu>
	<20140130202819.GO2212@dastard>
	<52EB3B96.7000103@hardwarefreak.com>
	<1391202273-sup-9265@al.wesleyan.edu>
	<52ED61C9.8060504@hardwarefreak.com>
	<20140202212152.GP2212@dastard>
Date: Mon, 03 Feb 2014 11:12:39 -0500
Message-Id: <1391443675-sup-1730@al.wesleyan.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs <xfs@oss.sgi.com>

Excerpts from Dave Chinner's message of 2014-02-02 16:21:52 -0500:
> On Sat, Feb 01, 2014 at 03:06:17PM -0600, Stan Hoeppner wrote:
> > On 1/31/2014 3:14 PM, C. Morgan Hamill wrote:
> > > So, basically, --dataalignment is my friend during pvcreate and
> > > lvcreate.
> > 
> > If the logical sector size reported by your RAID controller is 512
> > bytes, then "--dataalignment=9216s" should start your data section on a
> > RAID60 stripe boundary after the metadata section.
> > 
> > Tthe PhysicalExtentSize should probably also match the 4608KB stripe
> > width, but this is apparently not possible.  PhysicalExtentSize must be
> > a power of 2 value.  I don't know if or how this will affect XFS aligned
> > write out.  You'll need to consult with someone more knowledgeable of LVM.
> 
> You can't do single IOs of that size, anyway, so this is where the
> BBWC on the raid controller does it's magic and caches sequntial IOs
> until it has full stripe writes cached....

So I am probably missing something here, could you clarify?  Are you
saying that I can't do single IOs of that size (by which I take your
meaning to be IOs as small as 9216 sectors) because my RAID controllers
controller won't let me (i.e., it will cache anything smaller than the
stripe size anyway)?  Or are you saying that XFS with these given
settings won't make writes that small (which seems false, since I'm
essentially telling it to do writes of precisely that size).  I'm a bit
unclear on that.

In addition, does this in effect mean that when it comes to LVM, extent
size makes no difference for alignment purposes?  So I don't have to
worry about anything other that aligning the beginning and ending of
logical volumes, volume groups, etc. to 9216 sector multiples?

Thanks again!
--
Morgan Hamill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
