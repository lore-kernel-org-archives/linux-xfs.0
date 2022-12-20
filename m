Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE5CC3DA79
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 23:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiLTXXU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 18:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLTXXQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 18:23:16 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B01AB88
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:15 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso337249pjp.4
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2/k4p+F2J2msDAa+iHXuzkjg4CqrJdEP/jFmYYLf3lU=;
        b=SMtdCI/cZtyv3UE0V+Itesfd9J9JfsTywcZ5u90nWtsqijbjEuKKDqiT3w4jt8/m3N
         QDAeC5crVrQ2gAGeHFgV3wxHDbDv69e9fEWNTfSRwbz2ePWSGN4hKWtDGHdmntXVSgmi
         lBND996tYLioAVbpOsYJdfyV2NCZNrsYap2qkjb+NVqebgDap0qAGPlV9Dkx8ADdXfTq
         E40Pz1ihG125hn5UjYXEoQjasXgQSPoFlNDDx/XWHSGom9SBhQcP8Cznacw2KSUNm/OL
         orisiXM3As3iiTosVjqgy5MPHIlzRexLCHy6oDLJ0uMgSVaacCwFj6FA9RTsEf45RGok
         IvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2/k4p+F2J2msDAa+iHXuzkjg4CqrJdEP/jFmYYLf3lU=;
        b=7QXk1H1yek+YFXscnyQkR2ZOxJQNdMh9zeTlVKyO1ssa2KKM1wf3dt2LG7+Mn/xhAD
         NYgzbbOC3V+0ByQqSAl1YiuwnyCzT3el0wc+h86j2Amy4aIlYaGxr829PhCrjeA2GMzP
         AS0YH9VVMWAoTk99cdveFjD3jbvixu0crOQzYnyHxLcYsc0SJSOulRwJEURntm5l6vYU
         4a2mrKQPQSyuPdrkDAvCDGE2VxYAAPADvzRXiAsBKLtig3MyKDNXOn8cnwLU0b68CcNq
         3bYDX6g+qFAZ+CSGRRdyB5Yli+S94ERNOLZLlTzjcpd/daQPl/JuAc39FgpsLl90cJg0
         RNKg==
X-Gm-Message-State: ANoB5ploLMCv2CmzGWbgGvMS7iq5vfyeKJsG3kilRE13KcZDmsaxuuLv
        HfFYQY6TerMP9lhY8hzWplW3mILlBe2n6FgE
X-Google-Smtp-Source: AA0mqf4826LYjZ0kusEse6Pu9K4B869A4M2LKIg5CBUG5pMU/cV2wZLTpG7cmSFi5gwMAhhiX4Gjzw==
X-Received: by 2002:a17:90b:3942:b0:221:5596:593b with SMTP id oe2-20020a17090b394200b002215596593bmr37555470pjb.5.1671578594773;
        Tue, 20 Dec 2022 15:23:14 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id x14-20020a17090ab00e00b00219220edf0dsm56793pjq.48.2022.12.20.15.23.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 15:23:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1p7lx1-00Asnd-8u
        for linux-xfs@vger.kernel.org; Wed, 21 Dec 2022 10:23:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1p7lx1-00Ec6B-0o
        for linux-xfs@vger.kernel.org;
        Wed, 21 Dec 2022 10:23:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/9] xfs: collapse xlog_state_set_callback in caller
Date:   Wed, 21 Dec 2022 10:23:05 +1100
Message-Id: <20221220232308.3482960-7-david@fromorbit.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221220232308.3482960-1-david@fromorbit.com>
References: <20221220232308.3482960-1-david@fromorbit.com>
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
index 2795157e345e..25168b38fa25 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2544,25 +2544,6 @@ xlog_get_lowest_lsn(
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
@@ -2594,7 +2575,17 @@ xlog_state_iodone_process_iclog(
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
2.38.1

