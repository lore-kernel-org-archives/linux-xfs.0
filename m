Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03577C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 08:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC3D661437
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 08:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbhDUI6Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 04:58:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35767 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235313AbhDUI6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 04:58:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618995459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=it6oVVTCNmY640TTxP6MCvnTbV9SwYW8TNajxR4D+7o=;
        b=dA0xUpsmC151ni8MVnulfH9VdeK3iWSfVsg9Pf53HVGc0A1OUEgJOjjNdihO1BsZs7h9Ed
        Nv0mL0tDCy+kbPD4eNhnKq7FoIJahzvwzOtVVyERACVcrIO1QkSiQk3CuvMB0qQDW4xD3z
        o2J9Cl/sAJ2JzUhQn9dH/6RDN2zteXU=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-4lLpso72NjemPfXp8VGLEw-1; Wed, 21 Apr 2021 04:57:38 -0400
X-MC-Unique: 4lLpso72NjemPfXp8VGLEw-1
Received: by mail-pf1-f200.google.com with SMTP id k11-20020a62840b0000b029024135614a60so10358372pfd.18
        for <linux-xfs@vger.kernel.org>; Wed, 21 Apr 2021 01:57:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=it6oVVTCNmY640TTxP6MCvnTbV9SwYW8TNajxR4D+7o=;
        b=jkU8MbjwnYUO4Nhvshq7T6l3ThRXd7zsxTfVWSFsYSxROgjVjSX1/jGQx18PXlumFg
         TUa3anb40AKqRdC7If3oeo0DUwqQLi1AmY4D2kHf9bEvwsyYPRXbAtjj8o0/RkO7OKPM
         0LI3v0r4+TM3PZUwFeYhrGDf4B2dFBN+XSIxYSejQLRO/7NTKbrYPKpnt1pklF7FDD80
         kAVgnV/g0sGPZ8tpLPZ3NIQl6YDVb3WD4P90W7u/5bFho4V+kwDeXbgYK5F5MczJXpgJ
         8DJ6aCwD8QcuN/ZAFgB48IvWhZbe2w072pEaiLM22Tr1ufFc/XrY5coGrDeLb1Ih1rhG
         8HRg==
X-Gm-Message-State: AOAM533q0Rtb17AKjV7vBim8x48sy8Xq2COX8tZrfqcVmHKEcZpx1hWw
        etaUrNDApydAa7tgT+S1PBSAI9KupWnLvup0CTmrsSrzDzXpxp+HbU8NDXI1bfoyjiD6/JPet04
        oYcGYuy0Z6gWxsWzDTYSOSAh7ywG552ZB4fgm5hB39f/JVYfjmWtn5kueE54GTk6U3RX2aR1L2A
        ==
X-Received: by 2002:a17:90b:344f:: with SMTP id lj15mr9989931pjb.211.1618995456957;
        Wed, 21 Apr 2021 01:57:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxsBQzCAT3JvVuvaKTXpkAryZso75yIJieiFWrZmyIANrheOCRs0lQIKsbr9TdxW4ZITPtJSg==
X-Received: by 2002:a17:90b:344f:: with SMTP id lj15mr9989913pjb.211.1618995456708;
        Wed, 21 Apr 2021 01:57:36 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x3sm1242123pfj.95.2021.04.21.01.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 01:57:36 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>
Cc:     Gao Xiang <hsiangkao@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH] mkfs: warn out the V4 format
Date:   Wed, 21 Apr 2021 16:57:16 +0800
Message-Id: <20210421085716.3144357-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Kernel commit b96cb835e37c ("xfs: deprecate the V4 format") started
the process of retiring the old format to close off attack surfaces
and to encourage users to migrate onto V5.

This also prints warning to users when mkfs as well.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 mkfs/xfs_mkfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0eac5336..ef09f8b3 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4022,6 +4022,10 @@ main(
 	validate_extsize_hint(mp, &cli);
 	validate_cowextsize_hint(mp, &cli);
 
+	if (!cli.sb_feat.crcs_enabled)
+		fprintf(stderr,
+_("Deprecated V4 format (-mcrc=0) will not be supported after September 2030.\n"));
+
 	/* Print the intended geometry of the fs. */
 	if (!quiet || dry_run) {
 		struct xfs_fsop_geom	geo;
-- 
2.27.0

