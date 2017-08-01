Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:42033 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751003AbdHAIJV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2017 04:09:21 -0400
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: metadata I/O error: block 0x575b6d70,("xfs_trans_read_buf_map") error
 4 numblks 16
Message-ID: <8b406cdd-3d52-b464-ca5f-e8e3a36a6f9b@profihost.ag>
Date: Tue, 1 Aug 2017 10:03:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello,

under very high load i'm getting the following error on a bcache device
using XFS:
XFS (bcache1): metadata I/O error: block 0x575b6d70
("xfs_trans_read_buf_map") error 4 numblks 16
XFS (bcache1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -4.
XFS (bcache1): xfs_do_force_shutdown(0x8) called from line 3519 of file
fs/xfs/xfs_inode.c. Return address = 0xffffffff993441ff
XFS (bcache1): Corruption of in-memory data detected. Shutting down
filesystem
XFS (bcache1): Please umount the filesystem and rectify the problem(s)
XFS (bcache1): xfs_log_force: error -5 returned.
XFS (bcache1): xfs_log_force: error -5 returned.
XFS (bcache1): xfs_log_force: error -5 returned.

The used kernel is 4.4.79 based while using an opensuses patchset. Is
this something which is a known problem or something suse has broken?

Thanks!

Greets,
Stefan
