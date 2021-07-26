Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C61B8C432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 06:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5D3660F38
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 06:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhGZGDC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 02:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhGZGDA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 02:03:00 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE6DC061757;
        Sun, 25 Jul 2021 23:43:30 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id k1so10305210plt.12;
        Sun, 25 Jul 2021 23:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jUFLFUkCJgFdloUBuT5iV/vcuM8mHTXSbAtDG6b1axo=;
        b=VppVpLvKkmMfhCVVj3NPTVDElMehfc//chGW5FT4lUgRQyJnFP/oqgvG+aQ/V/oBeq
         yHcAHbpq8DVLw26cden9Pd497XBpDfSWxiDdf6bx0vufWJ4ujmaRHQ5sxBl/ovRN4NfR
         sMqWGBLvavnwKLJd5EESXyDVE/Wba+SrDTpnME5oR44gRgsilqHndE6XopMeQf4LyGR/
         d/MATogpE4q/oYEXt3fwhZVd2kLWpRlY1KSyZriT0HNnyIb7HMhte7LfCL5KTRYwG2F4
         /sfx1nZKcwfA34nYA7Td5WtWRND3c/eF4DYq9NLecjQN880+b9/KfJNX9HiM2SYvnH9M
         rMrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jUFLFUkCJgFdloUBuT5iV/vcuM8mHTXSbAtDG6b1axo=;
        b=QPOEwRhRUk65QH4FT79gOSzLw08xTLhFLQyxH0JbcKoR1QFmlMUp0KgARVT84L8HR3
         yCKoB8n9Nnfn7lenUS1GCk1igrj/HCPV0harquCjZMDoGMjAVz470q4+P9SBJTRvBOzz
         GIyUBmbsChcaKsPdZBvUwfau0j9qAsmVLvOh9mgtfVQ4+8FWZZ4YR8EcawPPvGMSHD/i
         3vCMAbg4Wk28PkUwxQZV2sAV73cfLKx+Ggone7u0Bgn5aRYTNg2TdFs35pavt3AQEGYD
         ydUH7nizShRgnfcZbvEcpW40ecRUo6kMOwvSZg7zAvPj8RpDnUNf/0lznt0FUS3VgKQV
         R2ag==
X-Gm-Message-State: AOAM533FVVDnNnz1qvcaBHAl6m6/2HY/Nv0HO54aGceoSHkPsQ3eabAq
        oI1SjZrPIKsdACS8T9F0nSZHC/gIQh8=
X-Google-Smtp-Source: ABdhPJyvbJJd3J8BdmNAD1PANazPJJ2EWITrb2v7s7iX6lW0XoRaXrKQaQawzRt1qrkYCfJlhMxC/g==
X-Received: by 2002:a63:d648:: with SMTP id d8mr16675422pgj.280.1627281809593;
        Sun, 25 Jul 2021 23:43:29 -0700 (PDT)
Received: from localhost.localdomain ([122.167.58.51])
        by smtp.gmail.com with ESMTPSA id c11sm44411172pfp.0.2021.07.25.23.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 23:43:29 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] common/xfs: Add helpers to obtain reflink/rmapbt status of a filesystem
Date:   Mon, 26 Jul 2021 12:13:12 +0530
Message-Id: <20210726064313.19153-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726064313.19153-1-chandanrlinux@gmail.com>
References: <20210726064313.19153-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds helpers to obtain status of reflink and rmapbt features of a
filesystem. The status of these features are obtained by invoking
$XFS_INFO_PROG program.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 common/xfs | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/common/xfs b/common/xfs
index c5e39427..e9f84b56 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1099,6 +1099,40 @@ _xfs_mount_agcount()
 	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
 }
 
+# Get reflink status of a filesystem
+_xfs_is_reflink_enabled()
+{
+	local status
+
+	$XFS_INFO_PROG "$1" | grep -q reflink >> $seqres.full
+	[[ $? != 0 ]] && return 1
+
+	status=$($XFS_INFO_PROG "$1" | grep reflink= | \
+			 sed -e 's/^.*reflink=\([0-1]\).*$/\1/g')
+	if [[ $status == 1 ]]; then
+		return 0
+	else
+		return 1
+	fi
+}
+
+# Get rmapbt status of a filesystem
+_xfs_is_rmapbt_enabled()
+{
+	local status
+
+	$XFS_INFO_PROG "$1" | grep -q rmapbt >> $seqres.full
+	[[ $? != 0 ]] && return 1
+
+	status=$($XFS_INFO_PROG "$1" | grep rmapbt= | \
+			 sed -e 's/^.*rmapbt=\([0-1]\).*$/\1/g')
+	if [[ $status == 1 ]]; then
+		return 0
+	else
+		return 1
+	fi
+}
+
 # Wipe the superblock of each XFS AGs
 _try_wipe_scratch_xfs()
 {
-- 
2.30.2

