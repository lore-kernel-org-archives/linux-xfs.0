Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9E818E377
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081220; cv=none; b=Vquck6ovKiPTfSAIKq/TqNMCtHHmbV+Uyj5M+oHgvkn/nNP9q5JYhuFEpmjLy6gqBpiucOXTl09zcchUJKcmYovlBNFZxoTzfXYP1NFVuOh3xaErk5RC8tFQbyloNmUUUZXeCTUSpoIPCS2HPJYkwb0Bjn2SEREGfnODwDg5Wbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081220; c=relaxed/simple;
	bh=t1pp2kQBW+bIOL1D1kkYD7API4lDHo3Bdbk5YGLfX+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cRXt3gLdOc0mYbBCjfgmHFnXwRnw8FYkHbxTSRQu6GvFoW101CsiqB7vyniNs6bWlMFtICa+TDz1B6bFNZCAfUvTo7U9F+Eoy9zi9xyGcibN6RyGJ7gOW4oZFJ8bPlv45mW0t+0rfAF2Tqa5vlwq+T51t30C3mOBRts5kVGdPds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Gq6VBQek; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gq6VBQek"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PU+gMMcqbMAv5kqcOaYNWx1n3wxONo6NP42NwYclx/s=; b=Gq6VBQekJAEHh2sIXPI+kOm4Wo
	t/+lpy8ynR5mLSy44NvFUi0ZcjsPKSAXWCLBQMhXoBZXvF15oYpOKZ31Wc0BGc7ig/Ssl4pUoLzMS
	23Pe7Sj8NjxKHLuFhbMDYxmttmJVeg6KJSs1I6T6Vt6mxfDlZHEP/hQ1l7eSXEIIZHPHQ68vJrWRj
	RzvROVOkemPgoMrD3B/CNWI2Dd9NyzaBA/D9L0wmhv2m3tDvdypiHDLxCdXurlo2t5FiFjiTD0pDJ
	qEk7ZpHuWdYZl/r1jvO1BY3vxaycqRd1Jo6HRWCwj1ksReDNLhh5zp4D11q1eYlUhjh6IKJ0LTMf2
	F/jYB0jw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1ju-00000003Cnx-4AA9;
	Fri, 13 Dec 2024 09:13:38 +0000
Date: Fri, 13 Dec 2024 01:13:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/43] xfs: compute rtrmap btree max levels when reflink
 enabled
Message-ID: <Z1v6wgvNi5iSQaeI@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124859.1182620.14450652763894339074.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124859.1182620.14450652763894339074.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 05:14:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Compute the maximum possible height of the realtime rmap btree when
> reflink is enabled.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

