Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC42C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 07:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EF1964DD1
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 07:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhA1HmK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 02:42:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38327 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231351AbhA1HjI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 02:39:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611819461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YJ0jL9GMWHp751fy3UmKrB3at0MAUtoimJXOag7+nSA=;
        b=B2H2FgyRZeYU9PZtmeG7Lk9jpK+Dc5TArEeUrsOcCtP4yU7wA01L1DjTvdGhiTlAYUTvh6
        PoHrlysWMTyG43UQYu9bMvRncaBlhCNvecWwduq1Wdp3lWAs6of+56tykwLCZBaH8FPLO1
        054bK7Hy7svlS5O6zW0wVRvkOD9J+/o=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-XtNQeC2yMAG9aNSTBwIDdQ-1; Thu, 28 Jan 2021 02:37:40 -0500
X-MC-Unique: XtNQeC2yMAG9aNSTBwIDdQ-1
Received: by mail-pg1-f198.google.com with SMTP id w4so3332674pgc.7
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jan 2021 23:37:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YJ0jL9GMWHp751fy3UmKrB3at0MAUtoimJXOag7+nSA=;
        b=C0Rq9Xraf924hTCtcyr74DRfyWvCXIS6fjk3fefrEwllQ/+CHUbziduPpvi6MzX+19
         s64ec7jW+UGlhD7Q37u8X9n+Mi2HJwYhmP7/PmTiBT3hh0UsIyxTKcBEw19b0KJRK9ey
         SY8HWOYspYa4OxJD0AQsO4s3X48jwEF+3qAQPR9BmZx0iw3Ls8+nvg4CUoL9NLnl9Bxw
         yRbYl4VNmNvDcwUeWQ1CULKD5OEAucZZawHBn0rRalBL11GvHNG4DUIvXsiTT1tQ5ZEU
         iXldG214V1PFRWe6xfgY8XP7zCrZvlPO+mcQsCnXyLbGueLRZ34T/krbZ+xofG3NTEax
         xQVQ==
X-Gm-Message-State: AOAM533cBaqArRBXtW7en95IbHJnQP92/jE0fRD4jFx4VgOsMGmKRw0A
        W5NFn4uIfynUgQhH9sh89DEsvqcScewY1G7epYRA4k4p+0R5BMMs5a65NGhXOX/88+S3SbPpGjl
        NqlfQg0DH/6iRWB3tmlBAajGtX6iNGVvkGSJ5fCR2FaUlsM7fu1fiSOe9JrVzZx0VAwWAVdTt
X-Received: by 2002:a17:90a:ae12:: with SMTP id t18mr10118743pjq.92.1611819458624;
        Wed, 27 Jan 2021 23:37:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw61m3eTQVdWZrZgVNkdFllbck5iRcGIPruolac0+5P4CYoOhFoGE7vwrABsrfLt0zB/eFZXQ==
X-Received: by 2002:a17:90a:ae12:: with SMTP id t18mr10118722pjq.92.1611819458404;
        Wed, 27 Jan 2021 23:37:38 -0800 (PST)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id n12sm4734897pff.29.2021.01.27.23.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 23:37:37 -0800 (PST)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH 1/2] xfs_logprint: print misc buffers when using -o
Date:   Thu, 28 Jan 2021 18:37:07 +1100
Message-Id: <20210128073708.25572-2-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210128073708.25572-1-ddouwsma@redhat.com>
References: <20210128073708.25572-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Logprint only dumps raw buffers for unhandled misc buffer types, but
this information is generally useful when debugging logprint issues so
allow it to print whenever -o is used.

Switch to using the common xlog_print_data function to dump the buffer.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 logprint/log_misc.c      | 19 +++----------------
 logprint/log_print_all.c |  2 +-
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index c325f046..d44e9ff7 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -392,23 +392,10 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 		}
 	} else {
 		printf(_("BUF DATA\n"));
-		if (print_data) {
-			uint *dp  = (uint *)*ptr;
-			int  nums = be32_to_cpu(head->oh_len) >> 2;
-			int  byte = 0;
-
-			while (byte < nums) {
-				if ((byte % 8) == 0)
-					printf("%2x ", byte);
-				printf("%8x ", *dp);
-				dp++;
-				byte++;
-				if ((byte % 8) == 0)
-					printf("\n");
-			}
-			printf("\n");
-		}
 	}
+
+	xlog_recover_print_data(*ptr, be32_to_cpu(head->oh_len));
+
 	*ptr += be32_to_cpu(head->oh_len);
     }
     if (head && head->oh_flags & XLOG_CONTINUE_TRANS)
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index eafffe28..2b9e810d 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -176,8 +176,8 @@ xlog_recover_print_buffer(
 		} else {
 			printf(_("	BUF DATA\n"));
 			if (!print_buffer) continue;
-			xlog_recover_print_data(p, len);
 		}
+		xlog_recover_print_data(p, len);
 	}
 }
 
-- 
2.27.0

