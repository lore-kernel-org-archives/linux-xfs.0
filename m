Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Sep 2008 20:42:11 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8M3g21A006809
	for <xfs@oss.sgi.com>; Sun, 21 Sep 2008 20:42:03 -0700
Message-ID: <48D71676.5080808@sgi.com>
Date: Mon, 22 Sep 2008 13:52:22 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Unlock inode before calling xfs_idestroy()
References: <48D3193C.6060201@sgi.com> <48D326A7.6070508@sgi.com>
In-Reply-To: <48D326A7.6070508@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Timothy Shimmin wrote:
> Lachlan McIlroy wrote:
>> Lock debugging reported the ilock was being destroyed
>> without being unlocked.
>>
>> --- a/fs/xfs/xfs_iget.c    2008-09-19 13:03:57.000000000 +1000
>> +++ b/fs/xfs/xfs_iget.c    2008-09-19 13:12:38.000000000 +1000
>> @@ -214,6 +214,7 @@ finish_inode:
>>         xfs_ilock(ip, lock_flags);
>>
>>     if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
>> +        xfs_iunlock(ip, lock_flags);
>>         xfs_idestroy(ip);
>>         xfs_put_perag(mp, pag);
>>         return ENOENT;
>> @@ -224,6 +225,7 @@ finish_inode:
>>      * write spinlock.
>>      */
>>     if (radix_tree_preload(GFP_KERNEL)) {
>> +        xfs_iunlock(ip, lock_flags);
>>         xfs_idestroy(ip);
>>         delay(1);
>>         goto again;
>> @@ -239,6 +241,7 @@ finish_inode:
>>         BUG_ON(error != -EEXIST);
>>         write_unlock(&pag->pag_ici_lock);
>>         radix_tree_preload_end();
>> +        xfs_iunlock(ip, lock_flags);
>>         xfs_idestroy(ip);
>>         XFS_STATS_INC(xs_ig_dup);
>>         goto again;
> 
> I'm just wondering about the case where lock_flags==0
> and the inode is not locked.
> I think it would fail an assert in xfs_iunlock().
Good catch Tim, thanks.

> 
> 
> --Tim
> 
> 
> 	if (lock_flags)
> 		xfs_ilock(ip, lock_flags);
> 
> 	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
> 		xfs_iunlock(ip, lock_flags);
> 		xfs_idestroy(ip);
> 		xfs_put_perag(mp, pag);
> 		return ENOENT;
> 	}
> 
> void
> xfs_iunlock(
>         xfs_inode_t             *ip,
>         uint                    lock_flags)
> {
>         /*
>          * You can't set both SHARED and EXCL for the same lock,
>          * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
>          * and XFS_ILOCK_EXCL are valid values to set in lock_flags.
>          */
>         ASSERT((lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) !=
>                (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
>         ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
>                (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
>         ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_IUNLOCK_NONOTIFY |
>                         XFS_LOCK_DEP_MASK)) == 0);
>         ASSERT(lock_flags != 0);
> 
> 
