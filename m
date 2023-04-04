Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB568C77B70
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Apr 2023 14:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbjDDO4K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Apr 2023 10:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbjDDO4E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 10:56:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AE44C05
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 07:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680620101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I6je06aEmhF92s7sMY7DVi3uR44iZ0FPA/bMk0qTbjY=;
        b=FrKZnfqqRTW645fATVeGqe1U9/lb+xUN+GAHkIQ4nFQsH4nvReeGC3kgAnKn6AewxF3ONx
        ZjDS85UbKAhOlccQqwHFPKWLBLG75v8v4hiVL+S0fTmyRAJEz0FEkc5wx+6rusoPxe1UGC
        dOBObfkQhGhnXo7/CFhbfEBc9zmWie4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-AGua7vkrM-KQnuNy59LAfA-1; Tue, 04 Apr 2023 10:55:00 -0400
X-MC-Unique: AGua7vkrM-KQnuNy59LAfA-1
Received: by mail-qk1-f197.google.com with SMTP id s21-20020a05620a0bd500b0074234f33f24so14661121qki.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 07:54:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I6je06aEmhF92s7sMY7DVi3uR44iZ0FPA/bMk0qTbjY=;
        b=QrdN/ajomgaolO+9DS0EalHdb4BsHT66BkrOS/2tajCzpC1wrH2cmBbu+71iESajzS
         Ll4mEnPmB4Kmn+OJio3CCNEEEzUZiruBw3meGj3ALZZ8qtWc2G1VRmwBb1dMWhUX7aW5
         6ehec6rMveuyMTSXZFRhdnN29rsKvv8xHbRZTa2YZprDegIuzf01H99Nk8tk/zrHhZm+
         O8/3qbnSTahcmCpYse4JwWtbK2T/M2aBOnaVIKhyVRA5M1ViCE1gsAwAxOHXEgkGrasm
         yGn7asYnrkmjdt4k3vL+UoEWYEb9Yoz0yKShhJkc/B/nA0QvUXkSW2gijpX27fBsoO/t
         hN/Q==
X-Gm-Message-State: AAQBX9ejWt00H8DMTTW4QO/Mas3WnY6CstyV+rMk6hntmH1vkn6fUbrF
        s/59pofTuzuO37qYpX9Ws2Uc+LfjBE1nbaFkB/a+rsPs2DvNu4hUFHp1b0HfndhamIo2HJJpiQr
        A3Iit3BbfZ0V+4hfL7kuA4SAWhpztOA==
X-Received: by 2002:a05:622a:189e:b0:3bc:dd21:4a0 with SMTP id v30-20020a05622a189e00b003bcdd2104a0mr3575648qtc.30.1680620099206;
        Tue, 04 Apr 2023 07:54:59 -0700 (PDT)
X-Google-Smtp-Source: AKy350ba/Mx2sYrhvQuuxEbUABini+6j6yzJy9T6p4OPPcKlZcS6dLVBbS/lM0x+VENbSuVT7xiskA==
X-Received: by 2002:a05:622a:189e:b0:3bc:dd21:4a0 with SMTP id v30-20020a05622a189e00b003bcdd2104a0mr3575618qtc.30.1680620098846;
        Tue, 04 Apr 2023 07:54:58 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j4-20020ac86644000000b003e6387431dcsm3296539qtp.7.2023.04.04.07.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:54:58 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     djwong@kernel.org, dchinner@redhat.com, ebiggers@kernel.org,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 05/23] fsverity: make fsverity_verify_folio() accept folio's offset and size
Date:   Tue,  4 Apr 2023 16:53:01 +0200
Message-Id: <20230404145319.2057051-6-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230404145319.2057051-1-aalbersh@redhat.com>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Not the whole folio always need to be verified by fs-verity (e.g.
with 1k blocks). Use passed folio's offset and size.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 include/linux/fsverity.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 119a3266791f..6d7a4b3ea626 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -249,9 +249,10 @@ static inline void fsverity_enqueue_verify_work(struct work_struct *work)
 
 #endif	/* !CONFIG_FS_VERITY */
 
-static inline bool fsverity_verify_folio(struct folio *folio)
+static inline bool fsverity_verify_folio(struct folio *folio, size_t len,
+					 size_t offset)
 {
-	return fsverity_verify_blocks(folio, folio_size(folio), 0);
+	return fsverity_verify_blocks(folio, len, offset);
 }
 
 static inline bool fsverity_verify_page(struct page *page)
-- 
2.38.4

