Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47100 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750953AbdAKCk7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Jan 2017 21:40:59 -0500
Subject: Re: Generic/389 xfs_io segfault on btrfs and ext4
References: <ca7ae533-8d7f-9783-1900-bdfb17d6a32c@cn.fujitsu.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d5116871-0bb3-46b0-c9e3-def74bd57967@sandeen.net>
Date: Tue, 10 Jan 2017 20:40:57 -0600
MIME-Version: 1.0
In-Reply-To: <ca7ae533-8d7f-9783-1900-bdfb17d6a32c@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Eryu Guan <eguan@redhat.com>, agruenba@redhat.com, btrfs <linux-btrfs@vger.kernel.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On 1/10/17 8:08 PM, Qu Wenruo wrote:
> Hi, Andreas and Eryu,
> 
> I found test case generic/389 fails on btrfs and ext4, and it fails with xfs_io segfault.

Details, please?

Works ok here:

# ./check  generic/389
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 bp-05 4.9.0-rc1+
MKFS_OPTIONS  -- /dev/sdb2
MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:nfs_t:s0 /dev/sdb2 /mnt/scratch

generic/389 1s ... 1s
Ran: generic/389
Passed all 1 tests

# rpm -q xfsprogs
xfsprogs-4.9.0-1.el6.x86_64

What version of kernel and xfsprogs were you testing, and what was the segfault?

Thanks,
-Eric
 
> So it seems to be a bug in xfsprogs, but I'm already using the latest release from Fedora.
> 
> Is this a known bug?
> 
> Thanks,
> Qu
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
