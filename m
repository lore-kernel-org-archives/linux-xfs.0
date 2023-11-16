Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A2AC2BB3F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 02:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344497AbjKPC2u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344463AbjKPC2t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 21:28:49 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39E819E;
        Wed, 15 Nov 2023 18:28:46 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-5a9bc2ec556so242490a12.0;
        Wed, 15 Nov 2023 18:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700101726; x=1700706526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ttm9oT2ytWj9k9eU+TyoYVC+3EqiI8xfehOR37fLkAY=;
        b=mDIjvelrDa3Pzm3Ipn8bfqajv+AA1dfvCK6rdzbt2iFgh+K2Vn8XtKyfPHUi32AUX9
         VF5BHVHc5IkdKsLy/n0GTqM4xFTpozK8Okwb85PiOdy3CN8iThjyrLPTr+XICHva/4ne
         fLg+fIhh9BHQx8SdHh8RVCk5PNa79iSnrIxi5B/AMTJxrY021l8eq7+40BDqKXK+upDO
         mlAnphRpTU08V5/7ev/CMpz0OOanuJJvPQFrPo51/9n9kZsYVl50/gck3ndiq6YndhUD
         9HAzftV+yTPFfNf9VdWAw+IqOQhUOVWhGRr2jCn0tC1/C91E5XT89lrTBZnZyz7lL1yU
         1LYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700101726; x=1700706526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ttm9oT2ytWj9k9eU+TyoYVC+3EqiI8xfehOR37fLkAY=;
        b=tvGP8Sv2ZOPSpIdPHiUWSyH3PMRWTZJ1v8DSkt2cKT33hPU2HextRIP1iIZXazUTo9
         A/qxkS0VqpdUs1nMD1IZReOnV5FxOVis+Rku+JnN6cpd7LpiWhgKrUWMk8OQk0tiOYQK
         ZDx9AvZUjsf/EMXLsPIQLn/4yfHU5b3CzsXpkOxznc6Zmob4Msw4B1rbYi8sNWbVT7g3
         vQLcUn+mz95IFGj2pLAXIj1osT11u5OujMr+CpXHXaffjbte3HbwBAgv6sGCZKRiQsid
         x6HPBma1do52V/iFUfk7NVeHnqx/L0E+jS39lUthlYXUIpJA4Wb7Qb1y0/uopjiMGOut
         0X1A==
X-Gm-Message-State: AOJu0Ywp3O4E3WjPcZiMb3YTYmcgoHYA9V4C1MUjeaFUe/uPQ8QaMEK+
        ZD30GmwhGmBZPRfYFDCU/50VSk52AloO0A==
X-Google-Smtp-Source: AGHT+IGe9nbfkdWphipO+OGDGo8xWHWw2cwvRcgtsID+TLiVMiOiXMfq4Rg8g+Hqdu1prTWqOxTT5g==
X-Received: by 2002:a05:6a20:a111:b0:187:7a49:82a3 with SMTP id q17-20020a056a20a11100b001877a4982a3mr3269911pzk.36.1700101725937;
        Wed, 15 Nov 2023 18:28:45 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:25ea:d6bb:623c:d6a0])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b001b8b1f6619asm8087072plh.75.2023.11.15.18.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:28:45 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15 08/17] xfs: don't leak memory when attr fork loading fails
Date:   Wed, 15 Nov 2023 18:28:24 -0800
Message-ID: <20231116022833.121551-8-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231116022833.121551-1-leah.rumancik@gmail.com>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit c78c2d0903183a41beb90c56a923e30f90fa91b9 ]

I observed the following evidence of a memory leak while running xfs/399
from the xfs fsck test suite (edited for brevity):

XFS (sde): Metadata corruption detected at xfs_attr_shortform_verify_struct.part.0+0x7b/0xb0 [xfs], inode 0x1172 attr fork
XFS: Assertion failed: ip->i_af.if_u1.if_data == NULL, file: fs/xfs/libxfs/xfs_inode_fork.c, line: 315
------------[ cut here ]------------
WARNING: CPU: 2 PID: 91635 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
CPU: 2 PID: 91635 Comm: xfs_scrub Tainted: G        W         5.19.0-rc7-xfsx #rc7 6e6475eb29fd9dda3181f81b7ca7ff961d277a40
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
RIP: 0010:assfail+0x46/0x4a [xfs]
Call Trace:
 <TASK>
 xfs_ifork_zap_attr+0x7c/0xb0
 xfs_iformat_attr_fork+0x86/0x110
 xfs_inode_from_disk+0x41d/0x480
 xfs_iget+0x389/0xd70
 xfs_bulkstat_one_int+0x5b/0x540
 xfs_bulkstat_iwalk+0x1e/0x30
 xfs_iwalk_ag_recs+0xd1/0x160
 xfs_iwalk_run_callbacks+0xb9/0x180
 xfs_iwalk_ag+0x1d8/0x2e0
 xfs_iwalk+0x141/0x220
 xfs_bulkstat+0x105/0x180
 xfs_ioc_bulkstat.constprop.0.isra.0+0xc5/0x130
 xfs_file_ioctl+0xa5f/0xef0
 __x64_sys_ioctl+0x82/0xa0
 do_syscall_64+0x2b/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

This newly-added assertion checks that there aren't any incore data
structures hanging off the incore fork when we're trying to reset its
contents.  From the call trace, it is evident that iget was trying to
construct an incore inode from the ondisk inode, but the attr fork
verifier failed and we were trying to undo all the memory allocations
that we had done earlier.

The three assertions in xfs_ifork_zap_attr check that the caller has
already called xfs_idestroy_fork, which clearly has not been done here.
As the zap function then zeroes the pointers, we've effectively leaked
the memory.

The shortest change would have been to insert an extra call to
xfs_idestroy_fork, but it makes more sense to bundle the _idestroy_fork
call into _zap_attr, since all other callsites call _idestroy_fork
immediately prior to calling _zap_attr.  IOWs, it eliminates one way to
fail.

Note: This change only applies cleanly to 2ed5b09b3e8f, since we just
reworked the attr fork lifetime.  However, I think this memory leak has
existed since 0f45a1b20cd8, since the chain xfs_iformat_attr_fork ->
xfs_iformat_local -> xfs_init_local_fork will allocate
ifp->if_u1.if_data, but if xfs_ifork_verify_local_attr fails,
xfs_iformat_attr_fork will free i_afp without freeing any of the stuff
hanging off i_afp.  The solution for older kernels I think is to add the
missing call to xfs_idestroy_fork just prior to calling kmem_cache_free.

Found by fuzzing a.sfattr.hdr.totsize = lastbit in xfs/399.

[ backport note: did not include refactoring of xfs_idestroy_fork into
xfs_ifork_zap_attr, simply added the missing call as suggested in the
commit for backports ]

Fixes: 2ed5b09b3e8f ("xfs: make inode attribute forks a permanent part of struct xfs_inode")
Probably-Fixes: 0f45a1b20cd8 ("xfs: improve local fork verification")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 20095233d7bc..c1f965af8432 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -330,6 +330,7 @@ xfs_iformat_attr_fork(
 	}
 
 	if (error) {
+		xfs_idestroy_fork(ip->i_afp);
 		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
 		ip->i_afp = NULL;
 	}
-- 
2.43.0.rc0.421.g78406f8d94-goog

