Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9C1CD4938
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 01:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjIUBs5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Sep 2023 21:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjIUBs5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2023 21:48:57 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D044B7
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:48:51 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id 5614622812f47-3ae015b6441so51513b6e.1
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695260930; x=1695865730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dwerFL2Xlng+UKi9MgZzfcivTNi/U3UsTqlgcNiGGGE=;
        b=G96pAx/qH3Tc5YKVjvZIzQmeOCfld3VAs/OKSLOwTdNkWrb34MdSE2nA3nCfr01u1o
         IKZx4XaIOG33bMuavURu3liGPbrkcWidvg7ty67fn82gIbASbMLUI7kH3IfcsF2tigY0
         +5R19ws+iAS6gz6rYzagSliWt4AbLzJMN99whP3jeCc6RWCZCs6Fig1ezJzw6ue3spa/
         NQPs4o4uVHsdLY585UIREXYZK6HhQdL29lJEJPquPJib/bMSNvSKu3+T49DpPGrBzb1K
         uoLC7AxCztgkKrbz9NAAhySIiuCm36igXzHw0H3PZStJIvj8GkOXP62W1iI5SIPzoSiU
         ZzOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695260930; x=1695865730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dwerFL2Xlng+UKi9MgZzfcivTNi/U3UsTqlgcNiGGGE=;
        b=s2RgKplkfwv9sOI7STHlEHIlMDnFdeF4P7ouWsBgEnDNN9UWmNH20Tn1pMSlUpBBAv
         mNXh2zOC1/3F43pPGNO24yaRKW5jnNjMCxcbrLuzqG2CAQwSYEHCSt4s+gSLZw7A1uhT
         fR5rw86PIhuswlmQCauIqNikBaPny/TKUAwcu9FJEUhp47Zy/UY8Rw3H9swaa1oCg6Oq
         BgpEJBuf3XF1nWNc+J0RALBjMLDaqF3b02e3WZWORqghwVDV3FtJKoWTi61LSbTEDQWH
         sYj0MWZQCXXXgz8fC34tdXHyB+XoRkKas0/nU7YJAIzHNJGxvkMGfWtdxcGWuVZbolkl
         ROjA==
X-Gm-Message-State: AOJu0Yya0P3hRJT9aApwwDaud+n+kz7zMG4cy8gMoXtchZjAz6M5tugB
        RD3Ne/SEmB/tIndsEVNOr9NpIKB9avy2uedoGcY=
X-Google-Smtp-Source: AGHT+IF8P0iunp1Q2F9nGD6Mz4loMoccQO9o+nw1dvDio9I8Gx42Ev0xpJOX/1WLtezZ3oQdK4xRRw==
X-Received: by 2002:a05:6808:3091:b0:3a5:cc7d:3d66 with SMTP id bl17-20020a056808309100b003a5cc7d3d66mr4521380oib.49.1695260930370;
        Wed, 20 Sep 2023 18:48:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id g30-20020a63375e000000b0057401997c22sm138949pgn.11.2023.09.20.18.48.50
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 18:48:50 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qj8oB-003T1v-1S
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:48:47 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qj8oB-00000002VOI-0mPK
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:48:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/9] xfs: collapse xlog_state_set_callback in caller
Date:   Thu, 21 Sep 2023 11:48:41 +1000
Message-Id: <20230921014844.582667-7-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230921014844.582667-1-david@fromorbit.com>
References: <20230921014844.582667-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The function is called from a single place, and it isn't just
setting the iclog state to XLOG_STATE_CALLBACK - it can mark iclogs
clean, which moves them to states after CALLBACK. Hence the function
is now badly named, and should just be folded into the caller where
the iclog completion logic makes a whole lot more sense.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2ceadee276e2..83a5eb992574 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2510,25 +2510,6 @@ xlog_get_lowest_lsn(
 	return lowest_lsn;
 }
 
-static void
-xlog_state_set_callback(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	xfs_lsn_t		header_lsn)
-{
-	/*
-	 * If there are no callbacks on this iclog, we can mark it clean
-	 * immediately and return. Otherwise we need to run the
-	 * callbacks.
-	 */
-	if (list_empty(&iclog->ic_callbacks)) {
-		xlog_state_clean_iclog(log, iclog);
-		return;
-	}
-	trace_xlog_iclog_callback(iclog, _RET_IP_);
-	iclog->ic_state = XLOG_STATE_CALLBACK;
-}
-
 /*
  * Return true if we need to stop processing, false to continue to the next
  * iclog. The caller will need to run callbacks if the iclog is returned in the
@@ -2560,7 +2541,17 @@ xlog_state_iodone_process_iclog(
 		lowest_lsn = xlog_get_lowest_lsn(log);
 		if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
 			return false;
-		xlog_state_set_callback(log, iclog, header_lsn);
+		/*
+		 * If there are no callbacks on this iclog, we can mark it clean
+		 * immediately and return. Otherwise we need to run the
+		 * callbacks.
+		 */
+		if (list_empty(&iclog->ic_callbacks)) {
+			xlog_state_clean_iclog(log, iclog);
+			return false;
+		}
+		trace_xlog_iclog_callback(iclog, _RET_IP_);
+		iclog->ic_state = XLOG_STATE_CALLBACK;
 		return false;
 	default:
 		/*
-- 
2.40.1

