Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA7F17546
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706855196; cv=none; b=uQbnvfAQK9L1Hek3oaqW00de5kOQuBgtdlwBFlH7SrXMYOfCxoEyq4yc3idEFwxzEGwcqqlKYKds6ncFnHpBt922CY3s77MISeADVQwXlMgSjIr5do7dyUnwbe9/4hcTe7+V9TIcux8KGybyyb8CPEK/5axd1e1IaPqDOnZbw30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706855196; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mqQcGeylvZz3SJ9WeKAjS9S0aRKl4Ck4yhUsUnhtwImtAU/FBjnhnaVI8z9ktzjnAOyxTOUZO095Of8VOpjtSKjH/sEa5QVbn2WS3HAg9Tn5KGxQXIbRXSjbhLRCokQBDrKcIrIjm2VCpVeaHoZeJ3WMPP2xyL7uP4914nHX+uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WZL3H8nB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WZL3H8nB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WZL3H8nB8QJpELpHcmwDwijckK
	3dLHjm1cdKDD4KfHlIrbg4lVoW6849wwVxtdpzVSMvQAQNuVRVswcGCCdpF3iVlzniyKBodT84XlX
	AjCE9YhrpIDcCLp2Na2X7VVf+0XvIMLe+K1Yr5rMqJwM5rbT65AtgPhdOF1rGetKxHAuYeQNxCDZv
	zENxJukCNb1kz3rOidoiADSi27uobW9Mv/cPmy3yuXykq/Id2v6bh4KPUUvubScppwJFncRkr0etu
	c5iK++Xqs66HRb74YuJW33Xp2bR0hdEIpL9+o9jFpf8kuOmmOoOKxcafcctwb6MRWOAhAfoZTXGGB
	YPkv4Gcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVn0V-0000000APlI-0TzL;
	Fri, 02 Feb 2024 06:26:35 +0000
Date: Thu, 1 Feb 2024 22:26:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 1/5] xfs: teach buftargs to maintain their own buffer
 hashtable
Message-ID: <ZbyLG3aktCcxp_iL@infradead.org>
References: <170681336944.1608400.1205655215836749591.stgit@frogsfrogsfrogs>
 <170681336975.1608400.15103821354987789245.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681336975.1608400.15103821354987789245.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
