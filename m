Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1C0tVSj169251 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 18:55:32 -0600
Message-ID: <49937458.2000500@sgi.com>
Date: Thu, 12 Feb 2009 11:59:04 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Don't reset di_format in xfs_ifree()
References: <49921B3E.8040406@sgi.com> <20090211092020.GR8830@disturbed>
In-Reply-To: <20090211092020.GR8830@disturbed>
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Wed, Feb 11, 2009 at 11:26:38AM +1100, Lachlan McIlroy wrote:
>> I hit a panic while flushing a reclaimed inode that is fairly
>> reproducible under load.
>>
>> In xfs_iflush_fork() we're led to believe that there are extents
>> on this inode but there aren't any.  Actually the inode was a
>> directory.  I added some debugging to xfs_ifree() and found
>> that di_format was XFS_DINODE_FMT_LOCAL and got reset to
>> XFS_DINODE_FMT_EXTENTS and this has confused the code in
>> xfs_iflush_fork().
> 
> Wow. I wonder why we've never seen this before - it's not a new
> problem AFAICT.
> 
> A freed inode is supposed to have both forks in extent format
> with zero extents - it means the fork is empty. Changing it
> to local format means that it is not in the expected state
> for a subsequent create.
> 
> I think the problem may be that the size of the fork has not been
> reset to zero, not that format has been changed. If it was in local
> format, the truncates prior to freeing would not have done anything
> and the size of the data/attr fork would still be non-zero.  Hence
> if the fork is then changed to extent format, xfs_iextents_copy()
> will be triggered from xfs_iflush_fork() and you'd see something
> like the confusion you are seeing.
> 
> Hence I think we should be ensuring the fork size is set to zero for
> both the attr/data fork when the format is changed, not removing
> the change of type....

Yes, I agree.  I just don't have the time to hunt it down.  I see
there's a call to xfs_idestroy_fork() in xfs_ireclaim() for directories
but xfs_ireclaim() gets called after xfs_iflush() in xfs_reclaim_inode().
Might also need something like:

@@ -2445,6 +2447,7 @@ xfs_idestroy_fork(
                         kmem_free(ifp->if_u1.if_data);
                         ifp->if_u1.if_data = NULL;
                         ifp->if_real_bytes = 0;
+                       ifp->if_bytes = 0;
                 }
         } else if ((ifp->if_flags & XFS_IFEXTENTS) &&
                    ((ifp->if_flags & XFS_IFEXTIREC) ||

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
