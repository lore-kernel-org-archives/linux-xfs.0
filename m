Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA722C4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C603060E78
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239884AbhHFVYJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:24:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51764 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240308AbhHFVYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:24:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BHosT4ai/RSb3peV1ycUzHP+d1QOR1DbAUILujJwPKw=;
        b=LYq2ZZmHX0aoQp9ehFLIy748wJR7l76wzG6Arl3vnuckOn5yfjI6NpbGKAacq4ArHU7htG
        aAyFKrv8PCJnTSW7kHimf6D3uK6m8CIEuP4nCnhFrNJ/xwdR/3Feozg1pmPyd04gDPcOPN
        lZSpFRDYdwcliW7tLVP5/qURx9sz9qU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-ig3nwGakN66v8ybY039r0g-1; Fri, 06 Aug 2021 17:23:51 -0400
X-MC-Unique: ig3nwGakN66v8ybY039r0g-1
Received: by mail-ed1-f71.google.com with SMTP id c16-20020aa7d6100000b02903bc4c2a387bso1115825edr.21
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BHosT4ai/RSb3peV1ycUzHP+d1QOR1DbAUILujJwPKw=;
        b=kHZ6OzDqF+vgre9hnyret9UugjY1Mn147UzvbnM0lcDrS/HtJTv7EaPFLxHomwHUtk
         ss0S0504tvh7qU+KPG8I4z0SVJVI7CN3NhGsUOnBx3GWmf9lJ34az4/Vux3qGuoAAGHi
         Un96a3kZyLRt1BW0I29NxSk3TA9hiC7JKe8FhaUga/oAnGt1dNfDXlWGYTN/0rGh6u77
         ERWFlJ2fsTu2hRfP8lOqRley7RcaCnlYvNdv03H1jPI9YYu0NvP7U1vxCXYHrq93tCTR
         to6tslwAmCDCmx5Ps6v9WEzjakpoAZ0thQyrfrx9yNd78LPGgh6GQzLutYgg8AGo4JrO
         aR9g==
X-Gm-Message-State: AOAM5324V+HAFHZn2CjhRCUveaQZbd1AuDZEEM+5KZ0vfv7kbkrPfMAy
        LSxnRfsD59EWIXvZP1n0YqBsU5GpPzWRl62AqBx7LUVh6B53pKq8e0pOsnynJSiDVOovpz0aAKr
        ZdHMRxq/V0v5jQIWAdFW2tjZL5TkGd80Ym7f32YthG1ZD53lhRaKY92hW8HyA/A87Zzepynk=
X-Received: by 2002:aa7:db94:: with SMTP id u20mr15441690edt.381.1628285030081;
        Fri, 06 Aug 2021 14:23:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSGgDozczmD4cSUR1tw57KgA+O7smV1i5+tAuehGZAKbCefZ4W9q+GLloD78ZSrDPlRsxEuA==
X-Received: by 2002:aa7:db94:: with SMTP id u20mr15441679edt.381.1628285029957;
        Fri, 06 Aug 2021 14:23:49 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.48
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:49 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 20/29] xfsprogs: Stop using platform_zero_range()
Date:   Fri,  6 Aug 2021 23:23:09 +0200
Message-Id: <20210806212318.440144-21-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 include/linux.h | 14 ++++++++++++--
 libxfs/rdwr.c   |  2 +-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux.h b/include/linux.h
index 97882161..4ee4288f 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -208,7 +208,7 @@ static inline void platform_mntent_close(struct mntent_cursor * cursor)
 
 #if defined(FALLOC_FL_ZERO_RANGE)
 static inline int
-platform_zero_range(
+zero_range(
 	int		fd,
 	xfs_off_t	start,
 	size_t		len)
@@ -220,8 +220,18 @@ platform_zero_range(
 		return 0;
 	return -errno;
 }
+
+static inline int
+platform_zero_range(
+	int		fd,
+	xfs_off_t	start,
+	size_t		len)
+{
+	return zero_range(fd, start, len);
+}
 #else
-#define platform_zero_range(fd, s, l)	(-EOPNOTSUPP)
+#define zero_range(fd, s, l)	(-EOPNOTSUPP)
+#define platform_zero_range(fs, s, l) zero_range(fd, s, l)
 #endif
 
 /*
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 022da518..a92c909e 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -73,7 +73,7 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 
 	/* try to use special zeroing methods, fall back to writes if needed */
 	len_bytes = LIBXFS_BBTOOFF64(len);
-	error = platform_zero_range(fd, start_offset, len_bytes);
+	error = zero_range(fd, start_offset, len_bytes);
 	if (!error) {
 		xfs_buftarg_trip_write(btp);
 		return 0;
-- 
2.31.1

