Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974634D9FB;
	Mon, 25 Nov 2024 05:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732511708; cv=none; b=ATp1zfsxXw+4Dixkrm+0//6PLQIY1f0wW64mqkIKr66Am7E0Y+5tWu0P3Fxa5RFdOky+nUve4X8EmKTKRb6fSfJXdk8V3DG2cLQTc1MfZuwpdhX0CkygSUBjZxS7C0ZHs72Nfpo7/qEI8vFCpcmQi7Er0Y6FZTjuxSWm399s6Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732511708; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EyMtTvPkXPHOe5m2ChJZ1mQE5seu6ysmULDjiWuB2xWo0/6v8fsPsXGS3LicUWu1zkkO9WMs7o/VQuxszj+0FUudSWS9iHOT32uZmz9oMN1pDzxf2Q8kran/BQrJC+9ey76HssfYpSW/lxhfHRnxmPrYqy3IOhWYEkafdDFiC2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FwiQrVay; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FwiQrVay"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=FwiQrVayce6PIS/y6coxZddd7+
	+bbuBp5KCUgpmyWHbCfYm8SfR8Z3mbY74vyd3JJwK4OA5pUnYMNc7oeZ4zjZ8bhu8avTS8F/v+aRD
	Vo29oD1sK2L1ec3iVWAR47EujMmZaoWwO5uF2nzaVql7E2Kc+5UkiobSpc6JapmRk74dTBvj+mhqP
	pjrfNIqsDLpNmL1UiE2Gb3AKLx5wwwrH1NJ3XIqX1iXUKgRP9WtYpKKeRHmCaCqWxGqKzpQEi94t2
	IiixP1hTvgWOMm1lYvT8G4GeV6flN94WV5P2hMVOOILTq0l1cdkcEaDSDrk0fSd3ok7+lzKg+DQZz
	TD4JdK0Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFRRD-000000074nB-1AcT;
	Mon, 25 Nov 2024 05:15:07 +0000
Date: Sun, 24 Nov 2024 21:15:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/17] generic/251: constrain runtime via time/load/soak
 factors
Message-ID: <Z0QH254koWcJiWmi@infradead.org>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
 <173229420209.358248.6636819948700619006.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173229420209.358248.6636819948700619006.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

