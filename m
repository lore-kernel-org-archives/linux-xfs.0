Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE04C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 10:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351748AbiFAKqN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 06:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352373AbiFAKqC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 06:46:02 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D6281488;
        Wed,  1 Jun 2022 03:45:57 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r9-20020a1c4409000000b00397345f2c6fso2763148wma.4;
        Wed, 01 Jun 2022 03:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DxI+KP/yP2c1dj72ZEf9XEZoYdpFMxSLMCxGwNL12Ug=;
        b=SSchd4ou2Qrd6oY3fcHH5+g1IFPuS2tvK+hrbnb0JWstRhc6AFH/rL8JMdhvkgLlHC
         ZQnMiyzGdrmz7zxpZycbRjhZEnAlUnJikj921NXo9WhKDeRM0kPeZPqyRt6mhnkAKbsI
         NhofRNZAJ21B7ZW5mb9Ai94DP+J2+9SpDz+IpdJvwY3nB4MzAnlQqeHAOb0wrmKZObkn
         GBtqfOkfPP4tTdFfs1Id/G/8oEw5QO47M4f+k1aXXd9RayTalDf/DDddsRI6HaQXdF2i
         F+DTcjHCU8Z7OBScDLfQe4v/NRF06Q1ZL9KBUJXXmLEqTHUZ+eLMUm4D+/7DzYFdeeSO
         2Fnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DxI+KP/yP2c1dj72ZEf9XEZoYdpFMxSLMCxGwNL12Ug=;
        b=BFIiz/KM1W3luy1/ZGZPwQmlubkBqcbzZfiwhH17tRj8hCuFF89TZhmt7jwKoXMQt+
         rKKqK5TZI0vBq6W5vbRuCXMhU0KzpqtL4bXJ4zze/aqFq+tZcQiiUNuDjawvWct/RckP
         NBvQqigj1m1GMxTgoMRVR2as2pD5A1w6PEldw3OwJDdcstXDp0ZZlM8ZlfXLXiPl0M26
         HcnssYxeHRdgc4EKvC0FSoIkj3cclXRY4aRsHAVTr/y/vy6KsCSip/mS/SdQpG84N6jL
         w1ORKoOBzvBBLPrNJfwG4LSOBy54KiaP440teC6NLqFyjRitlApbcZMGbm51N9AzbYp5
         pI6g==
X-Gm-Message-State: AOAM5327pu9VgwsvIYmGKduWisjAt1dcQdZujNv37mxgTW02y0p7wV8p
        dGBs2jxL82GTUkLvvB505rI=
X-Google-Smtp-Source: ABdhPJzBklGwj5Q+1v+rSCE4Qoyh0XYrgDTRYeslp8/xMqxEL+ImMzqNLyht0DgmF0I/9DJivB4GZw==
X-Received: by 2002:a05:600c:350f:b0:397:7204:ce8e with SMTP id h15-20020a05600c350f00b003977204ce8emr27969597wmq.0.1654080356056;
        Wed, 01 Jun 2022 03:45:56 -0700 (PDT)
Received: from localhost.localdomain ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id h9-20020a5d4309000000b002102af52a2csm1562150wrq.9.2022.06.01.03.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 03:45:55 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org,
        Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
Subject: [PATCH 5.10 CANDIDATE 2/8] xfs: set inode size after creating symlink
Date:   Wed,  1 Jun 2022 13:45:41 +0300
Message-Id: <20220601104547.260949-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220601104547.260949-1-amir73il@gmail.com>
References: <20220601104547.260949-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>

commit 8aa921a95335d0a8c8e2be35a44467e7c91ec3e4 upstream.

When XFS creates a new symlink, it writes its size to disk but not to the
VFS inode. This causes i_size_read() to return 0 for that symlink until
it is re-read from disk, for example when the system is rebooted.

I found this inconsistency while protecting directories with eCryptFS.
The command "stat path/to/symlink/in/ecryptfs" will report "Size: 0" if
the symlink was created after the last reboot on an XFS root.

Call i_size_write() in xfs_symlink()

Signed-off-by: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_symlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8e88a7ca387e..8d3abf06c54f 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -300,6 +300,7 @@ xfs_symlink(
 		}
 		ASSERT(pathlen == 0);
 	}
+	i_size_write(VFS_I(ip), ip->i_d.di_size);
 
 	/*
 	 * Create the directory entry for the symlink.
-- 
2.25.1

