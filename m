Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F24ECC4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 16:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F179207A9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 16:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbgLCQNS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 11:13:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729965AbgLCQNS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 11:13:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607011911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=sHOvwdbyRH2luwOlXD7q+xrnG9OL5GkCAEesL4epgrU=;
        b=CXHCoXvrkK9pY8iKNu0ETPGnIo9RyNL8K9O+tIvcU2cl2RZjatPfavvnKLu+gIzYYJ2vqF
        kyjUTArVb8vYhAzqxeWCZRlCcUIawAJw287B7osrBFgY2Zh6rSNV3UUaIZrpDbsfnO1I/r
        8mU3da9qbXyctyuA14rqQIfmVKHBAag=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435--2De0Z8uNMC3UvBdUyWhIw-1; Thu, 03 Dec 2020 11:11:48 -0500
X-MC-Unique: -2De0Z8uNMC3UvBdUyWhIw-1
Received: by mail-pg1-f198.google.com with SMTP id o128so1680466pga.2
        for <linux-xfs@vger.kernel.org>; Thu, 03 Dec 2020 08:11:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sHOvwdbyRH2luwOlXD7q+xrnG9OL5GkCAEesL4epgrU=;
        b=XzB2Fb0H9LApcQqZ7WrIcjX94S+Br3oCTSJ7D2fxnrFp4kBVjryqQCHyg5bqK+NRkO
         pIG8mh3w+sThUNeDlXuMFy9ObzkL2hYjHQQDaj9JPhCpQh9KAm4/dHU5U4fsjMLUo65Z
         7PdzZ1CIsR8jBrq0bNcJyu905OGg671lEeYD4ILckypZsHcsKEPH9Qunx+lxNQyk8qc6
         1ufiUcrjAJh8otDNDzG5NTFx99AeOfq17ix6AT6DEIa7wioWuq6CnqVtdihA3qh0x510
         zTaxYaRVs+nUHAh/RtRS6jEtDVaRUy9f7BzKe3oN6g+WfnuOrrfO0WpYWIDZFylyRlFo
         92bw==
X-Gm-Message-State: AOAM530lPnjnbpSBXlKuUWBQvO5pVM++rZkK6JkOe9CuQfO5sOHepPj3
        g4kVwSmQ6vhW/ypRNUBeA6HpqrPAPj/sdRMXpCdbId8ztSyRIsmIi44SK29KkzO9YDoHuEockmf
        je32og3qSJEzsDb6EUmmafTxTFLDMDrSy1nSuo6NlVDVlK/n0LqHRyEEPzq+ITuW+KdkZtvdSfQ
        ==
X-Received: by 2002:a17:902:b498:b029:da:84a7:be94 with SMTP id y24-20020a170902b498b02900da84a7be94mr3695387plr.52.1607011907431;
        Thu, 03 Dec 2020 08:11:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxmg/dh+oek14A3BiOdGkzHQXxSSIgxlwgyPNuRORT6NM4J2KuyWY+0kpFgOkxIcMDSTSTEwA==
X-Received: by 2002:a17:902:b498:b029:da:84a7:be94 with SMTP id y24-20020a170902b498b02900da84a7be94mr3695367plr.52.1607011907135;
        Thu, 03 Dec 2020 08:11:47 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l1sm1738798pgg.4.2020.12.03.08.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 08:11:46 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v2 6/6] xfs: kill ialloced in xfs_dialloc()
Date:   Fri,  4 Dec 2020 00:10:28 +0800
Message-Id: <20201203161028.1900929-7-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201203161028.1900929-1-hsiangkao@redhat.com>
References: <20201203161028.1900929-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

It's enough to just use return code, and get rid of an argument.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 597629353d4d..ec63afb59156 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -607,13 +607,13 @@ xfs_inobt_insert_sprec(
 
 /*
  * Allocate new inodes in the allocation group specified by agbp.
- * Return 0 for success, else error code.
+ * Returns 0 if inodes were allocated in this AG; 1 if there was no space
+ * in this AG; or the usual negative error code.
  */
 STATIC int
 xfs_ialloc_ag_alloc(
 	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	int			*alloc)
+	struct xfs_buf		*agbp)
 {
 	struct xfs_agi		*agi;
 	struct xfs_alloc_arg	args;
@@ -795,10 +795,9 @@ xfs_ialloc_ag_alloc(
 		allocmask = (1 << (newlen / XFS_INODES_PER_HOLEMASK_BIT)) - 1;
 	}
 
-	if (args.fsbno == NULLFSBLOCK) {
-		*alloc = 0;
-		return 0;
-	}
+	if (args.fsbno == NULLFSBLOCK)
+		return 1;
+
 	ASSERT(args.len == args.minlen);
 
 	/*
@@ -903,7 +902,6 @@ xfs_ialloc_ag_alloc(
 	 */
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, (long)newlen);
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, (long)newlen);
-	*alloc = 1;
 	return 0;
 }
 
@@ -1749,7 +1747,6 @@ xfs_dialloc_select_ag(
 	struct xfs_buf		*agbp;
 	xfs_agnumber_t		agno;
 	int			error;
-	int			ialloced;
 	bool			noroom = false;
 	xfs_agnumber_t		start_agno;
 	struct xfs_perag	*pag;
@@ -1823,17 +1820,14 @@ xfs_dialloc_select_ag(
 		if (!okalloc)
 			goto nextag_relse_buffer;
 
-
-		error = xfs_ialloc_ag_alloc(*tpp, agbp, &ialloced);
-		if (error) {
+		error = xfs_ialloc_ag_alloc(*tpp, agbp);
+		if (error < 0) {
 			xfs_trans_brelse(*tpp, agbp);
 
 			if (error == -ENOSPC)
 				error = 0;
 			break;
-		}
-
-		if (ialloced) {
+		} else if (error == 0) {
 			/*
 			 * We successfully allocated some inodes, so roll the
 			 * transaction and return the locked AGI buffer to the
-- 
2.18.4

