Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CA21552FC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074227; cv=none; b=XfQJbNsTJogUYQjcaK+3z5fjIkF+nnT1UEYfZoHNzOxPJqt0kCmp6DHbnsVelCi4GuGxQjQNCFa6EEmCkZwpYcWk1M+N7BPzaZtJ2+pkvok/WF9cUfHPwhBYYMYwtpqHTEtVL6ktgv/jr+42b/Jl08UNndIFLXiW1QwX5HRYCZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074227; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lir3Ydnw7MQSHl3YFEeJVgszQHb+5J5+VUU/s/XLh3PoZ2Fx5FCPGW40SrpcDrS0KsgZnmfWNdCGsaevHXdMPUCwSRTyaT6dh4fdr1aO2C6ETAT6j708AtYHcGuT9VKRDduJdN8JG6mXkKeg5GSiB1IBsVeHdHLTRA8kpx0aKC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EcDQudni; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EcDQudni"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=EcDQudni4c0Yq1sQN/xLpMoDqq
	48YXF/zY0uryqdO3748jX5dVHApruZX5T+jrIuEffyRLf4PxolF0Ip1A8HO9s9An56YK4z2Chk9+s
	EXa621rdKRZZolO2CsbU5i8US4SPfXbj8rEyX0yPavSpjMw6LtSk9sXWqd7YBzWcANER/pWRoG7jC
	AcURjkwuRk2KIU+MEtpS/53K0r9WjKRTIsIcenVG8rBDJRtleqzkVM0z2TaiEM6Jz+KZRHDs2qk+V
	emMH3YReqmLcdzOhjYkT4rGJBeHjclqdM5u4FsBcbsdycavObQ6gL2VI0sRDJhAJKfj9hMefmOZUf
	t77/U1yw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzv8-00000002wf6-0oJ6;
	Fri, 13 Dec 2024 07:17:06 +0000
Date: Thu, 12 Dec 2024 23:17:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/37] xfs: scan rt rmap when we're doing an intense rmap
 check of bmbt mappings
Message-ID: <Z1vfcu-UYEJm9JmF@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123727.1181370.595086889127827740.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123727.1181370.595086889127827740.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

