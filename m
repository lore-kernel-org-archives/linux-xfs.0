Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE44C2E7397;
	Tue, 29 Sep 2026 01:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790645691; cv=none; b=bo+mQpJ0pMYR5NB/2hAqodRAIwwlOKOCFx1VpwDtJ+rUK2Rxey86lMOQZ3Xpee8eBj97b4nstDtQVQfn4tqU9itRnzbuTvsymC5lqTLM0BUF/8cgIwon6AcbPPlU0N7rP+wl8gO/K9DrjN4JG7iG6Onro6ye7DfXAUpCgdX4EG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790645691; c=relaxed/simple;
	bh=SIg+yqZ4T3vVAg5jUgGyBOGaz1qt8BD3qczNQ0ngg1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwINAWMW4WdEmGBXNR6LO0/TP/5uCdQAQQJ735+jGIluiehUnJpUfRXGbJO8FQjdtiVj2RcNYzkrbL0ojzJqEBW6PZKEwXaPLGBGfDo5GqekvvneM5F/0Pr1de/OCPRorkhjW73hlSXctbnUA1J1y4hL6APxVpjKn7OPTVoAjg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eczUFu9Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eczUFu9Q"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2A3471F000FF;
	Tue, 29 Sep 2026 01:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790645690;
	bh=YIuBSwKpUPDkv3Da6xh0BQZET1PIOrimJeLuX738+28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eczUFu9QGTqA6XMRJJwKuwYhqAvf1ky7evou5PUbPqPZEjWquTVNXXSba3W8sDRIz
	 qH207WHfN3pOCQPvtbDA4rgeF1DHbgSb/DN5UKli6LzKcN9E26C867o088Jzs8it0q
	 UqbMD7PuNPWc4b986KRSkkYPw/l1beOdfgMlpwzXMz8hc6Fhb9Sc6wuok1dlqEvLTT
	 osMr7upHthALWNyFX+/N8b2Z0NDJ0ZrpY6Qx+75d6LcngMGJUi8dDZPcL8GaNJ24xv
	 03RMMeBTl7tUdko4cwGDmCdeZNUY6xbhAiNc0NfH7AAJ+VeGeFWq9tjhcXcX/UoQPa
	 Hk5ZvIf7UhzGA==
Date: Mon, 28 Sep 2026 18:34:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs/206: filter out csum information from mkfs
 output
Message-ID: <20260929013449.GG2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100855.2734089-5-hch@lst.de>

On Thu, Sep 24, 2026 at 12:07:45PM +0200, Christoph Hellwig wrote:
> To make the test work with csum-enabled mkfs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ugh, I hate this test.  But it makes sense.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/xfs/206 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/xfs/206 b/tests/xfs/206
> index a515c6c8838c..f5e0b1404732 100755
> --- a/tests/xfs/206
> +++ b/tests/xfs/206
> @@ -67,6 +67,7 @@ mkfs_filter()
>  	    -e 's/, parent=[01]//' \
>  	    -e '/rgcount=/d' \
>  	    -e '/zoned=/d' \
> +	    -e '/csum=/d' \
>  	    -e "/^Default configuration/d"
>  }
>  
> -- 
> 2.53.0
> 
> 
