Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BE8EBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944778; cv=none; b=p+13KaHL4mxzWCRKEYYZ6Qq7R+F6GCEnhgV/NJ/i1DPqOxCulwgeEe6n9Bj/VMKBK8n2Me1IYNT0fZiuOQwXdOUqsqHfwQr+GHZkBtAp1HGS8f6fkY31bS+sTlEtl/s8HXxEdPaBZsfx5KEisfyAe5DyKMOwK5ydyJsPDG7DdoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944778; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kuVucMd6GjSsptfd1nodwT+No50J2KTHJusW7hhiezUbuuW8sEEVEB4Nr6O5YqZK9p6ByMqRxBVIj/8k6AVeZllqWTeiOKUFGsqjpzNx/yrEERYdXFpwf/THMBMW5+K8nCQYkWe4029RMAI+q9ImDAjC25igUlrwVSdKCIxOF2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2HXBdc5K; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2HXBdc5K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2HXBdc5KJxMkCQK2LpdKm7IwTy
	3wn98q/Zxc6CgoMPMbs8Is+f1bcRGZBGAl8w44GyOdcSKxMB92AbxwOfAk0C3vTdq7vrxbIiPgxQX
	98nSOhkLWYOCP4hJmZTC9+iKYD9JiHwXfHjMbIjK4fDz4NkI6hTKeHSM1fiiiSakEb8sDM8SwbvTm
	1HjFfqj5Wn5kAECLeObvjIaDdERm/iDSci/zCCA/2HANbW5lIFU7QSf+TY47l6TNshyrRFphbU/MI
	8ONtWB28pD2+QzAxNCd4HR8PZIoSjZEXdMaPNY3Z5dB5QELLSfohljzzSQd6MdOFRQau7brcMEgpN
	Xa8PmLRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW3k-00000007fT3-3INe;
	Fri, 21 Jun 2024 04:39:36 +0000
Date: Thu, 20 Jun 2024 21:39:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/24] xfs: implement atime updates in xfs_trans_ichgtime
Message-ID: <ZnUECJGrdi77g_u_@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418016.3183075.9987831252721662701.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418016.3183075.9987831252721662701.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

