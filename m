Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 639A4C5519F
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 19:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26CE120758
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 19:37:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S1h5et7y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbgKVThp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Nov 2020 14:37:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56842 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgKVThp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Nov 2020 14:37:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AMJYuiX145857;
        Sun, 22 Nov 2020 19:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=gvhNgJ9GCl6cyyfi5re2Qj83WzPGqGNPamh/tXZdFnk=;
 b=S1h5et7yUNoj2Gexv6B7wCmpOf8kFZ47wMWNw1mpNs+XBQt0FMGWAlLZze6DXmplRyDR
 ni+uiSdGLwsEoiprxBSR4bB7f1fI4KDP1IZIQ6G8flR1Y6ucgsNrRYDK2GpBmf0xd10w
 WjeEIfIA1uaYTJp2i4ExcVwumfiAnWtpoco+Cj7j92PwUAKmKET1MNT9lhemTNhFP0Uf
 njH6Npctt7JWZAjndGxnzVObd8Rf4bktGGXEOCBj+N20MRJXEvNxsg9+l5airiwIEaok
 hBaoM6PGo7pvCpSs67YuCI1wxqmrh2tn8WgSrwKvjelBQyWm8nsFE3lajFLro5WCSMTi Tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34xtuktqe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 22 Nov 2020 19:37:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AMJZima114180;
        Sun, 22 Nov 2020 19:37:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34ycnpu7fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Nov 2020 19:37:32 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AMJbUaF005865;
        Sun, 22 Nov 2020 19:37:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 22 Nov 2020 11:37:30 -0800
Date:   Sun, 22 Nov 2020 11:37:29 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Friedemann Stoyan <fstoyan+xfs@swapon.de>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: Internal error ltrec.rm_startblock > bno since Kernel 5.9.9
Message-ID: <20201122193729.GB7880@magnolia>
References: <20201122071800.GA13313@defiant.lab.swapon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201122071800.GA13313@defiant.lab.swapon.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9813 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011220143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9813 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0
 phishscore=0 clxscore=1011 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011220143
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 22, 2020 at 08:18:00AM +0100, Friedemann Stoyan wrote:
> Hi all,
> 
> After Upgrading to kernel 5.9.9 I got three crashes at two computers

Sorry about that, there was a bad patch in -rc4 that got sucked into
5.9.9 because it had a fixes tag.  The revert is already upstream:

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?id=eb8409071a1d47e3593cfe077107ac46853182ab

--D

> with the same error:
> 
> Nov 22 06:07:54 kernel: XFS (dm-3): Internal error ltrec.rm_startblock > bno || ltrec.rm_startblock + ltrec.rm_blockcount < bno + len at line 575 of file fs/xfs/libxfs/xfs_rmap.c.  Caller xfs_rmap_unmap+0x737/0xab0 [xfs]
> Nov 22 06:07:54 kernel: CPU: 1 PID: 4211 Comm: pacman Tainted: G        W         5.9.9-arch1-1 #1
> Nov 22 06:07:54 kernel: Hardware name: LENOVO 20F6S0C400/20F6S0C400, BIOS R02ET71W (1.44 ) 05/08/2019
> Nov 22 06:07:54 kernel: Call Trace:
> Nov 22 06:07:54 kernel:  dump_stack+0x6b/0x83
> Nov 22 06:07:54 kernel:  xfs_corruption_error+0x85/0x90 [xfs]
> Nov 22 06:07:54 kernel:  ? xfs_rmap_unmap+0x737/0xab0 [xfs]
> Nov 22 06:07:54 kernel:  xfs_rmap_unmap+0x767/0xab0 [xfs]
> Nov 22 06:07:54 kernel:  ? xfs_rmap_unmap+0x737/0xab0 [xfs]
> Nov 22 06:07:54 kernel:  xfs_rmap_finish_one+0x280/0x300 [xfs]
> Nov 22 06:07:54 kernel:  xfs_rmap_update_finish_item+0x37/0x60 [xfs]
> Nov 22 06:07:54 kernel:  xfs_defer_finish_noroll+0x170/0x4a0 [xfs]
> Nov 22 06:07:54 kernel:  xfs_defer_finish+0x11/0x70 [xfs]
> Nov 22 06:07:54 kernel:  xfs_itruncate_extents_flags+0xcf/0x2c0 [xfs]
> Nov 22 06:07:54 kernel:  xfs_inactive_truncate+0xaf/0xe0 [xfs]
> Nov 22 06:07:54 kernel:  xfs_inactive+0xb4/0x140 [xfs]
> Nov 22 06:07:54 kernel:  xfs_fs_destroy_inode+0xaa/0x1f0 [xfs]
> Nov 22 06:07:54 kernel:  destroy_inode+0x3b/0x70
> Nov 22 06:07:54 kernel:  do_unlinkat+0x207/0x310
> Nov 22 06:07:54 kernel:  do_syscall_64+0x33/0x40
> Nov 22 06:07:54 kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> Nov 22 06:07:54 kernel: RIP: 0033:0x7f495d7babbb
> Nov 22 06:07:54 kernel: Code: f0 ff ff 73 01 c3 48 8b 0d b2 f2 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 57 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 85 f2 0c 00 f7 d8 64 89 01 48
> Nov 22 06:07:54 kernel: RSP: 002b:00007fff7832a0b8 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
> Nov 22 06:07:54 kernel: RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f495d7babbb
> Nov 22 06:07:54 kernel: RDX: 0000000000000003 RSI: 0000000000000004 RDI: 00007fff7832a270
> Nov 22 06:07:54 kernel: RBP: 000055e9d8325300 R08: 0000000000000001 R09: 000055e9d83273a0
> Nov 22 06:07:54 kernel: R10: 000055e9d691f440 R11: 0000000000000206 R12: 00007fff7832a270
> Nov 22 06:07:54 kernel: R13: 0000000000000000 R14: 00007fff7832a150 R15: 000055e9d691f440
> Nov 22 06:07:54 kernel: XFS (dm-3): Corruption detected. Unmount and run xfs_repair
> Nov 22 06:07:54 kernel: XFS (dm-3): xfs_do_force_shutdown(0x8) called from line 461 of file fs/xfs/libxfs/xfs_defer.c. Return address = 000000004ce3c3c5
> Nov 22 06:07:54 kernel: XFS (dm-3): Corruption of in-memory data detected.  Shutting down filesystem
> Nov 22 06:07:54 kernel: XFS (dm-3): Please unmount the filesystem and rectify the problem(s)
> 
> # cat /proc/version
> Linux version 5.9.9-arch1-1 (linux@archlinux) (gcc (GCC) 10.2.0, GNU ld (GNU Binutils) 2.35.1) #1 SMP PREEMPT Wed, 18 Nov 2020 19:52:04 +0000
> 
> # xfs_info /usr
> meta-data=/dev/mapper/vg0-usr    isize=512    agcount=4, agsize=524288 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1
> data     =                       bsize=4096   blocks=2097152, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=3693, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> All crashes occured during system updating with pacman. In all cases the /usr
> filesystem was affected.
> 
> Regards
> Friedemann
