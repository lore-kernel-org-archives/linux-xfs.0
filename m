Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B4FCCA47E
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 07:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiF0Hda (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 03:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbiF0Hd3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 03:33:29 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115EF5F7B;
        Mon, 27 Jun 2022 00:33:28 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v14so11698288wra.5;
        Mon, 27 Jun 2022 00:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BztR3xl1wXSqEmt618SWPDGdztRQPzdI6eVz/ObVHhI=;
        b=CvjX0rm3EoE8khbsBpmBE9BcbieFleylvaRKbdxtOkTzj+SbayW9UF0BBNBXYqMkvT
         cftKVq0oHpbSfg/c0e8FX+Fpto1YAnDYw/dZ5p5hWOkM11OMauDd2AL1JvW7N7kB3H9y
         /HQ54m2qUpQIM/MVNaLt8dHNEb5T5tb6wfM4uXCIFDgHsSuplCsH7BmJL3ed8/askgAR
         /3NnqvrCsfdD/41lOhoPdlfZDVivzEa4F32Bfxp8GTJOSqyl5osgM3Y+I75Uva3imMHI
         3wAitz3MniFjqW4D5hbGr4/kkWbw9rApViT2x1Wg5uzIRmmEU353GvJYROqHyP4JDoUL
         CLhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BztR3xl1wXSqEmt618SWPDGdztRQPzdI6eVz/ObVHhI=;
        b=SWAdEH9/9KBjZZ/mv03yXm8Pp61kjk7SxxCi5lO3he4XVzOdov1VljWcoDEp+gr6Rh
         tSH55kMPLbaQYuQqu1310aNyyQVYX/summKtru/Tj/0qICqQqY5an0oYghFq7CTBlArk
         D8TS+JMvV0th0Hq+mCiegAXYP1C1s8YxflOkJXTlY/2AhfLYuxEaGhOuf6re0xwdUnXe
         0eRZxu4QG3TiEQzZwl9dFxzE6GNmC+q5dXwFdR3vS2Z+oGQ6FFiSab7zqi0wscmfIF4u
         i/S9/BEbyp2+cEWH7FSgzS4nZ+dLQ601fbsEfs1U0+CWQTSlHhrcsL4bPfcIz6ozgEEN
         Frnw==
X-Gm-Message-State: AJIora/SCMdes1qacSWDT9jb9uUeu9gCqUsNJjef8fkmQnwKLZOMuuXV
        g4tsR7EWNQHhg0mGo0Mq8sY=
X-Google-Smtp-Source: AGRyM1vuI/aNm+g7BWDoprDddUlIrM6zLYlPhBendmGhbSF0w2LJP0cOpEJu7/kvbPOcpWOpRkNJnw==
X-Received: by 2002:a5d:4d10:0:b0:21b:93fc:67a9 with SMTP id z16-20020a5d4d10000000b0021b93fc67a9mr10434361wrt.505.1656315207670;
        Mon, 27 Jun 2022 00:33:27 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id j20-20020a05600c2b9400b00397623ff335sm12070070wmc.10.2022.06.27.00.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 00:33:27 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5.10 CANDIDATE v2 7/7] xfs: fix xfs_reflink_unshare usage of filemap_write_and_wait_range
Date:   Mon, 27 Jun 2022 10:33:11 +0300
Message-Id: <20220627073311.2800330-8-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220627073311.2800330-1-amir73il@gmail.com>
References: <20220627073311.2800330-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit d4f74e162d238ce00a640af5f0611c3f51dad70e upstream.

The final parameter of filemap_write_and_wait_range is the end of the
range to flush, not the length of the range to flush.

Fixes: 46afb0628b86 ("xfs: only flush the unshared range in xfs_reflink_unshare")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_reflink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 6fa05fb78189..aa46b75d75af 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1503,7 +1503,8 @@ xfs_reflink_unshare(
 	if (error)
 		goto out;
 
-	error = filemap_write_and_wait_range(inode->i_mapping, offset, len);
+	error = filemap_write_and_wait_range(inode->i_mapping, offset,
+			offset + len - 1);
 	if (error)
 		goto out;
 
-- 
2.25.1

