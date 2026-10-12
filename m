Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B66489899;
	Mon, 12 Oct 2026 12:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791809046; cv=none; b=gpvegmCy5LRH9RR9u+WVEPRd3943v+mBcP46TMwWZWhWnOJ8Gshx1ZToiEqPu3R8oRyMJjfNoX0DDe1TA/hlyRsdk3WmqgaPQNwkxef6UxIuYncIQBOQ7vbdtYaMh6DUK/UiUTpxpxEUJWkY8c9XXU/Q+9VF8HR0uIuoqXSK93I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791809046; c=relaxed/simple;
	bh=VYjV1iHwrPT+hhkyRlN9sW9sIobajgkooUaQjlMtEJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I54xfYNKWQewFErxj0lgnOU18lvY4SOm8XPBioogXiLwNbpIgj7qbdHGiJNB9y/HDYU88DJF8tedDzYuheFTP/TuooqFFZu2x21v7Y0C2vzciqMXyX0R0XCwWS9T+Ix+dx5LU8q+v6MqxavBlLQ2W8jOAHBS2a3ULinz6P7BRQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hz53NMTU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hz53NMTU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VYjV1iHwrPT+hhkyRlN9sW9sIobajgkooUaQjlMtEJ4=; b=hz53NMTU6+v5eJXDcZrCy/xOv6
	0XMqQVqLGmhF7zr7h61b2LqVQezUK5ZQHv2Z8/zz/39KUPQ330MIMH2gZgUMfk0ruE1A4vbCFsJA/
	6mVz78wO+c84Gqe/BTJilAM5mclxsNZwDbxZnlQ/Ia529jqgCOvIZWlC0BQWj1zCLtWLf7YVvJjNm
	WZy88A95FWT3Mo8WK9EFh/eWjjb+AzkaMKM2jaKd3XlhnUp9TUaoG9wY7hsaJqK9LDtoJOzLRS+Ld
	+lZarlzH/c1X/Shiqjc01Nk7VuTP6fOby1KnljfWv83BqRlsz7hadn8DX/lBtgWVNHaH3mEQ/gbne
	M/9/XSWw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFNt-0000000AUfq-09Vh;
	Mon, 12 Oct 2026 12:44:05 +0000
Date: Mon, 12 Oct 2026 05:44:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: reattach dquots after changing inode ids
Message-ID: <aszWFcgPtr5cFKdT@infradead.org>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
 <179151614707.3163896.4351468047280563575.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179151614707.3163896.4351468047280563575.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Sashiko still feels unhappy about this one, and the complaints look
kinda legit.

