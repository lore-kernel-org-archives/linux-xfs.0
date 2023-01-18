Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777A9C54EBE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjARWp2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjARWpS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:18 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B6C5F38D
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:16 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id 7-20020a17090a098700b002298931e366so67321pjo.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zEMct9Zqrd13A6nzsqLIu04c0gI3Nv0cf7YVOTPO3rY=;
        b=ZTYbuE5VWxqg6wGLlAJ2Gjs0KMwmYFTi8coleZdcx13NLkq/GYZf/JwDPu5DzyBqxI
         bdFNCEsXfyODt9idLVHGb0mf0sCb+s7AwASNCWMB19RQU6EmovgxvsXPo5djBKfXfvRq
         veNw4KHVVpXbvPEAFUMz83uRslgmXY/osk4BPY+VukdpdItw4olJ0MDEBDru/zHfUVcH
         VRTTW1b0aFc02iC6KnC51VP1hn8A/G3b/YoU1ceRLH6EMV0rqlb8obONKq0q7l9qgvtZ
         4Td28wQYTu+fC9x9B9dfpYl1GkT43o5Cbxuyfsjvd1hA+/TRj8chtvYZxOKIWZSAgt61
         v1Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zEMct9Zqrd13A6nzsqLIu04c0gI3Nv0cf7YVOTPO3rY=;
        b=q+LGthsMOVMBpF/0WW+7lsXWv87Gn8in4J1JWBX6eR1+DCgSCaObySKe8/KcO4Kgcw
         CZDAZ79HzEDXi6t39j0MWTzAWfisc2MGxVhCdf46Vwuy1fSdQ3vuPSRq8jDup+UwN9EQ
         fy4Qq/r4bBkmHY3UkCpFRmiV02OXlqL6qbQ+yDb0hlAy78ZTR6NXOvw0lL/UdL7NSzKq
         Me6bEzIy5nPbMhd8yQDX4JoPMY9JIdvsJiyqO4r/DScv9Tzzy4Je66h+g13hl0OG69JG
         90mtzsmLepY8gIGCsCcR1WkEapxIkSZbczdXAAaiU4CPsgQ+MpO0CqRvvO12Z0IbLLYD
         CpSQ==
X-Gm-Message-State: AFqh2kqMW4ToItKcjH/NCHUrlrfeulS3tA0flZUFKYe6HAYzdvZYPx5L
        BxO2yJdmjKlGOKbtQON/LRCsXCz4wFVX+5Fv
X-Google-Smtp-Source: AMrXdXuMxKZGCffA32+IsKGgdfn0qxyHHkTr3CB8xhxxtQR3bn/NbPA3+HPdFEGlA8f4beeP9885NQ==
X-Received: by 2002:a17:902:bd41:b0:194:3cef:31 with SMTP id b1-20020a170902bd4100b001943cef0031mr9044498plx.49.1674081916118;
        Wed, 18 Jan 2023 14:45:16 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id t12-20020a170902e84c00b0019327a6abc2sm3878852plg.44.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB8-004iWs-V3
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:10 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB8-008FCz-38
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/42] xfs: don't assert fail on transaction cancel with deferred ops
Date:   Thu, 19 Jan 2023 09:44:29 +1100
Message-Id: <20230118224505.1964941-7-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
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

