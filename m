Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E8597F5D
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 15:32:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D00588F806F
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 13:32:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zC2h2mz6LN9BiiEu for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2015 13:32:21 -0700 (PDT)
Date: Tue, 17 Mar 2015 07:32:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfs: Supporting Host Aware SMR Drives
Message-ID: <20150316203207.GD28557@dastard>
References: <20150316060020.GB28557@dastard>
	<1426519733.4000.11.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1426519733.4000.11.camel@HansenPartnership.com>
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
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-fsdevel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Mar 16, 2015 at 11:28:53AM -0400, James Bottomley wrote:
> [cc to linux-scsi added since this seems relevant]
> On Mon, 2015-03-16 at 17:00 +1100, Dave Chinner wrote:
> > Hi Folks,
> > 
> > As I told many people at Vault last week, I wrote a document
> > outlining how we should modify the on-disk structures of XFS to
> > support host aware SMR drives on the (long) plane flights to Boston.
> > 
> > TL;DR: not a lot of change to the XFS kernel code is required, no
> > specific SMR awareness is needed by the kernel code.  Only
> > relatively minor tweaks to the on-disk format will be needed and
> > most of the userspace changes are relatively straight forward, too.
> > 
> > The source for that document can be found in this git tree here:
> > 
> > git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation
> > 
> > in the file design/xfs-smr-structure.asciidoc. Alternatively,
> > pull it straight from cgit:
> > 
> > https://git.kernel.org/cgit/fs/xfs/xfs-documentation.git/tree/design/xfs-smr-structure.asciidoc
> > 
> > Or there is a pdf version built from the current TOT on the xfs.org
> > wiki here:
> > 
> > http://xfs.org/index.php/Host_Aware_SMR_architecture
> > 
> > Happy reading!
> 
> I don't think it would have caused too much heartache to post the entire
> doc to the list, but anyway
> 
> The first is a meta question: What happened to the idea of separating
> the fs block allocator from filesystems?  It looks like a lot of the
> updates could be duplicated into other filesystems, so it might be a
> very opportune time to think about this.

Which requires a complete rework of the fs/block layer. That's the
long term goal, but we aren't going to be there for a few years yet.
Hust look at how long it's taken for copy offload (which is trivial
compared to allocation offload) to be implemented....

> > === RAID on SMR....
> > 
> > How does RAID work with SMR, and exactly what does that look like to
> > the filesystem?
> > 
> > How does libzbc work with RAID given it is implemented through the scsi ioctl
> > interface?
> 
> Probably need to cc dm-devel here.  However, I think we're all agreed
> this is RAID across multiple devices, rather than within a single
> device?  In which case we just need a way of ensuring identical zoning
> on the raided devices and what you get is either a standard zone (for
> mirror) or a larger zone (for hamming etc).

Any sort of RAID is a bloody hard problem, hence the fact that I'm
designing a solution for a filesystem on top of an entire bare
drive. I'm not trying to solve every use case in the world, just the
one where the drive manufactures think SMR will be mostly used: the
back end of "never delete" distributed storage environments....

We can't wait for years for infrastructure layers to catch up in the
brave new world of shipping SMR drives. We may not like them, but we
have to make stuff work. I'm not trying to solve every problem - I'm
just tryin gto address the biggest use case I see for SMR devices
and it just so happens that XFS is already used pervasively in that
same use case, mostly within the same "no raid, fs per entire
device" constraints as I've documented for this proposal...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
