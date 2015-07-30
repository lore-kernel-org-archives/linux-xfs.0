Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 97CFC7F7C
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 14:04:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 819EE8F8033
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 12:04:12 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id sNVu7C7BPowK7gjD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Jul 2015 12:04:10 -0700 (PDT)
Date: Thu, 30 Jul 2015 12:04:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/24] xfs: add refcount btree stats infrastructure
Message-ID: <20150730190403.GG10043@birch.djwong.org>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
	<20150729223318.17414.21535.stgit@birch.djwong.org>
	<20150730003427.GG16638@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150730003427.GG16638@dastard>
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

On Thu, Jul 30, 2015 at 10:34:27AM +1000, Dave Chinner wrote:
> On Wed, Jul 29, 2015 at 03:33:18PM -0700, Darrick J. Wong wrote:
> > The refcount btree presents the same stats as the other btrees, so
> > add all the code for that now.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_btree.h |    4 ++--
> >  fs/xfs/xfs_stats.c        |    1 +
> >  fs/xfs/xfs_stats.h        |   18 +++++++++++++++++-
> >  3 files changed, 20 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index 8d9fffe..b747c86 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -99,7 +99,7 @@ do {    \
> >  	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
> >  	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
> >  	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(rmap, stat); break;	\
> > -	case XFS_BTNUM_REFC: break;	\
> > +	case XFS_BTNUM_REFC: __XFS_BTREE_STATS_INC(refcbt, stat); break; \
> >  	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
> >  	}       \
> >  } while (0)
> > @@ -115,7 +115,7 @@ do {    \
> >  	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
> >  	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
> >  	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_ADD(rmap, stat, val); break; \
> > -	case XFS_BTNUM_REFC: break;	\
> > +	case XFS_BTNUM_REFC: __XFS_BTREE_STATS_INC(refcbt, stat); break; \
> 
> __XFS_BTREE_STATS_ADD()

Good catch; fixed.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
