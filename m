Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46234C432BE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22F4C61184
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240279AbhHFVYI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:24:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240308AbhHFVYH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:24:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cUGEXRCzb6w2Ws2sS1zDgMNCuH/1F4t27JjerpAaI+k=;
        b=e9PdY35PuOhc345DgTI4Q7+3Dtx+YcvwDrXPuOJp4ehOouzMwa4w6WHiZJ2g/5DS7v/ocJ
        /0lO4D69uT+Y3xGKvjUvqr4igkNSF0I0TinVer2fFPlX9q0KLc7tQdqB9zbULgF0YjZ78u
        sf1YxDohBbVi+NafI6bT1r78PUqFHm8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-1O6s2V2kNtGQwQBu8D0nVQ-1; Fri, 06 Aug 2021 17:23:50 -0400
X-MC-Unique: 1O6s2V2kNtGQwQBu8D0nVQ-1
Received: by mail-ed1-f70.google.com with SMTP id x1-20020a05640218c1b02903bc7f97f858so5578158edy.2
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cUGEXRCzb6w2Ws2sS1zDgMNCuH/1F4t27JjerpAaI+k=;
        b=UPYbahvOVZ2yWWN3UkGVRT4EpC8Yyv0x/EgoSzmviPH9V+rLaJvFH6h+SgKBxEqLaa
         Ve6Is85A1xkd4xPExAvy9LqQvlAUQimbp1rmd1so4oxjKr8kr43YPDgJFoHkkuEacdPW
         BlOoFpnepYOkQEmC9OP4E7aLok7CjbbzgneNrVPVhm3KUVPzHHYMI8TK/bBcH3t3994S
         +N7rJ1+w1V4n1xF+cJjHMVqykmlWf4XabbxVRDKcMAt3+rhsySlm1mRYXBxbyt3502Ac
         axzR4+JIOpJcx2c7eD3AcUXG/5D7J4bweyRwqJrG6seNYmsJ306fLDCGvlktOhO2eWty
         FRjg==
X-Gm-Message-State: AOAM532ls1mGEx9tf3jeHcePgbYjXgafukeeMUP8G8uEkC2jaCNSxyIP
        m8dW95KnylvmsxSDrRIx7FArxgm4Z8MVzDUP83miJd8ZcPkqfp4TqEh3yi8dxq8/IxMq9CjX4DF
        yqbb+zpSPZfM5F4DpVDzxRsQjbWCy0Y1DzRBz8P3FWaNP6jUoTQxHmZgUq/YNgdOoIDJh3rQ=
X-Received: by 2002:a17:906:405:: with SMTP id d5mr11555422eja.189.1628285028841;
        Fri, 06 Aug 2021 14:23:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6psWm60i+I6XbsgDfWZ33dXgJQVM+Y0nG4/CuvqA8RD/HRbHKhUcvkQsuX3CRzGnL10oKMw==
X-Received: by 2002:a17:906:405:: with SMTP id d5mr11555412eja.189.1628285028681;
        Fri, 06 Aug 2021 14:23:48 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.47
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:47 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 19/29] xfsprogs: Stop using platform_discard_blocks
Date:   Fri,  6 Aug 2021 23:23:08 +0200
Message-Id: <20210806212318.440144-20-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 include/linux.h |  7 ++++++-
 mkfs/xfs_mkfs.c | 10 +++++-----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux.h b/include/linux.h
index 7940fe8c..97882161 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -140,7 +140,7 @@ static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
 #endif
 
 static __inline__ int
-platform_discard_blocks(int fd, uint64_t start, uint64_t len)
+discard_blocks(int fd, uint64_t start, uint64_t len)
 {
 	uint64_t range[2] = { start, len };
 
@@ -149,6 +149,11 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 	return 0;
 }
 
+static __inline__ int
+platform_discard_blocks(int fd, uint64_t start, uint64_t len)
+{
+	return discard_blocks(fd, start, len);
+}
 #define ENOATTR		ENODATA	/* Attribute not found */
 #define EFSCORRUPTED	EUCLEAN	/* Filesystem is corrupted */
 #define EFSBADCRC	EBADMSG	/* Bad CRC detected */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index c6929a83..fc672a10 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1263,7 +1263,7 @@ done:
 }
 
 static void
-discard_blocks(dev_t dev, uint64_t nsectors, int quiet)
+discard_batch_of_blocks(dev_t dev, uint64_t nsectors, int quiet)
 {
 	int		fd;
 	uint64_t	offset = 0;
@@ -1286,7 +1286,7 @@ discard_blocks(dev_t dev, uint64_t nsectors, int quiet)
 		 * not necessary for the mkfs functionality but just an
 		 * optimization. However we should stop on error.
 		 */
-		if (platform_discard_blocks(fd, offset, tmp_step) == 0) {
+		if (discard_blocks(fd, offset, tmp_step) == 0) {
 			if (offset == 0 && !quiet) {
 				printf("Discarding blocks...");
 				fflush(stdout);
@@ -2664,11 +2664,11 @@ discard_devices(
 	 */
 
 	if (!xi->disfile)
-		discard_blocks(xi->ddev, xi->dsize, quiet);
+		discard_batch_of_blocks(xi->ddev, xi->dsize, quiet);
 	if (xi->rtdev && !xi->risfile)
-		discard_blocks(xi->rtdev, xi->rtsize, quiet);
+		discard_batch_of_blocks(xi->rtdev, xi->rtsize, quiet);
 	if (xi->logdev && xi->logdev != xi->ddev && !xi->lisfile)
-		discard_blocks(xi->logdev, xi->logBBsize, quiet);
+		discard_batch_of_blocks(xi->logdev, xi->logBBsize, quiet);
 }
 
 static void
-- 
2.31.1

