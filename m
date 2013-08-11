Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B1FF87CBE
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 18:23:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1C99304043
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 16:23:50 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	pLRZJNCxnGNRoGSf for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 16:23:48 -0700 (PDT)
Date: Mon, 12 Aug 2013 09:23:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** Re: [PATCH 5/14] xfsprogs: sync commit
	f5f3d9b016 completely
Message-ID: <20130811232342.GA12779@dastard>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com> <20130808210600.GN3111@sgi.com>
	<20130808212012.GS3111@sgi.com> <52041617.1020508@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52041617.1020508@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Thu, Aug 08, 2013 at 05:05:11PM -0500, Eric Sandeen wrote:
> On 8/8/13 4:20 PM, Ben Myers wrote:
> > TODO
> > 
> > ---
> >  include/xfs_dir2_format.h |    2 +-
> >  libxfs/xfs_dir2_data.c    |    2 ++
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > Index: b/include/xfs_dir2_format.h
> > ===================================================================
> > --- a/include/xfs_dir2_format.h	2013-08-06 12:52:58.830818621 -0500
> > +++ b/include/xfs_dir2_format.h	2013-08-06 12:53:38.550877679 -0500
> > @@ -247,7 +247,7 @@ typedef struct xfs_dir2_data_free {
> >   */
> >  typedef struct xfs_dir2_data_hdr {
> >  	__be32			magic;		/* XFS_DIR2_DATA_MAGIC or */
> > -	/* XFS_DIR2_BLOCK_MAGIC */
> > +						/* XFS_DIR2_BLOCK_MAGIC */
> >  	xfs_dir2_data_free_t	bestfree[XFS_DIR2_DATA_FD_COUNT];
> >  } xfs_dir2_data_hdr_t;
> >  
> > Index: b/libxfs/xfs_dir2_data.c
> > ===================================================================
> > --- a/libxfs/xfs_dir2_data.c	2013-08-06 12:54:17.540817693 -0500
> > +++ b/libxfs/xfs_dir2_data.c	2013-08-06 12:55:10.460877745 -0500
> > @@ -54,6 +54,7 @@ __xfs_dir2_data_check(
> >  	p = (char *)xfs_dir3_data_entry_p(hdr);
> >  
> >  	switch (be32_to_cpu(hdr->magic)) {
> > +		/* XXX bpm endian switch does not match commit */
> 
> in userspace, for some reason, doing it the "kernel way"
> 
> (i.e. 
> 
> switch (hdr->magic) {
> case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
> 
>  ...)
> 
> yields:
> 
> xfs_dir2_data.c:57: error: case label does not reduce to an integer constant

Right, and as I've already pointed out previously it's fixed in the
second series of patches by this:

[PATCH 06/49] libxfs: fix byte swapping on constants

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
