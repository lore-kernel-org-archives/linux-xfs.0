Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD831C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jan 2022 17:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355549AbiALRVe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jan 2022 12:21:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56900 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355559AbiALRVX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jan 2022 12:21:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AA7E616C7
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jan 2022 17:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3DEC36AE5;
        Wed, 12 Jan 2022 17:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642008081;
        bh=oJZ1ZGJZjD+I0fb4jVGAsUID35/gWsFKrHNF3Q8tcoU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CzLp8+wpFExKVyzjNzZGzQ0MdQ/Qx7fe+CpFCCKT98Ghv4N1ZlLGYN7/PyvNLnZZ4
         lkN67Qx0dgRTHfZkSqJYTVSDXAvAbEcT+9BpZECVtjT8rO1q9oZPncq8RlpFctM+e4
         J2XL6HMfm8Vhd8U1x7e6qJrB8FrM2UyOD6IQqZh2WLNUdZqw6OLWomQwSNH6Tobu8a
         fgWFvJXMr2loRgVq69CQE3J35W4qMQfPIkHW3VYUKNzE6v7MnWFiBybXcl4rwg7pLu
         akgQyPbLLf0AuLLNO4NOaX4RFF11/F9I8aVmaRVQQdAUNqlTKRBy+8XawpGQt5eE1k
         vEHHp/BakugOg==
Date:   Wed, 12 Jan 2022 09:21:21 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Well Loaded <wellloaded@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS volume unmounts itself with lots of kernel logs generated
Message-ID: <20220112172121.GA19198@magnolia>
References: <bf0b1c63-8fee-112b-fc6c-801593ef4f23@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf0b1c63-8fee-112b-fc6c-801593ef4f23@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 12, 2022 at 02:11:13PM +0200, Well Loaded wrote:
> I'm having issues with my XFS volume. It mounts itself as soon as some
> medium load happens e.g. can open/view a text file, it crashes under rsync.
> This below is the relevant part of the syslog:

Is the disk full?

--D

> 
> 
> Jan 12 11:42:01 NAS kernel: [ 3179.130696] XFS (sdc1): Unmounting Filesystem
> Jan 12 11:42:03 NAS kernel: [ 3180.798027] XFS (sdc1): Mounting V4
> Filesystem
> Jan 12 11:42:03 NAS kernel: [ 3180.921496] XFS (sdc1): Ending clean mount
> Jan 12 11:47:22 NAS kernel: [ 3498.175610] CPU: 5 PID: 5404 Comm: rsync Not
> tainted 4.18.0-0.bpo.1-amd64 #1 Debian 4.18.6-1~bpo9+1
> Jan 12 11:47:22 NAS kernel: [ 3498.175616] Hardware name: VMware, Inc.
> VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00
> 12/12/2018
> Jan 12 11:47:22 NAS kernel: [ 3498.175622] Call Trace:
> Jan 12 11:47:22 NAS kernel: [ 3498.175629]  dump_stack+0x5c/0x7b
> Jan 12 11:47:22 NAS kernel: [ 3498.175688]  xfs_trans_cancel+0x116/0x140
> [xfs]
> Jan 12 11:47:22 NAS kernel: [ 3498.175736]  xfs_create+0x41d/0x640 [xfs]
> Jan 12 11:47:22 NAS kernel: [ 3498.175780] xfs_generic_create+0x241/0x2e0
> [xfs]
> Jan 12 11:47:22 NAS kernel: [ 3498.175808]  ? d_splice_alias+0x139/0x3f0
> Jan 12 11:47:22 NAS kernel: [ 3498.175812]  path_openat+0x141c/0x14d0
> Jan 12 11:47:22 NAS kernel: [ 3498.175816]  do_filp_open+0x99/0x110
> Jan 12 11:47:22 NAS kernel: [ 3498.175820]  ? __check_object_size+0x98/0x1a0
> Jan 12 11:47:22 NAS kernel: [ 3498.175823]  ? do_sys_open+0x12e/0x210
> Jan 12 11:47:22 NAS kernel: [ 3498.175825]  do_sys_open+0x12e/0x210
> Jan 12 11:47:22 NAS kernel: [ 3498.175829]  do_syscall_64+0x55/0x110
> Jan 12 11:47:22 NAS kernel: [ 3498.175832]
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> Jan 12 11:47:22 NAS kernel: [ 3498.175836] RIP: 0033:0x7f6652f836f0
> Jan 12 11:47:22 NAS kernel: [ 3498.175837] Code: 00 f7 d8 64 89 01 48 83 c8
> ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 83 3d 19 30 2c 00 00 75
> 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 fe 9d 01
> 00 48 89 04 24
> Jan 12 11:47:22 NAS kernel: [ 3498.175875] RSP: 002b:00007ffc53860668
> EFLAGS: 00000246 ORIG_RAX: 0000000000000002
> Jan 12 11:47:22 NAS kernel: [ 3498.175877] RAX: ffffffffffffffda RBX:
> 0000000000000000 RCX: 00007f6652f836f0
> Jan 12 11:47:22 NAS kernel: [ 3498.175879] RDX: 0000000000000180 RSI:
> 00000000000000c2 RDI: 00007ffc538628d0
> Jan 12 11:47:22 NAS kernel: [ 3498.175881] RBP: 000000000003a2f8 R08:
> 000000000000ffff R09: 67756c702e707061
> Jan 12 11:47:22 NAS kernel: [ 3498.175882] R10: 0000000000000000 R11:
> 0000000000000246 R12: 00007ffc53862942
> Jan 12 11:47:22 NAS kernel: [ 3498.175884] R13: 8421084210842109 R14:
> 00000000000000c2 R15: 00007f6653011540
> Jan 12 11:47:22 NAS kernel: [ 3498.175888] XFS (sdc1):
> xfs_do_force_shutdown(0x8) called from line 1018 of file
> /build/linux-GVmoCH/linux-4.18.6/fs/xfs/xfs_trans.c.  Return address =
> 00000000ddf97241
> 
> 
> I have already performed xds_repair /dev/sdc1 and xfs_repair -L /dev/sdc1
> they both completed successfully but the issue is still happening.
> 
> Is there anything else I can try? Is this perhaps a bug?
> 
> Thanks!
