Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45008 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbeIDW6X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Sep 2018 18:58:23 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH v8 23/28] xfs: Add parent pointers to rename
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
 <1535484161-11059-24-git-send-email-allison.henderson@oracle.com>
 <20180903032031.GO5631@dastard>
 <CAOQ4uxj-cB4fXUJXyw0P+SZKm9xhRuPpYY_HVo2X+25hv2RAtQ@mail.gmail.com>
Message-ID: <c0350922-3b2d-53b4-64e4-ce9ce0f80dd7@oracle.com>
Date: Tue, 4 Sep 2018 11:31:55 -0700
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxj-cB4fXUJXyw0P+SZKm9xhRuPpYY_HVo2X+25hv2RAtQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 09/02/2018 10:28 PM, Amir Goldstein wrote:
> On Mon, Sep 3, 2018 at 6:26 AM Dave Chinner <david@fromorbit.com> wrote:
>>
>> On Tue, Aug 28, 2018 at 12:22:36PM -0700, Allison Henderson wrote:
>>> This patch removes the old parent pointer attribute during the
>>> rename operation, and re-adds the updated parent pointer
>>>
>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>
> [...]
>>>        }
>>>
>>>        /* RENAME_EXCHANGE is unique from here on. */
>>> -     if (flags & RENAME_EXCHANGE)
>>> -             return xfs_cross_rename(tp, src_dp, src_name, src_ip,
>>> +     if (flags & RENAME_EXCHANGE) {
>>> +             error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
>>>                                        target_dp, target_name, target_ip,
>>>                                        spaceres);
>>> -
>>> +             goto out;
>>> +     }
>>
>> This looks problematic, too. i.e.  On error, xfs_cross_rename() will
>> have already called xfs_trans_cancel(), but it hasn't unlocked any
>> of the inodes. If it succeeds, it commits the transaction. Either
>> way, the transaction has been finished and freed. However, the
>> code we jump to expects that the transaction is open and still
>> running.
>>
>> Also "out" typically means "goto end of function and return". This
>> is jumping to parent pointer addition, not the function return
>> processing. Hence the label needs to be changed to
>> "parent_pointer"....
>>
> [...]
>>> +out:
>>> +     if (xfs_sb_version_hasparent(&mp->m_sb)) {
>>> +             error = xfs_parent_add_deferred(target_dp, tp, src_ip, target_name,
>>> +                             new_diroffset);
>>
>> And so when we try to add the a parent pointers, we haven't checked
>> if the cross rename failed and aborted the transaction. Or if it
>> succeeded, it expects to continue using the transaction which
>> xfs_cross_rename() committed.
>>
> 
> Allison,
> 
> Not sure if you know that xfs_cross_rename() exchanges src with target, so
> the src_dp parent pointer has to be adjusted as well in case of cross rename.

Oh I see.  Ok, I will add in a snippet to handle src_dp in the case of 
the cross rename.  Thank you!

Allison

> 
> Thanks,
> Amir.
> 
