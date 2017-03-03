Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:45889 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751278AbdCCL7o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 06:59:44 -0500
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PowerPC] XFS : Metadata corruption detected at 0x60000000382100b0, xfs_agf block
In-Reply-To: <1488531850.5962.22.camel@abdul-ThinkPad-T450>
References: <1488531850.5962.22.camel@abdul-ThinkPad-T450>
Date: Fri, 03 Mar 2017 22:59:39 +1100
Message-ID: <87efyer2ok.fsf@concordia>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org
Cc: sachinp@linux.vnet.ibm.com, mpe@ellerman.id, linuxppc-dev@lists.ozlabs.org, aneesh.kumar@linux.vnet.ibm.com

Abdul Haleem <abdhalee@linux.vnet.ibm.com> writes:

> Hi,
>
> Reboot fails for PowerPC machine running RHEL7.3 (3.10.0-514.el7)
> following these messages:
>
> SGI XFS with ACLs, security attributes, no debug enabled
> XFS (dm-0): Mounting V5 Filesystem
> FS (dm-0): Starting recovery (logdev: internal)
> XFS (dm-0): Metadata corruption detected at 0x60000000382100b0, xfs_agf
> block 0x4b00001
> XFS (dm-0): Unmount and run xfs_repair
> XFS (dm-0): First 64 bytes of corrupted metadata buffer:
> c0000000f06b7200: 58 41 47 46 00 00 00 01 00 00 00 03 00 32 00 00
> XAGF.........2..
> c0000000f06b7210: 00 00 00 01 00 00 00 02 00 00 00 00 00 00 00
> 01  ................
> c0000000f06b7220: 00 00 00 01 00 00 00 00 00 00 00 76 00 00 00
> 02  ...........v....
> c0000000f06b7230: 00 00 00 04 00 2d 0c c7 00 2a 14 62 00 00 00
> 00  .....-...*.b....
> XFS (dm-0): metadata I/O error: block 0x4b00001
> ("xfs_trans_read_buf_map") error 117 numblks 1
> Failed to mount /sysroot.
>
> Steps to recreate:
> Run some file system test (ltp or xfs/086) on 4.10.0 upstream kernel
> built on the PowerVM LPAR after the test completes, reboot the machine
> back to base kernel, boot falls to dracut mode with above messages,
> every time it requires a xfs_repair to recover the file system.

Can you work on a better repro case?

What if you mount an XFS filesystem in the guest, run the test against
it, unmount it and then remount it. Do you see the bug then? Or does it
require a reboot to trigger?

cheers
