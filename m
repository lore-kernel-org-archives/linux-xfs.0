Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639C61DE4F1;
	Wed,  7 May 2025 05:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746594777; cv=none; b=fMWIHtNFWM3Dm9oI6QqoFEVWU3GQygYy812O5tA/OXQxXHtVN012RQXTIQng+rCieBtCCTSkjpOr6myYZs/ReUEEfJnj7zF2ZEv7IVOgBzjN0pCrm7PjXFMSO+iFBN2R378fdOysMTjB+VkQKmLPZSf84PlmfbkvjUVN5NvKhfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746594777; c=relaxed/simple;
	bh=xWnA9m0mTTud3F0cQ1k+eUtS1SkTrlDRfRYWqLNyHIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAyOtbWtqnn9CPuIVA/j06jzq2EgZeFELmhf3w5jMjbKQ71iZzmNJk+EexMcG7UWhR2s8eJ9r+AZiKe1GSjO/2DUg/sreI+VqEsDXvuEIVzGI4NUB2hRlEWj1suCEdfOUtmHAn/1hG24xBFUkPqhwr0AMY8EG6SeL/gbkejwy4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qD7tEUPW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qD7tEUPW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BZIRrMcMFWzllOUsLcdrth7tHSfP3TOR3YLPdX1NtU4=; b=qD7tEUPWBMVvh53hHcUbHWZwe2
	bNyCFUF4PnIq0IP8qi6ikyLfwjSxevKMTs2IfYq1bL+jpXX+1pR90IQmFVA1tEtNFT6OYONpiMcim
	UUs0qmeC85T6+A6QsrSH+Nk6VbclOZNatBkuA8tOAZF5P3CR71fE7y81RYA5mbHwycsyVKHJ6/xdz
	z8VZowkeF3qPF6atp8sv9Ti40xK0k+OV31CfhMXtuLBbTaIDorMTTXjvTEOLWNwt5I5TZgXo8pO3b
	w1/i9vOxf1Mo/+zW9Jdiujkob+L8pKNjjIGhnFM0wBcKSwSFKYSFUqPAi9tb3pIu4gg+TbnFNU5ce
	QA5o4niQ==;
Received: from 2a02-8389-2341-5b80-3ba7-83fe-7065-4f0b.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3ba7:83fe:7065:4f0b] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCX5S-0000000EEoq-1xct;
	Wed, 07 May 2025 05:12:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/15] common: add a _filter_rgno helper
Date: Wed,  7 May 2025 07:12:21 +0200
Message-ID: <20250507051249.3898395-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507051249.3898395-1-hch@lst.de>
References: <20250507051249.3898395-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Based on the existing _filter_agno helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/common/xfs b/common/xfs
index 39650bac6c23..98f50e6dc04b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2274,3 +2274,13 @@ _scratch_find_rt_metadir_entry() {
 
 	return 1
 }
+
+# extract the realtime grou number from xfs_bmap output
+_filter_rgno()
+{
+	# the rg number is in column 4 of xfs_bmap output
+	perl -ne '
+		$rg = (split /\s+/)[4] ;
+		if ($rg =~ /\d+/) {print "$rg "} ;
+	'
+}
-- 
2.47.2

