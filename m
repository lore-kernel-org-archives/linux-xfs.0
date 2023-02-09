Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 922FEC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjBIW0Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjBIW0V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:26:21 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BAC6BA94
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:26:10 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 78so2536366pgb.8
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mGThyxmkTTx5yKSqdgYLAecRC7kAl4zoixESVQZ74F0=;
        b=w0b0ULNr/eJahGW4sDB4YpVpEk2mvsSz7mrzmmwO8vV/ntqdKfITzmNg5pnAFDxngj
         PTfnuXtgduzVRSPpojtdFU4XWXm3jMcnYel6NOnpV6+xSbZs+SeMtENaJKWQ8o6gnxrm
         zcYxOC2V2KPkF+zcUGTJ0Re0A+d9ls7o5YsHuta90vmVfgRROm0Ozcp0YIzxTxKBO344
         36GTF6zgdq89U2tL1YBzT+E0MeQqcOSC5gPc9KzDlFnbNrslz4Kjea43/sq6ptq24MLU
         TO4Itr4q9WFqOZI7GXpjr7EplkMBd7cdKkh5lOa5mR1FZ7EJB3Z9KrSrzA4OiWoSWL+s
         Tu0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mGThyxmkTTx5yKSqdgYLAecRC7kAl4zoixESVQZ74F0=;
        b=tYyzd+Q1ia6rOUCaVQiFPbxmSN/IwOJf0X2Q1THZSyg1FaWNG9/Ch1I9bXQpM7Efho
         vMO55s3FhPYyByncPJ36C6T6E797443EWeaLP8Qxr0yfmehYexVBvFfvCEopyFLNJDIf
         ViMrWrH8nBnYImn3xl3gthHGPyQWzZTBW6J4wXSoRMUiOMm91mCTGBoDA+VnG/3gWSwb
         +20JxBatg3njf/FqR228cB+hmYHy5GmEAlMB8K0LD/Hus4A3E5RZscLWAlmr/mdsjqqM
         6nLrPtU6hPRCgsdx1JxgrGfpAD8w87d24P1imWTDaJ3nVGbatxBfmJnbPASkNZBnozv9
         wVsw==
X-Gm-Message-State: AO0yUKX7mTh4zWZ+HuiAYPAE1wI8B9PX2cuUF+rlh0u+st+YUg1wYYe/
        +DYR2wmWmwah9pBELaMvAslSXNAmCyyzT/Vc
X-Google-Smtp-Source: AK7set/CuQN9H0ev+X+p1AhFXYcca+I2zfiI28n7nPRNgzmTBNN09WmNd69GkawwSXVX4z2IvZcrAw==
X-Received: by 2002:a62:4e48:0:b0:5a7:a688:cd8a with SMTP id c69-20020a624e48000000b005a7a688cd8amr9411134pfb.33.1675981569499;
        Thu, 09 Feb 2023 14:26:09 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id z5-20020aa785c5000000b005a85db65bf2sm1818195pfn.129.2023.02.09.14.26.09
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:26:09 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFL-00DOUt-W5
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFL-00FcMK-3B
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/42] xfs: don't assert fail on transaction cancel with deferred ops
Date:   Fri, 10 Feb 2023 09:17:49 +1100
Message-Id: <20230209221825.3722244-7-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We can error out of an allocation transaction when updating BMBT
blocks when things go wrong. This can be a btree corruption, and
unexpected ENOSPC, etc. In these cases, we already have deferred ops
queued for the first allocation that has been done, and we just want
to cancel out the transaction and shut down the filesystem on error.

In fact, we do just that for production systems - the assert that we
can't have a transaction with defer ops attached unless we are
already shut down is bogus and gets in the way of debugging
whatever issue is actually causing the transaction to be cancelled.

Remove the assert because it is causing spurious test failures to
hang test machines.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trans.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 53ab544e4c2c..8afc0c080861 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1078,10 +1078,10 @@ xfs_trans_cancel(
 	/*
 	 * It's never valid to cancel a transaction with deferred ops attached,
 	 * because the transaction is effectively dirty.  Complain about this
-	 * loudly before freeing the in-memory defer items.
+	 * loudly before freeing the in-memory defer items and shutting down the
+	 * filesystem.
 	 */
 	if (!list_empty(&tp->t_dfops)) {
-		ASSERT(xfs_is_shutdown(mp) || list_empty(&tp->t_dfops));
 		ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 		dirty = true;
 		xfs_defer_cancel(tp);
-- 
2.39.0

