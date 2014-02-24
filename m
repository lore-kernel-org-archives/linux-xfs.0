Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 723D57F50
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 14:38:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F354DAC003
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 12:38:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nwxCCRrV9UVHfCs0 for <xfs@oss.sgi.com>;
	Mon, 24 Feb 2014 12:38:20 -0800 (PST)
Message-ID: <530BADBA.60402@sandeen.net>
Date: Mon, 24 Feb 2014 14:38:18 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: be honest about used inodes in statfs
References: <53067DC0.9040800@redhat.com>
	<20140224160047.GA13221@bfoster.bfoster>
In-Reply-To: <20140224160047.GA13221@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 2/24/14, 10:01 AM, Brian Foster wrote:
> On Thu, Feb 20, 2014 at 04:12:16PM -0600, Eric Sandeen wrote:
>> Because we have lazy counters, it's possible that we over-allocate
>> inodes past the maxicount (imaxpct) limit.  
>>
>> A previous commit,
>>
>>  2fe3366 xfs: ensure f_ffree returned by statfs() is non-negative
>>
>> stopped statfs from underflowing f_ffree in this case, but that
>> only happened when we mis-reported f_files, capped at maxicount.
>>
>> Change statfs to report the actual number of inodes allocated,
>> even if it is greater than maxicount.  It's reality.
>> Deal with it.  ;)
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index f317488..7c7a810 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -1083,7 +1083,6 @@ xfs_fs_statfs(
>>  	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
>>  	__uint64_t		fakeinos, id;
>>  	xfs_extlen_t		lsize;
>> -	__int64_t		ffree;
>>  
>>  	statp->f_type = XFS_SB_MAGIC;
>>  	statp->f_namelen = MAXNAMELEN - 1;
>> @@ -1100,17 +1099,24 @@ xfs_fs_statfs(
>>  	statp->f_blocks = sbp->sb_dblocks - lsize;
>>  	statp->f_bfree = statp->f_bavail =
>>  				sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
>> +
>> +	/* Potential number of new inodes in free blocks */
>>  	fakeinos = statp->f_bfree << sbp->sb_inopblog;
>> +	/* Total possible files is current inodes + potential new inodes */
>>  	statp->f_files =
>>  	    MIN(sbp->sb_icount + fakeinos, (__uint64_t)XFS_MAXINUMBER);
>> +	/* Unless we have maxicount!  Then cap it at that */
>>  	if (mp->m_maxicount)
>>  		statp->f_files = min_t(typeof(statp->f_files),
>>  					statp->f_files,
>>  					mp->m_maxicount);
>>  
>> -	/* make sure statp->f_ffree does not underflow */
>> -	ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
>> -	statp->f_ffree = max_t(__int64_t, ffree, 0);
>> +	/* But if we already managed to allocate more, let's be honest */
>> +	statp->f_files = max_t(typeof(statp->f_files),
>> +				sbp->sb_icount,
>> +				statp->f_files);
>> +
>> +	statp->f_ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
> 
> Hi Eric,
> 
> Would something like the following be equivalent (and accurate?):
> 
>         /*
>          * Potential number of new inodes in free blocks, limited by maxicount.
>          */
>         fakeinos = statp->f_bfree << sbp->sb_inopblog;
>         if (mp->m_maxicount)
>                 fakeinos = mp->m_maxicount > sbp->sb_icount ?
>                         MIN(mp->m_maxicount - sbp->sb_icount, fakeinos) : 0;
>         /* Total possible files is current inodes + potential new inodes */
>         statp->f_files = MIN(sbp->sb_icount + fakeinos,
>                                 (__uint64_t) XFS_MAXINUMBER);
> 
>         statp->f_ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);

Yeah, I think that's better.  Want to send that patch?  You did the hard work of
making it look sane.  ;)

-Eric

> Brian
> 
>>  
>>  	spin_unlock(&mp->m_sb_lock);
>>  
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
	

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
