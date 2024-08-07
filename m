Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DD426AFC;
	Wed,  7 Aug 2024 14:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723041322; cv=none; b=MUKkkcKTrcF4KXaqHMU/DNKJMb99nx72kKSaPsC8noLMBzJQ+Or4tYEEWiyStd91+MrKnYjYJBCzDBezo3X3a8D4h+RwNCzE7fjyPJ5Mh3HZ8J9DoM/SBPwDTJvHWnbEP/aQrCSTJYM8TBYlUE40Fe2eus7ckMkDfB2kTYFNDtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723041322; c=relaxed/simple;
	bh=/dIVNpGKtGXtga7buwSR5dtv7Dlm2vM1zFIJkXMK3Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQAZcOAKmMYo70xjXb6TGzfqDrmn1tD2sprqs0F+3u8tki/f/LVW4824+g+Li94yL6ozFHoARgasATpueRzKmdoaTl+wm58RAkjhQdZx7W16rlWHpcQJC89lN9OBnRAuUACfb5wAt8hCk5I+5ZbDXYnWEkHpGqBercMABYooph8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rqQW3mKV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rqQW3mKV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=m/8uei2TCXym9/wia0WZ+2kHr9lpaGpdOLT6NqnMXtM=; b=rqQW3mKVMsfBTHZTsGxACFX8t2
	TB5noeQa7SzqADZ4fBiLeW+7q1R9D8FqI6EMIsHfrU5EiIB9UP20h/j2kw3f5d74VCf1tqzLsLVEG
	g3wUzKcDrw36NwT0omnnveqMpcFZ2t21uPihtcbgu8BF6GI6nrRw/OuvxNbfFh4yIlbVq5RJy6L3h
	376p7+/qM8j4h0EaWpv9GIheICXKEfbgIagcQg18JIXr3IqiZsBPabwxxR4zDr1CTerld/RPAjJ3H
	AzyfUfa7SDOKsk1XOueTwkN8lSZjzKmaEqhE+qT8AUcJ17ChCClGNedvPX321OL4t667c9AAoauLl
	KCodrRPg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sbhl1-00000005M0M-2dAv;
	Wed, 07 Aug 2024 14:35:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] common: _notrun if _scratch_mkfs_sized failed
Date: Wed,  7 Aug 2024 07:35:07 -0700
Message-ID: <20240807143519.2900711-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240807143519.2900711-1-hch@lst.de>
References: <20240807143519.2900711-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

If we fail to create a file system of a specific size that means it can't
work with some of the options in $MKFS_OPTIONS like the log size.  Don't
fail the test case for that, but instead _norun it and display the options
that caused it to fail.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index afc33bbc2..93d366338 100644
--- a/common/rc
+++ b/common/rc
@@ -1168,7 +1168,7 @@ _try_scratch_mkfs_sized()
 
 _scratch_mkfs_sized()
 {
-	_try_scratch_mkfs_sized $* || _fail "_scratch_mkfs_sized failed with ($*)"
+	_try_scratch_mkfs_sized $* || _notrun "_scratch_mkfs_sized failed with ($*)"
 }
 
 # Emulate an N-data-disk stripe w/ various stripe units
-- 
2.43.0

