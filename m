Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A39233123
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738904883; cv=none; b=DEPzeWGuUKRiiiawTluksswTpumBfXniYojJq6T5i4K5f3wkhoHG7rDoBBvg216WPf6dwyJXVeEtIyY9UNVIw3MyoIrJbiTpocYOc6oIRIxMXYwtulzHS642PVOp3L6IdMvdwqZ721kl97E1JO4KXk+rS6lMu1hbui6rN7BlLY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738904883; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZMAnPO9h8eCHPHyEX99OuVIflYDDXHKhkryFR7JRnL7LLSLfejZUX2KwWDoRclZI7MAsu/Dh6eBsgh02Elv37YrlY9nSDdCxoWE5F3NVxBQNO/NlVhuXLbKl1OylyjX5hlKVFlBbBpkO7JWvcP6VrfQ+ITW6zuaiBv0aw7N1EHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bnD2F1Pa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bnD2F1Pa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=bnD2F1Pa3Qwh4iw9DlJeGN+udc
	HBdqBv3LjqQGyEcH65+Ipz2Uta6OytkZlAXw1ElsE3fR1KpCaanaW/25gTOnCC6Qh+4N6BnPCkO/L
	H9jYKLeULznxJX8o9YNufFvIl6hAmISi2wq4pk04wVC4AMeRD4sMpiEbUtIQfrlEcbjFTQDO5B9WX
	vmBMmUZiY7lX2L5iWwqd/Rfz2W27CeSHmVrbD7wpNdW+hFXZh2aWvCYX+M1Hs0QSfHKExLvW0Xn10
	O2qA1VQE8//CmnWe6tnQ8nNyLaHJMZpoGwVUWMJIvnrQQKOWQG/4HXXcYgd9Rt3EbefTpPXN8shxr
	eotkIxMw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGav-00000008LQe-1D6p;
	Fri, 07 Feb 2025 05:08:01 +0000
Date: Thu, 6 Feb 2025 21:08:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/27] libxfs: add a realtime flag to the rmap update log
 redo items
Message-ID: <Z6WVMQk1Jy6l6uU8@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088127.2741033.14339847563200590694.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088127.2741033.14339847563200590694.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

