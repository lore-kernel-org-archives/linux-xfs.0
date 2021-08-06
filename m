Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F87EC432BE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5868B60E78
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239943AbhHFVX7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22049 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239884AbhHFVX7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AO5TTOJAm+OwCOWEQSNnKihTdrq6kDBXXwo5DuvgPX4=;
        b=bfl2+5fLqyltl7UWgcXVIDYbj84sMtBUR3SaZPBzq/hVD1xn4UChANDn18XvJnTamtEm8y
        CebigkQCYjehWO+DKcvybbxfIZaKDwOl2PXt2dYi98IVZnyxbGAIdpvbl7K56UukxwGvQ/
        +v1LHV/j+HhW5nJm7RtVLfuCoL0K0AM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486--Dqu-ybAMSCS72mZRhw_Sw-1; Fri, 06 Aug 2021 17:23:41 -0400
X-MC-Unique: -Dqu-ybAMSCS72mZRhw_Sw-1
Received: by mail-ed1-f69.google.com with SMTP id y39-20020a50bb2a0000b02903bc05daccbaso5582239ede.5
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AO5TTOJAm+OwCOWEQSNnKihTdrq6kDBXXwo5DuvgPX4=;
        b=h7jbrLesf995H7YdLgTtzH1i+cfXgMTcbXF8NuBMU4qrxwWqUacsHi9ujNIZcTD1hs
         WYzVDqiqtmK2i0CS6/bZa0xU1Z297fLL6jTlhahxh5G5c05UWZfvYWZu9V5u0XGYcs42
         JTHvY+hOcnh7OzBrfzbhUEq+HyYDm74r1+dhJPy08n6dCPN8dKwqsnM/HqSPMPVnWN/h
         Xywt21T6JduVDQJL/5rNxfiNoc1T2deuy8UByymS93LC0YTKCPNXoeBWG23g//kpde6D
         nIa5Zx1zJiuc0IBKJPsuC44sihUBlWeJE1CWYbUrwjZELogXpKe+kU82ydx+Gy0GuwzN
         1aGw==
X-Gm-Message-State: AOAM533Pp9yFSGK1p4K5CVBRVWSIbbW3iER/yB3r+p1rygBkQn06c1Dr
        PNGVMMInQF10A6dbDqprAtv61MVG0qiVrjc4XaycXvlBkU49g3Ylg49EXR8+jBbVsQMEEH1sVrj
        fXHTGYnqkgpyuMZ0W5xv8tl7cnsv7jx+0/sI1w8HkUs2Z9kzA1B6a/UwN/d4tZ0/SmWQyXVs=
X-Received: by 2002:a17:907:b11:: with SMTP id h17mr11698247ejl.93.1628285020318;
        Fri, 06 Aug 2021 14:23:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlJdRtlug97WR70k/FjTKtaFMWZ3dJEoqmKsaFpaIoAClYKtX2JvnkupjlRiT/IlT0pygrqA==
X-Received: by 2002:a17:907:b11:: with SMTP id h17mr11698238ejl.93.1628285020173;
        Fri, 06 Aug 2021 14:23:40 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.39
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:39 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 15/29] xfsprogs: Stop using platform_mntent_open()
Date:   Fri,  6 Aug 2021 23:23:04 +0200
Message-Id: <20210806212318.440144-16-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 fsr/xfs_fsr.c   | 2 +-
 include/linux.h | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 25eb2e12..38afafb1 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -314,7 +314,7 @@ initallfs(char *mtab)
 	mi = 0;
 	fs = fsbase;
 
-	if (platform_mntent_open(&cursor, mtab) != 0){
+	if (mntent_open(&cursor, mtab) != 0){
 		fprintf(stderr, "Error: can't get mntent entries.\n");
 		exit(1);
 	}
diff --git a/include/linux.h b/include/linux.h
index ae32f0e0..b6249284 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -166,7 +166,7 @@ struct mntent_cursor {
 	FILE *mtabp;
 };
 
-static inline int platform_mntent_open(struct mntent_cursor * cursor, char *mtab)
+static inline int mntent_open(struct mntent_cursor * cursor, char *mtab)
 {
 	cursor->mtabp = setmntent(mtab, "r");
 	if (!cursor->mtabp) {
@@ -176,6 +176,11 @@ static inline int platform_mntent_open(struct mntent_cursor * cursor, char *mtab
 	return 0;
 }
 
+static inline int platform_mntent_open(struct mntent_cursor * cursor, char *mtab)
+{
+	return mntent_open(cursor, mtab);
+}
+
 static inline struct mntent * platform_mntent_next(struct mntent_cursor * cursor)
 {
 	return getmntent(cursor->mtabp);
-- 
2.31.1

