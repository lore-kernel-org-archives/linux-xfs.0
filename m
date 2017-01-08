Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37730 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934778AbdAHOsy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2017 09:48:54 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v08EiLUD075029
        for <linux-xfs@vger.kernel.org>; Sun, 8 Jan 2017 09:48:53 -0500
Received: from e23smtp09.au.ibm.com (e23smtp09.au.ibm.com [202.81.31.142])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27uhna88hu-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 08 Jan 2017 09:48:53 -0500
Received: from localhost
        by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Mon, 9 Jan 2017 00:48:50 +1000
Subject: xfs:  commit 6552321831dc "xfs: remove i_iolock and use i_rwsem in
 the VFS inode instead"  change causes hang
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Sun, 08 Jan 2017 09:48:44 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1483886924.8189.81.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>

Validation of a file's signature/hash, calculating a file's hash, or
simply audit logging a file's hash prior to use, with commit
6552321831dc "xfs: remove i_iolock and use i_rwsem in the VFS inode
instead" cause the system to hang.

IMA takes the i_rwsem (fomerly i_mutex) before reading the file to
synchronize calculating the file hash and validating the file's
hash/signature stored as security.ima xattr.  (In fix mode, it writes
the file hash as the security.ima.)  Prior to commit 6552321831dc "xfs:
remove i_iolock and use i_rwsem in the VFS inode instead" used an XFS
specific lock, not i_rwsem.

INFO: task plymouthd:3106 blocked for more than 120 seconds.
      Not tainted 4.10.0-rc2 #3
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
plymouthd       D11400  3106      1 0x00040080
Call Trace:
[c0000000f11df320] [c0000000ffde2700] 0xc0000000ffde2700 (unreliable)
[c0000000f11df4f0] [c00000000001c2f0] __switch_to+0x2c0/0x450
[c0000000f11df550] [c0000000008a8a24] __schedule+0x304/0x950
[c0000000f11df5f0] [c0000000008a90b8] schedule+0x48/0xc0
[c0000000f11df620] [c0000000008b0e64] rwsem_down_read_failed+0x144/0x1e0
[c0000000f11df6b0] [c0000000008afa78] down_read+0x78/0x80
[c0000000f11df6e0] [c0000000004d0ef8] xfs_ilock+0x198/0x1b0
[c0000000f11df720] [c0000000004be758] xfs_file_buffered_aio_read+0x58/0x140
[c0000000f11df770] [c0000000004be8f8] xfs_file_read_iter+0xb8/0x150
[c0000000f11df7c0] [c000000000306948] __vfs_read+0x138/0x1b0
[c0000000f11df860] [c00000000055e4a0] integrity_kernel_read+0x70/0xb0
[c0000000f11df8b0] [c000000000560fc0] ima_calc_file_hash+0x3a0/0x770
[c0000000f11dfa60] [c000000000561f2c] ima_collect_measurement+0x1dc/0x210
[c0000000f11dfb10] [c00000000055feec] process_measurement.isra.0+0x39c/0x510
[c0000000f11dfb90] [c00000000031f1b4] path_openat+0x764/0x14a0
[c0000000f11dfc90] [c00000000032196c] do_filp_open+0xfc/0x170
[c0000000f11dfdc0] [c000000000305c4c] do_sys_open+0x1ac/0x2d0
[c0000000f11dfe30] [c00000000000b860] system_call+0x38/0xfc

Mimi

