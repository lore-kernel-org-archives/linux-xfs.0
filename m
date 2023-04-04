Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C24C761A6
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 14:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbjDDO5i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbjDDO4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 10:56:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D901BF6
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 07:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680620162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O6TxF2wDPSZ8VkfH+UnP0K94pMIAUpQJ5kpEzKyPwfU=;
        b=GS2KGV/+MUjmaJVfe4mBU+tmK84BvK3X+iEVla2oKufoIc9LreJv2avKNjGPyEuKg+dPXz
        x4p27NZPXC633rljS27T3ciZZ9lZlslOy0thFNJDeHuAz2jKGSOuF/bl+6VMyFD/kGv2WX
        o/ylgYmt0jQTHvTdIRuZIbN19t993fM=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-mfhskv7cOeagvo86uv11tw-1; Tue, 04 Apr 2023 10:56:00 -0400
X-MC-Unique: mfhskv7cOeagvo86uv11tw-1
Received: by mail-qv1-f71.google.com with SMTP id e1-20020a0cd641000000b005b47df84f6eso14823968qvj.0
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 07:56:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O6TxF2wDPSZ8VkfH+UnP0K94pMIAUpQJ5kpEzKyPwfU=;
        b=N+22wwq72cgfc/olNSKyJ1KEKvubliHgf5G/mAYZyXPrIkzImCxXp32rkD7HLb0vs4
         PfvIKlaPkhgCEohYy+1N5kWRZQew9yCvzu9SuaPlpvNa81P5+YUtG2xEtpuuz/rTVDaO
         MH3kbLRPq5jqjwNofHzMN3JlmCm9hMZ/5H/QEa0eZwxXPQq43rlctsfRxd1VWQEPFDRC
         5joLdQlBn7aN6aeau3oaw/Aa6I5bGmDy6tJx1myR8eWomiC+YeMaG0EE+nmzhHEM348v
         uaC1gTwskgc3gMygwYpp1mXX2IJeCoZ4cUp5hXBAMUorq2LI+BikXXt5tH5ASYPNJ4IG
         SbjA==
X-Gm-Message-State: AAQBX9cTSgwBNlqD39bK8HaNq1YADDHgzPDR/uZ/RWKB0wOm0vmD53ix
        SNnz9+YsHn6kXGYYWvX/WBQFJM/BFEBnQbgrtTN04VqhJ6V1kIOlkB+ZHiXlUuAS+7cL+RCox1y
        p9PHeXKKbrHIYxLnumSQ=
X-Received: by 2002:ac8:5b8f:0:b0:3e3:9502:8dfc with SMTP id a15-20020ac85b8f000000b003e395028dfcmr4467461qta.9.1680620159962;
        Tue, 04 Apr 2023 07:55:59 -0700 (PDT)
X-Google-Smtp-Source: AKy350a7eyzBLFAVwLtkZzZp5jojS6UQc2rD1+xfGSjK6d6WcBELJ7jmQgpE+gezZ7mdNPw1AFtdEg==
X-Received: by 2002:ac8:5b8f:0:b0:3e3:9502:8dfc with SMTP id a15-20020ac85b8f000000b003e395028dfcmr4467424qta.9.1680620159602;
        Tue, 04 Apr 2023 07:55:59 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j4-20020ac86644000000b003e6387431dcsm3296539qtp.7.2023.04.04.07.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:55:59 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     djwong@kernel.org, dchinner@redhat.com, ebiggers@kernel.org,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 23/23] xfs: enable ro-compat fs-verity flag
Date:   Tue,  4 Apr 2023 16:53:19 +0200
Message-Id: <20230404145319.2057051-24-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230404145319.2057051-1-aalbersh@redhat.com>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Finalize fs-verity integration in XFS by making kernel fs-verity
aware with ro-compat flag.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index ccb2ae5c2c93..a21612319765 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -355,10 +355,11 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
 #define XFS_SB_FEAT_RO_COMPAT_VERITY   (1 << 4)		/* fs-verity */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
-		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
-		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
-		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
-		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		(XFS_SB_FEAT_RO_COMPAT_FINOBT  | \
+		 XFS_SB_FEAT_RO_COMPAT_RMAPBT  | \
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
+		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT| \
+		 XFS_SB_FEAT_RO_COMPAT_VERITY)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
-- 
2.38.4

