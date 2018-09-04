Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44348 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbeIDW5g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Sep 2018 18:57:36 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH v8 00/28] Parent Pointers v8
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
 <20180903012006.GM5631@dastard> <20180903014051.GN5631@dastard>
Message-ID: <c3147918-2af3-ebc7-bf95-15ee73466a70@oracle.com>
Date: Tue, 4 Sep 2018 11:31:09 -0700
MIME-Version: 1.0
In-Reply-To: <20180903014051.GN5631@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 09/02/2018 06:40 PM, Dave Chinner wrote:
> On Mon, Sep 03, 2018 at 11:20:06AM +1000, Dave Chinner wrote:
>> On Tue, Aug 28, 2018 at 12:22:13PM -0700, Allison Henderson wrote:
>>> Hi all,
>>>
>>> This is the 8th version of parent pointer attributes for xfs. The goal of
>>> this patch set is to add a parent pointer attribute to each inode.  The
>>> attribute name containing the parent inode, generation, and directory offset,
>>> while the  attribute value contains the file name.  This feature will enable
>>> future optimizations for online scrub, or any other feature that could make
>>> use of quickly deriving an inodes path from  the mount point.  This set also
>>> introduces deferred attribute operations, though it is currently only used by
>>>   the new parent pointer code.
>>
>> Hi Allison,
>>
>> FYI, A couple of minor things I noticed on import of the patch set
>> to 4.19-rc1:
>>
>> ......
>> Applying: xfs: parent pointer attribute creation
>> .git/rebase-apply/patch:131: trailing whitespace.
>> 	error = xfs_attr_set(child, (const unsigned char *)&rec, sizeof(rec),
>> .git/rebase-apply/patch:136: new blank line at EOF.
>> +
>> .git/rebase-apply/patch:296: new blank line at EOF.
>> +
>> warning: 3 lines add whitespace errors.
>> Applying: xfs: add parent attributes to link
>> Applying: xfs: remove parent pointers in unlink
>> .git/rebase-apply/patch:97: new blank line at EOF.
>> +
>> warning: 1 line adds whitespace errors.
>> Applying: xfs: Add parent pointers to rename
>> Applying: xfs: Add the parent pointer support to the superblock version 5.
>> Applying: xfs: Add helper function xfs_attr_list_context_init
>> Applying: xfs: Increase XFS_DEFER_OPS_NR_INODES to 4
>> Applying: xfs: Add parent pointer ioctl
>> .git/rebase-apply/patch:340: new blank line at EOF.
>> +
>> warning: 1 line adds whitespace errors.
>> Applying: xfs: Add delayed attributes error tag
>> ......
>>
>> Also, I get a couple of compiler warnings:
>>
>> fs/xfs/libxfs/xfs_attr.c: In function ¿xfs_attr_set¿:
>> fs/xfs/libxfs/xfs_attr.c:446:48: warning: passing argument 3 of ¿xfs_attr_set_deferred¿ discards ¿const¿ qualifier from pointer target type [-Wdiscarded-qualifiers]
>>    error = xfs_attr_set_deferred(dp, args.trans, name, namelen,
>>                                                  ^~~~
>> In file included from fs/xfs/libxfs/xfs_attr.c:25:0:
>> fs/xfs/libxfs/xfs_attr.h:197:5: note: expected ¿void *¿ but argument is of type ¿const unsigned char *¿
>>   int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
>>       ^~~~~~~~~~~~~~~~~~~~~
>> fs/xfs/libxfs/xfs_attr.c: In function ¿xfs_attr_remove¿:
>> fs/xfs/libxfs/xfs_attr.c:584:4: warning: passing argument 3 of ¿xfs_attr_remove_deferred¿ discards ¿const¿ qualifier from pointer target type [-Wdiscarded-qualifiers]
>>      name, namelen, flags);
>>      ^~~~
>> In file included from fs/xfs/libxfs/xfs_attr.c:25:0:
>> fs/xfs/libxfs/xfs_attr.h:200:5: note: expected ¿void *¿ but argument is of type ¿const unsigned char *¿
>>   int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
>>       ^~~~~~~~~~~~~~~~~~~~~~~~
> 
> Another couple:
> 
> fs/xfs/libxfs/xfs_attr.c: In function ¿xfs_leaf_has_attr¿:
> fs/xfs/libxfs/xfs_attr.c:863:27: error: variable ¿dp¿ set but not used [-Werror=unused-but-set-variable]
>    struct xfs_inode        *dp;
>                             ^~
> fs/xfs/libxfs/xfs_attr_leaf.c: In function ¿xfs_shortform_has_attr¿:
> fs/xfs/libxfs/xfs_attr_leaf.c:635:15: error: variable ¿mp¿ set but not used [-Werror=unused-but-set-variable]
>    xfs_mount_t *mp;
>                 ^~
> 
> The fixup patch I wrote to make it compile is below.

Alrighty, thank you!  I will get those added in the next version.  I 
think initially these pointers were char *, and then in an earlier 
review we changed them to void *.  I'm not really sure it makes a huge 
difference?  I had noticed the warnings earlier and forgot to come back 
and weed them out.  I will get these changes added to their 
corresponding patches.  Thank you!

Allison

> 
> Cheers,
> 
> Dave.
> 
