Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 950A37F52
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 15:02:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 692138F8052
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 13:01:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Yb1SgYVicTC9CONI for
	<xfs@oss.sgi.com>; Wed, 23 Apr 2014 13:01:45 -0700 (PDT)
Date: Wed, 23 Apr 2014 16:01:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 11/20] xfsprogs/mkfs: finobt mkfs support
Message-ID: <20140423200135.GC5225@bfoster.bfoster>
References: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
	<1397146270-42993-12-git-send-email-bfoster@redhat.com>
	<20140423060352.GL15995@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140423060352.GL15995@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 23, 2014 at 04:03:53PM +1000, Dave Chinner wrote:
> On Thu, Apr 10, 2014 at 12:11:01PM -0400, Brian Foster wrote:
> > Add the 'finobt' metadata option to mkfs to format an fs with free
> > inode btree support. If enabled, initialize the associated AGI
> > header fields and btree root block.
> > 
> > Also, do the initialization of the superblock version and feature
> > bits (including the new finobt flag) a bit earlier. These fields
> > must now be initialized prior to the use of XFS_PREALLOC_BLOCKS(),
> > as the latter returns a value that depends on whether a finobt root
> > btree block is reserved.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> $ sudo mkfs.xfs -f -mcrc=1,finobt=1 -m crc=0 -d size=128m /dev/ram1
> meta-data=/dev/ram1              isize=256    agcount=4, agsize=8192 blks
>          =                       sectsz=512   attr=2, projid32bit=1
> 	 =                       crc=0        finobt=1
> 	                         ^^^^^        ^^^^^^^^
> .....
> $ mount /dev/ram1 /mnt/scratch
> [ 4727.269080] XFS (ram1): Mounting Filesystem
> [ 4727.270077] XFS (ram1): Log inconsistent or not a log (last==0, first!=1)
> [ 4727.271227] XFS (ram1): empty log check failed
> [ 4727.271970] XFS (ram1): log mount/recovery failed: error 22
> [ 4727.273097] XFS (ram1): log mount failed
> 
> If "-mcrc=0" is seen on the command line, it needs to turn off
> finobt....
> 
> xfs/001 and xfs/002 trip over this when run like:
> 
> $ MKFS_OPTIONS="-mcrc=1,finobt=1" ./check xfs/00[12]
> 
> Otherwise, everything seems to be working ;)
> 

Yeah, I've hit this. Which reminds me... I should probably detect this
and fail outright in mkfs as well.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
