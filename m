Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8A053E3A
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 07:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706601500; cv=none; b=j0GPEoB6Szu0oPIrqwYaLlkr+ivca4AUTAIx7Pp7084EP+gD9M5qgEeyf3nRXV9k8YBIHFemPQhRL1ZYubOv9GekEUlQJZOvZsEVOYup9Ni4qR4JOXs29AcVcO9xUccyTHRTkjl/jzBPuun/yXgEvuGum7Cb2Xw+zKBrCbfomVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706601500; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLZv+76AopIG/8uYzSCRBb6460FBjXnib4/YZPPD4lRridvinlJn5KZbGw9CdDsQNI7lTDN0Nrk6rlIr8raQJuaW+a3L4cEpI226TUitrHhEZs3kFLwfJ8cQTrc08BPco+PObVL3TlSdr0QcvdVbK4EPN27/fF4hvIQBld1cZbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zMGlYT5b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zMGlYT5b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zMGlYT5b8HEgJMUsY9eM8BUJkp
	FF/oOO342971+UOOv9xiCBtfwBArkizxArXWl73icxIqMr6E3qipY4ZmY/j3cnmvo5qkaJ21rlgWH
	ApsJgCQQ8QtjbzjVhDa2tlbCe2t+VhuFxqasWOgpJnspv8reyu7zu6/Xm9gQ6yPDP574eLauwK2Uz
	X+FEYGmqfsnGszNKD+METkk2gbt34JukiMKagIg2IOtZ08ebAzmwXz0xeDlekvHF0BpfpINnAJJLT
	vBZn906dfAUr3qNvI9m/OnPpLTgN9OcTKS66xblXzX2WJhNEUbNnDrHbtLKDsnu3cDuVh/C01YCpG
	LyXB9Y1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUj0b-0000000FbPN-2xCL;
	Tue, 30 Jan 2024 07:58:17 +0000
Date: Mon, 29 Jan 2024 23:58:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>,
	Chandan Babu R <chandanrlinux@gmail.com>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: remove conditional building of rt geometry
 validator functions
Message-ID: <ZbisGfGfO98ZQwNE@infradead.org>
References: <20240130042723.GH1371843@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130042723.GH1371843@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
