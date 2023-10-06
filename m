Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B667CE94101
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbjJFSzM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbjJFSyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:54:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F40111
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xavYdX/wZ0RnKLfU/MnqAKGW0flPB1iaCT9iprzm3zc=;
        b=Ujz+NlbGEN9Q1P/qTduhm5DSQzJw45W7JGaX8A3XXLl1fpvTdbzNgoJsQIYlw4taJoWqMq
        0HuQHRW8fk/t/B0dCE/klIy2JF05S8nMhC2GEgUJA3aoMnFZFVLIh/UOjbVbe0XrAyVPo1
        g1F8xXbrvoRz87l/Bd+cmm82i+DJuuw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-rKQ9aIx5MjCRWGHiNWHx2A-1; Fri, 06 Oct 2023 14:52:41 -0400
X-MC-Unique: rKQ9aIx5MjCRWGHiNWHx2A-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9a62adedadbso211235066b.1
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618360; x=1697223160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xavYdX/wZ0RnKLfU/MnqAKGW0flPB1iaCT9iprzm3zc=;
        b=VI/Th81wc0jNgcyxkOaveabR/y2lOYPAss4W2wBqqqEMuQlHduAOB2pp85AnYnZ47T
         +Rvgj1Ii+s+2N6Yr3R5uMjUhP6NqwqoucNYvIM5AvG6QFLRnL8gQ1oaizYypa9IeWKuQ
         gpWfWGxmXoKNPN6LvvWhuE3FWzSeBXcgnFrrAkdq5sMwNJ6K+nkEivPGhw5ZcOyDW0/X
         rkkmNcei3JV2W8++OenOA2RYyxRW04Sd7ezzB8nGOkfbm9fyBgxOWWPkwowa1P43WurD
         PD3aeuKBjkm0YPf8p52NEgsn2DhB4erkbb4HE2atO2U5wRTeGVx/PT6dDjQC4G+hnWQ7
         cLBA==
X-Gm-Message-State: AOJu0YyUWtAJF/J9ZPnJBX312xfq4+mDBTIRLPB1Tz0Y8An/G/Kfa8uF
        6AILnco2VK0SFYLaNcE4CEPdCea7qjkSKFQmJ6df6EpdHDXuW1xi0VUC8FRyUXKqyJBa4WWPuax
        lP+HBkjChQWSiH2ISCyaATXyOr+lKMsiKJgMlXfceES70aBi1R4kshZ2+UAppb81jNzSgG680ys
        UMrTI=
X-Received: by 2002:a17:907:75f7:b0:9ae:658f:a80a with SMTP id jz23-20020a17090775f700b009ae658fa80amr7985143ejc.48.1696618360183;
        Fri, 06 Oct 2023 11:52:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7SK73SUKTlwsNFT0YwN9JhYvDJYdu/UT4rHQhvxh32fN6Ie3lbiMgVmY+qoDZrohiyXJoFw==
X-Received: by 2002:a17:907:75f7:b0:9ae:658f:a80a with SMTP id jz23-20020a17090775f700b009ae658fa80amr7985129ejc.48.1696618359925;
        Fri, 06 Oct 2023 11:52:39 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:39 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 23/28] xfs: don't allow to enable DAX on fs-verity sealsed inode
Date:   Fri,  6 Oct 2023 20:49:17 +0200
Message-Id: <20231006184922.252188-24-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
inodes which already have fs-verity enabled. The opposite is checked
when fs-verity is enabled, it won't be enabled if DAX is.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 9f2d5c2505ae..3153767f0d6f 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1209,6 +1209,8 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
-- 
2.40.1

