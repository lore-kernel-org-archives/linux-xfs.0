Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B228B2AE95;
	Wed, 19 Feb 2025 07:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949201; cv=none; b=TenpamkqlnCnOvYkTC2JyiK07ch7GWgMij/vp/IJnu6KvayWXB8ZQsXxcztDBhaD4W4pjHjobh9Z6iIpYJK7tAhEhPkHNW1kAUbUck7msagyKTYGAM/SlgnrNsnB1yIQlBSrjfuBYY86j9vg/oVBT5dfxiNhHNvY9qcRUJ+mwH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949201; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ehIv3Im+L6pRLZdvQn0PJDUlR/yoG/JXk23/Pb1vH+JYbbm/ef6XaouiNowqMD8YfYgr45n4ni5+HKYFVZKWhgfS111ZnCHlpc3FHsuDTzJu0iFb2jttIA8D2+qX6vN+Jmxob/ohbF9HeTlxsa4VSxU/ZYCjhTxKfCASvIqPp4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bNdKVM4Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bNdKVM4Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bNdKVM4Q94/PCq5t5hGyPcpT66
	/0AqpS2XF8bQnhiPj1Q5CN14p9Q2NoQXXKL3cEgtak3IUUe3GabaVI1i1+TzpF19BbqCASBK2BHiB
	SppnN5+9QsPkqeOBCQ83NlkA1i6Aa0QSOQ/D2CG1thfNzSRCZ9rlvuRjEtmYJrhvjSb4ofitoEBG0
	6B/b8P7IROFVUqtrUTtaxiDrlu29qbFlaLPe4hIb3NMO66m0husravMCvCYVZSkJTiUMWspmj6G4+
	oFfCDbax7d3qxJXTevh0txp1xkSr+TrJh151g5ZjVw56HwTz+Bt30YcJMltVI4NSt629TU3Yj+ui+
	GoYTX79A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeGm-0000000BB6p-0tTz;
	Wed, 19 Feb 2025 07:13:20 +0000
Date: Tue, 18 Feb 2025 23:13:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 03/15] fuzzy: stress data and rt sections of xfs
 filesystems equally
Message-ID: <Z7WEkNsoHoZwblxK@infradead.org>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
 <173992589235.4079457.2842406217553234453.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589235.4079457.2842406217553234453.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

