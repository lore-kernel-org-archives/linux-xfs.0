Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A4C285CA4;
	Wed, 17 Jun 2026 06:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781677397; cv=none; b=YP5Ff7shC8E/lYKHbtMKJDyhBqgragcenVpvgmvr2yxTuaGXMOpaRkw2xJyGRKUqHM+Yw/4HbnXtU1inBXXtoyQvsbaUT6BMn43Y5sAt9RJhRBtonROWFnUDmbo/C8U9MuypijbaQZsOD7QNS9vnzXmndwwdFsuPdYiULBIeZJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781677397; c=relaxed/simple;
	bh=7NFQKnCqpbuwan2qzFfYl39dgkStsQWtDKR/V3CwZdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQk741L2AQlNyEC+e5Yb37MelpIbDvIt3AOm94TWZE98W/nClYCAZZHAT+h6alrwAIODEmiFPa7p3CAuTDMekNacnRGHtinlKXyj8iIjUJZVuXYPad60ioOJJcOi54aDEjAHD1hymrF/U2BgMvP8FfOAVgbWWXx5bY6t6KFnyHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wqllVTWX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wqllVTWX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BnEuuzP5RqDLfKWI0l85dae8itMYoWREp75IPtBWSdo=; b=wqllVTWX3s2nkyI5X4MsPNlA9J
	UX3fEQbQYHHGeEuEwSGfPwPXmElrH2NaaNjNFdqW20QABHeFo+SYIQtxMN4jxCRIyZbEm/VKvy9mO
	GpftHX17OkEmf4qlwSOesbk4UCnTTYzXwSsMTcFNbZ+ApeShAmpMo+WUsAGsQ0YmEB9RFMxSrBcuZ
	QuDnENPb/yw0P9nLSI1YI6oCK6vNFUGHZVb+kcH5IXlPVYsdUo/pPjv9w+C85esCGSmoimU2g8Fbk
	rBXVby4uD6RASKqG3hGVrKAMEN3t87M8jljS0HVcHadJmN+WZdK3bziuSmPX7hJcDMnBVUJOfofDr
	0/b8RWbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZjgB-0000000Ghxo-2Blf;
	Wed, 17 Jun 2026 06:23:15 +0000
Date: Tue, 16 Jun 2026 23:23:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Eric Sandeen <sandeen@sandeen.net>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: mkfs.xfs "concurrency" change concerns
Message-ID: <ajI9U04nCpf3u3l9@infradead.org>
References: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
 <ajAJ6lXJWcko4epj@infradead.org>
 <20260615154048.GW6095@frogsfrogsfrogs>
 <ajDeAYs79j4enacm@infradead.org>
 <ajH4WwBqd_uyqQNj@shinmob>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajH4WwBqd_uyqQNj@shinmob>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 17, 2026 at 10:43:10AM +0900, Shin'ichiro Kawasaki wrote:
> Just FYI, here's my command line logs. nullb0 and nullb1 are 8GiB memory backed
> null_blk devices. I also tried each of "-d concurrency=0", "-l concurrency=0"
> and "-r concurrency=0" seperately, and observed the same failures. I used the
> kernel at xfs/for-next on Jun/12 and fstests tag v2026.05.17. The fstests
> alraday has the commit by Lukas ffc8bad17e5b ("xfs/21{6,7} Use default -l
> concurrency=0 on mkfs.xfs that supports it").

Both xfs/078 and xfs/216 don't actually use MKFS_OPTIONS :(

Can you try the quick hack patch below:

diff --git a/tests/xfs/078 b/tests/xfs/078
index 6057aeea1..c477f6cfb 100755
--- a/tests/xfs/078
+++ b/tests/xfs/078
@@ -57,7 +57,7 @@ _grow_loop()
 	$XFS_IO_PROG -f -c "truncate $original" $LOOP_IMG
 	loop_dev=`_create_loop_device $LOOP_IMG $bsize`
 
-	dparam=""
+	dparam="-d concurrency=0 -l concurrency=0 -r concurrency=0"
 	if [ -n "$agsize" ]; then
 		dparam="-d agsize=$agsize"
 	fi
diff --git a/tests/xfs/216 b/tests/xfs/216
index 1749647c1..ded3d30af 100755
--- a/tests/xfs/216
+++ b/tests/xfs/216
@@ -22,11 +22,7 @@ _cleanup()
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
-if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
-	loop_mkfs_opts="-l concurrency=0"
-else
-	loop_mkfs_opts=""
-fi
+loop_mkfs_opts="-d concurrency=0 -l concurrency=0 -r concurrency=0"
 _scratch_mount
 
 _require_loop
