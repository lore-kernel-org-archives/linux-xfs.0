Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C953BC33C9E
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 16:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9592424658
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 16:13:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kWOqEnHo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgANQMg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 11:12:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43402 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728850AbgANQMg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 11:12:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ieFO0VW89Plk/SxbxvjUMyxGKaaWQ3fu6VZZX3+eXfU=; b=kWOqEnHoRjSX1561j4MXD/6Osb
        /OSAUcMlRV+0OWE0r2Z9tu9pFwGdI9kU0cZLSrXGU5IgPFiU6NFRlChhIO7uHCiaP4wNdJTnqu6T9
        Ps6ig31zrnEbY0fXUCQw3qTjXUe1NlpLy17XH2HPoPNpiJUSG0x6d++F+lFe7LfPM6r+8Xv04Gyag
        AbtmbVoAxfu/Ep68NNEmqpcqONUpR8jSGGMIFYT1Py+iCoBpYi14sVJ+dAbBfnXr2oVLhpUAkIL9K
        Aypu60LR6r1u0zQW/bnDAMKp4wozCSqUhg9jx/OHWyPSJHeWsIXS11ws8MzTl5qh3PhQvKaIew/NW
        EU6QFkZg==;
Received: from [2001:4bb8:18c:4f54:fcbb:a92b:61e1:719] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irOnz-00008Y-Fj; Tue, 14 Jan 2020 16:12:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 03/12] xfs: fix IOCB_NOWAIT handling in xfs_file_dio_aio_read
Date:   Tue, 14 Jan 2020 17:12:16 +0100
Message-Id: <20200114161225.309792-4-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114161225.309792-1-hch@lst.de>
References: <20200114161225.309792-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Direct I/O reads can also be used with RWF_NOWAIT & co.  Fix the inode
locking in xfs_file_dio_aio_read to take IOCB_NOWAIT into account.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c93250108952..b8a4a3f29b36 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -187,7 +187,12 @@ xfs_file_dio_aio_read(
 
 	file_accessed(iocb->ki_filp);
 
-	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
+			return -EAGAIN;
+	} else {
+		xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	}
 	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL,
 			is_sync_kiocb(iocb));
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-- 
2.24.1

