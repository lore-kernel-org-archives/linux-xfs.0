Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54726 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753704AbdDLMfB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Apr 2017 08:35:01 -0400
Subject: Re: [PATCH] xfs_db: set buf flag for inode or dqblk with "type"
References: <20170411225334.GE8502@birch.djwong.org>
 <d7c0fbec-5229-3d69-a435-a68e76ada593@sandeen.net>
 <20170412060730.GJ8502@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dc9daf99-6387-cd3f-5851-ff8d183eeb23@sandeen.net>
Date: Wed, 12 Apr 2017 07:35:00 -0500
MIME-Version: 1.0
In-Reply-To: <20170412060730.GJ8502@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On 4/12/17 1:07 AM, Darrick J. Wong wrote:
> On Tue, Apr 11, 2017 at 10:54:15PM -0500, Eric Sandeen wrote:
>> Currently, setting "type" to inode or dqblk does not
>> appropriately set the buffer type flags for these
>> types.  i.e.:
>>
>> xfs_db> inode 128
>>
>> sets ino_buf, but
>>
>> xfs_db> convert inode 128 fsblock
>> 0x10 (16)
>> xfs_db> fsblock 16
>> xfs_db> type inode
>>
>> does not.  This is apparent if we try to use "type" to
>> switch to an inode or dqblk, then try to use "write -d"
>> which tests these flags.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/db/io.c b/db/io.c
>> index 9918a51..d78fc66 100644
>> --- a/db/io.c
>> +++ b/db/io.c
>> @@ -617,6 +617,13 @@ set_iocur_type(
>>  	struct xfs_buf	*bp = iocur_top->bp;
>>  
>>  	iocur_top->typ = t;
>> +	iocur_top->ino_buf = 0;
>> +	iocur_top->dquot_buf  = 0;
> 
> Extra spaces.

yeah, derp.

>> +
>> +	if (t->typnm == TYP_INODE)
>> +		iocur_top->ino_buf = 1;
>> +	else if (t->typnm == TYP_DQBLK)
>> +		iocur_top->dquot_buf = 1;
> 
> iocur_top->dquot_buf = (t->typnm == TYP_DQBLK); ?

*shrug* sure.  I'm not actually sure this patch is quite right,
though, I think it's a band-aid.  Will think about it some more.

Thanks,
-Eric

> --D
> 
>>  
>>  	/* verify the buffer if the type has one. */
>>  	if (!bp)
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
