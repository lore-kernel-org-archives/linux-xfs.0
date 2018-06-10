Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52342 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753655AbeFJRfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 13:35:01 -0400
Subject: Re: [PATCH v7 19/23] xfs: Add parent pointers to rename
References: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
 <1528607108-11059-20-git-send-email-allison.henderson@oracle.com>
 <CAOQ4uxiyUOE4Z4RCERuTHGq5APyM6QzrTvC16pJOy_S_syXFkg@mail.gmail.com>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <590c8356-d035-af2c-c4d8-2ce247fc3e6e@oracle.com>
Date: Sun, 10 Jun 2018 10:34:52 -0700
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxiyUOE4Z4RCERuTHGq5APyM6QzrTvC16pJOy_S_syXFkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 06/10/2018 06:39 AM, Amir Goldstein wrote:
> On Sun, Jun 10, 2018 at 8:05 AM, Allison Henderson
> <allison.henderson@oracle.com> wrote:
>> This patch removes the old parent pointer attribute during the
>> rename operation, and re-adds the updated parent pointer
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/xfs_inode.c | 68 +++++++++++++++++++++++++++++++++++++++++-------------
>>   1 file changed, 52 insertions(+), 16 deletions(-)
>>
> [...]
>>          xfs_defer_init(&dfops, &first_block);
>>
>>          /* RENAME_EXCHANGE is unique from here on. */
>> -       if (flags & RENAME_EXCHANGE)
>> -               return xfs_cross_rename(tp, src_dp, src_name, src_ip,
>> +       if (flags & RENAME_EXCHANGE) {
>> +               error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
>>                                          target_dp, target_name, target_ip,
>>                                          &dfops, &first_block, spaceres);
>> -
> 
> You forgot to update parent pointers in RENAME_EXCHANGE
> case, both src and target.
> 
> I commented that on v6, you must have missed that.
> 
> Thanks,
> Amir.
Alrighty, I may have over looked it in all the traffic, I will get it 
updated.  Thx!

Allison

> 
