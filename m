Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B671AD3F0;
	Thu, 20 Jun 2024 12:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718887732; cv=none; b=dPl56KeWrFGCyNtBnjhJqbydDiJrrNS4o3nxCUoTMUvMVgZxCLJ912oX1+7Am2scLtXXhzk3JuUqF+LS3wFrKcSclY6ZkbH5LcyVStwN7dtKkBAPQSwcLNqIBpZTbbcEmG6ATUxsEP/3W3ZuEJhK/rz+JkjFl9XP3Vs/2vtnThs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718887732; c=relaxed/simple;
	bh=Znz1/WticofOJ4kp6T68erovnD49x4LoIDe/CILNMak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l1PDpo9sc/ZBveT4PXALm/lKJ/mjy0i1n7CzqVdNk+rZPWMunUq4lZRVqibhTfUHspE8vpZ16jt9D25Q79RH/p8wdasfY9ZtwVj3V3+mzhE7hN9Tujqeme5XOYFhubD8wDExGDk+elrCtesBnQ0behylWL3p5DJsZ9Y6qxgNIhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yEXhsE0M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yEXhsE0M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=TmzJIS8IzqHs61XSR7pFF8ecgSFjDgMf1Y8mHznNTek=; b=yEXhsE0M/SlUsDBd+YEgQjGNWL
	z/2KWQQUi9thZQsFQXRvw9cNRJEYIhMCsufeZQqp32AAv+BFU3+Sj966hjfi08QgXDCJ4kU10AaAX
	RKAZ/hFs02v0tdE3yWWIdpDw7UET9wWLMZJsZ/g6V4KcN/2Vnryx0tYQadoaW6K3Imq3g7olt5MI1
	Rge5Kwxk8btBqkPVAoo0NLIA8atZm601Ts88plWdMQvgr5yEKrm8v4sVi3F+3hLWrj+RB9nF9ijZr
	/4c6ShQgja8ZgnH+vJPI/8DAJl3qLcZYAPN0j+OLa2ouO5qpeMJ3wCOGDjW4PQyWKPbWIgQvvW07I
	a+ugOWLg==;
Received: from 2a02-8389-2341-5b80-1453-b431-46b2-cdf7.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1453:b431:46b2:cdf7] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKHDc-00000005034-0eog;
	Thu, 20 Jun 2024 12:48:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: djwong@kernel.org,
	zlang@kernel.org
Cc: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] xfs/073: avoid large recurise diff
Date: Thu, 20 Jun 2024 14:48:44 +0200
Message-ID: <20240620124844.558637-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs/073 has been failing for me for a while on most of my test setups
with:

diff: memory exhausted

from the large recursive diff it does.  Replace that with a pipe using
md5sum to reduce the memory usage.

Based on a snipplet from Darrick Wong.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/073 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/073 b/tests/xfs/073
index c7616b9e9..0f96fdb09 100755
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -76,7 +76,8 @@ _verify_copy()
 	fi
 
 	echo comparing new image files to old
-	diff -Naur $source_dir $target_dir
+	(cd $source_dir; find . -type f -print0 | xargs -0 md5sum) | \
+	(cd $target_dir ; md5sum -c --quiet)
 
 	echo comparing new image directories to old
 	find $source_dir | _filter_path $source_dir > $tmp.manifest1
-- 
2.43.0

