Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B458C22EEF
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389334; cv=none; b=cSJx3beR+OWmpAgDhHHYnEMlllPS1hiqDll7qnUiTp60Rowgtu1/3EKIZd3o6f2j1Rj6sfNYNH9nT15NP+TfTAgT2WYA7S+fF7Le4Tl/pOqtPqIoh1dxQO8gPaG6Qa+f0iCZBeX4wiGPJYxdjxQx6MhAKm7GZQ6FoKs7/V8Vtbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389334; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tsOZFpR/B2/Km/bQO/ifBb89yUKdSaNOmPqsUXCF8A1NjX+u7d/5nS1AaJm6ZZQRU7T5+3mN+AJvHepuD6b9JsDdlVCnVUqYFE0B8gp71BR+5aN9kKTmymBGS8iUgNavcb4a7p3E9dll4m0rGe9VBn8q14qG/wwYsjigvcecTg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0jm8ojbm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0jm8ojbm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0jm8ojbmXnlg1ZhMCIqVRtBNU5
	x0sZEyYczr8Uz3RfBb3PuzCRkk3egctDznsqe/jfXXu0lS1JtxPBKtfolRCjugAfElNlyxpknDtUj
	mrr8kUSQBFjM0QDYd394UPVHA7k7+9q45DtEwGd1Pf100R16dyBFeYKXHwNmMKqrGkAsyLh1k4Sf7
	cyY+ynxBnLkCbxFiXWff42fpfygCugHABIOHNiEQ52NmbwfdUhrtY8UHEwEwInh3+6rN4p8asMeC3
	L6xF/Pkt74tcpKtvK51drMHT7Wh1dB9wkxM3PFL+uEusKLPUWRCDnDz7IJqSr62nMMKYU6kI5nS3K
	Qm7qK8DQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMRA-0000000FFUn-1Smw;
	Fri, 23 Aug 2024 05:02:12 +0000
Date: Thu, 22 Aug 2024 22:02:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/24] xfs: define locking primitives for realtime groups
Message-ID: <ZsgX1N7mca8Aj2m8@infradead.org>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087452.59588.12210244336745998210.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437087452.59588.12210244336745998210.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

