Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23BE410D1B;
	Wed, 21 Jan 2026 15:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769007936; cv=none; b=n5xWS8J563nO4/+RAJLqFwb1fNrwIDBdLx2R9lS+HoLht4C7gIQki9LMnx6UpEvc2tvFE+/4oo+jPXfqQQK/FZA7I3RSNlsfd+heoYF7VyduSkd0FYQHIHNqQ4FzmMHbmqxRv0HEHxgSdrMVRWCTmXDwY2A/sXRMbdr3cWswBAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769007936; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NNe1LnLd+3pksgCFTfztF/J9JB7jgWTvVSpGclaZlPRE7uxmO2ENiF0WWpjTquVZ5CF840gu6CqV2KaeNqnMHrMjs/21pKjC/x1EnnAe9FrwiVmYAu1TpyY3n/deBewCwmkddCk4QaLCB7/F4kygKFUC7mX/UqiHSM5v7wR0uh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b4U0o19J; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b4U0o19J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=b4U0o19JWoa2A9uVIIsrlkQEj7
	K8EZV+6bbHQfwF4JIr8Z9LrLXg9jJPm+qMlSV5LdDJX6Af2RulS2Gaw9xv1nRGNtqhTBdS+0pmF1s
	PTDpNkyhVvc/GyXTESQI/u+c7AGeE6An65aNZHxrBlmUEQjKmMdyfqnKAcypXKvnL0TXiKb1XJCN8
	2d3ITzcPVkqBG25HatXkdL0M2PXssh4z8xKwenCFlLRaOvQ6c8T59ilPcx/AY5COW1MV2hkisONmH
	2Ki4P+V261W6QqAIsDNRNY8jkWU2UjDfn/nJuKzDiiuVCyYFQ/6oWxY5FoB4LouNVaxi0bax/+QAk
	7dHKcgXg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viZm1-00000005hIR-27Cs;
	Wed, 21 Jan 2026 15:05:33 +0000
Date: Wed, 21 Jan 2026 07:05:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: delete attr leaf freemap entries when empty
Message-ID: <aXDrPTfjwC_p_fpe@infradead.org>
References: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
 <176897695577.202569.9464144622549604714.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176897695577.202569.9464144622549604714.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

