Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999F414A09C
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728893666; cv=none; b=n1XP7Y2HZgJbrhBVE0LlqM0M+KDygQfELHcUZkrWwhWcJBR92gRmNhZ/B4QKnq7IgR9aogUv+xxo5pn2ehTa3mnv98GUqv+7JkZHyKiRooxCDjHCg1vrqEpu50CI6MTNxYIwudFTA8PcleenWzzMFn30kopaqJ1vh4f5O/CHnZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728893666; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sM1hlESa9J16PnNDcaUeN2SVF9lRj3EMOHi/M0NslzWTBU2OhNFChhibqjgkiRQU96N/F4nC47EuI1iuafCPewwWN31nMhgKZiRgQ4IPfbmF9Q9GD703+ZnDtEHY48vEiwVkpPVLqIWF8m/iIUKROaOg3+5DaCvxZga+hqHf9JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EwZ5tEBG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EwZ5tEBG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=EwZ5tEBGfXJvP/cCE9fT643Sjv
	awxrtznu8HBDKK3pXdscwh7QLoynkATe8ayjVrKMCRADXfAysbhVgIPm3BXmt7zulCHkAF1VfQQgM
	anjErnPpDkQSH1lxg6Wr65YnYNmt+IRSVcaBzKMsHhSGeVnsAQusTyWMsrlh3p/8xYjikbTrZ3cTS
	sWX3BUaj06F/e3ccRUh/uNT2gOn5chnOd6LorloR81qG820ubodlzh4gy4JXDksH7R5juOOqloHm9
	HEO4vo2zS0mMd8Vc6XZGUHyeUg2QefAo4gbU14Chd0bv0GwarULWLlHBumqKAYW40O3HyMY2jBoDi
	a35jk8DQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0GDh-00000004Dwd-15bZ;
	Mon, 14 Oct 2024 08:14:25 +0000
Date: Mon, 14 Oct 2024 01:14:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/36] xfs: implement busy extent tracking for rtgroups
Message-ID: <ZwzS4T4rB6c37Zos@infradead.org>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644848.4178701.6141796872423816632.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860644848.4178701.6141796872423816632.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

