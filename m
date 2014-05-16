Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 412A97F4E
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 18:02:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5A8AAC005
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 16:02:24 -0700 (PDT)
Received: from a.painless.aa.net.uk (a.painless.aa.net.uk [81.187.30.51]) by
	cuda.sgi.com with ESMTP id 5m3OqqMToWlCAANJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 May 2014 16:02:22 -0700 (PDT)
From: Adam Sampson <ats@offog.org>
Subject: Re: [ANNOUNCE] xfsprogs: v3.2.0 released!
References: <20140516055650.GF26353@dastard>
Date: Sat, 17 May 2014 00:02:15 +0100
In-Reply-To: <20140516055650.GF26353@dastard> (Dave Chinner's message of "Fri,
	16 May 2014 15:56:50 +1000")
Message-ID: <y2a8uq11g5k.fsf@cartman.at.offog.org>
MIME-Version: 1.0
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

Dave Chinner <david@fromorbit.com> writes:

> It is my pleasure to announce the release of v3.2.0 of the xfsprogs
> package.

If this is built with DEBUG= (i.e. not defaulting to DEBUG=-NDEBUG),
several source files fail to compile -- it looks like there are a number
of assertions that haven't been updated for changes in the code:

logitem.c:53:24: error: 'struct xfs_buf' has no member named 'b_map_count'
    ASSERT(blip->bli_buf->b_map_count == nmaps);
                        ^
trans.c:52:12: error: 'struct xfs_log_item' has no member named 'li_ailp'
  ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
            ^
trans.c:52:37: error: 'xfs_mount_t' has no member named 'm_ail'
  ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
                                     ^
util.c:253:40: error: 'mp' undeclared (first use in this function)
   ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid));
                                        ^
util.c:401:33: error: 'xfs_ifork_t' has no member named 'if_ext_max'
   ip->i_d.di_nextents > ip->i_df.if_ext_max);
                                 ^
xfs_btree.c:545:2: warning: implicit declaration of function 'xfs_buf_geterror' [-Wimplicit-function-declaration]
  ASSERT(!xfs_buf_geterror(bp));
  ^
xfs_btree.c:2052:21: error: 'const struct xfs_btree_ops' has no member named 'keys_inorder'
   ASSERT(cur->bc_ops->keys_inorder(cur,
                     ^
xfs_btree.c:2064:21: error: 'const struct xfs_btree_ops' has no member named 'recs_inorder'
   ASSERT(cur->bc_ops->recs_inorder(cur,
                     ^
xfs_btree.c:2240:21: error: 'const struct xfs_btree_ops' has no member named 'keys_inorder'
   ASSERT(cur->bc_ops->keys_inorder(cur, rkp,
                     ^
xfs_btree.c:2259:21: error: 'const struct xfs_btree_ops' has no member named 'recs_inorder'
   ASSERT(cur->bc_ops->recs_inorder(cur, rrp,
                     ^
xfs_dir2_node.c:1053:36: error: 'oldstale' undeclared (first use in this function)
  ASSERT(hdr1.stale + hdr2.stale == oldstale);
                                    ^
xfs_inode_fork.c:728:2: warning: implicit declaration of function 'xfs_isilocked' [-Wimplicit-function-declaration]
  ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
  ^
xfs_inode_fork.c:728:42: error: 'XFS_ILOCK_SHARED' undeclared (first use in this function)
  ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
                                          ^

(Errors from current Git, built with GCC 4.9. You also get a good crop
of warnings if you build it with clang 3.4.1's scan-build, which'd be
worth checking out in case there's anything serious there.)

> A signed gzipped-tar archive of the source code is available here:

It's signed with a different key from the previous release -- it'd be
useful to mention the key ID in the announcement so that it can be
verified.

Cheers,

-- 
Adam Sampson <ats@offog.org>                         <http://offog.org/>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
