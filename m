Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C50F7C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 10:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350199AbiFAKqZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 06:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352392AbiFAKqM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 06:46:12 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE35082176;
        Wed,  1 Jun 2022 03:46:03 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id p10so1748211wrg.12;
        Wed, 01 Jun 2022 03:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SzyQsb1o4fSk85fpWvWY8/HRYw+PK4Y1RJ618LPBXOE=;
        b=RzG769fdg8raTun+uF0tVEDrp4nAp9ExnsLgDPRhpX3iU7p/C9+JgxA1g8MCuh9U+L
         CXS6+olCuALo70i+7qGPNvc+K6ZGk76vuAFkjGTvf32Gs3LnwCfrQBJqT5SfW9jKuky7
         ISkcSC8Ic2nPg1CbAscD0EP7q5FT1ZQCO5c8Woxzy4vgRGO3eKmSzervHYFyciNMQ4nw
         GfXNwfAKJaNz9b/+MHxaiSfy5M+q7/6Zh5xPE0/hSnBGP9NQMFBR3dabqSZ7X0bEbrMH
         0CZo7PqYRnofU8yzAb8YRP0DRpTsl7EAog7dnl/jvYwnCfq3SBfBsd5lCI+xEOCkI1cA
         x0Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SzyQsb1o4fSk85fpWvWY8/HRYw+PK4Y1RJ618LPBXOE=;
        b=z7S548PmR7oEc7V9qx3SUhRyFmlbtjYEj7yw3HsDnjtcjMn0YzHwQdoD/yOJi29gOz
         UPIPV13xLRTng2jD2HGIViwX8T+MPSJE7/Hqh5sSEDwp58fMOrNRQhOlwVPh8JGDUPK9
         w6DYKU7G06TXlGb+2ubscmB87oqvbfH7e/GK5Hrwbv5wkzTAvAP3zu/zeUPHR4GmLqRu
         Xp7r+PxWXsGrZYv1IuNrA717ymySLJu9j4Uc8QJi+EZ47TpREkhvQW4r3mhN0pvbEdXJ
         GzID0HRPekl8GIlKKS1Ow+ShqY7BTxtfPML4XXX8OdXXcra7m3FMElWnvyTAnLGk3Ear
         JMvw==
X-Gm-Message-State: AOAM532tHTvqoXxLMly94pWAY4xLEkObGDpFncn8sfgZc3k/i5ge7FZ9
        TM5dwuuGQnpROTqZjKfh8vk=
X-Google-Smtp-Source: ABdhPJxVktF5m5x2CT3UBq6WKXUJf5O+5QpGyqL5yUSHWy4+CxHwFz+Sdti5Fq6ndYZgz62W28uSQg==
X-Received: by 2002:a5d:6b45:0:b0:210:514:579e with SMTP id x5-20020a5d6b45000000b002100514579emr27514375wrw.400.1654080362542;
        Wed, 01 Jun 2022 03:46:02 -0700 (PDT)
Received: from localhost.localdomain ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id h9-20020a5d4309000000b002102af52a2csm1562150wrq.9.2022.06.01.03.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 03:46:02 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 6/8] xfs: restore shutdown check in mapped write fault path
Date:   Wed,  1 Jun 2022 13:45:45 +0300
Message-Id: <20220601104547.260949-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220601104547.260949-1-amir73il@gmail.com>
References: <20220601104547.260949-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit e4826691cc7e5458bcb659935d0092bcf3f08c20 upstream.

XFS triggers an iomap warning in the write fault path due to a
!PageUptodate() page if a write fault happens to occur on a page
that recently failed writeback. The iomap writeback error handling
code can clear the Uptodate flag if no portion of the page is
submitted for I/O. This is reproduced by fstest generic/019, which
combines various forms of I/O with simulated disk failures that
inevitably lead to filesystem shutdown (which then unconditionally
fails page writeback).

This is a regression introduced by commit f150b4234397 ("xfs: split
the iomap ops for buffered vs direct writes") due to the removal of
a shutdown check and explicit error return in the ->iomap_begin()
path used by the write fault path. The explicit error return
historically translated to a SIGBUS, but now carries on with iomap
processing where it complains about the unexpected state. Restore
the shutdown check to xfs_buffered_write_iomap_begin() to restore
historical behavior.

Fixes: f150b4234397 ("xfs: split the iomap ops for buffered vs direct writes")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_iomap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7b9ff824e82d..74bc2beadc23 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -870,6 +870,9 @@ xfs_buffered_write_iomap_begin(
 	int			allocfork = XFS_DATA_FORK;
 	int			error = 0;
 
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
 	/* we can't use delayed allocations when using extent size hints */
 	if (xfs_get_extsz_hint(ip))
 		return xfs_direct_write_iomap_begin(inode, offset, count,
-- 
2.25.1

