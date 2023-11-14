Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 938EDC074FD
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 01:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbjKNBx7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbjKNBx6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 20:53:58 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140BAD44
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:55 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1cc68c1fac2so45882485ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699926834; x=1700531634; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBeYMsYS9dTbIpPqHB0pGx1gW53aFcxx0jv/SHtFKug=;
        b=JwgaorsIbWIZONOX1fidxA8yyE4AajPLTM7S2tzo4g9nl2J/Ora9UXZdAKTLj7Epam
         fomB1R5WoHSR4rdZzlIlKqWMJI0pkEumyyswFtYYsEndwe1u7ZzyO4k57fRHOTEbOJu7
         DVxXXqibuVbyK7pgsCnpwM+jIM9f+vcyW6Hgh2tEsfKWhkADMElz8w0egIu8PAkOG2E/
         /lhrFdhNycd27DGMLtwd47amtWNCEE6eJGOcTDpWcjd33B3oz/XBsydMrpCUY3LWmUbE
         5JxGTYnZW1239A5kTZ1CG/YMxhNT3BrsF/XuLhPWwwWkKLUAElbNjM8xNbF3JDPz9Z14
         wCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699926834; x=1700531634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bBeYMsYS9dTbIpPqHB0pGx1gW53aFcxx0jv/SHtFKug=;
        b=KJZWkqxkhO3Wc3AA0NdugTtshVFViTU/t89Vb/TL757rV34768FkeP+NEh4/Uq8Upf
         pxndNH4aOEWY08TqNzPSnd8/7Bq9gCu2kGTfmEziteKxzG12a6FgSkomnTpbIMn+xJvv
         /BVUUAdZCH4nEKtU9J/yTZP6O41a7DQpZ7J7SQYLEtDFO3OfzVgW0nj0xnu3Ff8wRE0s
         z3xcfc+uGcxjFgYuh4v8Ua4PLFO6GW4inCoOcQdXL6WcxFO6vmpmeAdsUT3ibaK9njAc
         /oXGzSjZjyysFjV3MeC1copB3yKZSxN7SLA3e7AGB0UOR1Wtgy0Y1V9HIR1dg+XN/7wa
         xFDg==
X-Gm-Message-State: AOJu0Yxm6mq22kSXsFhyieYyJjxwYWuX5M9xfFv/CxEWZftGb0lPmcq6
        rvGORdDuqREQA0Mus0EQaucYACO33RH3DA==
X-Google-Smtp-Source: AGHT+IEOcgv3zsFMcSedXismyYxl+FSvVRICjFms3Sl6ht2zjv30sokBKjQXpZJv0HMbW0+aN5E28g==
X-Received: by 2002:a17:902:7881:b0:1ce:33b2:a1e0 with SMTP id q1-20020a170902788100b001ce33b2a1e0mr1070437pll.33.1699926834321;
        Mon, 13 Nov 2023 17:53:54 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d177:a8ad:804f:74f1])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902ecd100b001c9cb2fb8d8sm4668592plh.49.2023.11.13.17.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 17:53:54 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com, fred@cloudflare.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 08/17] xfs: don't leak memory when attr fork loading fails
Date:   Mon, 13 Nov 2023 17:53:29 -0800
Message-ID: <20231114015339.3922119-9-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114015339.3922119-1-leah.rumancik@gmail.com>
References: <20231114015339.3922119-1-leah.rumancik@gmail.com>
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

