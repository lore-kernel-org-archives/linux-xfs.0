Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A0E4CD4938
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 01:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjIUBj5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Sep 2023 21:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjIUBj4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2023 21:39:56 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323D2AB
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:39:51 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1c0c6d4d650so3569115ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695260390; x=1695865190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MLvhZIcM0SpJ7wSPoi1+k37DPAhj8JFuXNxcyOg8Bl8=;
        b=Pux4oQWpUKGb9EBWgxzQB9tTvg+vsQa76w8EUGRqKGZYwP09SM4D+opwfA8AdDKrPs
         C02UR+Cwlem7TZ8SeqCMbXgVLNN/2kcHiBMUJBPoSoaeWm7CRONbefy4iwmgoQYSFtSb
         oYiAXHLIa7WfwoC+i64eE1tuMR6cRWnd1GwlsDQUxsbho3uhkwbeL2W6Iwx2XJKGF+HF
         tIAaxuj2dzV+H0ClGIhVLqJ5O2H5P2K+GfYUYT47bE1nsIgk6LCreUabwHaKDXxUGzRi
         qS3fqCSSff2nHCGuHClSww+uNPRUvn7fFxYf1OywtUWRaWBlkie1BjeWdIVAD06CtTL2
         dFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695260390; x=1695865190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MLvhZIcM0SpJ7wSPoi1+k37DPAhj8JFuXNxcyOg8Bl8=;
        b=rGO1oCuZ14DA2EmUtjUufh8j5tHKrsWuBBvOFspLcYXIqUbuBxoRsMRQUMkdmxH+y2
         K431qKk+ngf7hIPPq69YddG2wd0jdrQ27zAR7hpQlkEv/+kjzAydF2YRhWVWtTCiYotE
         lpHdTR60b6v3/D/+jUxGyjbOMyhG7IxWw/8cc0+tU3pdBixe2AyGFOrayKv1S43Ehozd
         KiUQhoa2GYZoZfbw8wb0v2MH3RcdFINiogtT+89DaP6DEjv4Do8V1kn2D49zdlUybLkK
         PwOpmF4cCchDC/+igZAvDBvhcNqsdYdi1hkCr107xoROoW6iQXW+6dGV/ZpxIeiCL3gL
         Lnqw==
X-Gm-Message-State: AOJu0YyB38WgCRBfcIv4HgYf0YdezgexeGyovdh18WYpd6FbVSUcOPL3
        WW51A3iszoEbgjhzSRJ1Fp5ezrjqLUwLSB6b7hE=
X-Google-Smtp-Source: AGHT+IEyIEmr2paM4FY8CWZBJ52WVvDxd4B8hGlItu/j/jXz4y6u+KTYomiz1e4VImWf1Y2UnnRksA==
X-Received: by 2002:a17:902:e886:b0:1c2:1068:1f4f with SMTP id w6-20020a170902e88600b001c210681f4fmr3976835plg.17.1695260390599;
        Wed, 20 Sep 2023 18:39:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id jj18-20020a170903049200b001c5c0d6fc76sm143442plb.233.2023.09.20.18.39.49
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 18:39:49 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qj8fT-003Sv6-1Y
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:39:47 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qj8fT-00000002MHQ-0xJO
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:39:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: abort fstrim if kernel is suspending
Date:   Thu, 21 Sep 2023 11:39:45 +1000
Message-Id: <20230921013945.559634-4-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230921013945.559634-1-david@fromorbit.com>
References: <20230921013945.559634-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

A recent ext4 patch posting from Jan Kara reminded me of a
discussion a year ago about fstrim in progress preventing kernels
from suspending. The fix is simple, we should do the same for XFS.

This removes the -ERESTARTSYS error return from this code, replacing
it with either the last error seen or the number of blocks
successfully trimmed up to the point where we detected the stop
condition.

References: https://bugzilla.kernel.org/show_bug.cgi?id=216322
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_discard.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index f16b254b5eaa..d5787991bb5b 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -283,6 +283,12 @@ xfs_trim_gather_extents(
 	return error;
 }
 
+static bool
+xfs_trim_should_stop(void)
+{
+	return fatal_signal_pending(current) || freezing(current);
+}
+
 /*
  * Iterate the free list gathering extents and discarding them. We need a cursor
  * for the repeated iteration of gather/discard loop, so use the longest extent
@@ -336,10 +342,9 @@ xfs_trim_extents(
 		if (error)
 			break;
 
-		if (fatal_signal_pending(current)) {
-			error = -ERESTARTSYS;
+		if (xfs_trim_should_stop())
 			break;
-		}
+
 	} while (tcur.ar_blockcount != 0);
 
 	return error;
@@ -408,12 +413,12 @@ xfs_ioc_trim(
 	for_each_perag_range(mp, agno, xfs_daddr_to_agno(mp, end), pag) {
 		error = xfs_trim_extents(pag, start, end, minlen,
 					  &blocks_trimmed);
-		if (error) {
+		if (error)
 			last_error = error;
-			if (error == -ERESTARTSYS) {
-				xfs_perag_rele(pag);
-				break;
-			}
+
+		if (xfs_trim_should_stop()) {
+			xfs_perag_rele(pag);
+			break;
 		}
 	}
 
-- 
2.40.1

