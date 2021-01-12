Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B54C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3A1D20789
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 07:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732521AbhALHlb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 02:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730190AbhALHlb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 02:41:31 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD63C061794;
        Mon, 11 Jan 2021 23:40:50 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id h10so880091pfo.9;
        Mon, 11 Jan 2021 23:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tuRANglPuvCThAaGoAF4a7CUchGXxnbMIAXQeoen4YY=;
        b=usisPELkuG/Xu6/jsf3bH44hLVmemTJ5aR1XYtDtUYKfiQZ194Oho+KUmN/e5Q3zkB
         zRhsCvv8g9jgY0A9PzdHJJYT707A1mp+i6voKfEBQW9YAln7C4Ji+zAP+Z2iZl782tYt
         4ckFyMUfQw+8ryp5we1NrKLbCixxudCcBYyFE6cPqsfJjINXPVhyKntnXJhF1RUzXQjw
         QW/QHZO96o9AX0xI7baLdL8ej5DgtRhbmucRzTOZ+9wccAlrXMknJHNou5VlPf4qNm3B
         kwlbY9PhmZEGWTkJzQ7nxXl1wAWhBRVRe9Aa9nvoVJPsXZ/G79UoK9762cQu78zo+Mr0
         qfYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tuRANglPuvCThAaGoAF4a7CUchGXxnbMIAXQeoen4YY=;
        b=COZudaLD/svagusHcdP8y15Uo2lbgt3tTFgikefKL4P4VKr6TsnyOuy/bS+JDRIUE6
         3RAJX/M98TWUL2N7/ulV/c6SwgiynGN83AOtCmE9KtOk3jOUDU3c566ZjXPoRnwZWTRT
         0SHhYZKqjZLDm4y1O7mH2NVHVFEPr8C04nm9N5rTXWuuIoMIAJcj85hDVA/sActuH57c
         /9sa3Bkk3GupNHvVLVQYumfrqSnsK581ejBGAAqJUG9hg0xbEnG7p8RYDX4WTkVmZMVl
         /OaJ19jXHhzU7WP3F6xWEEDM0APaKu3wj/D6C039D35yZiAyE1xM69jjLtN3UshVmwth
         jh2w==
X-Gm-Message-State: AOAM532X4Br1W67k5nBW/OWVQJWh1mvtCuqIxbO+RH30q5YASiSlGHaY
        UA1lGoau9+V+es51N4kijSy/rTNJXlQ=
X-Google-Smtp-Source: ABdhPJx/uKACnT/2cOSEuLPYCacSgUn/7w8kRTqa+VKtlGX2Gp3T4us6iqqSKOk/sU6ex/8z0H4AoQ==
X-Received: by 2002:a62:14d3:0:b029:19e:88c0:8c67 with SMTP id 202-20020a6214d30000b029019e88c08c67mr3318651pfu.69.1610437250259;
        Mon, 11 Jan 2021 23:40:50 -0800 (PST)
Received: from localhost.localdomain ([122.171.39.105])
        by smtp.gmail.com with ESMTPSA id mj5sm1962340pjb.20.2021.01.11.23.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 23:40:49 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V3 01/11] common/xfs: Add a helper to get an inode fork's extent count
Date:   Tue, 12 Jan 2021 13:10:17 +0530
Message-Id: <20210112074027.10311-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112074027.10311-1-chandanrlinux@gmail.com>
References: <20210112074027.10311-1-chandanrlinux@gmail.com>
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
index 3f5c14ba..641d6195 100644
--- a/common/xfs
+++ b/common/xfs
@@ -903,6 +903,28 @@ _scratch_get_bmx_prefix() {
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
2.29.2

