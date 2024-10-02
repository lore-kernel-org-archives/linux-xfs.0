Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E1284A36
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 22:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727909501; cv=none; b=JQWV9dpNVFCS4Go9KIGu/Jg2p42NptaInhuQEJpOz1kcDFcQKfFjBVlLux+ua/wMv46WoZSQ8qntO1KUqMIVAc1JMhEUiyzcUo0fNqeN/PSSjQyW/aMlIxpbqupdXcNK13u7EG24s6tPzXiLNM3gnZkziPPQdPioOSODqBbGRgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727909501; c=relaxed/simple;
	bh=BgTfz3bndb7EdA47khKolOTtq+e8I0yXn1+pG0Z77gE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e6P6rKe7vqNPjf/hXOYrYkmVrXluFWqo3MZAB7ZKNaSS0yXKqlPlaQZ4xMcYZ07tRSsTg+sz4ogvpeWYX9Q4ICukQs/k1rm3aYChSlwxTk/9jc4W3BO/ECEUprmGuISedpg4BfeAiRbwHkTPUrhmlN+OKzUHZy56A5rfC8VlrfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a9SXE+nf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a9SXE+nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A815C4CEC2;
	Wed,  2 Oct 2024 22:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727909501;
	bh=BgTfz3bndb7EdA47khKolOTtq+e8I0yXn1+pG0Z77gE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a9SXE+nf45Sww8muGH0vqtIaWM7AuFiA5oFcQxJ1cNQntyfoGb6h39+uvhYD6mKSi
	 gzI4yjSHpciRrRTPb7rHr29yUWXSJecnC78uM68VYLUhvGD8h7OQJUlC6KB0okpPgO
	 F4o44+R171b5oZvWmu1poFxX8Xx08GALWfjj64kMCnbHDxUV59L4b7ZXYtBbJ1aLuK
	 6gAdojsvQP7eQMXeAzYlt/ZSCGUgB/+MotfqdT+RqKQlNubDDsuPIOM2dDB6HcLQ9I
	 +Ul1pBNkaQSyAwwjvoLdDSpvBVtR/0KNBiKK6O0P3nLtbmSC3vPk6rhaZSpx3J5KQd
	 ACLELhMx/bfJQ==
Date: Wed, 2 Oct 2024 15:51:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_db/mdrestore/repair: don't use the incore struct
 xfs_sb for offsets into struct xfs_dsb
Message-ID: <20241002225140.GI21853@frogsfrogsfrogs>
References: <172783103027.4038482.10618338363884807798.stgit@frogsfrogsfrogs>
 <172783103075.4038482.16400875402327891337.stgit@frogsfrogsfrogs>
 <ZvzgHzB19AWcfSoQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZvzgHzB19AWcfSoQ@infradead.org>

On Tue, Oct 01, 2024 at 10:54:39PM -0700, Christoph Hellwig wrote:
> >  	if (xfs_sb_version_hasmetauuid(sb))
> > -		size = offsetof(xfs_sb_t, sb_meta_uuid)
> > +		size = offsetof(struct xfs_dsb, sb_meta_uuid)
> >  			+ sizeof(sb->sb_meta_uuid);
> 
> It would be nice to fix the formatting here, or maybe even add a a
> field_end() or simіlar helper here..

I think that's part of the metadir patchset, in "xfs_repair: refactor
offsetof+sizeof to offsetofend".

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thank you!

--D
