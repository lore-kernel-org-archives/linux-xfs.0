Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7DF15B11F
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709139941; cv=none; b=g6/7O2Jvnat8VkhU+AUnFwoULmgXGE6a6lVwSvi6W/mSQ1lfGoxbRue1ltlEI8LyDmd8dKHmkpPKkpYjIMM9Uo/zBpuEsVOimMqhMtXt2kdoYHojFSuSOjrkLyA7J5eURCgm2hckRcVtj0IHiRVVJtvf0Awf4/7HyVZkflyko8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709139941; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O7iPEo8XmyfJidHY71OYp0jLZIBCjfDZeCnPY0VhGlPY6M0p3ASD+7Hj8Ee9JWFC6liGIOxSdMi7QZeYVG04+TmypsqliDdV1C0y53TsBPKPKeZ4lti/6n9o4ng0IsomxGXaMCMZ5YI0lVHSwvakSuVMiSyuF7EDjpiP839/6bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SVjLzq4G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SVjLzq4G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SVjLzq4GNFF4qj8XDNo6SENHx3
	g4BEbKd+tgZRG1OYTHWV1D3yjNjZVzul5VehK53OAHG17OD+GreNiA1W3TbIBfYtSPj2IZKkWTZE4
	RuVEocbI+FMm21LGPdwiq0NmHtuhy1SfMo+dX9ZdcPtbpKrZZ9N6uHb/V1lxdbNRUjjeJix10gOh0
	jldHXasFD6RtBNPSrapEX9BEo/3AIGxU5SxD5JsrkjO/7KJo57Mm7bIyDtoR6NB640GYPhVcJoxjA
	8K5u2xaJnDWlRCO5joiKN7SGwA6L2BX5GWJXu7Og2sPRHA9+K3DZMjcawElsA6E9W9d11qs2Thu4b
	wQS+P7Ug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNND-0000000ADyb-1xCt;
	Wed, 28 Feb 2024 17:05:39 +0000
Date: Wed, 28 Feb 2024 09:05:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/6] xfs: repair extended attributes
Message-ID: <Zd9n44GfeEaJ9wR8@infradead.org>
References: <170900013612.939212.8818215066021410611.stgit@frogsfrogsfrogs>
 <170900013677.939212.8190008302968114091.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900013677.939212.8190008302968114091.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
