Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1CMXXMi089713 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 16:33:33 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDCE3118F3B
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 14:32:56 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	CDQY6hpErENDLbk2 for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2009 14:32:56 -0800 (PST)
Date: Fri, 13 Feb 2009 09:32:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Don't reset di_format in xfs_ifree()
Message-ID: <20090212223253.GV8830@disturbed>
References: <49921B3E.8040406@sgi.com> <20090211092020.GR8830@disturbed>
	<49937458.2000500@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49937458.2000500@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 12, 2009 at 11:59:04AM +1100, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Wed, Feb 11, 2009 at 11:26:38AM +1100, Lachlan McIlroy wrote:
>>> I hit a panic while flushing a reclaimed inode that is fairly
>>> reproducible under load.
>>>
>>> In xfs_iflush_fork() we're led to believe that there are extents
>>> on this inode but there aren't any.  Actually the inode was a
>>> directory.  I added some debugging to xfs_ifree() and found
>>> that di_format was XFS_DINODE_FMT_LOCAL and got reset to
>>> XFS_DINODE_FMT_EXTENTS and this has confused the code in
>>> xfs_iflush_fork().
....
>> I think the problem may be that the size of the fork has not been
>> reset to zero, not that format has been changed. If it was in local
>> format, the truncates prior to freeing would not have done anything
>> and the size of the data/attr fork would still be non-zero.  Hence
>> if the fork is then changed to extent format, xfs_iextents_copy()
>> will be triggered from xfs_iflush_fork() and you'd see something
>> like the confusion you are seeing.
>>
>> Hence I think we should be ensuring the fork size is set to zero for
>> both the attr/data fork when the format is changed, not removing
>> the change of type....
>
> Yes, I agree.  I just don't have the time to hunt it down.  I see
> there's a call to xfs_idestroy_fork() in xfs_ireclaim() for directories
> but xfs_ireclaim() gets called after xfs_iflush() in xfs_reclaim_inode().

I suspect it should be in xfs_inactive() if we are in local format.
This is what happens with the attribute fork.  I think that is where
we need something like:

	if ((ip->i_d.di_mode & S_IFMT) == S_IFDIR &&
	    ip->i_d.di_nextents == 0)
		xfs_idestroy_fork(ip, XFS_DATA_FORK);

> Might also need something like:
>
> @@ -2445,6 +2447,7 @@ xfs_idestroy_fork(
>                         kmem_free(ifp->if_u1.if_data);
>                         ifp->if_u1.if_data = NULL;
>                         ifp->if_real_bytes = 0;
> +                       ifp->if_bytes = 0;
>                 }
>         } else if ((ifp->if_flags & XFS_IFEXTENTS) &&
>                    ((ifp->if_flags & XFS_IFEXTIREC) ||

Looking at that, the whole if (local) {} else if (extent/btree)
code could probably be replaced with a single call to
xfs_iext_destroy() as it does the cleanup correctly in both cases,
anyway....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
