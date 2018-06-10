Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49858 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753446AbeFJPZy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 11:25:54 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 21/27] xfsprogs: Remove single byte array from struct
 parent
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
 <1528607272-11122-22-git-send-email-allison.henderson@oracle.com>
 <CAOQ4uxhwt2cMDqKe78LZvvmLpeB_FncrPQWx=H9Tr0sGtTEBKQ@mail.gmail.com>
Message-ID: <fb8cf95a-d958-282e-175b-e8e2bf255789@oracle.com>
Date: Sun, 10 Jun 2018 08:25:44 -0700
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhwt2cMDqKe78LZvvmLpeB_FncrPQWx=H9Tr0sGtTEBKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>


On 06/10/2018 04:21 AM, Amir Goldstein wrote:
> On Sun, Jun 10, 2018 at 8:07 AM, Allison Henderson
> <allison.henderson@oracle.com> wrote:
>> Variable sized arrays implemented this way may cause
>> corruptions depending on how different compilers pack
>> the structure.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   include/parent.h | 1 -
>>   io/parent.c      | 9 ++++++---
>>   2 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/parent.h b/include/parent.h
>> index f338f96..85cef85 100644
>> --- a/include/parent.h
>> +++ b/include/parent.h
>> @@ -22,7 +22,6 @@ typedef struct parent {
>>          __u64   p_ino;
>>          __u32   p_gen;
>>          __u16   p_reclen;
>> -       char    p_name[1];
> 
> How about
>     char    p_name[0];
> 
> Is that also risky? keeps the code cleaner IMO.
> Second best, at least have a macro to access p_name
> instead of open coding ((char*)parent)+sizeof(struct parent))
> all the time. First option is much better IMO.
> 
> Thanks,
> Amir.
> 

Oh yes, I think there was some discussion about not using declarations 
like that in a previous review of the set last year.  Initially I had 
applied the same logic here to sort of prepare these older structs for 
use in an alternate solution to patch 26, but then later adopted 
Darricks solution that does not require then.  I could probably drop 
this patch from the set since this code is removed in patch 27.  Thx for 
the catch though!

Allison
