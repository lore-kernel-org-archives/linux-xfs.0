Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA53DC38147
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjARWpU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjARWpP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:15 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE035F3BA
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v10-20020a17090abb8a00b00229c517a6eeso3992677pjr.5
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+XhOUABUrwg/JfEwItPd+UcaDxpn/yLUV8KJI364MO8=;
        b=5qBLwiYm7I+ze5BHggBhVap0fYmry9CNc758puQ6LwCTMd5PjMQ8wGk6dyljsE/YMo
         qw+J9UH89tJJL96XWq+aLxVevGbvu+4P6YrGAROpytqaFZl2NEaYIwZWDvwkaX84kN0E
         hqyVVT5RUeK4AvMVx+4Oj5fWkqwx8MvYSn0UHEvlmwcYyDsXIq3tMhxIfNN9w417dmeX
         oC8nfGaqHq8DnpsCC6B864YTN3YEELEyVhzIAAEcqNSMJB00juI4EW4Nc94wVYrKwPO5
         RTsO8CTgV1GEh+m/+QxxxCoeMw41bggaPusbmjgvSiAxEDWVdidioY5redqXpgMdCQNM
         dp9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+XhOUABUrwg/JfEwItPd+UcaDxpn/yLUV8KJI364MO8=;
        b=ta8iHIQsw+vSYR/1f/2XqlITCVNpEV52Lbq6wVOE3h5UiTvgOTm9YDnTZLnFkk0EU4
         iStioNBO7pOz/Uetf+qdNwxZVPqB0nHLAtdCe8mHPRw5kw1DnEpnzVroOHZuebQpvesx
         2EbrCpDxlYw3I/5ueZezX9BHSAGtHU/pjHuGm0QdOcaxFYQJxbUn+0r3zNuBKS4vSP5Z
         RPySWGpxZlwT7OP9Ei2B6CLxfB71EeaoWxQCtlx/jmZFLpDGDfB9HQhQXAETVP/xN1e3
         6VHVjKksDt2ApnXwZWj8b+XfGdP7mXfn6CA90Dh3QF+J/LfuKPxib++craWF+Amklenv
         K19Q==
X-Gm-Message-State: AFqh2kpzju26c+P+68HCDPyMNG3M0SBUyDbCuJreBDlsJFFKFLJcIjIK
        Ilm+jP+b3xS2SKp7VLtwXnWp+lVWPBDX62I3
X-Google-Smtp-Source: AMrXdXu7hRXchv1y7xJeb92RD0RJCWrfWXl0tMN6Ul0Gz5scepZ28bRj14ZBjQ+9RKHr13ZuLkWnpA==
X-Received: by 2002:a17:902:7894:b0:189:cf92:6f5c with SMTP id q20-20020a170902789400b00189cf926f5cmr8942348pll.52.1674081913808;
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902650f00b00188f3970d4asm23661258plk.163.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB8-004iWf-RY
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:10 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB8-008FCf-2m
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/42] xfs: prefer free inodes at ENOSPC over chunk allocation
Date:   Thu, 19 Jan 2023 09:44:25 +1100
Message-Id: <20230118224505.1964941-3-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When an XFS filesystem has free inodes in chunks already allocated
on disk, it will still allocate new inode chunks if the target AG
has no free inodes in it. Normally, this is a good idea as it
preserves locality of all the inodes in a given directory.

However, at ENOSPC this can lead to using the last few remaining
free filesystem blocks to allocate a new chunk when there are many,
many free inodes that could be allocated without consuming free
space. This results in speeding up the consumption of the last few
blocks and inode create operations then returning ENOSPC when there
free inodes available because we don't have enough block left in the
filesystem for directory creation reservations to proceed.

Hence when we are near ENOSPC, we should be attempting to preserve
the remaining blocks for directory block allocation rather than
using them for unnecessary inode chunk creation.

This particular behaviour is exposed by xfs/294, when it drives to
ENOSPC on empty file creation whilst there are still thousands of
free inodes available for allocation in other AGs in the filesystem.

Hence, when we are within 1% of ENOSPC, change the inode allocation
behaviour to prefer to use existing free inodes over allocating new
inode chunks, even though it results is poorer locality of the data
set. It is more important for the allocations to be space efficient
near ENOSPC than to have optimal locality for performance, so lets
modify the inode AG selection code to reflect that fact.

This allows generic/294 to not only pass with this allocator rework
patchset, but to increase the number of post-ENOSPC empty inode
allocations to from ~600 to ~9080 before we hit ENOSPC on the
directory create transaction reservation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 5118dedf9267..e8068422aa21 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1737,6 +1737,7 @@ xfs_dialloc(
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	bool			ok_alloc = true;
+	bool			low_space = false;
 	int			flags;
 	xfs_ino_t		ino;
 
@@ -1767,6 +1768,20 @@ xfs_dialloc(
 		ok_alloc = false;
 	}
 
+	/*
+	 * If we are near to ENOSPC, we want to prefer allocation from AGs that
+	 * have free inodes in them rather than use up free space allocating new
+	 * inode chunks. Hence we turn off allocation for the first non-blocking
+	 * pass through the AGs if we are near ENOSPC to consume free inodes
+	 * that we can immediately allocate, but then we allow allocation on the
+	 * second pass if we fail to find an AG with free inodes in it.
+	 */
+	if (percpu_counter_read_positive(&mp->m_fdblocks) <
+			mp->m_low_space[XFS_LOWSP_1_PCNT]) {
+		ok_alloc = false;
+		low_space = true;
+	}
+
 	/*
 	 * Loop until we find an allocation group that either has free inodes
 	 * or in which we can allocate some inodes.  Iterate through the
@@ -1795,6 +1810,8 @@ xfs_dialloc(
 				break;
 			}
 			flags = 0;
+			if (low_space)
+				ok_alloc = true;
 		}
 		xfs_perag_put(pag);
 	}
-- 
2.39.0

