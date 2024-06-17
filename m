Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD6719309C
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 11:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718624655; cv=none; b=K+G7chDqpAFOWbZchd8b1JTuIZaAcc5jASlm56xXlqYhu+af0byYSpiLJWDEkkDJ8LryTgPyM/oxUBBY810z0n0lz1/yl6FBIn2NRHolbDFLnOV8lQJXh3H5WlEIPvagyE/1imzK/dNryRhgKWkPDw0r70SAJWDT3u57aa7hKkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718624655; c=relaxed/simple;
	bh=ZtD/Ej6Qxhz40Ye8Uf7SHRyQeIxWHNhaooy3sQumPj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gnqBy+98jPVVAWbURC4fq4A0GEW8hbv5FTjIbtZaBt9F+PQfFAbaPa4xXrJ4nmJQq2OF3j8ViOblmkrWafr7ak1Ho3Eq3esxu59u8QLu1NopkWgV+URgAqVrK8SHhYS6SJSiE/iF67LZEj1HfuLRys3a39YDgixWkNxeRJ9EEFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+54pj+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+54pj+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B781C2BD10;
	Mon, 17 Jun 2024 11:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718624654;
	bh=ZtD/Ej6Qxhz40Ye8Uf7SHRyQeIxWHNhaooy3sQumPj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n+54pj+xsYRTbqRVDzmV7xD4KGq8eHBAtKwGI0qLB4ZnzXjC07CoNsVkJMNMcHONS
	 /ZX6QGCGPH/pVlylgzzosFsWYjTIbze/cgkHS33WoD0tPv57xIBAI/JyXVNtL711zn
	 ykPwljqXwHFtQOKmjgpAtGWkf6c78vnPyqU/eqx74GwYXbVJIldpT5s/qU/iGpE2Dq
	 ARsyuYfXvuNT8sNpbibyav9a50VnHyBHxEJVG5ybLE5VY9OeEX4lm5oIT6/K1tKqTg
	 bZWkTDP8OcC8YkQnUbRQm3g0CClSfobk7v5xGayo5SO/6tUqHZ8hbX8veU4Yc2ijL0
	 bf01E9DxnoHQA==
Date: Mon, 17 Jun 2024 13:44:10 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v3 1/1] xfs_io: make MADV_SOFT_OFFLINE conditional
Message-ID: <hzjj2qebc3aavltys2g3uqvuoxb3l6nviywujk7t5mr6kfktni@jis77afrm3ns>
References: <20240531195751.15302-1-bage@debian.org>
 <20240531195751.15302-2-bage@debian.org>
 <qoYaXWsiqCq-eMNbKd8enPEiLX-SsHxWz8Bhsr8rMBI8SWV4hD1zJ1pdJUirIyRK6xVb0525mayHy0Tpyzm0Xw==@protonmail.internalid>
 <ZlqoBUiK9WBpDTMr@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZlqoBUiK9WBpDTMr@infradead.org>

On Fri, May 31, 2024 at 09:48:05PM GMT, Christoph Hellwig wrote:
> On Fri, May 31, 2024 at 09:57:51PM +0200, Bastian Germann wrote:
> > +#ifdef MADV_SOFT_OFFLINE
> > +/* MADV_SOFT_OFFLINE is undefined on mips */
> 
> ... as of Linux 6.9 */

no problem.

Carlos

> 
> With that (can probably just be fixed when applying):
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
