Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42142 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387807AbeGLBxa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jul 2018 21:53:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6C1ieMO012582
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jul 2018 01:46:24 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2k2p768f4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jul 2018 01:46:24 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6C1kNNe017765
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jul 2018 01:46:23 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6C1kNRq024561
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jul 2018 01:46:23 GMT
Subject: Re: [PATCH RFC 7/8] xfs: return non-zero blocks for inline data
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-8-git-send-email-shan.hai@oracle.com>
 <20180711130825.dkreolul3mlvtf3b@odin.usersys.redhat.com>
 <2e421e56-7463-3ac1-2eac-fa72ee8cd3eb@oracle.com>
 <fd877bb3-641f-b70c-a40e-e4287339ed53@oracle.com>
 <20180712013147.GK32415@magnolia>
From: Shan Hai <shan.hai@oracle.com>
Message-ID: <e70ed6e4-a889-87ac-d25c-db2abc0e61a1@oracle.com>
Date: Thu, 12 Jul 2018 09:46:20 +0800
MIME-Version: 1.0
In-Reply-To: <20180712013147.GK32415@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 2018年07月12日 09:31, Darrick J. Wong wrote:
> On Thu, Jul 12, 2018 at 09:13:46AM +0800, Shan Hai wrote:
>>
>> On 2018年07月12日 09:03, Shan Hai wrote:
>>>
>>> On 2018年07月11日 21:08, Carlos Maiolino wrote:
>>>> On Fri, Jul 06, 2018 at 11:12:28AM +0800, Shan Hai wrote:
>>>>> Return non-zero blocks for inline data even though the inode has
>>>>> no external blocks, otherwise the "ls -ls" would show zero blocks
>>>>> occupied by the file.
>>>>>
>>>> Is there any issue you ran into while leaving inodes with zero
>>>> blocks allocated?
>>>> Inodes should actually report the real amount of allocated blocks,
>>>> not fake it.
>>>> Inodes with inlined data should actually report 0 blocks, otherwise,
>>>> many
>>>> applications which actually relies on the amount of allocated blocks
>>>> for each
>>>> file will misbehave.
>>>>
>>> Man ls(1) reads:
>>>
>>> -s, --size
>>>      print the allocated size of each file, in blocks
>>>
>>> So the 'ls -ls' would report 0 blocks when the data is inlined, a file
>>> holds data
>>> but it consumes 0 blocks, how is it possible :), this patch fixes this
>>> problem.
>>>
>> This patch is inspired by the
>> upstream commit 9206c561554c9 (ext4: return non-zero st_blocks for inline
>> data),
>> please refer it for details.
> The fact that we're following precedent set by ext4 is worth mentioning
> in the commit message.

OK, I will include it in the next version of the patch.

Thanks
Shan Hai
> --D
>
>> Thanks
>> Shan Hai
>>
>>> Thanks
>>> Shan Hai
>>>>> Signed-off-by: Shan Hai <shan.hai@oracle.com>
>>>>> ---
>>>>>    fs/xfs/xfs_iops.c | 8 +++++++-
>>>>>    1 file changed, 7 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>>>>> index 0fa29f39d658..63be1355a473 100644
>>>>> --- a/fs/xfs/xfs_iops.c
>>>>> +++ b/fs/xfs/xfs_iops.c
>>>>> @@ -500,8 +500,14 @@ xfs_vn_getattr(
>>>>>        stat->atime = inode->i_atime;
>>>>>        stat->mtime = inode->i_mtime;
>>>>>        stat->ctime = inode->i_ctime;
>>>>> -    stat->blocks =
>>>>> +
>>>>> +    if (xfs_sb_version_hasinlinedata(&mp->m_sb) &&
>>>>> +        XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) == XFS_DINODE_FMT_LOCAL) {
>>>>> +            stat->blocks = BTOBB(XFS_ISIZE(ip));
>>>>> +    } else {
>>>>> +        stat->blocks =
>>>>>            XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
>>>>> +    }
>>>>>          if (ip->i_d.di_version == 3) {
>>>>>            if (request_mask & STATX_BTIME) {
>>>>> -- 
>>>>> 2.11.0
>>>>>
>>>>> -- 
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

