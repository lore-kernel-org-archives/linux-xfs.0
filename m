Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39846 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751254AbdDQMT1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Apr 2017 08:19:27 -0400
Subject: Re: XFS crashes with xfs_iunlink_remove: xfs_imap returned error -22
References: <f94b7ddd-a5a0-b376-6d70-fd9472bd20e8@profihost.ag>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bc5aafb9-37a3-9c02-50b7-421633dbd606@sandeen.net>
Date: Mon, 17 Apr 2017 07:19:26 -0500
MIME-Version: 1.0
In-Reply-To: <f94b7ddd-a5a0-b376-6d70-fd9472bd20e8@profihost.ag>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Priebe <s.priebe@profihost.ag>, linux-xfs@vger.kernel.org



On 4/17/17 2:54 AM, Stefan Priebe wrote:
> Hello list,
> 
> one of my servers is crashing every night with the following errors:
> 
> XFS (sda3): xfs_iunlink_remove: xfs_imap returned error -22.
> XFS (sda3): xfs_inactive_ifree: xfs_ifree returned error -22 XFS


-EINVAL

> (sda3): xfs_do_force_shutdown(0x1) called from line 1872 of file
> fs/xfs/xfs_inode.c. Return address = 0xffffffff9e33cf53 XFS (sda3):
> I/O Error Detected. Shutting down filesystem
> 
> I ran xfs_repair v4.9.0 but it seems unable to recover / fix this
> error. I'm running an OpenSUSE 42.2 kernel based von v4.4. Is there
> anything i can do to fix this?

# echo 11 > /proc/sys/fs/xfs/error_level

to get a full backtrace from the shutdown (if you didn't already)
so we can at least see what process is encountering the errors.

I have a hunch, though - are you running xfs_fsr overnight?

-Eric


> Thanks!
> 
