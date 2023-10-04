Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F5DE8FDC2
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Oct 2023 00:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbjJDATx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 20:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjJDATw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 20:19:52 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835309B
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 17:19:49 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1c3d8fb23d9so11834485ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Oct 2023 17:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696378789; x=1696983589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vpuL6NL2kX2lxIlxPO/kA0KyQz/NVfBf3lYMUhGj7Q0=;
        b=1VSFSHQfxpeOzWOL2tTzb/XXaJQHfMkSyBr1H6uyiqmZhG4oTIihClM0Z4Zm22CHXo
         XbU4XrbU/NzYDOsubpBAh80Es2/ak67O4af/IeROy+lHDVjASE8Z+VVfO8g85R13AGGk
         OMF4pzNbs2nhwCcwR1pZTnx5xDeIqT0mXdBfqBtPLMOHUL9v/Wh5sLRz2zrpuz/K/PiH
         ZSm/w9Rci6d2eezjkjsanU+o6my0vcFWpWdELzXCckVuhASgjFWmY6psRogV5qzzNboP
         BGj6W1B0ilNbVAybj3fTOhzo3gF7US3+f2Y+H13wXALLzYeO+TxBlbK1Ic2uVtM66sLS
         bffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696378789; x=1696983589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vpuL6NL2kX2lxIlxPO/kA0KyQz/NVfBf3lYMUhGj7Q0=;
        b=Mf7FI7NDH49EFcwE9XL3KlIdfQqDvX1g41BPkzG0F+/5pQfDOafRmZck6p2r9CpRMz
         DxIbzjdVWcvkF80lKKve55GgswKDZKMbndBCeN4dD4t+X/eMIkaxjbZK/4VdwTiQD2Ad
         S9z3odMY0qgrX4KtSa8kiC4ZpAsQJZ67MZYpIGvfEgn8zvYWneY0Sb74q4qAuwHnwv5c
         YnEO6qBSDuWkV8lZQKMPxLgH7XEsH31KZvt97mk1/4F8oxfha5M3Z4l20S7Jpan/tCe9
         P28MNqzXSaNQG+HLf5v7BkwSeD8cNKEmUipehNWuHRz6uSVhVXA/mRbtcsgpC473ref2
         GD4g==
X-Gm-Message-State: AOJu0Yz9ONNvlXND0sDqfm/Rd2CAFXadS3kFM3XE4ok3UM1n/x/AmCs7
        lPu+8d/eBeHutpTVAU07tKh4xkSorGQHZSkN6hM=
X-Google-Smtp-Source: AGHT+IEmKQCGmAW3Me4KZi7/QkMwRUuW+XLd6ak4PyToIdHguyaGOOPod3kSNjHFhGdWZFC/aDHEtg==
X-Received: by 2002:a17:902:76ca:b0:1c7:7b27:f9a9 with SMTP id j10-20020a17090276ca00b001c77b27f9a9mr895894plt.59.1696378789013;
        Tue, 03 Oct 2023 17:19:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id l17-20020a170902eb1100b001b8062c1db3sm2243186plb.82.2023.10.03.17.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 17:19:48 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qnpc9-0097N7-3B;
        Wed, 04 Oct 2023 11:19:45 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qnpc9-00000001Tr9-37hd;
        Wed, 04 Oct 2023 11:19:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     john.g.garry@oracle.com
Subject: [PATCH 3/9] xfs: select the AG with the largest contiguous space
Date:   Wed,  4 Oct 2023 11:19:37 +1100
Message-Id: <20231004001943.349265-4-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231004001943.349265-1-david@fromorbit.com>
References: <20231004001943.349265-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

If we don't find an AG with sufficient contiguous free space for a
maxlen allocation, make sure we select the AG with the largest
contiguous free space to allocate from.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e64ba7e2d13d..ee1c1415c67a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3233,6 +3233,8 @@ xfs_bmap_btalloc_select_lengths(
 	struct xfs_mount	*mp = args->mp;
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno, startag;
+	xfs_agnumber_t		max_blen_agno;
+	xfs_extlen_t		max_blen = 0;
 	int			error = 0;
 
 	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
@@ -3264,10 +3266,22 @@ xfs_bmap_btalloc_select_lengths(
 			}
 			break;
 		}
+		if (*blen > max_blen) {
+			max_blen = *blen;
+			max_blen_agno = agno;
+		}
 	}
 	if (pag)
 		xfs_perag_rele(pag);
 
+	if (max_blen > *blen) {
+		if (max_blen_agno != startag) {
+			ap->blkno = XFS_AGB_TO_FSB(mp, max_blen_agno, 0);
+			ap->aeof = false;
+		}
+		*blen = max_blen;
+	}
+
 	args->minlen = xfs_bmap_select_minlen(ap, args, *blen);
 	return error;
 }
-- 
2.40.1

