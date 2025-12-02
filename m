Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94CD30147E
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 07:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764661067; cv=none; b=DouHWTDxncf2+SEqV7qDZ3ssd3g3NpvRnTWe9CKh733/SqIA8/QxZGufoDOA/xYILFBDw/vDpCj+W1yhurG4APnKgYx+N9SYXEQ5L2825yD2AGzEz41C22JkY0Zl6h8P/W/2+VrNnpnJteTJdbkPc+Q78Z0XCJJ4kb6FdCX775g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764661067; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GPa7s6D/WxxwnJXBJEKqFM8L/3A/vHX/Sy9GLGKNXRQcjnNRJDPdf1binizIxtkvhkxgXMjWT+xPXgFv8haHK/1f83qWDvbMUrBVv2jmnyKf0+To1Z6J/QOu+AMlg1+rZafp74cUj21ErDIDYhauwDIIStJCEuCimE3R7GqgIQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=y5NPvna7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="y5NPvna7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=y5NPvna76l/Bjl99HYB2JK446I
	loiqpXbo5Et0142DiICy/vJFjtcsLV7o+uFIHykwF/8BrNbQ8UfCWeZv9D/bHRqTlyA8FvlLx3yic
	sDQFLYfCrk5ym9zJW3RusCQlpY/EXdIbwQw3AwZZSQpv2VyAUTtZKZUgaeEgq83Q5iNBZ8vDfRHfN
	xzPDRKo0i7KbmFvVWyLH5eWqnn3QXKmgH0zYJaDNWX6n4xiz2oQHehBF+Si8ao5ri8fIftyi+/L7p
	jp7pXN8pXfVECu779qa7xPFYe9lgMaG4A7Fst/SBD28lS8icrP3OHpyYAR8OiARS8I7hFOMwAcLFL
	AyMF5C1Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQKxF-00000004xnV-1RLQ;
	Tue, 02 Dec 2025 07:37:45 +0000
Date: Mon, 1 Dec 2025 23:37:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_db: document the rtsb command
Message-ID: <aS6XSSwc7IujBTJD@infradead.org>
References: <176463876086.839737.15231619279496161084.stgit@frogsfrogsfrogs>
 <176463876136.839737.6808868548984812536.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176463876136.839737.6808868548984812536.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

