Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19400C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 16:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2448613DB
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 16:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhHWQPF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 12:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229477AbhHWQPE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Aug 2021 12:15:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 32104613E6
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 16:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629735262;
        bh=L7bto+kMEr0Zi4pHah2SzqHdr61gK/AMiEnnHs+2POs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=cpIvdXxMirM4u6Ul5oMlRatnNL3nOkCgd2c6UMAApTnqbUpnaYP7zqvuFNy+/25mI
         gzQafRhOZ5QcrZZUoBdExU8A1uC8V7kqHQTKwSu1oHR3OT2nPOQBEEyxoBrb4qAN/o
         /tW5eWrg/E1MFgVYfTEiEnEvVHqCqN1i8x3Fg+UAjJQQMfJOJ+24FwDtPw2Fmxdv0X
         1IGPZcy7hhuKwxO1lHqjhypfU34bAlsZlBFctC9ATAKe3JqBtZqd0hJkQkpWaQYLoW
         qOU0ZlDLr/cjQ8eFctecUTMErKFxItpqG3ZFGl5oMiUb4/xLRvNwQ4srjqMJQc1pqV
         brFME/SEeCfgA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214077] [xfstests xfs/168] xfs_repair failed with shrinking
 776672
Date:   Mon, 23 Aug 2021 16:14:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: xiang@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-214077-201763-klccByZGAt@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214077-201763@https.bugzilla.kernel.org/>
References: <bug-214077-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214077

Gao Xiang (xiang@kernel.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |xiang@kernel.org

--- Comment #5 from Gao Xiang (xiang@kernel.org) ---
Hi,

I tried several times without any luck in my own VM,
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 AliYun 5.13.0-rc4+ #1 SMP Mon Aug 23 20:17:12=
 CST
2021
MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,reflink=3D1,rmapbt=3D1,bigtime=3D=
1,inobtcount=3D1
-b size=3D1024 /dev/loop1
MOUNT_OPTIONS -- /dev/loop1 /fs/loop1

xfs/168 197s ...  225s
Ran: xfs/168
Passed all 1 tests

But with my own understanding, I guess that may be due to the following
condition:

                /*=20
                 * Roll the transaction before trying to re-init the per-ag=
=20
                 * reservation. The new transaction is clean so it will can=
cel=20
                 * without any side effects.=20
                 */=20
                error =3D xfs_defer_finish(tpp);  <--- here we unlock the A=
GF,
new allocation allowed.
                if (error)=20
                        return error;=20

                error =3D -ENOSPC;=20
                goto resv_init_out;=20
        }=20
        xfs_ialloc_log_agi(*tpp, agibp, XFS_AGI_LENGTH);=20
        xfs_alloc_log_agf(*tpp, agfbp, XFS_AGF_LENGTH);
        return 0;
resv_init_out:
        err2 =3D xfs_ag_resv_init(agibp->b_pag, *tpp); <--- so resv init ca=
n be
failed here.
        if (!err2)
                return error;
resv_err:
        xfs_warn(mp, "Error %d reserving per-AG metadata reserve pool.", er=
r2);
        xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
        return err2;

As I mentioned before, I'm not sure if growfs has similiar race like this.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
