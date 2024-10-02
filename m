Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0644926AFF;
	Wed,  2 Oct 2024 05:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727847912; cv=none; b=dJr3eYWUFjwgUqk9EbEjPgKI61wjsWMse5BSsaJ1jJXSK0ZN1rR6r1kdHD2QRvsPAaLtPF4ww2KLAhTlzeFErjvXct5euQ5N5bJIkkd/1ccbrUURwyBPYPcv3J6gya67KCDhqcdFt/luPazhJ9aFSQ2tGaKcxmnDOgbiN6sH/tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727847912; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CKN2ZGomuYOzIBu9W3heH8m4qmLG8oP4+wTNwKjrB3I18WbMBOQOZA6NspxzO0PW6F1CDV2vg2fsfJT7IfHCh/VXkaLyRnnFIuYywEtQbY7gbK0hlQi3qNA989KGRiyqh52mjqvX3CwoLVFgKVZvSKJ5swxvVTdPWERH2JwqP4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ww+q5ULn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ww+q5ULn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Ww+q5ULnUGCXETGj/KtFvvMwoE
	WWXFe5i9/7QLeJVehWsSZ62DQr/f2lg8hDI280XlyQZgbCLPw683JSSbAgSYnK6hyehGAgaMFAzxb
	ScY3guk9XZq57RgUshf6eKQz7rNenRmrRBpacYC6cE6bDRoXp2OJQABD2oem9dTZaBsmBWdFZ2g20
	kYyLeHdQQC1VvtnDYocoS67416vCKRP4GhfXW7BAvAxlgupunjgMUliVoFa6S3iQKUzAbEavGgbR2
	VEpc3dLgdl9zJhMy7s3lkmR/Qve623Zj/9TFCGTZKnPfXImCUX5mJql+UxRrjfbiEIyYCBjVm6AlS
	A3F/2Jkg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svsAg-00000004rXE-1ziy;
	Wed, 02 Oct 2024 05:45:10 +0000
Date: Tue, 1 Oct 2024 22:45:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] src/fiexchange.h: add the start-commit/commit-range
 ioctls
Message-ID: <Zvzd5mhIuLgyKbPV@infradead.org>
References: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>
 <172780126034.3586479.14747488978575659943.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172780126034.3586479.14747488978575659943.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

