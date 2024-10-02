Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C631D042F
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 15:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727881879; cv=none; b=YY6/l3O4d49Jm1WUKwuaFJGxnpuaET3lr4904p42zwqdFWt5J6gQaA5B5riUxvWywuyY0U+RfuFAPdoQoJwDDbZX5ClQtFsvdU+PaTQ0H1piWp3DjLafRWR+3E/AvyfZ9tNfRCezEcRT0dqlxm7DZkUdkql4O6rg7nnaWpsAQ2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727881879; c=relaxed/simple;
	bh=iStq12soUVefOwrlgb1Fgi7o+TR7F5bo8Y8WGnibinA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B8swGJM103BjLp320Ub7/o510n9SfVhxeN/VhpkThEPe4lFRPMUSXkW3HGlT6dA3Y6MzHd7y4HL/JT65fnxHrQYHjN9zX9MIna0X6SYEsPHWl6SH/sLZLjpSLY0wRteynIzOD+HmD4NUZ4OEaSEcvU16DqXoANuHb5l1oX65okQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N8lPQEt/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N8lPQEt/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yfj8rF1jBPQw9YCX+kFHxJqqlQM4g8VGeWhe/wqBHFE=; b=N8lPQEt/Emx9bN9n2gPcEJ5c7V
	MX/MJt8f0W8eBtMTbe6WgcVRInFmIwnbDy2LxKSjLkdByKxQhIdej+GPj6JazcyZb67lumwDrazyt
	tRU5QrIDeVeN0rqQknwitDtMLqaThhio6+zTUZDVh4z3RHAFSwFSh8NfC+N+MfoSvv+wSG38MjZvS
	7uxPa5AOUHW3ZVkMbSQAaVr++TUavLBqoDusoub+9Vz9UZwQePXyL02xmjJ3RR8rleFNSt51tbscC
	2TKghGXz2Yqm5OnrXcbYN+iHch1P5PyS9ata+ty90OWbXmG7KmW0d6jfjjygEeeH8v7KUrNq/pVlW
	MOLqXdJQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sw10X-00000006Z7U-3U72;
	Wed, 02 Oct 2024 15:11:17 +0000
Date: Wed, 2 Oct 2024 08:11:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix simplify extent lookup in xfs_can_free_eofblocks
Message-ID: <Zv1ilUMwSOVeT1Q_@infradead.org>
References: <20241002145921.GA21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002145921.GA21853@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	if (ip->i_delayed_blks)
> +		found_blocks = true;
> +	else if (xfs_iext_lookup_extent(ip, &ip->i_df, end_fsb, &icur, &imap))
>  		found_blocks = true;

This could be simplified a little bit by doing:

	if (ip->i_delayed_blks ||
	    xfs_iext_lookup_extent(ip, &ip->i_df, end_fsb, &icur, &imap))
 		found_blocks = true;

but otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

