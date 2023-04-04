Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DF7C761A6
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 14:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbjDDO5s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235184AbjDDO45 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 10:56:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2663046A3
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 07:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680620163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FFUi+70wiITyeuozy7B4Yd/jMxRAxWPn5c55TeHG694=;
        b=Ha2WGZ39D5ygYUmB5K5qMhC6lLjo6wuklRA+7g+XKxzeg5TErX6ZngVLawFkeeKeA+kH/1
        JN637ZQn9PuewT9dPxHB8fLFv4kPedkfLFwUrPIalaF5Y0okPNKM1Fjo+hu0VoIAEe1OhO
        XXtPF0pcRfKPYeYEtmzfXpQ6Wg8xddI=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-s67l4Lu6NnS6WkJBNAWxWg-1; Tue, 04 Apr 2023 10:56:02 -0400
X-MC-Unique: s67l4Lu6NnS6WkJBNAWxWg-1
Received: by mail-pl1-f197.google.com with SMTP id o9-20020a170902d4c900b001a2bef29d53so3809360plg.7
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 07:56:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FFUi+70wiITyeuozy7B4Yd/jMxRAxWPn5c55TeHG694=;
        b=3bwrbvQQag7Jdl08ljhTeIqhKGSZmQK3emLTlvMIoaOVqTR9NjKwT9XLGrVVIpY8PH
         P1ZMvXyiwm60L8G7ypdsMpZobNhEPEsNkKThDf+IBHG13RAP+x6Dv47jdHQwPsc5p9Wm
         S2QfXmoo7dlC2+mUKJTe4Wk3CkLBV4kCuuLJHR9GqxizFoFBAFMkcL6muqbU7xZQX4RD
         Y5rJd1bzF1EmT8kAXem5yrr9ELq6rr9dLdJec4wBTVe4xkja/HQUUXLQ3GJIJDp/oND/
         Dutg0/Rts/11iCF8V+A1xrPiIG6CGHdnFfyK4DgxKuR9ZdmTijxuA5guABHkV2ULSpWb
         rBEw==
X-Gm-Message-State: AAQBX9epIXoeHKYOatPZo1MiVUQ8Z8Xsq7Gxluien7PyvfZrgTElnXDf
        c+Sfot9vN85RATAGX5FwsYEBnsD4yR4fygep5yVTbdfJcarEYamqDvCzpayAxvlGKwgxk+D4Qg6
        y7TKXg6pA1u9v3i3j/qCNrTCQ9AnUaw==
X-Received: by 2002:a17:90b:4d05:b0:240:9e3d:d532 with SMTP id mw5-20020a17090b4d0500b002409e3dd532mr3251568pjb.8.1680620160753;
        Tue, 04 Apr 2023 07:56:00 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zzc10/1v2LcCE0zfPnbg3x+8dh54gKx1zJb5SpW17zpBOCvtCa2VKQbBuo0E40V5nvMeZ6aQ==
X-Received: by 2002:a05:622a:199f:b0:3e3:913c:1ca8 with SMTP id u31-20020a05622a199f00b003e3913c1ca8mr4130703qtc.22.1680620139945;
        Tue, 04 Apr 2023 07:55:39 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j4-20020ac86644000000b003e6387431dcsm3296539qtp.7.2023.04.04.07.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:55:39 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     djwong@kernel.org, dchinner@redhat.com, ebiggers@kernel.org,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 18/23] xfs: don't allow to enable DAX on fs-verity sealsed inode
Date:   Tue,  4 Apr 2023 16:53:14 +0200
Message-Id: <20230404145319.2057051-19-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230404145319.2057051-1-aalbersh@redhat.com>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
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
index 5398be75a76a..e0d7107a9ba1 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1204,6 +1204,8 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
-- 
2.38.4

