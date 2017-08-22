Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41336 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751976AbdHVEFp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Aug 2017 00:05:45 -0400
Subject: Re: [PATCH RFC 0/3] xfs: add customizable default values for error
 configuration
References: <1503316462-16553-1-git-send-email-houtao1@huawei.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4fdb34d1-e18d-3c99-4cae-e68bdf05f3b9@sandeen.net>
Date: Mon, 21 Aug 2017 23:05:43 -0500
MIME-Version: 1.0
In-Reply-To: <1503316462-16553-1-git-send-email-houtao1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, cmaiolino@redhat.com

On 8/21/17 6:54 AM, Hou Tao wrote:
> Hi all,
> 
> XFS has the configurable error handlers for each mounted device, but
> the default values of these configuration are static. It will be useful
> to make the default values customizable when there are many XFS filesystems
> and we need to shutdown the filesystem after getting any error.
> 
> The patches are simple. A sysfs tree is created under .../xfs/default_error
> and its hierarchies are the same with the tree under .../fs/xfs/<dev>/error.
> 
> When the default value of any error configuration is being modified, the
> corresponding value of all mount points will be checked again the old
> default value. If they are the same, the value of the mount point will
> be updated to the new default value as well, else the value of the mount
> point will NOT be changed.
> 
> Thoughts, reviews, flames appreciated.

I recognize that it's an RFC, but if this goes in please also update
Documentation/filesystems/xfs.txt which documents the current error
handling tunables.

Thanks!

-Eric
