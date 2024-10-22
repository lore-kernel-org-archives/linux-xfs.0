Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82EE1E529;
	Tue, 22 Oct 2024 05:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576072; cv=none; b=PDDyvbKxVxxguTB2aYH3/g+Ox59KrMXqPzs9MZ0hPOqzj0v/uUkCNxXrH+qmBIdj+d6cfuaHXEv1aQ1Zlq3E50HxmFVRC/+CVNyC0nrlFAv8+HSLW3UmsNF2smX9uw4pAu2gQ9Ro4IyZk5zc5RWruCmk20nJ6CF310EJZmu1OLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576072; c=relaxed/simple;
	bh=XehdSKvsWe1uh0krq2vLXFjrY56kN12Mf+wK7GV3+BI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8A/AlNTpqUa8eVHT91aK5Mb8QSYjv7raOTRYELZxisxEpTnF+k7d+tdFBzbcmTW8BaVJoSk3AdZaOOWHhhq8gQ5g/ZGwrcXq7fObUTe+Qr6aYfnMn9xGVbAMiIy5+QJ5uBkQQ7yy11L3ZcRw4LKL0cwqbY8j+6e2tNnM79glDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WKo/IyF9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WKo/IyF9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SZWNhnyTNyHIgjBiyxipL2zfUfpd2lOkh5eWqyyIx/k=; b=WKo/IyF9JJRPNDj8GATAcAwFbJ
	JDlacylFF8fsNB9wQKgL0X1a7SlBSul6SEE0RySXkXFPB/A4j4CKfwLb2FoovBZAdKeDjkW1pv3Mm
	jyrSOKpqI5OtUZZXtrmVJzee1/X8gNjw6Py0pXy41tAQ8A0KU3MQ/CNuCzw+PmZ2+6MIFv8VXrbfo
	jZzNDW0Z/ADDIf1J58hWDjMRQpa5hIYSgae6VdmvszGh49dk3iGMoyBYHfcurp6nJUuVy91pkPoAp
	DogTAFhMj8yHa7wWBFmgf90jDkwEnCmhLHK3eASWS9s+A6fgT6IouMra+ouImG1dFRtJpk3v0yo+N
	aYe1QvOQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t37kE-00000009i8y-1JGF;
	Tue, 22 Oct 2024 05:47:50 +0000
Date: Mon, 21 Oct 2024 22:47:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] common/xfs: _notrun tests that fail due to block
 size < sector size
Message-ID: <Zxc8hoOEc2x129bv@infradead.org>
References: <172912045589.2583984.11028192955246574508.stgit@frogsfrogsfrogs>
 <172912045609.2583984.9245803618825626168.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172912045609.2583984.9245803618825626168.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 16, 2024 at 04:15:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It makes no sense to fail a test that failed to format a filesystem with
> a block size smaller than the sector size since the test preconditions
> are not valid.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

