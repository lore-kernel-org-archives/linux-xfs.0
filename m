Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10665C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C509B64DD8
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244727AbhCCDMu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:12:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376821AbhCBNvs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 08:51:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614693002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YqyVKW1D3H7omDOceYG0VSdlxuMXLMPdz9uVHGbAsvw=;
        b=Qx4BJELFGt50BljlkVzvMCtRSqRuITJ7rle4nLsjwzBvachb4FyzYzL4rSXLJvHpPXlDHx
        KjjRUwmtjKyfiCoRAQfH5vrTbWNAjP9RmtsBmpjovWVVuNYfO5OXY1j7i9+XLV5+Cdq816
        Yj0TJyZV3u3MClkEkjYmwCFQq3yJ0g0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-0iDkB9DBOJOM1W4bl9lCvQ-1; Tue, 02 Mar 2021 08:45:58 -0500
X-MC-Unique: 0iDkB9DBOJOM1W4bl9lCvQ-1
Received: by mail-wr1-f69.google.com with SMTP id p18so11121951wrt.5
        for <linux-xfs@vger.kernel.org>; Tue, 02 Mar 2021 05:45:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YqyVKW1D3H7omDOceYG0VSdlxuMXLMPdz9uVHGbAsvw=;
        b=E0oyMwOI0WIzfSntRjOUThNEIft9qCCTPGdHgb66X1cGTCrT3XPKAHksdr7V1+uhi4
         vIy8/U0prSAJrxOg5dkHZ6b8WQowl5tmqQruigKlz5HUZ+HYobh5WC0LH1vag4fTy+Q9
         b1WGu+v7d81W6qLba4DtbEvnGPbGCNrsC9OJrNi80qxv+IRsmyHK8nWd05MFAwU37/Lo
         h6Qqy0dkMnH/KQLQXRpAroWQUjSBrjTDQ3UJp/KX91Ty+dANwBxK6W1T4LYUZIHmufTl
         T8coURO1wCYFk6Kj0gTH7q3dvhHEColltyOKhcQu3+Yb91Pf/KDieeraVkG49b7mvMUT
         kaaQ==
X-Gm-Message-State: AOAM532qwQyxcWRnem6znExBfwNZCxim/tnyCwCYPektg345MWbk1W9I
        EeWC4CrrV7p3Wz6getR/xRF7OtN67B4WA/Gk+y2Ws+cdPd+jvkC6inIb1XH0RdtiwYAkcgwVqkY
        4ZE/b+5rUIQy/X226f/gGDyPGi7bzv9sDb4ih4bhwJDJAitH4T9TZs4khQZl4BmdfGjnsgjI=
X-Received: by 2002:a1c:195:: with SMTP id 143mr4006652wmb.81.1614692755760;
        Tue, 02 Mar 2021 05:45:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXExjl/Mb3jM0OdVBNErSXl6BYiRvJU7ap+VTDTUN+qVINrTDYblQgmmWNd3SSZ4UkdGCcNA==
X-Received: by 2002:a1c:195:: with SMTP id 143mr4006640wmb.81.1614692755601;
        Tue, 02 Mar 2021 05:45:55 -0800 (PST)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id f7sm28554802wre.78.2021.03.02.05.45.55
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 05:45:55 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfsprogs: document attr2, ikeep option deprecation in xfs.5
Date:   Tue,  2 Mar 2021 14:45:54 +0100
Message-Id: <20210302134554.112408-1-preichl@redhat.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since kernel v5.10, the (no)attr2 and (no)ikeep mount options are deprecated:

c23c393eaab5d xfs: remove deprecated mount options

Document this fact in the xfs(5) manpage.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 man/man5/xfs.5 | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
index 7642662f..b657f0e4 100644
--- a/man/man5/xfs.5
+++ b/man/man5/xfs.5
@@ -118,6 +118,12 @@ to the file. Specifying a fixed allocsize value turns off
 the dynamic behavior.
 .TP
 .BR attr2 | noattr2
+Note: These options have been
+.B deprecated
+as of kernel v5.10; The noattr2 option will be removed no
+earlier than in September 2025 and attr2 option will be immutable
+default.
+.sp
 The options enable/disable an "opportunistic" improvement to
 be made in the way inline extended attributes are stored
 on-disk.  When the new form is used for the first time when
@@ -159,6 +165,13 @@ across the entire filesystem rather than just on directories
 configured to use it.
 .TP
 .BR ikeep | noikeep
+Note: These options have been
+.B deprecated
+as of kernel v5.10; The noikeep option will be removed no
+earlier than in September 2025 and ikeep option will be
+immutable default.
+
+.sp
 When ikeep is specified, XFS does not delete empty inode
 clusters and keeps them around on disk.  When noikeep is
 specified, empty inode clusters are returned to the free
-- 
2.29.2

