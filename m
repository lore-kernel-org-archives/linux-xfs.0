Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Sep 2008 20:47:09 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8M3kteu007467
	for <xfs@oss.sgi.com>; Sun, 21 Sep 2008 20:46:55 -0700
Message-ID: <48D71797.6090407@sgi.com>
Date: Mon, 22 Sep 2008 13:57:11 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Unlock inode before calling xfs_idestroy()
References: <48D3193C.6060201@sgi.com> <20080919072603.GA26903@infradead.org>
In-Reply-To: <20080919072603.GA26903@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Christoph Hellwig wrote:
> On Fri, Sep 19, 2008 at 01:15:08PM +1000, Lachlan McIlroy wrote:
>> Lock debugging reported the ilock was being destroyed
>> without being unlocked.
>>
>> --- a/fs/xfs/xfs_iget.c	2008-09-19 13:03:57.000000000 +1000
>> +++ b/fs/xfs/xfs_iget.c	2008-09-19 13:12:38.000000000 +1000
>> @@ -214,6 +214,7 @@ finish_inode:
>> 		xfs_ilock(ip, lock_flags);
>>
>> 	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
>> +		xfs_iunlock(ip, lock_flags);
>> 		xfs_idestroy(ip);
>> 		xfs_put_perag(mp, pag);
>> 		return ENOENT;
>> @@ -224,6 +225,7 @@ finish_inode:
>> 	 * write spinlock.
>> 	 */
>> 	if (radix_tree_preload(GFP_KERNEL)) {
>> +		xfs_iunlock(ip, lock_flags);
>> 		xfs_idestroy(ip);
>> 		delay(1);
>> 		goto again;
> 
> Just move the xfs_ilock call after these two statements, there is no
> need to have it locked before inserting it into the radix tree.
Okay, thanks.  I thought we may need it locked while doing the mode
check so I left it as is.

> 
>> @@ -239,6 +241,7 @@ finish_inode:
>> 		BUG_ON(error != -EEXIST);
>> 		write_unlock(&pag->pag_ici_lock);
>> 		radix_tree_preload_end();
>> +		xfs_iunlock(ip, lock_flags);
>> 		xfs_idestroy(ip);
>> 		XFS_STATS_INC(xs_ig_dup);
>> 		goto again;
> 
> But here we still need the fix.  But as Tim mention we need to check
> for lock_flags != 0 first.  Long-term it might make sense to just make
> xfs_iunlock a no-op if lock_flags == 0, but let's do that separately.
> 
