Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABD7C4BA06
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 02:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25DAF21744
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 02:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="Rf+CVbYi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgBZCGo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 21:06:44 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:45538 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbgBZCGo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 21:06:44 -0500
Received: by mail-qv1-f68.google.com with SMTP id l14so608288qvu.12
        for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2020 18:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NSkwZNOAHW8c739fmLnrfEAtdBwdaCvTO8Gg7YKI1a8=;
        b=Rf+CVbYi5z8LNsUAgPb/YJeUfXPNLe4/iRX+Up3V3VHLLY2KxPkKFlCuqEh2zLwqrO
         t2q7IVxnBeyRpDj3yJPm9d71aydf+FXdCkDWtpj1bUMeAg6RIQFjOhqC5rjkmY7izdjd
         T3ds6ct/gdClzPmaG89AFYoNON9+rAw2qDdAkqTVa0ojnxIt567IODMwok7wbnQZnvu4
         bhXurR4+z7IbsAM+t79v9VZDRekZfaj7AMdBDO7Uh195IFUW0vLkZyCWp1kUMc3qDNlC
         IaX8OgE/34tU49jIOCiYqgLEREDNQOPusIXErXKBIGfokntQSqQG+OedlJJyfGLlWHxV
         NHxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NSkwZNOAHW8c739fmLnrfEAtdBwdaCvTO8Gg7YKI1a8=;
        b=LXdE0gtZIh+Ct/FhYfmKQUaHOqBk7Agpxq6dO86x3PDlwzWbWIWnLhSJdRdzdKssnW
         IMbV5nKcYB5ltRoAqagtyA6PIK2LFoocCkmmAznx8DpNCtMtq8Qdqda/hKbFKCbSHF9g
         weWhEw0qS5PokfXao6FDn7ZxLUWQvDoofLOfwx8Pdvv0WArSUyPWYwzvUgN8UF5AXsCL
         kDNU+p3TzAuRy0EVKmNJVNT9MEk/O5EVTsMVcQUYgUHZLeaLeesu4wg4qmwj+5QV4NzX
         yaxMSUyMwUJzVBmmdH2zl1CVAtaovhzGjNj6/fQRYsm0gYwjJ+UkqGsRp8b5acqiSKZR
         4tHg==
X-Gm-Message-State: APjAAAUyJ4esSymiZI3tGDuTW2KNO3AY5qG+Eem0RIVr14hjJGkmBfJ+
        5aVDO89qNdwHkCRdwI5Eq0tnFw==
X-Google-Smtp-Source: APXvYqyFkp00IAiNHBc2lKdiBE7KKll3+LIQTscMbLqIHkaNeczjw5hevunZRksLoakR7GI0I+XDOA==
X-Received: by 2002:ad4:4e50:: with SMTP id eb16mr2386360qvb.34.1582682803407;
        Tue, 25 Feb 2020 18:06:43 -0800 (PST)
Received: from ovpn-121-122.rdu2.redhat.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id h12sm265718qtn.56.2020.02.25.18.06.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Feb 2020 18:06:42 -0800 (PST)
From:   Qian Cai <cai@lca.pw>
To:     darrick.wong@oracle.com
Cc:     hch@infradead.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH v3] xfs: fix an undefined behaviour in _da3_path_shift
Date:   Tue, 25 Feb 2020 21:06:37 -0500
Message-Id: <20200226020637.1065-1-cai@lca.pw>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In xfs_da3_path_shift() "blk" can be assigned to state->path.blk[-1] if
state->path.active is 1 (which is a valid state) when it tries to add an
entry to a single dir leaf block and then to shift forward to see if
there's a sibling block that would be a better place to put the new
entry. This causes a UBSAN warning given negative array indices are
undefined behavior in C. In practice the warning is entirely harmless
given that "blk" is never dereferenced in this case, but it is still
better to fix up the warning and slightly improve the code.

 UBSAN: Undefined behaviour in fs/xfs/libxfs/xfs_da_btree.c:1989:14
 index -1 is out of range for type 'xfs_da_state_blk_t [5]'
 Call trace:
  dump_backtrace+0x0/0x2c8
  show_stack+0x20/0x2c
  dump_stack+0xe8/0x150
  __ubsan_handle_out_of_bounds+0xe4/0xfc
  xfs_da3_path_shift+0x860/0x86c [xfs]
  xfs_da3_node_lookup_int+0x7c8/0x934 [xfs]
  xfs_dir2_node_addname+0x2c8/0xcd0 [xfs]
  xfs_dir_createname+0x348/0x38c [xfs]
  xfs_create+0x6b0/0x8b4 [xfs]
  xfs_generic_create+0x12c/0x1f8 [xfs]
  xfs_vn_mknod+0x3c/0x4c [xfs]
  xfs_vn_create+0x34/0x44 [xfs]
  do_last+0xd4c/0x10c8
  path_openat+0xbc/0x2f4
  do_filp_open+0x74/0xf4
  do_sys_openat2+0x98/0x180
  __arm64_sys_openat+0xf8/0x170
  do_el0_svc+0x170/0x240
  el0_sync_handler+0x150/0x250
  el0_sync+0x164/0x180

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Qian Cai <cai@lca.pw>
---

 v3: Borrow the commit log from Christoph.
 v2: Update the commit log thanks to Darrick.
     Simplify the code.

 fs/xfs/libxfs/xfs_da_btree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 875e04f82541..e864c3d47f60 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1986,7 +1986,8 @@ xfs_da3_path_shift(
 	ASSERT(path != NULL);
 	ASSERT((path->active > 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	level = (path->active-1) - 1;	/* skip bottom layer in path */
-	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
+	for (; level >= 0; level--) {
+		blk = &path->blk[level];
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr,
 					   blk->bp->b_addr);
 
-- 
2.21.0 (Apple Git-122.2)

