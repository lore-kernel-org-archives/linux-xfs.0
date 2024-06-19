Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AAE4A1D;
	Wed, 19 Jun 2024 06:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777399; cv=none; b=cFMaTWZYpKqPFXIrO9WzxUSz20lYJ/kIdkKqFRWAaJwWRCO2kQ0lZQlgbNwcGakB46tcU3emQDeAYEuXfHKbTWM9ydLjj8uZd4cbbPfRJBqyuz6+F1oup8R1Wt7RfrRb/GmDJHGGVqWbLAeFdXoIAGgcENEQ1MAEljD9/NQKu8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777399; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c05Xa5vgrOXpGsC5g5t0Il15LpKC3E7Umsu3XOBp/v2bwi0xHl138SehbXhMwdVSkHgaQ5Bcvbr6AhK0Nd54geTQnuaf5Zzz1QFz7q8OivLVjptbpDKn9IoDjifU1rEVT43OsZexdZxupYeshauuPUTSi4Auk2Iy1Uu+x73GT84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=siButoJk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="siButoJk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=siButoJkxrU++4N9rgxVFqT+Jx
	iWldWnNHQr5hUGZyLJVZzU/SLm33ZE+rFpIwJ5w463UaSdWmAHv7wS58RgG2lAX8NEPSddkvoWBt0
	ISrIWZNkgnGsQ/iZ2730/FnCy23qTy4rvQ66d9llCbALR2S1oCgBpVW2ke1+aig1ZMczh6R4rZJV5
	9592ksGiMcLiTlNsVOv1F5I7S9RPv8IIUhfu2EhjJkJPxTMEmhRjeQZLtDQQsJWhV4L9jdI8Tkke4
	wvKkT63UL48sYEmA2bJs7wOwaeIGUq5DcP9oWZwqFYIh7KQFP10gWNvM1/qkfSKsTRbN9HKgQnEio
	CgkCfVIw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoW6-00000000189-240y;
	Wed, 19 Jun 2024 06:09:58 +0000
Date: Tue, 18 Jun 2024 23:09:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] misc: flip HAVE_XFS_IOC_EXCHANGE_RANGE logic
Message-ID: <ZnJ2NqI7w-Vvza8F@infradead.org>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145390.793463.9133351291514672371.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145390.793463.9133351291514672371.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
