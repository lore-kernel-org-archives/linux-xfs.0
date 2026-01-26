Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C72E3370FA
	for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 13:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769432903; cv=none; b=QG2WfyV79n/8ugAyJACi1qnlF5OG9KS98rLvDr+DkDGLIfEMcc+GHfhdNvEThjiBwA+YpWVTYlhZVZ433KEgFysJ0MAV3y2tYjXHBgENnSpaR/aRx/MhM4GXz2ugYeWo7UUNdZywteQ5ILoSUnEYLz3rYQS8ZuzO/pbcyxiPnVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769432903; c=relaxed/simple;
	bh=OpycpDodkaEVM+v2hvjBWPfwyMwwyA4nAXguuU8uJjU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rv0/rf3f9oLDNXg4tb64GgQx2+vVp+67rSLz/oZrNcSGELIgTD5+iZgcwX1RFP3Sezqs8/VwHstSnfUC+aeNITsCbNecSM7WrX2Jr+uvmVO6u9LIxZh6dtra8SkXke+0q4YcxXFi2eX9+5XU9AhMsGA09y51yacKp+joGqZGcaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T35igtMP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T35igtMP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=KMGfY1Tpp2KAibdxNW1BIxZZIS4dEAIzk8UYs2iUCqY=; b=T35igtMPS2pYAbGLOV4NzXISv7
	6epf4yntCnXZFztGH16ZW8Dg5aOXLH+nhbz+g9UGJKOf91lns5zFAiuOXut7b11Fl5yMYmb9AAnjt
	e+CK39UYelfn7uG3MfruJRC7ucr1LbT5bfzZbrgicM9OKGurLHnIyhP9LX/YAutzmiw55NJUENoJL
	c4uZPvgD3sjqH3gjQoj8ppXHH7tqX62dBCHnZnqYS5z7eVlSWZnYEX2WPNWcFVOE5LBJ3F22WDzW+
	XQZUaYdutKB+NUy5nRUx8aE0ayFMfthFLQyZTGYElMvgOhJnBOh2Z6FRKyN+M156zOy5jtbmMjQAY
	JP9KDzhw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkMKL-0000000Cawu-0dQ9;
	Mon, 26 Jan 2026 13:08:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs/841: fix the fsstress invocation
Date: Mon, 26 Jan 2026 14:08:16 +0100
Message-ID: <20260126130816.11494-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs/841 fails for me with:

+/root/xfstests-dev/tests/xfs/841: line 79: -f: command not found

Looks like the recent edits missed a \ escape.  Fix that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/841 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/841 b/tests/xfs/841
index b4bf538f1526..ee2368d4a746 100755
--- a/tests/xfs/841
+++ b/tests/xfs/841
@@ -64,7 +64,7 @@ _create_proto_dir()
 	rm -rf "$PROTO_DIR"
 	mkdir -p "$PROTO_DIR"
 
-	FSSTRESS_ARGS=`_scale_fsstress_args -d $PROTO_DIR -s 1 -n 2000 -p 2 -z
+	FSSTRESS_ARGS=`_scale_fsstress_args -d $PROTO_DIR -s 1 -n 2000 -p 2 -z \
 		-f creat=15 \
 		-f mkdir=8 \
 		-f write=15 \
-- 
2.47.3

