Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51254 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbeLYGLA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Dec 2018 01:11:00 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BBA6A289A6
        for <linux-xfs@vger.kernel.org>; Tue, 25 Dec 2018 06:10:59 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202053] [xfstests generic/464]: XFS corruption and Assertion
 failed: 0, file: fs/xfs/xfs_super.c, line: 985
Date: Tue, 25 Dec 2018 06:10:59 +0000
Message-ID: <bug-202053-201763-R7nWMjQIjy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202053-201763@https.bugzilla.kernel.org/>
References: <bug-202053-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202053

--- Comment #5 from Zorro Lang (zlang@redhat.com) ---
(In reply to Zorro Lang from comment #4)
> I never hit this bug before, just a similar bug which has been fixed one
> year ago, by:
> commit 40214d128e07dd21bb07a8ed6a7fe2f911281ab2
> Author: Brian Foster <bfoster@redhat.com>
> Date:   Fri Oct 13 09:47:46 2017 -0700
> 
>     xfs: trim writepage mapping to within eof
> 
> So I doubt if this's a regression issue?

I just reproduced this issue on kernel 4.19, so it's not a regression from
v4.19:

[ 1297.449750] XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) ||
ip->i_delayed_blks == 0, file: fs/xfs/xfs_super.c, line: 954
[ 1297.463147] WARNING: CPU: 20 PID: 26952 at fs/xfs/xfs_message.c:104
assfail+0x54/0x57 [xfs]
[ 1297.472473] Modules linked in: sunrpc intel_rapl sb_edac
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ipmi_ssif 
intel_cstate intel_uncore iTCO_wdt iTCO_vendor_support ipmi_si sg
intel_rapl_perf ipmi_devintf wmi ioatdma i2c_i801 pcspkr ipmi_msghandler
lpc_ich xfs libcrc32c sd_mod mgag200 drm_kms_helper 
syscopyarea sysfillrect sysimgblt igb fb_sys_fops ttm dca drm crc32c_intel
megaraid_sas i2c_algo_bit cdc_ether usbnet mii dm_mirror dm_region_hash dm_log
dm_mod
[ 1297.525374] CPU: 20 PID: 26952 Comm: umount Not tainted 4.19.0-mainline #1

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
