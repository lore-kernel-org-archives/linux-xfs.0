Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D3BC636D4
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Feb 2023 11:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjBQLPy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Feb 2023 06:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjBQLPs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Feb 2023 06:15:48 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0DB627E3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 03:15:26 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31HAnAP5001873;
        Fri, 17 Feb 2023 11:15:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date : to :
 cc : from : subject : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=S7G/cyIxUoiDCgoqYIyeQiOOEi+6zn5VwhVQ/8N87VU=;
 b=FIIHqJw5DzBa8GnYkzkm85zi/H0e12o7kjHP4gNl1jJ92R5oR7VnMS+eyaFtci2VXrBS
 9ZQ3BSKYFGQtj2a22unA/pq/os5TwV/kixAF81O/+iebyMvfRA2bERwo9ISsmkiTLkKV
 j/m93m/Gv6ZHBxjg3ya1R77kSazNlgwXdDqFYFYid7B9KxdZ303FsE9plJrCkBMaDUep
 hkW22N4DplYf3Sn/9mY2XsMVw/F5ugcc1hlXGR24p91erKMJ0LMcvO4qIiLEyhZGn5dT
 ai8SpZ2HoMOgrY+BcfiamWUkAGOAIGed1NoVSMpR2cOGfH+2EVOKhqM7GJZagHe4wigH xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nt0a1atv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 11:15:19 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31HApFB8032407;
        Fri, 17 Feb 2023 11:15:19 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nt0a1atuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 11:15:19 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31H9V0c1000993;
        Fri, 17 Feb 2023 11:15:18 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3np2n7y5y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 11:15:18 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31HBFHfm1442312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Feb 2023 11:15:17 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1435758064;
        Fri, 17 Feb 2023 11:15:17 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF60458062;
        Fri, 17 Feb 2023 11:15:13 +0000 (GMT)
Received: from [9.43.51.161] (unknown [9.43.51.161])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 17 Feb 2023 11:15:13 +0000 (GMT)
Message-ID: <e5004868-4a03-93e5-5077-e7ed0e533996@linux.vnet.ibm.com>
Date:   Fri, 17 Feb 2023 16:45:12 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Content-Language: en-US
To:     djwong@kernel.org, dchinner@redhat.com
Cc:     linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com, shrikanth hegde <sshegde@linux.vnet.ibm.com>
From:   shrikanth hegde <sshegde@linux.vnet.ibm.com>
Subject: xfs: system fails to boot up due to Internal error xfs_trans_cancel
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: A3Pv8rroMG8n3qhiu98YI0txv9hfuTgO
X-Proofpoint-ORIG-GUID: Kb-nXtXqrWbux-Rk8JPvmE0KtxKFRlin
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_06,2023-02-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 mlxscore=0 malwarescore=0 adultscore=0 phishscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302170101
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We are observing panic on boot upon loading the latest stable tree(v6.2-rc4) in 
one of our systems. System fails to come up. System was booting well 
with v5.17, v5.19 kernel. We started seeing this issue when loading v6.0 kernel.

Panic Log is below.
[  333.390539] ------------[ cut here ]------------
[  333.390552] WARNING: CPU: 56 PID: 12450 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]
[  333.390615] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink rfkill sunrpc pseries_rng xts vmx_crypto xfs libcrc32c sd_mod sg ibmvscsi ibmveth scsi_transport_srp nvme nvme_core t10_pi crc64_rocksoft crc64 dm_mirror dm_region_hash dm_log dm_mod
[  333.390645] CPU: 56 PID: 12450 Comm: rm Not tainted 6.2.0-rc4ssh+ #4
[  333.390649] Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1010.22 (NH1010_122) hv:phyp pSeries
[  333.390652] NIP:  c0080000004bfa80 LR: c0080000004bfa4c CTR: c000000000ea28d0
[  333.390655] REGS: c0000000442bb8c0 TRAP: 0700   Not tainted  (6.2.0-rc4ssh+)
[  333.390658] MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24002842  XER: 00000000
[  333.390666] CFAR: c0080000004bfa54 IRQMASK: 0
[  333.390666] GPR00: c00000003b69c0c8 c0000000442bbb60 c008000000568300 0000000000000000
[  333.390666] GPR04: 00000000002ec44d 0000000000000000 0000000000000000 c000000004b27d78
[  333.390666] GPR08: 0000000000000000 c000000004b27e28 0000000000000000 fffffffffffffffd
[  333.390666] GPR12: 0000000000000040 c000004afecc5880 0000000106620918 0000000000000001
[  333.390666] GPR16: 000000010bd36e10 0000000106620dc8 0000000106620e58 0000000106620e90
[  333.390666] GPR20: 0000000106620e30 c0000000880ba938 0000000000200000 00000000002ec44d
[  333.390666] GPR24: 000000000008170d 000000000000000d c0000000519f4800 00000000002ec44d
[  333.390666] GPR28: c0000000880ba800 c00000003b69c000 c0000000833edd20 000000000008170d
[  333.390702] NIP [c0080000004bfa80] xfs_iunlink_lookup+0x58/0x80 [xfs]
[  333.390756] LR [c0080000004bfa4c] xfs_iunlink_lookup+0x24/0x80 [xfs]
[  333.390810] Call Trace:
[  333.390811] [c0000000442bbb60] [c0000000833edd20] 0xc0000000833edd20 (unreliable)
[  333.390816] [c0000000442bbb80] [c0080000004c0094] xfs_iunlink+0x1bc/0x280 [xfs]
[  333.390869] [c0000000442bbc00] [c0080000004c3f84] xfs_remove+0x1dc/0x310 [xfs]
[  333.390922] [c0000000442bbc70] [c0080000004be180] xfs_vn_unlink+0x68/0xf0 [xfs]
[  333.390975] [c0000000442bbcd0] [c000000000576b24] vfs_unlink+0x1b4/0x3d0
[  333.390981] [c0000000442bbd20] [c00000000057e5d8] do_unlinkat+0x2b8/0x390
[  333.390985] [c0000000442bbde0] [c00000000057e708] sys_unlinkat+0x58/0xb0
[  333.390989] [c0000000442bbe10] [c0000000000335d0] system_call_exception+0x150/0x3b0
[  333.390994] [c0000000442bbe50] [c00000000000c554] system_call_common+0xf4/0x258
[  333.390999] --- interrupt: c00 at 0x7fffa47230a0
[  333.391001] NIP:  00007fffa47230a0 LR: 00000001066138ac CTR: 0000000000000000
[  333.391004] REGS: c0000000442bbe80 TRAP: 0c00   Not tainted  (6.2.0-rc4ssh+)
[  333.391007] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 22002202  XER: 00000000
[  333.391016] IRQMASK: 0
[  333.391016] GPR00: 0000000000000124 00007fffdb9330b0 00007fffa4807300 0000000000000008
[  333.391016] GPR04: 000000010bd36f18 0000000000000000 0000000000000000 0000000000000003
[  333.391016] GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  333.391016] GPR12: 0000000000000000 00007fffa48ba340 0000000106620918 0000000000000001
[  333.391016] GPR16: 000000010bd36e10 0000000106620dc8 0000000106620e58 0000000106620e90
[  333.391016] GPR20: 0000000106620e30 0000000106620e00 0000000106620c40 0000000000000002
[  333.391016] GPR24: 0000000106620c38 00000001066208d8 0000000000000000 0000000106620d20
[  333.391016] GPR28: 00007fffdb933408 000000010bd24cec 00007fffdb933408 000000010bd36e10
[  333.391050] NIP [00007fffa47230a0] 0x7fffa47230a0
[  333.391052] LR [00000001066138ac] 0x1066138ac
[  333.391054] --- interrupt: c00
[  333.391056] Code: 2c230000 4182002c e9230020 2fa90000 419e0020 38210020 e8010010 7c0803a6 4e800020 60000000 60000000 60000000 <0fe00000> 60000000 60000000 60000000
[  333.391069] ---[ end trace 0000000000000000 ]---
[  333.391072] XFS (dm-0): Internal error xfs_trans_cancel at line 1097 of file fs/xfs/xfs_trans.c.  Caller xfs_remove+0x1a0/0x310 [xfs]
[  333.391128] CPU: 56 PID: 12450 Comm: rm Tainted: G        W          6.2.0-rc4ssh+ #4
[  333.391131] Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1010.22 (NH1010_122) hv:phyp pSeries
[  333.391135] Call Trace:
[  333.391136] [c0000000442bbb10] [c000000000e84f4c] dump_stack_lvl+0x70/0xa4 (unreliable)
[  333.391142] [c0000000442bbb50] [c0080000004a6a84] xfs_error_report+0x5c/0x80 [xfs]
[  333.391194] [c0000000442bbbb0] [c0080000004d67b0] xfs_trans_cancel+0x178/0x1b0 [xfs]
[  333.391249] [c0000000442bbc00] [c0080000004c3f48] xfs_remove+0x1a0/0x310 [xfs]
[  333.391302] [c0000000442bbc70] [c0080000004be180] xfs_vn_unlink+0x68/0xf0 [xfs]
[  333.391355] [c0000000442bbcd0] [c000000000576b24] vfs_unlink+0x1b4/0x3d0
[  333.391359] [c0000000442bbd20] [c00000000057e5d8] do_unlinkat+0x2b8/0x390
[  333.391363] [c0000000442bbde0] [c00000000057e708] sys_unlinkat+0x58/0xb0
[  333.391367] [c0000000442bbe10] [c0000000000335d0] system_call_exception+0x150/0x3b0
[  333.391371] [c0000000442bbe50] [c00000000000c554] system_call_common+0xf4/0x258
[  333.391376] --- interrupt: c00 at 0x7fffa47230a0
[  333.391378] NIP:  00007fffa47230a0 LR: 00000001066138ac CTR: 0000000000000000
[  333.391381] REGS: c0000000442bbe80 TRAP: 0c00   Tainted: G        W           (6.2.0-rc4ssh+)
[  333.391385] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 22002202  XER: 00000000
[  333.391393] IRQMASK: 0
[  333.391393] GPR00: 0000000000000124 00007fffdb9330b0 00007fffa4807300 0000000000000008
[  333.391393] GPR04: 000000010bd36f18 0000000000000000 0000000000000000 0000000000000003
[  333.391393] GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  333.391393] GPR12: 0000000000000000 00007fffa48ba340 0000000106620918 0000000000000001
[  333.391393] GPR16: 000000010bd36e10 0000000106620dc8 0000000106620e58 0000000106620e90
[  333.391393] GPR20: 0000000106620e30 0000000106620e00 0000000106620c40 0000000000000002
[  333.391393] GPR24: 0000000106620c38 00000001066208d8 0000000000000000 0000000106620d20
[  333.391393] GPR28: 00007fffdb933408 000000010bd24cec 00007fffdb933408 000000010bd36e10
[  333.391427] NIP [00007fffa47230a0] 0x7fffa47230a0
[  333.391429] LR [00000001066138ac] 0x1066138ac
[  333.391431] --- interrupt: c00
[  333.394067] XFS (dm-0): Corruption of in-memory data (0x8) detected at xfs_trans_cancel+0x190/0x1b0 [xfs] (fs/xfs/xfs_trans.c:1098).  Shutting down filesystem.
[  333.394125] XFS (dm-0): Please unmount the filesystem and rectify the problem(s)



we did a git bisect between 5.17 and 6.0. Bisect points to commit 04755d2e5821 
as the bad commit.
Short description of commit:
commit 04755d2e5821b3afbaadd09fe5df58d04de36484 (refs/bisect/bad)
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Jul 14 11:42:39 2022 +1000

    xfs: refactor xlog_recover_process_iunlinks()


Git bisect log:
git bisect start
# good: [26291c54e111ff6ba87a164d85d4a4e134b7315c] Linux 5.17-rc2
git bisect good 26291c54e111ff6ba87a164d85d4a4e134b7315c
# bad: [4fe89d07dcc2804c8b562f6c7896a45643d34b2f] Linux 6.0
git bisect bad 4fe89d07dcc2804c8b562f6c7896a45643d34b2f
# good: [d7227785e384d4422b3ca189aa5bf19f462337cc] Merge tag 'sound-5.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect good d7227785e384d4422b3ca189aa5bf19f462337cc
# good: [526942b8134cc34d25d27f95dfff98b8ce2f6fcd] Merge tag 'ata-5.20-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata
git bisect good 526942b8134cc34d25d27f95dfff98b8ce2f6fcd
# good: [328141e51e6fc79d21168bfd4e356dddc2ec7491] Merge tag 'mmc-v5.20' of git://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc
git bisect good 328141e51e6fc79d21168bfd4e356dddc2ec7491
# bad: [eb555cb5b794f4e12a9897f3d46d5a72104cd4a7] Merge tag '5.20-rc-ksmbd-server-fixes' of git://git.samba.org/ksmbd
git bisect bad eb555cb5b794f4e12a9897f3d46d5a72104cd4a7
# bad: [f20c95b46b8fa3ad34b3ea2e134337f88591468b] Merge tag 'tpmdd-next-v5.20' of git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd
git bisect bad f20c95b46b8fa3ad34b3ea2e134337f88591468b
# bad: [fad235ed4338749a66ddf32971d4042b9ef47f44] Merge tag 'arm-late-6.0' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
git bisect bad fad235ed4338749a66ddf32971d4042b9ef47f44
# good: [e495274793ea602415d050452088a496abcd9e6c] Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma
git bisect good e495274793ea602415d050452088a496abcd9e6c
# good: [9daee913dc8d15eb65e0ff560803ab1c28bb480b] Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
git bisect good 9daee913dc8d15eb65e0ff560803ab1c28bb480b
# bad: [29b1d469f3f6842ee4115f0b21f018fc44176468] Merge tag 'trace-rtla-v5.20' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect bad 29b1d469f3f6842ee4115f0b21f018fc44176468
# good: [932b42c66cb5d0ca9800b128415b4ad6b1952b3e] xfs: replace XFS_IFORK_Q with a proper predicate function
git bisect good 932b42c66cb5d0ca9800b128415b4ad6b1952b3e
# bad: [35c5a09f5346e690df7ff2c9075853e340ee10b3] Merge tag 'xfs-buf-lockless-lookup-5.20' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-5.20-mergeB
git bisect bad 35c5a09f5346e690df7ff2c9075853e340ee10b3
# bad: [fad743d7cd8bd92d03c09e71f29eace860f50415] xfs: add log item precommit operation
git bisect bad fad743d7cd8bd92d03c09e71f29eace860f50415
# bad: [04755d2e5821b3afbaadd09fe5df58d04de36484] xfs: refactor xlog_recover_process_iunlinks()
git bisect bad 04755d2e5821b3afbaadd09fe5df58d04de36484
# good: [a4454cd69c66bf3e3bbda352b049732f836fc6b2] xfs: factor the xfs_iunlink functions
git bisect good a4454cd69c66bf3e3bbda352b049732f836fc6b2
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[4fcc94d653270fcc7800dbaf3b11f78cb462b293] xfs: track the iunlink list pointer in the xfs_inode


Please reach out, in case any more details are needed. sent with very limited
knowledge of xfs system. these logs are from 5.19 kernel.

# xfs_info /home
meta-data=/dev/nvme0n1p1         isize=512    agcount=4, agsize=13107200 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=52428800, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=25600, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# xfs_info -V
xfs_info version 5.0.0

# uname -a
5.19.0-rc2
