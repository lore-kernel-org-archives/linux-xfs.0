Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51204 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932751AbeGFTOH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Jul 2018 15:14:07 -0400
Subject: Re: [PATCH RFC 1/1] xfsprogs: add inode inline data support
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-10-git-send-email-shan.hai@oracle.com>
 <20180706033550.GO32415@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <eef931e2-2bbe-6f49-88d4-22eabf468036@sandeen.net>
Date: Fri, 6 Jul 2018 14:14:05 -0500
MIME-Version: 1.0
In-Reply-To: <20180706033550.GO32415@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Shan Hai <shan.hai@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 7/5/18 10:35 PM, Darrick J. Wong wrote:
> On Fri, Jul 06, 2018 at 11:12:30AM +0800, Shan Hai wrote:
>> Add a new mkfs command line option to enable the inode inline data
>> feature. The mkfs set a bit in the superblock to notify the kernel
>> that the data inlining is enabled, there is no extra options for
>> mount.
>>
>> Signed-off-by: Shan Hai <shan.hai@oracle.com>
>> ---
>>  growfs/xfs_growfs.c | 14 +++++++++-----
>>  libxfs/xfs_format.h |  4 +++-
>>  libxfs/xfs_fs.h     |  1 +
>>  mkfs/xfs_mkfs.c     | 20 +++++++++++++++++---
>>  4 files changed, 30 insertions(+), 9 deletions(-)
>>
>> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
>> index 366176b7..a370bf9d 100644
>> --- a/growfs/xfs_growfs.c
>> +++ b/growfs/xfs_growfs.c
>> @@ -60,13 +60,14 @@ report_info(
>>  	int		finobt_enabled,
>>  	int		spinodes,
>>  	int		rmapbt_enabled,
>> -	int		reflink_enabled)
>> +	int		reflink_enabled,
>> +	int		inlinedata_enabled)
>>  {
>>  	printf(_(
>>  	    "meta-data=%-22s isize=%-6u agcount=%u, agsize=%u blks\n"
>>  	    "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
>>  	    "         =%-22s crc=%-8u finobt=%u spinodes=%u rmapbt=%u\n"
>> -	    "         =%-22s reflink=%u\n"
>> +	    "         =%-22s reflink=%u inline=%u\n"
> I coulda sworn we refactored this into a library function...

We did, and it's in 4.17.0 now.

On the next version please rebase this to whatever's in the xfsprogs for-next
branch at the time, that's where all the action is.  :)

Thanks,
-Eric
