Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E21C74A5B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 11:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjCQLId (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCQLIb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 07:08:31 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B2524BD2
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:30 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id x22so3072198wmj.3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679051308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F/UNgWoj0g/ujTFM4Ms+u1ZVdhi+Be7I9bPF4qnLMhs=;
        b=Y9gUQ5JIPGb/iv/ojPXuaRly0h+JZ6sXZSiTfx7hsx9dp6ZBkhp6y5IYrdzdMZ01hN
         Oxhty4yX1FJYUzeemnLCnCuMlProHdqEmaPa5pCunIZfcdqIhLq36mqicn1wiqewLH64
         Ij/+KEGs0upL5APu3+PH0M+0gHt/evmV3HtpmifaQFoLNGAbdS69wzQoQklAzjqokDOi
         9e4+PHsNEvJd3KkkhYQ7kCxjvCJo5TFs7WpS1brzrDO7DA9CiGIEvyUyaGCFPD8YWnyW
         0hP/IlOpuPr2DRGJs+m3kLsJIoG076Heuma3a9Ft63Ws3q1B9aW9g/jx5CNfk7CkZR2r
         nxww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679051308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F/UNgWoj0g/ujTFM4Ms+u1ZVdhi+Be7I9bPF4qnLMhs=;
        b=iFhtG7KMVpCLWvHXnMwmIAFHqtW3a23SRaWfN3O4ADISIH89Z4Ep0C94rPHsn6opDn
         ACa+2bw3pX8d/dvJZrcknDaHXIkkx7JcFzCsFliWMwC109NZYZWuvmzxL2PKefy0mp1K
         dsp8vfVjf7p0zmMyRf05159x/iQ3mDuMNFQTeLghXgjR9dlNgk4uxYI+7jPDLwGLyK9Q
         4hdeRIIgtxmlCOzxAlYoaEWHIffeKegiewrfMOUBjM0yN+UOlTVw6Nb25CG1WlLLRvuz
         KnJgI3EIfiBKEocQm2D0hTEfxbbWZ7K15ZcMXSchjzvUBgdmMGQ8HLWwZ5JzfPU/bEaR
         P4bw==
X-Gm-Message-State: AO0yUKW7BNeeRl7iW0EDZ41okwtnNkFbvGb7GkjzRquMC5WLd6iln/d5
        BFi4tAEoxioYwkvdzwFw6fk=
X-Google-Smtp-Source: AK7set8bSwocvB4W2/JzjG9vVZHuV2dN3JYViSyO1B3p5ErCIkKwgq5nSzMoZPB+cdT11PFs3VR5BA==
X-Received: by 2002:a7b:c383:0:b0:3ed:8826:255d with SMTP id s3-20020a7bc383000000b003ed8826255dmr1151665wmj.5.1679051308482;
        Fri, 17 Mar 2023 04:08:28 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t14-20020a1c770e000000b003daf7721bb3sm7551100wmi.12.2023.03.17.04.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:08:28 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 CANDIDATE 03/15] xfs: don't leak btree cursor when insrec fails after a split
Date:   Fri, 17 Mar 2023 13:08:05 +0200
Message-Id: <20230317110817.1226324-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317110817.1226324-1-amir73il@gmail.com>
References: <20230317110817.1226324-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit a54f78def73d847cb060b18c4e4a3d1d26c9ca6d upstream.

The recent patch to improve btree cycle checking caused a regression
when I rebased the in-memory btree branch atop the 5.19 for-next branch,
because in-memory short-pointer btrees do not have AG numbers.  This
produced the following complaint from kmemleak:

unreferenced object 0xffff88803d47dde8 (size 264):
  comm "xfs_io", pid 4889, jiffies 4294906764 (age 24.072s)
  hex dump (first 32 bytes):
    90 4d 0b 0f 80 88 ff ff 00 a0 bd 05 80 88 ff ff  .M..............
    e0 44 3a a0 ff ff ff ff 00 df 08 06 80 88 ff ff  .D:.............
  backtrace:
    [<ffffffffa0388059>] xfbtree_dup_cursor+0x49/0xc0 [xfs]
    [<ffffffffa029887b>] xfs_btree_dup_cursor+0x3b/0x200 [xfs]
    [<ffffffffa029af5d>] __xfs_btree_split+0x6ad/0x820 [xfs]
    [<ffffffffa029b130>] xfs_btree_split+0x60/0x110 [xfs]
    [<ffffffffa029f6da>] xfs_btree_make_block_unfull+0x19a/0x1f0 [xfs]
    [<ffffffffa029fada>] xfs_btree_insrec+0x3aa/0x810 [xfs]
    [<ffffffffa029fff3>] xfs_btree_insert+0xb3/0x240 [xfs]
    [<ffffffffa02cb729>] xfs_rmap_insert+0x99/0x200 [xfs]
    [<ffffffffa02cf142>] xfs_rmap_map_shared+0x192/0x5f0 [xfs]
    [<ffffffffa02cf60b>] xfs_rmap_map_raw+0x6b/0x90 [xfs]
    [<ffffffffa0384a85>] xrep_rmap_stash+0xd5/0x1d0 [xfs]
    [<ffffffffa0384dc0>] xrep_rmap_visit_bmbt+0xa0/0xf0 [xfs]
    [<ffffffffa0384fb6>] xrep_rmap_scan_iext+0x56/0xa0 [xfs]
    [<ffffffffa03850d8>] xrep_rmap_scan_ifork+0xd8/0x160 [xfs]
    [<ffffffffa0385195>] xrep_rmap_scan_inode+0x35/0x80 [xfs]
    [<ffffffffa03852ee>] xrep_rmap_find_rmaps+0x10e/0x270 [xfs]

I noticed that xfs_btree_insrec has a bunch of debug code that return
out of the function immediately, without freeing the "new" btree cursor
that can be returned when _make_block_unfull calls xfs_btree_split.  Fix
the error return in this function to free the btree cursor.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_btree.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 24c7d30e41df..0926363179a7 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3190,7 +3190,7 @@ xfs_btree_insrec(
 	struct xfs_btree_block	*block;	/* btree block */
 	struct xfs_buf		*bp;	/* buffer for block */
 	union xfs_btree_ptr	nptr;	/* new block ptr */
-	struct xfs_btree_cur	*ncur;	/* new btree cursor */
+	struct xfs_btree_cur	*ncur = NULL;	/* new btree cursor */
 	union xfs_btree_key	nkey;	/* new block key */
 	union xfs_btree_key	*lkey;
 	int			optr;	/* old key/record index */
@@ -3270,7 +3270,7 @@ xfs_btree_insrec(
 #ifdef DEBUG
 	error = xfs_btree_check_block(cur, block, level, bp);
 	if (error)
-		return error;
+		goto error0;
 #endif
 
 	/*
@@ -3290,7 +3290,7 @@ xfs_btree_insrec(
 		for (i = numrecs - ptr; i >= 0; i--) {
 			error = xfs_btree_debug_check_ptr(cur, pp, i, level);
 			if (error)
-				return error;
+				goto error0;
 		}
 
 		xfs_btree_shift_keys(cur, kp, 1, numrecs - ptr + 1);
@@ -3375,6 +3375,8 @@ xfs_btree_insrec(
 	return 0;
 
 error0:
+	if (ncur)
+		xfs_btree_del_cursor(ncur, error);
 	return error;
 }
 
-- 
2.34.1

