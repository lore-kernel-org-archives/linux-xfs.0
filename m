Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17AA7C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 03:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDFC861248
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 03:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbhHXDf2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234449AbhHXDfZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Aug 2021 23:35:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F13FE6127B
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 03:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629776082;
        bh=GhIa40t0ewbvHbsYlft3XTPLPs0QtVJO2B9+wMAprk8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fA77dtdNlH0LxYHsVscj3ioNYo6ezRaJJmHka022vyA2XUXCZ+8PS5RCNuO8F/Rkl
         mogY4a9c5BeEKTR0z4Mw00Hz88dQKJcqvhAu4UtuO5Ak8HVe80v9fc1Mpzc2Tany0q
         hGYeHfnyxilZ2iqhur7cczDnHMQdYYPlNzmoaAHPQkzzSrq8qEVZsrKUMJOmPbj68P
         lOTNiUbIh0V2xqt8l4Uded2i4EHtkILbipneu6XxCbXNkZty6AN9HJopj59rIyNO45
         GATmSORIIQtgncXm5VkdIZfO3rXkmwcIy4j6qQRSJQuY/RHNOD73DPxhfj7cHVMzrJ
         fP62BP1LshikA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214077] [xfstests xfs/168] xfs_repair failed with shrinking
 776672
Date:   Tue, 24 Aug 2021 03:34:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214077-201763-i2Na1FxHgx@https.bugzilla.kernel.org/>
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

--- Comment #6 from Zorro Lang (zlang@redhat.com) ---
By adding some debug output:
diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index ee9ec0c50bec..ce5db7195604 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -859,6 +859,7 @@ xfs_ag_shrink_space(
                 * without any side effects.
                 */
                error =3D xfs_defer_finish(tpp);
+               pr_info("after xfs_defer_finish, error=3D%d", error);
                if (error)
                        return error;

@@ -870,6 +871,7 @@ xfs_ag_shrink_space(
        return 0;
 resv_init_out:
        err2 =3D xfs_ag_resv_init(agibp->b_pag, *tpp);
+       pr_info("after xfs_ag_resv_init [out], err2=3D%d\n", err2);
        if (!err2)
                return error;
 resv_err:

The failed xfs/168 dmesg output as below:

[  820.044203] run fstests xfs/168 at 2021-08-24 11:23:40
[  822.039473] XFS (dm-2): Mounting V5 Filesystem
[  822.126343] XFS (dm-2): Ending clean mount
[  822.176716] XFS (dm-2): EXPERIMENTAL online shrink feature in use. Use at
your own risk!
[  822.232059] XFS (dm-2): Unmounting Filesystem
[  823.999271] XFS (dm-2): Mounting V5 Filesystem
[  824.061384] XFS (dm-2): Ending clean mount
[  829.139729] XFS (dm-2): Unmounting Filesystem
[  829.632030] XFS (dm-2): Mounting V5 Filesystem
[  829.758903] XFS (dm-2): Ending clean mount
[  835.109447] XFS (dm-2): xlog_verify_grant_tail: space > BBTOB(tail_block=
s)
[  835.540700] XFS (dm-2): Unmounting Filesystem
[  836.309492] XFS (dm-2): Mounting V5 Filesystem
[  848.784972] XFS (dm-2): Ending clean mount
[  854.679181] XFS (dm-2): Unmounting Filesystem
[  855.658301] XFS (dm-2): Mounting V5 Filesystem
[  855.757461] XFS (dm-2): Ending clean mount
[  862.342901] XFS (dm-2): xlog_verify_grant_tail: space > BBTOB(tail_block=
s)
[  862.830414] XFS (dm-2): Unmounting Filesystem
[  864.397318] XFS (dm-2): Mounting V5 Filesystem
[  864.734746] XFS (dm-2): Ending clean mount
[  870.743557] XFS (dm-2): Unmounting Filesystem
[  872.274155] XFS (dm-2): Mounting V5 Filesystem
[  878.607770] XFS (dm-2): Ending clean mount
[  885.327410] XFS (dm-2): Unmounting Filesystem
[  887.102664] XFS (dm-2): Mounting V5 Filesystem
[  887.207968] XFS (dm-2): Ending clean mount
[  888.269530] after xfs_ag_resv_init [out], err2=3D0
[  893.921362] XFS (dm-2): xlog_verify_grant_tail: space > BBTOB(tail_block=
s)
[  893.921362] XFS (dm-2): xlog_verify_grant_tail: space > BBTOB(tail_block=
s)
[  894.343531] XFS (dm-2): Unmounting Filesystem
[  896.329804] XFS (dm-2): Mounting V5 Filesystem
[  896.442648] XFS (dm-2): Ending clean mount
[  897.487766] XFS (dm-2): Reserve blocks depleted! Consider increasing res=
erve
pool size.
[  897.532377] after xfs_ag_resv_init [out], err2=3D0
[  897.561337] after xfs_ag_resv_init [out], err2=3D0
[  897.593129] after xfs_defer_finish, error=3D0
[  897.593136] after xfs_ag_resv_init [out], err2=3D0
[  897.627267] after xfs_ag_resv_init [out], err2=3D0
[  897.656902] after xfs_defer_finish, error=3D0
[  897.656909] after xfs_ag_resv_init [out], err2=3D0
[  897.691148] after xfs_ag_resv_init [out], err2=3D0
[  897.719510] after xfs_ag_resv_init [out], err2=3D0
[  897.747765] after xfs_ag_resv_init [out], err2=3D0
[  897.776548] after xfs_ag_resv_init [out], err2=3D0
[  897.799510] after xfs_ag_resv_init [out], err2=3D0
[  897.822176] after xfs_ag_resv_init [out], err2=3D0
[  897.845231] after xfs_ag_resv_init [out], err2=3D0
[  902.797518] XFS (dm-2): Unmounting Filesystem
[  905.223385] XFS (dm-2): Mounting V5 Filesystem
[  905.336268] XFS (dm-2): Ending clean mount
[  906.478459] XFS (dm-2): Per-AG reservation for AG 1 failed.  Filesystem =
may
run out of space.
[  906.488330] after xfs_defer_finish, error=3D0
[  906.488347] after xfs_ag_resv_init [out], err2=3D0
[  906.523046] XFS (dm-2): Per-AG reservation for AG 1 failed.  Filesystem =
may
run out of space.
[  906.532797] after xfs_defer_finish, error=3D0
[  906.532807] after xfs_ag_resv_init [out], err2=3D0
[  906.564799] XFS (dm-2): Per-AG reservation for AG 1 failed.  Filesystem =
may
run out of space.
[  906.574422] after xfs_ag_resv_init [out], err2=3D-28
[  906.579790] XFS (dm-2): Error -28 reserving per-AG metadata reserve pool.
[  906.614881] XFS (dm-2): Corruption of in-memory data (0x8) detected at
xfs_ag_shrink_space+0x78f/0xa90 [xfs] (fs/xfs/libxfs/xfs_ag.c:879).  Shutti=
ng
down filesystem
[  906.631506] XFS (dm-2): Please unmount the filesystem and rectify the
problem(s)
[  907.104870] XFS (dm-2): Unmounting Filesystem
[  909.747600] XFS (dm-1): Unmounting Filesystem

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
