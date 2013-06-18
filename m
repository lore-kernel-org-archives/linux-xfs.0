Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6096E7CBF
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 16:42:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 32DFB8F8037
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 14:42:29 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	sfdc8YUZst4NED9c for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 14:42:27 -0700 (PDT)
Date: Wed, 19 Jun 2013 07:42:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 27/27] xfs: fix issues that cause userspace warnings
Message-ID: <20130618214225.GZ29338@dastard>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-28-git-send-email-david@fromorbit.com>
	<51BF6447.9060608@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51BF6447.9060608@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 17, 2013 at 03:32:23PM -0400, Brian Foster wrote:
> On 06/12/2013 06:22 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Some of the code shared with userspace causes compilation warnings
> > from things turned off in the kernel code, such as differences in
> > variable signedness. Fix those issues.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_attr_remote.c |    8 ++++----
> >  fs/xfs/xfs_bmap.c        |    3 ---
> >  fs/xfs/xfs_da_btree.c    |    6 +++---
> >  fs/xfs/xfs_dir2_node.c   |    2 ++
> >  fs/xfs/xfs_ialloc.c      |    2 +-
> >  fs/xfs/xfs_rtalloc.c     |    4 ++--
> >  6 files changed, 12 insertions(+), 13 deletions(-)
> > 
> ...
> >  
> > diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> > index 319d9e4..9831eff 100644
> > --- a/fs/xfs/xfs_ialloc.c
> > +++ b/fs/xfs/xfs_ialloc.c
> > @@ -1342,7 +1342,7 @@ xfs_imap(
> >  	xfs_agblock_t	cluster_agbno;	/* first block in inode cluster */
> >  	int		error;	/* error code */
> >  	int		offset;	/* index of inode in its buffer */
> > -	int		offset_agbno;	/* blks from chunk start to inode */
> > +	xfs_agino_t	offset_agbno;	/* blks from chunk start to inode */
> 
> xfs_agblock_t ?

Good catch. Brainfart - inode allocation code, must be an agino :P

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
