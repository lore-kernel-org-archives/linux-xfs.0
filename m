Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C25C432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1AD260C51
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhGZLH2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbhGZLH2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:07:28 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F3AC061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:56 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c16so5652451plh.7
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ojahhnDJds3W1B3s9c/VjZnIsirQaZ3K/2NRG0oOKOs=;
        b=K5eQcD7jZhUbPDj0unqRiysPYchPaPaZNYvh85CSgV6vvROrPyoBRnyYfzOM2EmG36
         IQmdl9XaJvpiP8dqBZXn+02YNp9MiV69a+zQf4/Puh0Pe3eHl1pPLlJXa5toLhs/DTBT
         OotnrpJMhRjwQ+Ta+5QIZhnSL5jmtcR3L/mEuo3HCQd+IFAHnJcOGUblYI2Tn3cTEvUE
         SH1FHo36ecbvwDglVE0zh3woyDRmTmUHHliHZ6MXnd/l5QxuWSW5CRvDYANrDu6Hyoa5
         GvrFqLSES8kBjHHAigBCKLAI1GFbdljW5ytVZuSMbpzeTAIkVUF8UkOaa7toitw0H91/
         XXFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ojahhnDJds3W1B3s9c/VjZnIsirQaZ3K/2NRG0oOKOs=;
        b=MHocJ1NnL7igABmbcsy54mySbJ8yFKT9CEDAdLtQJjeF1J7v4F/IqNu3h5kOyhvIVs
         sBueh/Y82eQLhBJoy3FXJH8KjKl65U0oUthfK3qVfy+ypBdq4GngPIaowDtzONw3wDKM
         IITDMjl6IpkFC6i1W26WFbgt1gfdN0KAZGEgGD4FjsqZ3h8TmrTIfwLvrq3DNOxHhgar
         6OUa/KrAyEbW+lrWjAbJwv5Oi0hIGEQ69qsuTf24likyNB+k1HYbp2ktw5lahPjiwsGz
         TOj5wgQZ2R8XsTfCSxJypOeSVL3KGnbbXhNULFUDSGTymFfx8w+nEuEshhWrSxnuXlOa
         ThlA==
X-Gm-Message-State: AOAM531wNnZafefEEWIN+H/kxRUgAyNaaQmZSWYoAr8YlrxSwS/qyoAT
        axlD4o0tqN+BjEzAHZkZRbT0B8w1Yws=
X-Google-Smtp-Source: ABdhPJzgqkXYQwvxhy9NQfWk526C6Zxwhfv6i/NHchTx0T87DeL0+3yO5qBIK3FFzgzWdJDn0leUog==
X-Received: by 2002:a17:90a:74c5:: with SMTP id p5mr16645861pjl.117.1627300075964;
        Mon, 26 Jul 2021 04:47:55 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id y10sm35936900pjy.18.2021.07.26.04.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:47:55 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 12/12] xfsprogs: Add extcnt64bit mkfs option
Date:   Mon, 26 Jul 2021 17:17:24 +0530
Message-Id: <20210726114724.24956-13-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114724.24956-1-chandanrlinux@gmail.com>
References: <20210726114724.24956-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Enabling extcnt64bit option on mkfs.xfs command line extends the maximum
values of inode data and attr fork extent counters to 2^48 - 1 and 2^32 - 1
respectively.  This also sets the XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT incompat
flag on the superblock preventing older kernels from mounting such a
filesystem.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 man/man8/mkfs.xfs.8 |  7 +++++++
 mkfs/xfs_mkfs.c     | 23 +++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 0e06e5bea..e20f6f475 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -650,6 +650,13 @@ space over time such that no free extents are large enough to
 accommodate a chunk of 64 inodes. Without this feature enabled, inode
 allocations can fail with out of space errors under severe fragmented
 free space conditions.
+.TP
+.BI extcnt64bit[= value]
+Extend maximum values of inode data and attr fork extent counters from 2^31 -
+1 and 2^15 - 1 to 2^48 - 1 and 2^32 - 1 respectively. If the value is
+omitted, 1 is assumed. This feature is disabled by default. This feature is
+only available for filesystems formatted with -m crc=1.
+.TP
 .RE
 .PP
 .PD 0
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 33b27b1f5..ac2b43188 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -78,6 +78,7 @@ enum {
 	I_ATTR,
 	I_PROJID32BIT,
 	I_SPINODES,
+	I_EXTCNT_64BIT,
 	I_MAX_OPTS,
 };
 
@@ -433,6 +434,7 @@ static struct opt_params iopts = {
 		[I_ATTR] = "attr",
 		[I_PROJID32BIT] = "projid32bit",
 		[I_SPINODES] = "sparse",
+		[I_EXTCNT_64BIT] = "extcnt64bit",
 	},
 	.subopt_params = {
 		{ .index = I_ALIGN,
@@ -481,6 +483,12 @@ static struct opt_params iopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = I_EXTCNT_64BIT,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		}
 	},
 };
 
@@ -813,6 +821,7 @@ struct sb_feat_args {
 	bool	metadir;		/* XFS_SB_FEAT_INCOMPAT_METADIR */
 	bool	nodalign;
 	bool	nortalign;
+	bool	extcnt64bit;
 };
 
 struct cli_params {
@@ -1594,6 +1603,9 @@ inode_opts_parser(
 	case I_SPINODES:
 		cli->sb_feat.spinodes = getnum(value, opts, subopt);
 		break;
+	case I_EXTCNT_64BIT:
+		cli->sb_feat.extcnt64bit = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2172,6 +2184,14 @@ _("metadata directory not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.metadir = false;
+
+		if (cli->sb_feat.extcnt64bit &&
+			cli_opt_set(&iopts, I_EXTCNT_64BIT)) {
+			fprintf(stderr,
+_("64 bit extent count not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.extcnt64bit = false;
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -3166,6 +3186,8 @@ sb_set_features(
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
 	}
 
+	if (fp->extcnt64bit)
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT;
 }
 
 /*
@@ -3876,6 +3898,7 @@ main(
 			.nodalign = false,
 			.nortalign = false,
 			.bigtime = false,
+			.extcnt64bit = false,
 		},
 	};
 
-- 
2.30.2

