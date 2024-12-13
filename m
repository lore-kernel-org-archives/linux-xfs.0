Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A7B1AF0BA
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081614; cv=none; b=IDk3fisdzyqVQHNGF0rojpCH5uZ4N0KsghF+Qn3+gE+TO4NuAKVuJibpUk1Tqa17UHxohj7QA3BCt00zEE4gsOQY4hJt9DHXFjWqyYWbOFuK/zYwPBRc5l9qvTD7yXl7/fEqtrjr3I0bTuw3gPV5atYEeM8fkD7Bll/Di/ZZ6TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081614; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBHDPFXUWoEW2szkl/aGjeU/E1Tmrotpb0HA31f/csYJXKy7j5oPRDJNqF/TuBh8kImOy65YhO0lwOc3j1FSZGwfmnqUkxnkqUPYd65WNFT2J77n6IEqEeqL+V8wHIV0o9NqEJerRx/bqpYaF/TxxEBL9HnIc+qRVt3xGDO8OgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=h5iqLHYE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h5iqLHYE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=h5iqLHYEZPWdQvuqwHgkfxm5/R
	AEYyoOEXUJ/m3ZJoHN8Qu4TCXymX4RYJRIWN0DUV6F6DtIkLRr72Sv+3tjjMLP0D3KQKgWk+yCpH9
	nYS5OGqCa94qlUZiezcuR86szuURVUjh16IoFf3yBxVuT2kHC49lR6CwzWub7QEJl7mCvmc8n+5Rn
	fMZY+fQAh9kviW+L7fi3JsRilMduezOi3K3NCajWHVL7qE7GPuy0G47kEMJapFpNzfrKXe0eQZa43
	Z3LKY6mE2R6TN2zdZcCyhMl5gyPRzP+6Fpm9B95rlsXhCqRQAPtmBTEMocRc4thLrvk+SAXbGY3F9
	e0nH5GYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1qG-00000003EEv-3K5u;
	Fri, 13 Dec 2024 09:20:12 +0000
Date: Fri, 13 Dec 2024 01:20:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/43] xfs: detect and repair misaligned rtinherit
 directory cowextsize hints
Message-ID: <Z1v8TImR8iROpKbN@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125132.1182620.18153783686406472894.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125132.1182620.18153783686406472894.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

