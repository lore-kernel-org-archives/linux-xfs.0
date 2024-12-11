Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7291EC4D9
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907502; cv=none; b=hTPnEJYyLMIy/1mg1SV6j13TJuPLSc2Uq4Lf1BAYhiHzX4hA69VbkehIN+Oq9v7j6Y2E54TNgBBh7J8Er7507DbIi/jRFx7MG2J5vkKZ691txmH68YbSHErPEzKvquDaESiP6zkXrgMUoBT4iopTKECvy7Mj9QoxEi2BvHLw5y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907502; c=relaxed/simple;
	bh=FvddXUtHQgRUJjh8pInZ94IoSCakxtDkWJ4YCoopjcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWEWbiwEhVo2Y9d8krhRSqH5eiBXs8g+CIm9VctURf/zTvvrbq+GPUYNDBDc3oP/tEp2Z2v24gKx2ounoWP31ukhZwC8NkSqjtICyiVmYeqSQrcSCRWycdpLUoafPRzlm05SQg8DUX/zSNJwM2p4DlwT39oNgt8HeLqUFAme33E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IQtLm+rK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IQtLm+rK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yi5lVA9lBBZ99VvU4n8+Y04KKLGwSePu1XbXypOF6nk=; b=IQtLm+rKpJZso+UEckrZuz+Whf
	u1TRjnDjHnCTLWUp1HIB82A41gMXYzOPUTl+0nxBw8bsj30Ai8jxyTg2EfG1zswouiR4/f6ErEBVh
	KdaKnwbbk46ljLuw8647s0vBPvhOiX3djuuLmVdMsJ/0DKLMyuqyXTM7Z/pDaeVg7Y/g50ubL1E2P
	VOfIw1uPP5B/iIdJX6Z5j0Fy8shMQU+ICFfSt/KrKhGnha44Jzm3Cas9R7TQ7lmxGZD88mxIHmyZa
	d0+8PZmPPFwFEnbd3I9TOe+oPONvhd9ZrF9NmzWXRypSXAowBD2zuTlMYRqjr7S94KHy04Z+ANTwA
	eEGwDlqg==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIY0-0000000EJTk-3jxv;
	Wed, 11 Dec 2024 08:58:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 36/43] xfs: disable reflink for zoned file systems
Date: Wed, 11 Dec 2024 09:55:01 +0100
Message-ID: <20241211085636.1380516-37-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

While the zoned on-disk format supports reflinks, the GC code currently
always unshares reflinks when moving blocks to new zones, thus making the
feature unusuable.  Disable reflinks until the GC code is refcount aware.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 59998aac7ed7..690bb068a23a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1818,6 +1818,13 @@ xfs_fs_fill_super(
 			goto out_filestream_unmount;
 		}
 
+		if (xfs_has_zoned(mp)) {
+			xfs_alert(mp,
+	"reflink not compatible with zoned RT device!");
+			error = -EINVAL;
+			goto out_filestream_unmount;
+		}
+
 		/*
 		 * always-cow mode is not supported on filesystems with rt
 		 * extent sizes larger than a single block because we'd have
-- 
2.45.2

