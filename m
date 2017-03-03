Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44626 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751601AbdCCOg7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2017 09:36:59 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v238wwFU125667
        for <linux-xfs@vger.kernel.org>; Fri, 3 Mar 2017 04:04:25 -0500
Received: from e28smtp06.in.ibm.com (e28smtp06.in.ibm.com [125.16.236.6])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28xs8ecd54-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Mar 2017 04:04:24 -0500
Received: from localhost
        by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <abdhalee@linux.vnet.ibm.com>;
        Fri, 3 Mar 2017 14:34:21 +0530
Received: from d28relay08.in.ibm.com (d28relay08.in.ibm.com [9.184.220.159])
        by d28dlp03.in.ibm.com (Postfix) with ESMTP id 95220125805F
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2017 14:34:31 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
        by d28relay08.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v2393Brk11075682
        for <linux-xfs@vger.kernel.org>; Fri, 3 Mar 2017 14:33:11 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
        by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v2394G9w028288
        for <linux-xfs@vger.kernel.org>; Fri, 3 Mar 2017 14:34:17 +0530
Subject: [PowerPC] XFS : Metadata corruption detected at 0x60000000382100b0,
 xfs_agf block
From: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Date: Fri, 03 Mar 2017 14:34:10 +0530
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1488531850.5962.22.camel@abdul-ThinkPad-T450>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, sachinp@linux.vnet.ibm.com, mpe@ellerman.id, aneesh.kumar@linux.vnet.ibm.com

Hi,

Reboot fails for PowerPC machine running RHEL7.3 (3.10.0-514.el7)
following these messages:

SGI XFS with ACLs, security attributes, no debug enabled
XFS (dm-0): Mounting V5 Filesystem
FS (dm-0): Starting recovery (logdev: internal)
XFS (dm-0): Metadata corruption detected at 0x60000000382100b0, xfs_agf
block 0x4b00001
XFS (dm-0): Unmount and run xfs_repair
XFS (dm-0): First 64 bytes of corrupted metadata buffer:
c0000000f06b7200: 58 41 47 46 00 00 00 01 00 00 00 03 00 32 00 00
XAGF.........2..
c0000000f06b7210: 00 00 00 01 00 00 00 02 00 00 00 00 00 00 00
01  ................
c0000000f06b7220: 00 00 00 01 00 00 00 00 00 00 00 76 00 00 00
02  ...........v....
c0000000f06b7230: 00 00 00 04 00 2d 0c c7 00 2a 14 62 00 00 00
00  .....-...*.b....
XFS (dm-0): metadata I/O error: block 0x4b00001
("xfs_trans_read_buf_map") error 117 numblks 1
Failed to mount /sysroot.

Steps to recreate:
Run some file system test (ltp or xfs/086) on 4.10.0 upstream kernel
built on the PowerVM LPAR after the test completes, reboot the machine
back to base kernel, boot falls to dracut mode with above messages,
every time it requires a xfs_repair to recover the file system.


-- 
Regard's

Abdul Haleem
IBM Linux Technology Centre



