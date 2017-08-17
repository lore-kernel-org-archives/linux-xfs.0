Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57898 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751107AbdHQP6p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 11:58:45 -0400
Subject: Re: xfs_repair fails to clean directory inode
References: <9c1f39a3-c4cf-e98d-4331-475b037268b7@suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <eb3d746b-ddc3-6a91-6f69-21051e22c102@sandeen.net>
Date: Thu, 17 Aug 2017 10:58:44 -0500
MIME-Version: 1.0
In-Reply-To: <9c1f39a3-c4cf-e98d-4331-475b037268b7@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On 8/17/17 7:13 AM, Hannes Reinecke wrote:
> Hi all,

Hi Hannes - 
 
> I've managed to corrupt my fs after a storage array failure earlier this
> week. After calling 'xfs_repair -L' on the FS running xfs_repair
> consistently gives me:
> 
> # xfs_repair /dev/dm-2
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> bogus .. inode number (0) in directory inode 128, clearing inode number
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 2
>         - agno = 1
>         - agno = 3
> bogus .. inode number (0) in directory inode 128, clearing inode number
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> done
> 
> irrespective on how many times I'm calling xfs_repair.
> (And yes, this is with latest xfsprogs)

Which version, specifically?

Would you be willing to provide a compressed xfs_metadump (offline, probably),
and then I could take a look at the behavior directly?  Would be easier
than reverse engineering it from the printfs above.  :)

(note, metadump is still leaking a bit of stale data here and there,
so treat the file accordingly if there's anything sensitive on the
filesystem)

Thanks,
-Eric
