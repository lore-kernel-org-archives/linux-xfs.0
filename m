Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B8F19F40A;
	Fri, 17 Oct 2025 04:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760675062; cv=none; b=gt9NpIFroHjKzLVjCM2UYUEaABcSiTure9SpT47W/G6JtLrMbaHr0pGsRc0rJVQ3sSS4YDIAgYZKvps1SI5FR0CyhHtIwCScX7D4YCI7+Ce70bsXAyAFAV4A674KIlwCiscxtcXlNIXtRlxojsbfOKc/75pvVnSp65xRhgfPbyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760675062; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cexIIwXdLt1iJvILQ5teWPNV0JAniksMtkVejsd/PMxiYecybWf3FCy5aIr0KNLzOr1Eft4b9Jx/VA7l3DJe/DzqM2fER2Ek71fhPhXQqiEnH9X0Un6ik0dALpCaQGej9fSv3cwdV9hM4HgOfd+Y7uX2M4QxxVVghQ49xkZRtxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kCqEjgRf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kCqEjgRf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=kCqEjgRf5aG2viT6+z5RxinoYW
	esAfcVrJmDP8fL4+d82QiwfKsC4mg3j+LwbqMFJXAVzqX6G1etYKOJSBAwUi4upb1+xNXl6MeZJUg
	ip5+jT+xR4QCIziq9Prj6pq4LB71Pewhv5zOEu4u2iR2oibMTudNc0KNNJj6QKIq29P/iZdhJg4YW
	jy3CDPvCJCDMWtLD3RAU9TXBKsA0LYI8y+lm6QaZn6i+2NcYV4xfvUJinR36C+hBTwQc5ytpksPIn
	92n7vn2w5+mcULt1jI0a2BkaSVVOtLvZfbNgvIEeI8LJg96y9dkuH3xAmI0PyuLTlFtOAjfeq5xoy
	HeCmN+kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9c0q-00000006WOn-1Hq2;
	Fri, 17 Oct 2025 04:24:20 +0000
Date: Thu, 16 Oct 2025 21:24:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] common: fix _require_xfs_io_command pwrite -A for
 various blocksizes
Message-ID: <aPHE9LDnuHXTcCbj@infradead.org>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054618045.2391029.13403718073912452422.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176054618045.2391029.13403718073912452422.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

