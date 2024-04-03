Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA07A14831D
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 14:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712153213; cv=none; b=cYMJ/F6es65jykTVrPL6jiSdz8mMOmMCMW9s+k2Jf+UtDwft2QmRk7EZgEM5Elmivb6/QZry4lIiFFm4Fr26YimcF93OQIlfyfwqdrthC81YjFNYsYsAW4rxo7LStJ/NnKXFsT79PcugteLloUJBCKH2AbtgYakcDhrz5OKT9+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712153213; c=relaxed/simple;
	bh=MIG5Xl8Vlz/BzodCgjrBqzjFukE0fuU5ymYdiTXTqD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YPQymL6z5ZgBu8vrZPj8/NBpkQUE5iBg49xb0pKKcBee0pfV7emzTyjWKE7q33PnJ5N/8eQK2Lqgeqzuck81RtpaV20rQlro3M3tAs4Dkbm7a3lehkS9ebqe7iCW/vpkZvznl2JOuCVgBKPQyEPrWcDLDUMYPo6TXAWenIHFqrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x1Cm0lFR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x1Cm0lFR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ua+RzfArqrhsLddV451kB/vuJnpULO/YLqOGUBDvzaQ=; b=x1Cm0lFRQ3EJR2yKx4fM4TT5rr
	Kkljf2vpeFHHRsXx2WdpiNYPEkWBB1RyypipCQdT3MGzE2YoGC46uvCcGZuxz+LcN1L99/U7U6BBm
	LOwr06gcC9dArLsNomi1XwaGh6cRJtXyUgxKUQn4UEXd2Vess6xygrAACE+4xtGN9sc+i6MUCC0oc
	bOwsdOyUSQlBGAIi1FnXM1E48gnEyGKJVHfrrtAK8wEsapkQNYpbqFRxmbKSR07FLTiYsr9KGOul8
	ekNy/v3clwrrqiflIJvTC/a9KtKDyb9KQdh5VN3P1GnwDqwK/1g/s9Z3X+oJ9usWlVIwU16wJTgQn
	YT3QGevQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rs1GK-0000000GN0b-13WR;
	Wed, 03 Apr 2024 14:06:48 +0000
Date: Wed, 3 Apr 2024 07:06:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 3/4] xfs: handle allocation failure in
 xfs_dquot_disk_alloc()
Message-ID: <Zg1ieA0NA9Bd_i3P@infradead.org>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402221127.1200501-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 03, 2024 at 08:38:18AM +1100, Dave Chinner wrote:
> @@ -356,6 +356,23 @@ xfs_dquot_disk_alloc(
>  	if (error)
>  		goto err_cancel;
>  
> +	if (nmaps == 0) {
> +		/*
> +		 * Unexpected ENOSPC - the transaction reservation should have
> +		 * guaranteed that this allocation will succeed. We don't know
> +		 * why this happened, so just back out gracefully.

So looking at this code, xfs_dquot_disk_alloc allocates it's own
transaction, and does so without a space reservation.  In other words:
an ENOSPC is entirely expected here in the current form.  The code, just 
like many other callers of xfs_bmapi_write, just fails to handle
the weird 0 return value and zero nmaps convention properly.

