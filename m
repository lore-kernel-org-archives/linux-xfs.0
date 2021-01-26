Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C38C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 18:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF31D21D93
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 18:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbhAZRYo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 12:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732531AbhAZGeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 01:34:22 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FC3C061786
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:03 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id m6so9909118pfm.6
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aAqSALjqWE3ykqwfd0UK8ah/z6jePHmqLjd54hyL/CE=;
        b=Waq/InOCWrAMRVMDPgWXSJTHY53SXMjSI1cR2SGNIWXGceqXEIic1XG4CjUZmkpbCW
         Rs5OD1ZjqIUlk4pPyGt3PgbzmgbuuBmP/RVRDpZVjQE9m1pX+MOCd7EZ4dRfJKv5dhpf
         IGCxrM9M5K3Z2DcRq4c9rJ0mxky1WtB/C3aOb2/RlJ/UU2EkQ67HvG9OHdNxfNjUxNLa
         Iuu1rIq2A+qhzGD5ykIku0YpRZkSROhU00SMq6tJ07yWnnnkkbZnXypRbvMgnZkbKm94
         sD5OTt0WmwY7mOTyjhUZL/fW1BlQnDyNSs3QJ3B+AsVqWV8G49VN9lcI0RUuYAwAtmeT
         vLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aAqSALjqWE3ykqwfd0UK8ah/z6jePHmqLjd54hyL/CE=;
        b=odtYpjz1OLd87ERYh62bBCkQDJCZ+02aCcwIFLOEKJlbcPVzG9RVwIQMLUFYZTnHnf
         01F8rEAxDSjdxfuMepVKkPCikihg2c4dxMbbwTjIyvmbqt5szLGNsrmLUJrF0pe2m0nL
         rZjczNTfSMnTHNDQo1AzqEdFq1IsKAQbXfEPivLOFUAunRPO525aS0r+oiBUUvRsS4Vd
         wZUGnvmwG6UtsUpDW3hj5wa7s0i/fudyq6Z6Z0O8gJ/1S6jVUzdf5ZLCCEMkkoyoRHdF
         PAFDnSNmAsWyUzUGN0vZDmVKn+JAqnJBd4S6RMCRBsnNvyLMlYIzNe/c9o1m25MK4zhw
         C2sg==
X-Gm-Message-State: AOAM530WZr+n+dCDtRd/bbo/o19mCIb7iTzHFM5HDPaQjN7IZ1QOhU4Y
        u2hL23TDo7YD8Y1XDviriLnyEGqkXqk=
X-Google-Smtp-Source: ABdhPJzvP5Yhw5bDaek2ibVdMiI9zkRI8pUmZn9a5CdXhPqgozB21YRCHERPY/J9XP9facqgtXV+Pw==
X-Received: by 2002:a63:1c42:: with SMTP id c2mr4435787pgm.304.1611642783098;
        Mon, 25 Jan 2021 22:33:03 -0800 (PST)
Received: from localhost.localdomain ([122.167.33.191])
        by smtp.gmail.com with ESMTPSA id w21sm17296578pff.220.2021.01.25.22.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 22:33:02 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org,
        hch@lst.de, allison.henderson@oracle.com,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH V15 05/16] xfs: Check for extent overflow when removing dir entries
Date:   Tue, 26 Jan 2021 12:02:21 +0530
Message-Id: <20210126063232.3648053-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126063232.3648053-1-chandanrlinux@gmail.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Directory entry removal must always succeed; Hence XFS does the
following during low disk space scenario:
1. Data/Free blocks linger until a future remove operation.
2. Dabtree blocks would be swapped with the last block in the leaf space
   and then the new last block will be unmapped.

This facility is reused during low inode extent count scenario i.e. this
commit causes xfs_bmap_del_extent_real() to return -ENOSPC error code so
that the above mentioned behaviour is exercised causing no change to the
directory's extent count.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 32aeacf6f055..6c8f17a0e247 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5151,6 +5151,24 @@ xfs_bmap_del_extent_real(
 		/*
 		 * Deleting the middle of the extent.
 		 */
+
+		/*
+		 * For directories, -ENOSPC is returned since a directory entry
+		 * remove operation must not fail due to low extent count
+		 * availability. -ENOSPC will be handled by higher layers of XFS
+		 * by letting the corresponding empty Data/Free blocks to linger
+		 * until a future remove operation. Dabtree blocks would be
+		 * swapped with the last block in the leaf space and then the
+		 * new last block will be unmapped.
+		 */
+		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
+		if (error) {
+			ASSERT(S_ISDIR(VFS_I(ip)->i_mode) &&
+				whichfork == XFS_DATA_FORK);
+			error = -ENOSPC;
+			goto done;
+		}
+
 		old = got;
 
 		got.br_blockcount = del->br_startoff - got.br_startoff;
-- 
2.29.2

