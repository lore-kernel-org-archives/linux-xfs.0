Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6741ECC;
	Tue,  4 Jun 2024 05:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717477595; cv=none; b=cjhf9WaySI8UZTa4u9ykGs+nJkNnFabEyq4C2QU9V2HPEPuoo44KD71cnjkxaMA+NZChDtvHWzGzqkMzsA59WOKzGccJBH0f43a6fRHMN1xJvup77pNZ5w42z/KlQI4eGr1S4s3A/iyeB26xgg3hehCLKYwwKwUVBg91iZiOHWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717477595; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sK6PoY+BUl8ldREF/LiKw0l8CJu3EkQxvdv5wDJ0dcKa02kMAqxJHA8/69MEVNVlGMTjJjjtuBsMCJRUoyjOAiJCGYgCvQH4y533QyPqOaq/Z1irJGnQHnEtomJ4sWNk2tDWsrfK/ZL64Gz9nMYmbFZiJ5nef8ZkabIJuevjIVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Gtgcc1iC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gtgcc1iC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Gtgcc1iC7yg0r1ucUfyUypanyI
	L7JfMxcFkbCTZCP5R4yMQY6I+XYBHmIb7oghWqjIQtxEm179jjxNgp/wLMIc3ZJjhQ5zAmHj3Z3oz
	Y13MW8nbM3DvixIlSvW3uOz8jl9FF2vR+2n8zYjfT2SJbHEOm1qvnGhBAEIfgVwfDDqTb7/B6aICS
	qz5BFRBLLo5ulLHXzH4gIk8ZeMNTwTHbU2tmEq8vFcF1szDCyvfor4oKCrBdwF9ACexnYswIIwcer
	yJpkmNKJU2KgmC7zZ008EQgOUSRcGAwY/tx0fsmDcvGEslHF7psCrMYUKiT0Wrd4BG787juzKWFHA
	acS6Z7PA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEMNV-00000001Da6-24AH;
	Tue, 04 Jun 2024 05:06:33 +0000
Date: Mon, 3 Jun 2024 22:06:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	guan@eryu.me
Subject: Re: [PATCH 2/3] fuzzy: allow FUZZ_REWRITE_DURATION to control
 fsstress runtime when fuzzing
Message-ID: <Zl6g2beOhFbCGNkP@infradead.org>
References: <171744525419.1532034.11916603461335062550.stgit@frogsfrogsfrogs>
 <171744525454.1532034.7496724268125813931.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171744525454.1532034.7496724268125813931.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

