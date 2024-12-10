Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C929224CC
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809108; cv=none; b=fhWUXiZGxjK54nIaE2NcjEiXr2VfCEEhLmHnCoLKK5rB1DVKNZNwc93BiH6c8d1SwI1j6NSZdFr47ZsFTeCTo9KJkz9Ijz4++tjCw0y6FvjJa26bg1gEqJH6pLl5dQFX8c8kzjGRV+Zwlyx/3oVKE0mw0hzXvhNiq0IX6JcM7xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809108; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZ6rIvLH0++cClzoJECp5qn8QvHqa0r6XP1zcVCqzEmVoys7Byazml3gdI9zjrPnc9fWXUJFA+q7nlYGF1ifGOI7jAKmNVLDja6LuBXjE+PLhAab+MFIAj8ohWksDx8Q+SFKS84YDzv38Bqe2XjhVGK5O9azuives6CdDjE+gs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hZyxv7TZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hZyxv7TZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=hZyxv7TZNH+K94ubUUelKMdowf
	LR9hLWTvD9yUI+ENedq0Ci13/5nfBwPyhUH5jJqYZ8zgXziRjntISqt5+Pb01wCqUrUP1cSdHWbWd
	hDzgRm/WeiH1KrmOeQWTG4AUZslYLQgGGoNc06+2PcZw+cqwok1UpNXNpS3xH8KkAKTT5FRueTXaF
	2nEHiQ69YxQO9ZJhPOaV94opaTpjfoVRM8Cm1/0cSysH2zGXeXwOC38GDPKAOW57ywXxf2OjlC/L8
	smaRlXHSGWVeNLnSZsKSndYoZ9GoOCKtfCqXZ19vt6VESqrIbRUUc8gWkyzaJZHH443qXBSaeHy9O
	1iK3H9rw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsx1-0000000AIK6-19i7;
	Tue, 10 Dec 2024 05:38:27 +0000
Date: Mon, 9 Dec 2024 21:38:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/50] xfs_repair: repair rtbitmap and rtsummary block
 headers
Message-ID: <Z1fT0zkTzy8yHctd@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752296.126362.12671784441675621141.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752296.126362.12671784441675621141.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

