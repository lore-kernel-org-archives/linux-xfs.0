Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58274 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728683AbfDESTy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Apr 2019 14:19:54 -0400
Subject: Re: [PATCH 30/36] libxfs: retain ifork_ops when flushing inode
From: Eric Sandeen <sandeen@sandeen.net>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259761740.31886.12775146464846669280.stgit@magnolia>
 <a443e2be-2e79-fcee-5cff-abfd1f8da50b@sandeen.net>
Message-ID: <75521ddc-a1f6-7797-0af6-7937da0cadd0@sandeen.net>
Date: Fri, 5 Apr 2019 13:19:52 -0500
MIME-Version: 1.0
In-Reply-To: <a443e2be-2e79-fcee-5cff-abfd1f8da50b@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Arkadiusz Miskiewicz <arekm@maven.pl>



On 4/5/19 1:17 PM, Eric Sandeen wrote:
> On 3/14/19 4:06 PM, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Retain the ifork ops used to validate the inode so that we can use the
>> same one to iflush it.  xfs_repair phase 6 can use multiple transactions
>> to fix various inode problems, which means that the inode might not be
>> fully fixed when each transaction commits.
>>
>> This can be a particular problem if there's a shortform directory with
>> both invalid directory entries and incorrect i8count.  Phase 3 will set
>> the parent inode to "0" to signal to phase 6 that it needs to reset the
>> parent and i8count, but phase 6 starts a transaction to junk the bad
>> entries which fail to commit because the parent is invalid:
>>
>> fixing i8count in inode 69022994673
>> Invalid inode number 0x0
>> xfs_dir_ino_validate: XFS_ERROR_REPORT
>> Metadata corruption detected at 0x464eb0, inode 0x10121750f1 data fork
>> xfs_repair: warning - iflush_int failed (-117)
>>
>> And thus the inode fixes never get written out.
> 
> This feels like it would be better to use consistently by dropping the ops
> arg to libxfs_inode_verify_forks, using ->i_fork_ops inside it, and setting
> it prior to the call.  Er, same for libxfs_iget?

er, no not for libxfs_iget, sorry.  But libxfs_iget can set the ops on
the inode if found and from then on stuff like libxfs_inode_verify_forks
uses what's currently set in the inode ....)

> A mishmash of grabbing what was last set in the inode vs. explicitly pointing
> at a global ops structure seems a bit ad hoc.  Thoughts?
