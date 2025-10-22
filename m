Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769971E00A0;
	Wed, 22 Oct 2025 04:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761106881; cv=none; b=cxfyxW77eJfQqLzCHaGVPDsVJUK6OFNyaL9s5mErIqYJk3DZAASwr/3T3J62Hp0a2N1mzMtq9vSogIY5MiihblnueB0Dhl4IZ6S1cXhNT13lB19NEFsxIOjJ7gcSQ7N9t92oaEXsh1VHB/38wPsznK/9LSQzfWi26hS9817RxW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761106881; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4DQoYBArXYVduV/KKD+jJLuhRom+QPW6hrE0E3JOCrPAUAO2gXGjOXd9HlIPErnu1DypSZwPP8ptjUivnk/AJXncbbMa7mBHcZX91r7h4DFUuiHUqXa0xgAB9qS1AeKML6J3Fw3528WZPsLTz1g3RAhdVItacIO4jAzg9kWIqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NZrIp3H+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NZrIp3H+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=NZrIp3H+C+gwTPKyARK3lFndwp
	3os7KV9+gWy5xJY/COCucASDg/6+qEoziK9ZvvU4ANMbSJXtrDbytVTeHHLUz+wnqR70XbpbJ30rx
	t7UjsOnF5D7EZRkRvUvHwphMkFnEq8Ds8PR9yUHGqv+FElmhn4Da+WctKVT4yzibyONwGuFAzSXe6
	yZ3zHQB7oc4iU578Ow9uv6oR8WXzie6uIbCFHXJO3ZXByQKzu93udxN1UB6j7BoandqyNjvdUF4je
	UGiAl//UjD9gxY02DYn4zyBdiggGJyryB0A8XTKv6xpmLPiuFr1iXnS9RMjQrYjYc41uT+k60BdA3
	mhmB7cXg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBQLg-00000001QGD-0DsH;
	Wed, 22 Oct 2025 04:21:20 +0000
Date: Tue, 21 Oct 2025 21:21:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] check: line up stdout columns
Message-ID: <aPhbwG2ok40GeI_t@infradead.org>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
 <176107188851.4163693.5236154684599011991.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176107188851.4163693.5236154684599011991.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

