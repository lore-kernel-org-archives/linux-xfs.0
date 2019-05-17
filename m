Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54198 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbfEQXB5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 19:01:57 -0400
Subject: Re: [PATCH 5/3] libxfs: rename bli_format to avoid confusion with
 bli_formats
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <d8f37464-9d76-2b09-f458-e236ef9afd95@redhat.com>
 <aa0a48c4-2f75-7f83-eeda-f55855994bd5@oracle.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1717fd26-ba67-e5c0-c906-0b84c1970250@sandeen.net>
Date: Fri, 17 May 2019 18:01:56 -0500
MIME-Version: 1.0
In-Reply-To: <aa0a48c4-2f75-7f83-eeda-f55855994bd5@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 5/17/19 5:29 PM, Allison Collins wrote:
> On 5/16/19 1:39 PM, Eric Sandeen wrote:
>> Rename the bli_format structure to __bli_format to avoid
>> accidently confusing them with the bli_formats pointer.
>>
>> (nb: userspace currently has no bli_formats pointer)
>>
>> Source kernel commit: b94381737e9c4d014a4003e8ece9ba88670a2dd4
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>   include/xfs_trans.h | 2 +-
>>   libxfs/logitem.c    | 6 +++---
>>   libxfs/trans.c      | 4 ++--
>>   3 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/xfs_trans.h b/include/xfs_trans.h
>> index 953da5d1..fe03ba64 100644
>> --- a/include/xfs_trans.h
>> +++ b/include/xfs_trans.h
>> @@ -39,7 +39,7 @@ typedef struct xfs_buf_log_item {
>>       struct xfs_buf        *bli_buf;    /* real buffer pointer */
>>       unsigned int        bli_flags;    /* misc flags */
>>       unsigned int        bli_recur;    /* recursion count */
>> -    xfs_buf_log_format_t    bli_format;    /* in-log header */
>> +    xfs_buf_log_format_t    __bli_format;    /* in-log header */
>>   } xfs_buf_log_item_t;
>>     #define XFS_BLI_DIRTY            (1<<0)
>> diff --git a/libxfs/logitem.c b/libxfs/logitem.c
>> index 4da9bc1b..e862ab4f 100644
>> --- a/libxfs/logitem.c
>> +++ b/libxfs/logitem.c
>> @@ -107,9 +107,9 @@ xfs_buf_item_init(
>>       bip->bli_item.li_mountp = mp;
>>       INIT_LIST_HEAD(&bip->bli_item.li_trans);
>>       bip->bli_buf = bp;
>> -    bip->bli_format.blf_type = XFS_LI_BUF;
>> -    bip->bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
>> -    bip->bli_format.blf_len = (unsigned short)BTOBB(bp->b_bcount);
>> +    bip->__bli_format.blf_type = XFS_LI_BUF;
>> +    bip->__bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
>> +    bip->__bli_format.blf_len = (unsigned short)BTOBB(bp->b_bcount);
>>       bp->b_log_item = bip;
> 
> I had a look around this area of code, and I see where the bli_format is getting referenced, but I don't see a bli_formats.  So I feel like I'm missing the motivation for the change.  Did I miss the bli_formats somewhere?  Thanks!

see above :)

> (nb: userspace currently has no bli_formats pointer) 

(I guess copying the kernel commit log added confusion even w/ the note)

-Eric
