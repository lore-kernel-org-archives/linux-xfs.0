Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:52670 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932413AbdDQH5w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Apr 2017 03:57:52 -0400
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: XFS crashes with xfs_iunlink_remove: xfs_imap returned error -22
Message-ID: <f94b7ddd-a5a0-b376-6d70-fd9472bd20e8@profihost.ag>
Date: Mon, 17 Apr 2017 09:54:21 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello list,

one of my servers is crashing every night with the following errors:

XFS (sda3): xfs_iunlink_remove: xfs_imap returned error -22.
XFS (sda3): xfs_inactive_ifree: xfs_ifree returned error -22
XFS (sda3): xfs_do_force_shutdown(0x1) called from line 1872 of file 
fs/xfs/xfs_inode.c. Return address = 0xffffffff9e33cf53
XFS (sda3): I/O Error Detected. Shutting down filesystem

I ran xfs_repair v4.9.0 but it seems unable to recover / fix this error. 
I'm running an OpenSUSE 42.2 kernel based von v4.4. Is there anything i 
can do to fix this?

Thanks!

Greets,
Stefan
