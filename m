Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC67C54EE9
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Sep 2022 03:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiIKDcF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 10 Sep 2022 23:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiIKDcE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Sep 2022 23:32:04 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1A0476F5
        for <linux-xfs@vger.kernel.org>; Sat, 10 Sep 2022 20:32:03 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j12so5403204pfi.11
        for <linux-xfs@vger.kernel.org>; Sat, 10 Sep 2022 20:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=2qs+1pHSkBcFT7Hc/GjK6tXvRXJh8I52IOeg96b5aos=;
        b=M941bLG4B9v2k2jXKtdsXls8Rw7kqh0em6MxSDrsG4XQg6b7kRt/SfVMh5sZRxt/24
         4F9NIphYH+jQRUEcnDLxcfQFZRVvaIvsZ3gzUXRj6TeoH6batbjEL0yx3HGiAbTET/Qi
         nR65Mu29dJ6SUsluE85YR0T+4kFcormMv7P4+dHOVQ4jNv8BeUdAa77DCded3RtWn4T0
         H9cbDnF3fWZN+x130eB9kms3jSuFwkNCFveqPOcb9urH7vjHIvgHmZPlDeHWIFIRUcOR
         ekDosIEOcYTs4X5a8/5WnQHwq0O9/DSfvkD6sbR4Q/MqevUcR4K2LlRCnBIGPmpVtgxi
         vDBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=2qs+1pHSkBcFT7Hc/GjK6tXvRXJh8I52IOeg96b5aos=;
        b=DCbf1fX/cTCvAjbHAoFQ76YWZozYtfdzBMwQQYIUkn3dO3/qtL/D6Xh9v9aoUXiyoN
         QoRiyj1w9YHKuVPsl+P5URVRBONZwUpqHE5RlTh40jQwse/APVPeTPkuPl4UAodBURBl
         PHTKUSylJtpl5BEzCl9c8rZoTEl9E6fbKj5d4/E1wyBG6yZ/LRPuzni546SFkOYHHocW
         IMr+6cuvPP7VHboyeoiI+WxDxwrk9rUKG33Uk5ERtfDL55Zab6lMEKle24gpXAyNVfDG
         7EilJljQbzdzLY5P4wuwAz0mANFPp/Rt0NyPM/iw1wgfdT2CrSZGlHxG0XcEWQvfkDAz
         gvxw==
X-Gm-Message-State: ACgBeo33LOR7GS/6GLSjykk1IB/tIJ+PWtscq5aBdeW2DNP7lzgFRqVo
        xgBJmkDZTCqR41CHJhoS9HwrvMh7c99c4g==
X-Google-Smtp-Source: AA6agR7UUjN4rHiFa/g/sAfMKtpZZdihFkzxOyDv2Qt7j41uccIjjqQSdFpbji7Py7doTcQcZRHMGA==
X-Received: by 2002:a63:e516:0:b0:434:9462:69cd with SMTP id r22-20020a63e516000000b00434946269cdmr17255453pgh.503.1662867123069;
        Sat, 10 Sep 2022 20:32:03 -0700 (PDT)
Received: from localhost.localdomain ([165.154.253.46])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090311c600b00177ef3246absm3045301plh.103.2022.09.10.20.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Sep 2022 20:32:02 -0700 (PDT)
From:   Stephen Zhang <starzhangzsd@gmail.com>
X-Google-Original-From: Stephen Zhang <zhangshida@kylinos.cn>
To:     djwong@kernel.org, dchinner@redhat.com, chandan.babu@oracle.com
Cc:     zhangshida@kylinos.cn, starzhangzsd@gmail.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix up the comment in xfs_dir2_isleaf
Date:   Sun, 11 Sep 2022 11:31:37 +0800
Message-Id: <20220911033137.4010427-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_dir2_isleaf is used to see if the directory is a single-leaf
form directory, as commented right above the function.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/xfs/libxfs/xfs_dir2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 76eedc2756b3..1485f53fecf4 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -632,7 +632,7 @@ xfs_dir2_isblock(
 int
 xfs_dir2_isleaf(
 	struct xfs_da_args	*args,
-	int			*vp)	/* out: 1 is block, 0 is not block */
+	int			*vp)	/* out: 1 is leaf, 0 is not leaf */
 {
 	xfs_fileoff_t		last;	/* last file offset */
 	int			rval;
-- 
2.25.1

