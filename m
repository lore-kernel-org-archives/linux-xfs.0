Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC79CD493D
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 01:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjIUBtA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Sep 2023 21:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjIUBs7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2023 21:48:59 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA5CAF
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:48:52 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-690d8fb3b7eso370119b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695260932; x=1695865732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CX5jpL8hXnv7uqrCusK7w69MO8sgoFMYTB+neSEgWGQ=;
        b=fTt8gPFDAUW8U6TqQCr6ebovGhE2TSco+L1DZkrGGatkP3HCOBCfrEDe5kMZw6Kh9+
         ymX1CKbH4DJgq01tcmCA/pZjbaW2T64WVgGgoJWiLuXS40MQThIXEcmj+2HRvzXBCuUU
         fC3iKcQEw23IGCsgqsg99ZnrclQqxs+jMg21WzA21cPrDYWU1SMaH1iVblwOKBmSaF88
         +U0Cn492UP1UKUTf1h3VBUpHuI9KF6sXzxK0aEENE86ROZ/vHneGIU69KvgBpN0vZuR7
         7jKcUuervm3+TxUpSCZAGjRpZgPz8CX174L5wWvuav1BLY7HqSGxrDzyCyxjEQ2Yn5xi
         STCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695260932; x=1695865732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CX5jpL8hXnv7uqrCusK7w69MO8sgoFMYTB+neSEgWGQ=;
        b=iKP/1z9wt6e+LxtSjlc+3VUvVJ9W7kNLAZJcuAHAxzjYZYp9OzxlWgqfUt1OLYC7ui
         29CQ3ZdgX9sOKJwPEXDIFdthHlmgoRUAP7s3aeiOlnu70wj2GZlFjKPVya8csuCZQMBB
         AoJqdPX4NRldI5WQBS3CXdvy2NI6Lz6L+Oc72uJ/QpCkCrqtLXs5vVyVmboza0TgRyNU
         bOb5Yi8cRiPxcaGJp3eXsgf4LnTimMhcZF0o4WL8B6bLQK0Plnad0x6yrneW1WXiZ+i4
         w2gQy14D9QMe5W0Um4Wn1w+TBvMUkdOwBbLt7NeMmmahrGG0dSRnZE4RqtApL5JPX7zW
         GaIA==
X-Gm-Message-State: AOJu0YxV3hkDg9/rM4dkyJasIW4SVEDL756dF3gDwz32Ni5vNJ7iW9+S
        aC5G4xwczPmtzVjd9zFHoBuVeuLrdWMCT8Iy4pM=
X-Google-Smtp-Source: AGHT+IFkjBOmJiYDWeVl3erUmpjjMxwNer2m0a7TdQZHl04mRNQ6jALgTuig/KTY+EvzUcjyIs54VQ==
X-Received: by 2002:a05:6a00:179f:b0:68e:3bc7:3101 with SMTP id s31-20020a056a00179f00b0068e3bc73101mr5132984pfg.2.1695260932037;
        Wed, 20 Sep 2023 18:48:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id a23-20020a62e217000000b00690ca4356f1sm158130pfi.198.2023.09.20.18.48.50
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 18:48:51 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qj8oB-003T1n-19
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:48:47 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qj8oB-00000002VO7-0MrE
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:48:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: ensure log tail is always up to date
Date:   Thu, 21 Sep 2023 11:48:39 +1000
Message-Id: <20230921014844.582667-5-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230921014844.582667-1-david@fromorbit.com>
References: <20230921014844.582667-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Whenever we write an iclog, we call xlog_assign_tail_lsn() to update
the current tail before we write it into the iclog header. This
means we have to take the AIL lock on every iclog write just to
check if the tail of the log has moved.

This doesn't avoid races with log tail updates - the log tail could
move immediately after we assign the tail to the iclog header and
hence by the time the iclog reaches stable storage the tail LSN has
moved forward in memory. Hence the log tail LSN in the iclog header
is really just a point in time snapshot of the current state of the
AIL.

With this in mind, if we simply update the in memory log->l_tail_lsn
every time it changes in the AIL, there is no need to update the in
memory value when we are writing it into an iclog - it will already
be up-to-date in memory and checking the AIL again will not change
this. Hence xlog_state_release_iclog() does not need to check the
AIL to update the tail lsn and can just sample it directly without
needing to take the AIL lock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c       |  5 ++---
 fs/xfs/xfs_trans_ail.c | 17 +++++++++++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bd08d1af59cb..b6db74de02e1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -530,7 +530,6 @@ xlog_state_release_iclog(
 	struct xlog_in_core	*iclog,
 	struct xlog_ticket	*ticket)
 {
-	xfs_lsn_t		tail_lsn;
 	bool			last_ref;
 
 	lockdep_assert_held(&log->l_icloglock);
@@ -545,8 +544,8 @@ xlog_state_release_iclog(
 	if ((iclog->ic_state == XLOG_STATE_WANT_SYNC ||
 	     (iclog->ic_flags & XLOG_ICL_NEED_FUA)) &&
 	    !iclog->ic_header.h_tail_lsn) {
-		tail_lsn = xlog_assign_tail_lsn(log->l_mp);
-		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
+		iclog->ic_header.h_tail_lsn =
+				cpu_to_be64(atomic64_read(&log->l_tail_lsn));
 	}
 
 	last_ref = atomic_dec_and_test(&iclog->ic_refcnt);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 3103e16d6965..e31bfeb01375 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -715,6 +715,13 @@ xfs_ail_push_all_sync(
 	finish_wait(&ailp->ail_empty, &wait);
 }
 
+/*
+ * Callers should pass the the original tail lsn so that we can detect if the
+ * tail has moved as a result of the operation that was performed. If the caller
+ * needs to force a tail LSN update, it should pass NULLCOMMITLSN to bypass the
+ * "did the tail LSN change?" checks. If the caller wants to avoid a tail update
+ * (e.g. it knows the tail did not change) it should pass an @old_lsn of 0.
+ */
 void
 xfs_ail_update_finish(
 	struct xfs_ail		*ailp,
@@ -799,10 +806,16 @@ xfs_trans_ail_update_bulk(
 
 	/*
 	 * If this is the first insert, wake up the push daemon so it can
-	 * actively scan for items to push.
+	 * actively scan for items to push. We also need to do a log tail
+	 * LSN update to ensure that it is correctly tracked by the log, so
+	 * set the tail_lsn to NULLCOMMITLSN so that xfs_ail_update_finish()
+	 * will see that the tail lsn has changed and will update the tail
+	 * appropriately.
 	 */
-	if (!mlip)
+	if (!mlip) {
 		wake_up_process(ailp->ail_task);
+		tail_lsn = NULLCOMMITLSN;
+	}
 
 	xfs_ail_update_finish(ailp, tail_lsn);
 }
-- 
2.40.1

