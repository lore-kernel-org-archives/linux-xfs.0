Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 010B5C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0CAB20936
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:01:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RWhj/1c3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgHaNBg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgHaNB0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 09:01:26 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71836C061573
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 06:01:26 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id o16so1728865pjr.2
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 06:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gB3hGLIDIJzisCt3/MbN13IHvMIpVN9+B4I3bgKJ138=;
        b=RWhj/1c3uV7SjNoaeproUIWWpciMgO6U4pTL/BPL0SNBeqaQDZzBL6c0x2t2BMoTCL
         jls4s1EoIH7UfcSzsLOj08mnitdbnGwJv5Dji771cgwTKReBkApAr34rqi0gPbeGHU2y
         IJ9WVyAZ/r8IkQDOvkenIRFIOVGcsZWDH+4AvmBlynyYAJ1qSwepZsW6ByKF6jGk7phN
         wxqomYHib6pt9tHwozccJiVbh3ym9QFDVKZJpDR+XiUzke6SBJXgvGXlr/oPW2E9QNe1
         s+Cw3XilGbNnFiUD7xmhZVWpNhpjQ+N1pAX/1aMZHvFqnPkefoBenKPL6u30Z3x7IrM3
         ij0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gB3hGLIDIJzisCt3/MbN13IHvMIpVN9+B4I3bgKJ138=;
        b=GICdh01z7Jb0VKoM/+/8ppI7ZA9haWtXTjcMawz6y4iweJEBtb3pCkUJkdBzwg8C22
         NwGfYqfSWRof4409F2d8VKzOoO1JAkGJ531lRKTpzHND/y4hpUMHtMcG1pPCqS8nV52z
         MjxyKetcpUGxgj88SyG+n4O9yU7MqyEYV76O8Mq1DQrujVt4x8ljZYOBf+yXOaWRyJa/
         g9C8V2rhdQ6n7fXqv7741GBbpkfrXf6DcKpWEVbnzIma+DA/t44nkIr1cNcPuPB7yxIi
         Mv9aZliMosv809lWr57ESaXzbT+HWmdYNn/rioaKIvuQHiZ1sic0Nq4nzUakB8xNGQaV
         QM7Q==
X-Gm-Message-State: AOAM532yrCiddB72RxRGyYxHoK6F28HeNtDac7uKT14v1Lc8Yr+nPmpa
        Z6S37C8z98gotOiLZ2orMDO+p8PVB6o=
X-Google-Smtp-Source: ABdhPJzhySpu/m2B73dgsv/mLGFY0lrdHO6u0NH3yxPi+2ZHQbWdoBqQm/nmR2h1xGQghrPxxRLbRg==
X-Received: by 2002:a17:90a:e00e:: with SMTP id u14mr1331471pjy.51.1598878885656;
        Mon, 31 Aug 2020 06:01:25 -0700 (PDT)
Received: from localhost.localdomain ([122.167.36.194])
        by smtp.gmail.com with ESMTPSA id o2sm7643220pjh.4.2020.08.31.06.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 06:01:24 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com
Subject: [PATCH 4/4] xfsprogs: Add wideextcnt mkfs option
Date:   Mon, 31 Aug 2020 18:31:02 +0530
Message-Id: <20200831130102.507-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200831130102.507-1-chandanrlinux@gmail.com>
References: <20200831130102.507-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Enabling wideextcnt option on mkfs.xfs command line causes the
filesystem inodes to have 47-bit data fork extent counters and 32-bit
attr fork extent counters. This also sets the
XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT incompat flag on the superblock
preventing older kernels from mounting such a filesystem.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 man/man8/mkfs.xfs.8 |  7 +++++++
 mkfs/xfs_mkfs.c     | 23 +++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 9d762a43..80378722 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -522,6 +522,13 @@ space over time such that no free extents are large enough to
 accommodate a chunk of 64 inodes. Without this feature enabled, inode
 allocations can fail with out of space errors under severe fragmented
 free space conditions.
+.TP
+.BI wideextcnt[= value]
+Extend inode data and attr fork extent counters from signed 32-bits and signed
+16-bits to unsigned 47-bits and unsigned 32-bits respectively. If the value is
+omitted, 1 is assumed. Wide extent count feature is disabled by default. This
+feature is only available for filesystems formatted with -m crc=1.
+.TP
 .RE
 .TP
 .BI \-l " log_section_options"
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2e6cd280..ff3e0705 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -71,6 +71,7 @@ enum {
 	I_ATTR,
 	I_PROJID32BIT,
 	I_SPINODES,
+	I_WIDEEXTCNT,
 	I_MAX_OPTS,
 };
 
@@ -383,6 +384,7 @@ static struct opt_params iopts = {
 		[I_ATTR] = "attr",
 		[I_PROJID32BIT] = "projid32bit",
 		[I_SPINODES] = "sparse",
+		[I_WIDEEXTCNT] = "wideextcnt",
 	},
 	.subopt_params = {
 		{ .index = I_ALIGN,
@@ -431,6 +433,12 @@ static struct opt_params iopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = I_WIDEEXTCNT,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		}
 	},
 };
 
@@ -734,6 +742,7 @@ struct sb_feat_args {
 	bool	reflink;		/* XFS_SB_FEAT_RO_COMPAT_REFLINK */
 	bool	nodalign;
 	bool	nortalign;
+	bool	wideextcnt;
 };
 
 struct cli_params {
@@ -1469,6 +1478,9 @@ inode_opts_parser(
 	case I_SPINODES:
 		cli->sb_feat.spinodes = getnum(value, opts, subopt);
 		break;
+	case I_WIDEEXTCNT:
+		cli->sb_feat.wideextcnt = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1972,6 +1984,14 @@ _("reflink not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.reflink = false;
+
+		if (cli->sb_feat.wideextcnt &&
+			cli_opt_set(&iopts, I_WIDEEXTCNT)) {
+			fprintf(stderr,
+_("wideextcnt inodes not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.wideextcnt = false;
 	}
 
 	if ((cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
@@ -2953,6 +2973,8 @@ sb_set_features(
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_SPINODES;
 	}
 
+	if (fp->wideextcnt)
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT;
 }
 
 /*
@@ -3608,6 +3630,7 @@ main(
 			.parent_pointers = false,
 			.nodalign = false,
 			.nortalign = false,
+			.wideextcnt = false,
 		},
 	};
 
-- 
2.28.0

