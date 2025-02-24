Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343F726136C
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 16:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740416324; cv=none; b=P4GP4JG7C1jrhdp27rm46JQpZWtpOHSv93YLtjIVK9sXEGplrjc1IWZt6PfkQbOVvbwz8b4lcoySpXP8GmcbuYdDP1Fyso75psXNRILmwaquv5kg6hvHlnqIRvxx+C2Z41C6iBKAriTNh+8OTfUTTYFErPYKqqXvF2jA8HQGcN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740416324; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHO0UuHAgLf3QQD8g+B0UD2Xo9ju7wpuXL3DNhVB4KOEg3fLZw2h9hrjeUBlbl2IrzMUL/z7i1egzVxqZe1ZIeUCS7AsWjXpsw20xlTeo4qDrsPw1POsAsfX0Ssa09gvDvkCAqIuW6FYky0wO24tg+GoBlyjuAWY7nvmoymJwpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FCSp0rn8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FCSp0rn8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=FCSp0rn8p8A/I+6//zU5tzRXR5
	nWe4i/XBewERCWlIt6nd+BvI6BwlJUBHi3BPOrlJR7hhHdB52dOCOi+6osCE02h0xNYJYXOhVjK/h
	PtlCsTlVLtm6CmAcL0SZHoBWiTfv3rY32Oxt/tyE46UBCQTZxOfb29BQi2BL6NZpzB/r6m40rHD1h
	IUMAPJDryZZLWHQwKuTDvBoCf3h9aYVaoOFwTz/vuoGdyLDLhjNhA0Pcrhy0lA1sT+OJa0jBYShB0
	ZB+ztB3MgRhw0W2y6iEWNECtuZEiVEGdfDVHGoTBCQk1BNrdCHE+BQd4IyDX/2kKibCvqb9Za2fV/
	WK3yDasA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tmbn0-0000000EWeS-3Wob;
	Mon, 24 Feb 2025 16:58:42 +0000
Date: Mon, 24 Feb 2025 08:58:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1] libfrog: wrap handle construction code
Message-ID: <Z7ylQpqZea0c_IKv@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086121.2738568.17449625667584946105.stgit@frogsfrogsfrogs>
 <20250220213600.GS21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220213600.GS21808@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

