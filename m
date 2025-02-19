Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1F41BCA19;
	Wed, 19 Feb 2025 07:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739950034; cv=none; b=kMZoR5ljUevr8AExnmWAJQ83yAzzRZiJmyLxWfdDlZL3C4OEQPBHeXi89scINq3j+mFjtG4ZRqMYU0LwFsMDMR++kKV4j6BoBkItw9ye+6mgVITmHJF9bgug+OwRXEyog7srjFD4PjJcLQkpOhxEX0X12mnR95mh2hhR8xzMlCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739950034; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OFrC3NBqalaEdkr3mHlkQmNm8UblXid7aZ+IeYLi5/FpQ8jXRoyBke33UdSUXSlbGMhvlfT0FBDGgxTv/Xxtif+vgEtQzV8goF7wj1TKviagqP0G3v6U9vFFX4FJsd4oA7ylMiZeLGCGQ8zCk6NmVFVgrklzX0S3+NpoOzRTPRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rrohmCAg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rrohmCAg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rrohmCAgV3ooGNIbQNeeL3qRAR
	0D1BZsXJ5lCU/KRJelxCnRl1mFFDT/YUOruy6a0fEf3jFb7g8qLozd9gz0s9UWwNKXKqG3YAgcFPw
	oURzRQSd1pPYGLljFF2Uvsccjk25zS3DLKvx7ybNhlIwU6UxwKb1rXhs7BC6gO/My63wC1/vc8WtC
	wS8ZAXOeE9+3pQ9ExtN29nGMk+9aY9jH9N1TPPWCcfqCIrz3HrQq98Zq7uupDLEy7LybGY2tsm346
	mlNBvGzjCxvRk1JoNuFJGbIx6T7hhqvqjTJMD+mfeRuDfEYaBe3P6MmN/FgmLMbA8+TYdaLms7Q/d
	8KZ6HETw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeUB-0000000BEot-3Y8w;
	Wed, 19 Feb 2025 07:27:11 +0000
Date: Tue, 18 Feb 2025 23:27:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 05/13] xfs: fix various problems with fsmap detecting the
 data device
Message-ID: <Z7WHz7TEdOw_bVMG@infradead.org>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
 <173992591205.4080556.345335448207805708.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591205.4080556.345335448207805708.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

