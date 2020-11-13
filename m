Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325DCC388F7
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 11:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1859207DE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 11:27:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P/neKgFV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgKML1s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 06:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgKML1n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 06:27:43 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87544C0617A7;
        Fri, 13 Nov 2020 03:27:33 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id cp9so4424038plb.1;
        Fri, 13 Nov 2020 03:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JNlJl80nokkfIDrzLdrxnx4cQjGrCYfO2o/A7orSY7s=;
        b=P/neKgFVO0bqx3pG4bsi/b4E5WwkulVBricSjG+xFBYrMR3qRkQHmv9CZjOKeYGkp3
         b+CKFmm+Fs5Ms30M3mejzeXIBNwItzC+Nm0R6GfF3ycYhp9SlT44vOD7kdOz393EmLLX
         hkD7Znuzl/KCp7eVZRHgT0Ogg/8cYxkeGIOWS4qWC5S7Lv4zwrTvEKgcw8qo2OgVQ4lH
         RY0c/B1Rnb64nIgNjTfDayRmPEhpH9vFgmxPvk3k6rPkTTnTNE6vsAXXgOU5e40p1P/t
         NVU6iWejIgWXHCPDTMSJPaJw9p0og1ntxwF/kbXA1AuTv39QVXA2+wHN/hT5SIc4Lrc1
         YcKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JNlJl80nokkfIDrzLdrxnx4cQjGrCYfO2o/A7orSY7s=;
        b=IHpqkuJFpeaEMWxslDKXSMTjTJUCxwbJypKkJgmAXq7z4RHzKauk9TZ1KIdtodbGwA
         i0DWpzeg3EPduG4i3pQDbIssufhwbKqRcISsWj++bhLQl+d22wyOlXLdhBVmxl9JAczb
         bJRSjEP/Z1302vZC5pvZiHalX8LsYGuKUCoiJsQeTkGzNvRq08HjGOhE86npuCrxEi5r
         VahEMHkm5wsW52mwW2O/WX5/Fyxqm4ABoM+1dPWEXBzW4U0skGFBU1gquRCt7bANF3j7
         b1TglJCVqxViyJ8vPMiHTwV9dqGkXs00ZQ1fJvvWxjULI7d5wM40vDRCwLYY9DEBzdvi
         7Jpg==
X-Gm-Message-State: AOAM531Dqi6CkLd3TEYOXQcbghE8UisIz5xuznxMkAdAHMKbC/p8l+iU
        p7yVoS2w+HRvjBoOaZjjWhgJBnIulBs=
X-Google-Smtp-Source: ABdhPJz/HYt/kNAWMVgCXuwdixfvIS7A/UFkAlt7cxbVB50gScymv7xDPsY0Hnor5s8VQW2zC/J51A==
X-Received: by 2002:a17:902:760c:b029:d6:efa5:4cdd with SMTP id k12-20020a170902760cb02900d6efa54cddmr1819661pll.56.1605266852878;
        Fri, 13 Nov 2020 03:27:32 -0800 (PST)
Received: from localhost.localdomain ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id w131sm9410857pfd.14.2020.11.13.03.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 03:27:32 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH 01/11] common/xfs: Add a helper to get an inode fork's extent count
Date:   Fri, 13 Nov 2020 16:56:53 +0530
Message-Id: <20201113112704.28798-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113112704.28798-1-chandanrlinux@gmail.com>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the helper _scratch_get_iext_count() which returns an
inode fork's extent count.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 common/xfs | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/common/xfs b/common/xfs
index 79dab058..45cd329c 100644
--- a/common/xfs
+++ b/common/xfs
@@ -883,6 +883,28 @@ _scratch_get_bmx_prefix() {
 	return 1
 }
 
+_scratch_get_iext_count()
+{
+	ino=$1
+	whichfork=$2
+
+	case $whichfork in
+		"attr")
+			field=core.naextents
+			;;
+		"data")
+			field=core.nextents
+			;;
+		*)
+			return 1
+	esac
+
+	nextents=$(_scratch_xfs_db  -c "inode $ino" -c "print $field")
+	nextents=${nextents##${field} = }
+
+	echo $nextents
+}
+
 #
 # Ensures that we don't pass any mount options incompatible with XFS v4
 #
-- 
2.28.0

