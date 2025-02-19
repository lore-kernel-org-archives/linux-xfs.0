Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9590C19F47E;
	Wed, 19 Feb 2025 07:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739950120; cv=none; b=aZUP6RKI8cP9G4gxlmDyKgb8nyTtqtKRq87z9Yiy648I9+qsDEz3SeLxg2U5D2HdagoY5EVaOEiotDHVQK91plkr6craMg4gNuqCwP/zDurfg3Ycmz9v8CaNEbtsznsw9NM5qPRhLNlvVP5/Rd+ACuZ3qrgPuhWEX9i6U4L7VtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739950120; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MFrsqbptGiqR3BV+A44ZF94nfQ97WGObJDw/DKoxZrQswcBQLBYCLrFgbCD0UmI6S6dHmnZO7C4pIdmAbW4cAmxfoXjVI9ZDW0B4PJarSxS9eBzlEdeHV/QrixsMxD6qhGX8f8o48MGovI8WWKmryPiMg8lC1b5k4Fiw2wLZSxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cB27rHHd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cB27rHHd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cB27rHHd5Pa/KCxCmI44D07C4z
	8BN68/G6j84LxQAlZmuRxZU0gomegifXSAtXNZM3fah44b6wn+20JJ4S8dXXxl93yHV5SMttSFYaj
	7yIaKqAomSJJkOm5Zpjs4yZ3UFT5MN3ugD06IXXM5R8UqYYKBl0bKS4rJIYmZJ9ml01/qsb+K0Qcz
	x9jr+hx8/BBT52dVZhvqm0jLRdtug6usWyvpjKPYe0XR9lVxmsf6ncUlgl0sQdl5IS6sMRXxvxxuT
	1hOiSYGMKIV+OpX0ukXfPeBoSgeTpgTRkAtaSQm4o5ITCSwSFWlpBzqTRRlzXdL0XmicTyYZjyTd+
	fqHJsb4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeVb-0000000BFHX-0NOF;
	Wed, 19 Feb 2025 07:28:39 +0000
Date: Tue, 18 Feb 2025 23:28:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 08/13] xfs/291: use _scratch_mkfs_sized instead of
 opencoding the logic
Message-ID: <Z7WIJxwQQnhnCzPY@infradead.org>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
 <173992591258.4080556.3753644406313565446.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591258.4080556.3753644406313565446.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

