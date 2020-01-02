Return-Path: <SRS0=76Wm=2X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_QP_LONG_LINE,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE70C3276D
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 16:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C1D924649
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 16:19:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="sL1RfpVM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgABQTz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 11:19:55 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40665 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728795AbgABQTz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jan 2020 11:19:55 -0500
Received: by mail-qk1-f195.google.com with SMTP id c17so31719224qkg.7
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jan 2020 08:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=AvD0QiBESqW0G7LnvKlO+TVu2M/tDLdQS5v3bjNXQuk=;
        b=sL1RfpVM5J8OwjnlP/uhIc5WMEFW17QfPvDDaB23wQx3uNHW4WV11QGWSfkyNqg03Y
         nsn+88VOiuLBEQUbY3255KMO5YJ9Dsv7+TbmLXPLD1B1FkkqluxHvgWPVBUzLBgXwtgs
         BUMmza2bSw5cgisGNTWNLUjYH5Aa+/upH17JBl4cX9DAI4i/SdeKmElV9DltvAjH+A+U
         FxhPNb3dnyTpQuyhy0X9Apb3bTcj1vIsaiV3Zbo+Vm/ldxYfuMwJ9JzsHMKy12NVylQW
         Ij4PVE9Ryi3GyxAgZ4BicSt2oqq0HfihZ1E3kICcNDILJCTHZVyNF8Z/JEKhn2BkiHn1
         wb6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=AvD0QiBESqW0G7LnvKlO+TVu2M/tDLdQS5v3bjNXQuk=;
        b=YwdiBnqEeZhsoMsZ9HTWENlEA9aEPAuCmWaAVKjFLfXfUVf+XmgK3oPkFoEVgCkpzh
         eq98Ii2xP+3TeA6QnV6pzJkMaalkUo3STOftxn1rP4CeZHO0GYvyMCsEWIosF2+R8iLD
         jIkIxzG2k82J5AuNdlBureFRfWZcxCnz+2qW9cB0ZDPzzDDG893gcEwYw9PGgHa0aT7E
         5t62ZGjxFCcVVdsAHcdyUvJZm73x/SRyvqvdISJ0BdBVHnHvQ9H9HJnjbyhGRFYg66u+
         R/laaJWiPy2+rUDXYOvIHAyloJZ1eceEXcmB95Dy39wrralzmv3w/bFf/L2/lUQZUf57
         OfCA==
X-Gm-Message-State: APjAAAXmNg5ePa4pLMDLno0nZEWS4LgjxV0kDXBVq8aJF86ruin3E1Hq
        BfIQcdN1oIaQm5/v+ncJIpKwgA==
X-Google-Smtp-Source: APXvYqxnMnJA0eF10zGRq9HRnzIjXOCnkugv43lLuLc++hI4RTeu/Z0R0juFtbIhR5TeSm2ZrG/a9A==
X-Received: by 2002:a05:620a:136e:: with SMTP id d14mr65398571qkl.342.1577981994212;
        Thu, 02 Jan 2020 08:19:54 -0800 (PST)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id w1sm17341776qtk.31.2020.01.02.08.19.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2020 08:19:53 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] xfs: Fix false positive lockdep warning with sb_internal & fs_reclaim
Date:   Thu, 2 Jan 2020 11:19:51 -0500
Message-Id: <24F33D67-E975-48E1-A285-0D0129CC3033@lca.pw>
References: <20200102155208.8977-1-longman@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20200102155208.8977-1-longman@redhat.com>
To:     Waiman Long <longman@redhat.com>
X-Mailer: iPhone Mail (17C54)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> On Jan 2, 2020, at 10:52 AM, Waiman Long <longman@redhat.com> wrote:
>=20
> Depending on the workloads, the following circular locking dependency
> warning between sb_internal (a percpu rwsem) and fs_reclaim (a pseudo
> lock) may show up:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> WARNING: possible circular locking dependency detected
> 5.0.0-rc1+ #60 Tainted: G        W
> ------------------------------------------------------
> fsfreeze/4346 is trying to acquire lock:
> 0000000026f1d784 (fs_reclaim){+.+.}, at:
> fs_reclaim_acquire.part.19+0x5/0x30
>=20
> but task is already holding lock:
> 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650
>=20
> which lock already depends on the new lock.
>  :
> Possible unsafe locking scenario:
>=20
>       CPU0                    CPU1
>       ----                    ----
>  lock(sb_internal);
>                               lock(fs_reclaim);
>                               lock(sb_internal);
>  lock(fs_reclaim);
>=20
> *** DEADLOCK ***
>=20
> 4 locks held by fsfreeze/4346:
> #0: 00000000b478ef56 (sb_writers#8){++++}, at: percpu_down_write+0xb4/0x65=
0
> #1: 000000001ec487a9 (&type->s_umount_key#28){++++}, at: freeze_super+0xda=
/0x290
> #2: 000000003edbd5a0 (sb_pagefaults){++++}, at: percpu_down_write+0xb4/0x6=
50
> #3: 0000000072bfc54b (sb_internal){++++}, at: percpu_down_write+0xb4/0x650=

>=20
> stack backtrace:
> Call Trace:
> dump_stack+0xe0/0x19a
> print_circular_bug.isra.10.cold.34+0x2f4/0x435
> check_prev_add.constprop.19+0xca1/0x15f0
> validate_chain.isra.14+0x11af/0x3b50
> __lock_acquire+0x728/0x1200
> lock_acquire+0x269/0x5a0
> fs_reclaim_acquire.part.19+0x29/0x30
> fs_reclaim_acquire+0x19/0x20
> kmem_cache_alloc+0x3e/0x3f0
> kmem_zone_alloc+0x79/0x150
> xfs_trans_alloc+0xfa/0x9d0
> xfs_sync_sb+0x86/0x170
> xfs_log_sbcount+0x10f/0x140
> xfs_quiesce_attr+0x134/0x270
> xfs_fs_freeze+0x4a/0x70
> freeze_super+0x1af/0x290
> do_vfs_ioctl+0xedc/0x16c0
> ksys_ioctl+0x41/0x80
> __x64_sys_ioctl+0x73/0xa9
> do_syscall_64+0x18f/0xd23
> entry_SYSCALL_64_after_hwframe+0x49/0xbe
>=20
> According to Dave Chinner:
>=20
>  Freezing the filesystem, after all the data has been cleaned. IOWs
>  memory reclaim will never run the above writeback path when
>  the freeze process is trying to allocate a transaction here because
>  there are no dirty data pages in the filesystem at this point.
>=20
>  Indeed, this xfs_sync_sb() path sets XFS_TRANS_NO_WRITECOUNT so that
>  it /doesn't deadlock/ by taking freeze references for the
>  transaction. We've just drained all the transactions
>  in progress and written back all the dirty metadata, too, and so the
>  filesystem is completely clean and only needs the superblock to be
>  updated to complete the freeze process. And to do that, it does not
>  take a freeze reference because calling sb_start_intwrite() here
>  would deadlock.
>=20
>  IOWs, this is a false positive, caused by the fact that
>  xfs_trans_alloc() is called from both above and below memory reclaim
>  as well as within /every level/ of freeze processing. Lockdep is
>  unable to describe the staged flush logic in the freeze process that
>  prevents deadlocks from occurring, and hence we will pretty much
>  always see false positives in the freeze path....
>=20
> Perhaps breaking the fs_reclaim pseudo lock into a per filesystem lock
> may fix the issue. However, that will greatly complicate the logic and
> may not be worth it.
>=20
> Another way to fix it is to disable the taking of the fs_reclaim
> pseudo lock when in the freezing code path as a reclaim on the freezed
> filesystem is not possible as stated above. This patch takes this
> approach by setting the __GFP_NOLOCKDEP flag in the slab memory
> allocation calls when the filesystem has been freezed.
>=20
> Without this patch, the command sequence below will show that the lock
> dependency chain sb_internal -> fs_reclaim exists.
>=20
> # fsfreeze -f /home
> # fsfreeze --unfreeze /home
> # grep -i fs_reclaim -C 3 /proc/lockdep_chains | grep -C 5 sb_internal
>=20
> After applying the patch, such sb_internal -> fs_reclaim lock dependency
> chain can no longer be found. Because of that, the locking dependency
> warning will not be shown.

There was an attempt to fix this in the past, but Dave rejected right away f=
or any workaround in xfs and insisted to make lockdep smarter instead. No su=
re your approach will make any difference this time. Good luck.=
