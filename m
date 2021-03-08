Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC853C4332E
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E63565225
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhCHPv7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:51:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbhCHPv3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 10:51:29 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5745FC06174A;
        Mon,  8 Mar 2021 07:51:29 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d8so5045909plg.10;
        Mon, 08 Mar 2021 07:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=41YtaORrrIuxqpPCdPrGdEctYzNj9wJAAYHDpYyjBDU=;
        b=tT9o47F7C9JqktZwquT+MIHutEHXYpukiQEp41IMsXEcF4EFQAJDf2XFmzUoWDtgve
         yi9jWZU/k9wq63ypBUdKYY0huUeB+NNl/X2cppC2XrqtC4arps3STmcPFwoLBQ3ffPhf
         mUvL54Wp8B7PNLkiRYEWH5TTp8KKkPbx/js/afiWrZCRXt87cj0cToRzVN6R0bR+PqRU
         uuVhpbQQJWo53vfJba/yKTyuWi1pwiHIDaI+7ykJ+JPlQpusOFpTEmKDM8uADWC6hefY
         7SrHS2EnKGMyaNcU8G6mCUpgGKyS7d5kWOPcoX4nnTNRexyOvN0iF5jmvXCnbLWlUS7K
         d5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=41YtaORrrIuxqpPCdPrGdEctYzNj9wJAAYHDpYyjBDU=;
        b=Ca+S+alTtBto7mf11NvYP8IxFdYi4r3P36gJ5OdRZmC4NL4ZtWNGvPrJzgrEPFzH4y
         sH/gdxE6VZ5RWupw428U6KST+7S5clBq3BI/tm3qgp61yr1W1aWHBxGBFLXs5pJ39Gbf
         apubjRkUN2GYzXd56f+EdUry9gC5rA6OTkMgOqhiKpcw+YfQ4NdyvajTJUezPLr17W2N
         T+OvTDwbtG+UrAMMXheqNOjTZk8homDS22VbQWNAMfGdIcRAeTN8rKMhXV38xWZssCwC
         3lj+oJDDnz00wrltXUxZYqPhsFvajhtaX8C3sXJmxp+A7N0QqP3PYovWdJHnMWOJXdEK
         OGLw==
X-Gm-Message-State: AOAM531EG0KL3YHwf5fgcsTw7j7mudbDWEnw1OBh/QOPeieWmMTa1x4R
        VC47HZGWlElVVlEjgLFfFT0V0GkoWqs=
X-Google-Smtp-Source: ABdhPJw7rUzENdNu99E6xsbg25zo/Gj/M8B5Mj4AmtZWgVZ+sU1J+rOkVJZ77XhYaJZIXAT8gGy5Pg==
X-Received: by 2002:a17:902:b78a:b029:e4:8ce6:fb64 with SMTP id e10-20020a170902b78ab02900e48ce6fb64mr22022930pls.77.1615218688838;
        Mon, 08 Mar 2021 07:51:28 -0800 (PST)
Received: from localhost.localdomain ([122.182.238.13])
        by smtp.gmail.com with ESMTPSA id s4sm11086378pji.2.2021.03.08.07.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:51:28 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V5 03/13] common/xfs: Add helper to obtain fsxattr field value
Date:   Mon,  8 Mar 2021 21:21:01 +0530
Message-Id: <20210308155111.53874-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308155111.53874-1-chandanrlinux@gmail.com>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a helper function to obtain the value of a particular field
of an inode's fsxattr fields.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 common/xfs | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/common/xfs b/common/xfs
index f0ae321e..9a0ab484 100644
--- a/common/xfs
+++ b/common/xfs
@@ -194,6 +194,18 @@ _xfs_get_file_block_size()
 	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
 }
 
+xfs_get_fsxattr()
+{
+	local field="$1"
+	local path="$2"
+	local value=""
+
+	value=$($XFS_IO_PROG -c "stat" "$path" | grep "$field")
+	value=${value##fsxattr.${field} = }
+
+	echo "$value"
+}
+
 # xfs_check script is planned to be deprecated. But, we want to
 # be able to invoke "xfs_check" behavior in xfstests in order to
 # maintain the current verification levels.
-- 
2.29.2

