Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C0CAC4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7772860E78
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240509AbhHFVYV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:24:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43239 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240338AbhHFVYV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:24:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1w+P82Tvwhwr5BqTiweZKyZhEfP6JktMBQ5MU886dMM=;
        b=EBYL7GrA4IX2OKLQv2Cmn/h9gUsMiCZ3DsXuQCtwrc6gDRs9EMsJR1ia4DcIbLpolu+Re1
        Pxj2xGjoxD8ZbPlpjtfW0HGyzLlgjdBPvOP2NUj98VNBVUXn+R9pimS14JxZLZ79iZEn5M
        Baj8DPzyr+1/Bx0wavkQCiVqCm5/Pyw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-aKGhxRrCOlelScQCfPtmqA-1; Fri, 06 Aug 2021 17:24:03 -0400
X-MC-Unique: aKGhxRrCOlelScQCfPtmqA-1
Received: by mail-ed1-f70.google.com with SMTP id a23-20020a50ff170000b02903b85a16b672so5601947edu.1
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:24:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1w+P82Tvwhwr5BqTiweZKyZhEfP6JktMBQ5MU886dMM=;
        b=SH3IU0sm3WyJ1GtWSg7fd5QkRIlND5+ww+92FEg0h3K4+5U8w6/HtbFW0ZizjnaZHa
         +R5umKWx+B9jbd053Z12205NHumvHjwc8YJc1g9wiPUO9QyyCFRiBW5etKWe3VJHckoc
         3nnCS0P9JPrHOQtWJvMOptVs+6/V9ChI7pekYqq+twwWuLDum98I8kipcCDkDLh5rk6y
         FA/KbLCcmBFXvK1h4jZk2oFeLVzRLvxyo0CmRGuc9Dl6xkqI3J2/8Au4AxIIVj94if/y
         NJ1mVl1XGCAlg5tGfNQzBZECVqfdfBFyKVq+i7fhYdfsT55rPKib7V0jX6B88TRWnPUv
         k36Q==
X-Gm-Message-State: AOAM530oKbXxD/yHCAfLWKQUQtgTBjw+U4lNvzI6sdu25HYMgWKYeHpc
        tWNamIRM/lDTWvQPX+INpPCUVznv43QX2luKcg5cxKuwol3rbBheKLiFjSuPVdPi+7gB5XM0SB/
        PQK0b23G+OMI4FAAADGBb0w+UuoXZ6NunGbslMOf2itFUtUZ8htNlZGG2nf1JrF1IDo9QKeA=
X-Received: by 2002:aa7:c40b:: with SMTP id j11mr6480865edq.253.1628285042374;
        Fri, 06 Aug 2021 14:24:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynv8xJD6ckiQv3zGjeFJIfstSsDqihXf4/Ifg2K2WkniEekOuk5m68ZTVu1zdGqF8zHk3cUg==
X-Received: by 2002:aa7:c40b:: with SMTP id j11mr6480855edq.253.1628285042187;
        Fri, 06 Aug 2021 14:24:02 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.24.00
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:24:01 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 29/29] xfsprogs: Stop using platform_physmem()
Date:   Fri,  6 Aug 2021 23:23:18 +0200
Message-Id: <20210806212318.440144-30-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 libfrog/linux.c     | 8 +++++++-
 libfrog/platform.h  | 1 +
 repair/xfs_repair.c | 2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/libfrog/linux.c b/libfrog/linux.c
index 43ca1e7d..9b99d1a7 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -338,7 +338,7 @@ platform_nproc(void)
 }
 
 unsigned long
-platform_physmem(void)
+physmem(void)
 {
 	struct sysinfo  si;
 
@@ -349,3 +349,9 @@ platform_physmem(void)
 	}
 	return (si.totalram >> 10) * si.mem_unit;	/* kilobytes */
 }
+
+unsigned long
+platform_physmem(void)
+{
+	return physmem();
+}
diff --git a/libfrog/platform.h b/libfrog/platform.h
index 42b0d753..b034d652 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -26,6 +26,7 @@ int direct_blockdev(void);
 int platform_align_blockdev(void);
 int align_blockdev(void);
 unsigned long platform_physmem(void);	/* in kilobytes */
+unsigned long physmem(void);	/* in kilobytes */
 void platform_findsizes(char *path, int fd, long long *sz, int *bsz);
 void findsizes(char *path, int fd, long long *sz, int *bsz);
 int platform_nproc(void);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index fbbc8c6f..b8d56d9d 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1081,7 +1081,7 @@ main(int argc, char **argv)
 					(mp->m_sb.sb_dblocks >> (10 + 1)) +
 					50000;	/* rough estimate of 50MB overhead */
 		max_mem = max_mem_specified ? max_mem_specified * 1024 :
-					      platform_physmem() * 3 / 4;
+					      physmem() * 3 / 4;
 
 		if (getrlimit(RLIMIT_AS, &rlim) != -1 &&
 					rlim.rlim_cur != RLIM_INFINITY) {
-- 
2.31.1

