Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750738AbeBUGaY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Feb 2018 01:30:24 -0500
Subject: Re: [PATCH] xfs: Remove duplicated check
References: <1519134782-10062-1-git-send-email-nborisov@suse.com>
 <20180220211114.GC7000@dastard>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e23b32c5-8b5f-c0ff-c8b9-db383dd775fb@suse.com>
Date: Wed, 21 Feb 2018 08:30:21 +0200
MIME-Version: 1.0
In-Reply-To: <20180220211114.GC7000@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



On 20.02.2018 23:11, Dave Chinner wrote:
> On Tue, Feb 20, 2018 at 03:53:02PM +0200, Nikolay Borisov wrote:
>> The check performed before the memcpy responsible for copying the rest
>> of the inode is already performed before we call xfs_log_dinode_to_disk.
>> So let's remove the 2nd instance of the check. No functional changes.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> Reported-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/xfs/xfs_log_recover.c | 5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index 00240c9ee72e..88dccfb1de96 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -3174,11 +3174,8 @@ xlog_recover_inode_pass2(
>>  	xfs_log_dinode_to_disk(ldip, dip);
>>  
>>  	/* the rest is in on-disk format */
>> -	if (item->ri_buf[1].i_len > isize) {
>> -		memcpy((char *)dip + isize,
>> -			item->ri_buf[1].i_addr + isize,
>> +	memcpy((char *)dip + isize, item->ri_buf[1].i_addr + isize,
>>  			item->ri_buf[1].i_len - isize);
>> -	}
>>  
> 
> This looks wrong.
> 
> The previous check is:
> 
> 	if (unlikely(item->ri_buf[1].i_len > isize)) {
> 		CORRUPTION_ERROR
> 		....
> 		error = -EFSCORRUPTED;
> 		goto out_release;
> 	}
> 
> So after this item->ri_buf[1].i_len is always <= isize. IOWs, the
> memcpy() is currently dead code that is never executed, not code we
> want to execute in every inode recovery.

Doh, you are right, will resend.

> 
> Cheers,
> 
> Dave.
> 
