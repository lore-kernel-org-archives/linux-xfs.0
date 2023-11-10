Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989EBC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 18:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbjKJSFJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 13:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235731AbjKJSEn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 13:04:43 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F957DA8
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 22:49:51 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6ce2d4567caso934078a34.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 Nov 2023 22:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1699598990; x=1700203790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UBEETL6nJeFuzIMLy/27m3ZjLavYPDa2hHML8/UEZ/w=;
        b=SwLMR0EOfMaLegMMs5dEO5EYSso3FBe9B5PbHRb4Rbcvw90BCn0GxngYMGA8PfgUfG
         /xkl0ZEHWUS1bRwqQGpmVd/j/R+2EQzs39XZEv4Lprj88zm3ixvcfywElYedvqJNyD4Z
         1WR7hb+ZfZGvk+8re5zIsBTMJ3JL7MRv6bwKmtgWvr9gBEDaUsnjkYq74nAK5S4DQ48p
         Fva7Ss4SgF1L8JAiZLYgQt/i/u0imgIXI4Pjp63HrUlQU+jtJ7sICRweNVdakPkh9E2q
         +i0W2mL8c/mGdwDIZ8q+UiA1zczJef/iVZh8WsH+bV3WqndIWCCkxZY8ceEryyUJvWVf
         UN/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699598990; x=1700203790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UBEETL6nJeFuzIMLy/27m3ZjLavYPDa2hHML8/UEZ/w=;
        b=vrvfy4Yf/rYPcSWkZlz+wYhfdhVc43BRnuVBh+oJMcshSzCPaZysRUtXcy0MNMwp5p
         YWkQVKpkjW2kxAlf9PTuAb9DOPKRQOjcqrqKIVl6lss/BOeJEPNMlcSQwUoT59nNsJpJ
         VUhnBqxFPxkn07fiinGsLmsY/gW7si4c+VSR6/NoYGbF5mqez8qI+rKFjQptLnAAhDdn
         oH6gQOLt3RLhwZHeM/rsgB+KAQKgu5N9khp4hYccF7vymj20EhcbNnry/73NjIVwsGfV
         QCSb6KqgJLK9XvZuyIbDfYbTrKRSZ+mXm5fYjFpWTZEtKcocnQ9IIBcypRdxjUhxEVS+
         koXw==
X-Gm-Message-State: AOJu0YyOFY2qLwrDmDZ49iQmG/gC2Olb+0TKaiKskbNZxAPq5Qa1u99H
        KPBLhVdzdk3hn3C6wkiRmuxav23BZrenQgSCUSM=
X-Google-Smtp-Source: AGHT+IHBXhonhDckrD/6UlFlutgdqukkcqiDWEytsNmTs6rnqsy6GpkGqxvvG3f8o2uMbB1zWfqRyg==
X-Received: by 2002:a05:6a20:8e0b:b0:185:a90d:367e with SMTP id y11-20020a056a208e0b00b00185a90d367emr1361500pzj.2.1699591506838;
        Thu, 09 Nov 2023 20:45:06 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id jg22-20020a17090326d600b001c75a07f62esm4401658plb.34.2023.11.09.20.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Nov 2023 20:45:06 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1r1JOB-00AbtH-1F;
        Fri, 10 Nov 2023 15:45:03 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1r1JOA-000000039Jb-45ss;
        Fri, 10 Nov 2023 15:45:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     zlang@redhat.com
Subject: [PATCH 1/2] xfs: inode recovery does not validate the recovered inode
Date:   Fri, 10 Nov 2023 15:33:13 +1100
Message-ID: <20231110044500.718022-2-david@fromorbit.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231110044500.718022-1-david@fromorbit.com>
References: <20231110044500.718022-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Discovered when trying to track down a weird recovery corruption
issue that wasn't detected at recovery time.

The specific corruption was a zero extent count field when big
extent counts are in use, and it turns out the dinode verifier
doesn't detect that specific corruption case, either. So fix it too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c   |  3 +++
 fs/xfs/xfs_inode_item_recover.c | 14 +++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index a35781577cad..0f970a0b3382 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -508,6 +508,9 @@ xfs_dinode_verify(
 	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
+	if (nextents + naextents == 0 && nblocks != 0)
+		return __this_address;
+
 	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
 		return __this_address;
 
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 6b09e2bf2d74..f4c31c2b60d5 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -286,6 +286,7 @@ xlog_recover_inode_commit_pass2(
 	struct xfs_log_dinode		*ldip;
 	uint				isize;
 	int				need_free = 0;
+	xfs_failaddr_t			fa;
 
 	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
 		in_f = item->ri_buf[0].i_addr;
@@ -529,8 +530,19 @@ xlog_recover_inode_commit_pass2(
 	    (dip->di_mode != 0))
 		error = xfs_recover_inode_owner_change(mp, dip, in_f,
 						       buffer_list);
-	/* re-generate the checksum. */
+	/* re-generate the checksum and validate the recovered inode. */
 	xfs_dinode_calc_crc(log->l_mp, dip);
+	fa = xfs_dinode_verify(log->l_mp, in_f->ilf_ino, dip);
+	if (fa) {
+		XFS_CORRUPTION_ERROR(
+			"Bad dinode after recovery",
+				XFS_ERRLEVEL_LOW, mp, dip, sizeof(*dip));
+		xfs_alert(mp,
+			"Metadata corruption detected at %pS, inode 0x%llx",
+			fa, in_f->ilf_ino);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
 
 	ASSERT(bp->b_mount == mp);
 	bp->b_flags |= _XBF_LOGRECOVERY;
-- 
2.42.0

