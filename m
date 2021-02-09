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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC6CC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 16:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84F9964E99
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 16:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbhBIQNx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 11:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbhBIQNx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 11:13:53 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040F9C061574;
        Tue,  9 Feb 2021 08:13:13 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id u15so10025411plf.1;
        Tue, 09 Feb 2021 08:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N1t+UwsftwCh3BOxeVki9cHQzsiGQ+r/aFD/kypWsSc=;
        b=gXzQVNaEXZHbsx0DTuMS5+5Nvu7xdl3smllwRtt0l9wl1bwD/dbSlmQQF31kyTEr9j
         5GZV4Z+BTVimQmxwn7s/w5KWG/sUePK/LZFdOtZT+opRBhPkiNbl+wHuiM9MLMWvudZY
         mfP29VVdRnN3dLgpQMxUc1G21YRbQsRaQOC9PbqtOBjVadlXxaMPqU9fpeOqp483GwYM
         qZkkR2K4AUjhCo3GOas1b0J9jkncyVkW70dt9B7KddldoHdKXVihsTMQR7JOQFtR8Mi7
         e/+IC7wq1tLgf5m1ivYpYTN1C0jHSk8awEhsaxvlRsc1FpjA6n0spWfDrssW5jC1RNrq
         tmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N1t+UwsftwCh3BOxeVki9cHQzsiGQ+r/aFD/kypWsSc=;
        b=cYUBAeHbNJ/zctqtMJ/AYdXqWxxYQKf+4R5J+kGu4mfyGZmDf8jWLbUBpENzGxtTCc
         5GFe2qPOrfFgODF5XdhK8BgKshwSwj9tQQluG8aYWLtp8lWmIcHOETvYm0nzbpJx4swc
         WP73thaigKQ4UaA38jUOdrtWO1aTELNtReKbKqurLuuFrVM9ztEiX3iMCNwpyrE0vWsR
         PhoRW/q6Oz5DCoyumgehmyapluKMj2hHjCcB+ubqenKhYp5uX6WFu9WelmZztD1oxMCh
         NTyimN1tiaZxZmEmowveXpKIpcgofH5o/eHNRjDIscYvPwvEKs2UPXqida/NQMjvWRUT
         94Ww==
X-Gm-Message-State: AOAM531un2LZILOGzxyOlef04RmiN9raA08qrKNjBcwLifVDIImhIXr4
        Y3+GwT2z2mogDiiLhZ6FPoJgCUWrZ4A=
X-Google-Smtp-Source: ABdhPJwOyVEWNRn04Beq03kvBA1AqbbgazJr2IbC5G7gcRPwNcRQip5SGnsLrF5lgF3AWQgTlM3LHg==
X-Received: by 2002:a17:90a:4589:: with SMTP id v9mr4558488pjg.113.1612887192381;
        Tue, 09 Feb 2021 08:13:12 -0800 (PST)
Received: from localhost.localdomain ([122.171.192.76])
        by smtp.gmail.com with ESMTPSA id p68sm22389216pfb.60.2021.02.09.08.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 08:13:12 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, guan@eryu.me
Subject: [PATCH] _scratch_mkfs_geom(): Filter out 'k' suffix from fs block size
Date:   Tue,  9 Feb 2021 21:42:52 +0530
Message-Id: <20210209161252.17901-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the original value of $MKFS_OPTIONS contained a block size value having 'k'
as a suffix (e.g. -b size=4k), then the newly constructed value of
$MKFS_OPTIONS will have 'k' suffixed to the value of $blocksize.  $blocksize
itself is specified in units of bytes. Hence having 'k' suffixed to this value
will result in an incorrect block size.

This commit fixes the bug by conditionally filtering out the 'k' suffix from
block size option present in the original value of $MKFS_OPTIONS.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 common/rc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index 649b1cfd..0ec7fe1a 100644
--- a/common/rc
+++ b/common/rc
@@ -1062,7 +1062,7 @@ _scratch_mkfs_geom()
     case $FSTYP in
     xfs)
 	if echo "$MKFS_OPTIONS" | egrep -q "b?size="; then
-		MKFS_OPTIONS=$(echo "$MKFS_OPTIONS" | sed -r "s/(b?size=)[0-9]+/\1$blocksize/")
+		MKFS_OPTIONS=$(echo "$MKFS_OPTIONS" | sed -r "s/(b?size=)[0-9]+k?/\1$blocksize/")
 	else
 		MKFS_OPTIONS+=" -b size=$blocksize"
 	fi
-- 
2.29.2

