Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1471A19644C
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 21:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727903776; cv=none; b=pxqleqAB/gab4IK1ahe1C7IEgNxMf5wbzj1nPNksgE1hpeE88vv3RC+o8fRE5awAeEKl9NnSkNU2rM17eWx8XdVoGmWKKDhgbXrbH9LTz7702n7nUgtp3mcN2wyKFXevHVynjOgPuk55AiHbt9FfALZC6XSLwbL/CockSwmw6QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727903776; c=relaxed/simple;
	bh=t9ihEvTnEhIkTDsJ0l417L1F+oOsq1xpgwTQ7r11Enw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WUHpAih2gOEn8PqLXd0a6D2NO6oLNOXyG+h2Hgu6hAP0ckkRQ6YXkZ1PWEbQUhcSuE1cxEEsUWJc6DMSq+NUG7Kwdx1bKCX1K5pRFK6tacdqno2vD6WE5//GTx+rY7i+58y9Ktjg1t8PAmXn5nc444VcsHm0O9GQEmKaoWT/pTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gLpDSMZ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gLpDSMZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8579AC4CEC2;
	Wed,  2 Oct 2024 21:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727903775;
	bh=t9ihEvTnEhIkTDsJ0l417L1F+oOsq1xpgwTQ7r11Enw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gLpDSMZ9BT1x2hTflifaRfY9JPCJuMnFny0n5TBVyZjH4CWf2BMK9GbUfvPnf2YUR
	 sZanL+h0b7nQcfFL5Q4s+bE2/hLx2Lv8V3JqE71FaRq0jP7JUdzq+LSHvoa1lNWuR8
	 D0hyD+VTXkmoE3ytt2R1Xpa6a/t3RCtm/QV/al1zYOVjv6EmQ8Gq7DV8Fd3sizezWl
	 4Ihtm0DnpOj+Oylb6ohTbzLi6xgY/Mx20eByMaqRpqlKuxNRrwgzGN4sivtCJX0StZ
	 KNDzwli7NKBXbwVGCBK1KkNltVcU+l6QISFzM2Uu0uYqGqcCnkgx83s+rUEb4bdQp4
	 Z98/pWwIsy30g==
Date: Wed, 2 Oct 2024 14:16:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix simplify extent lookup in xfs_can_free_eofblocks
Message-ID: <20241002211614.GE21853@frogsfrogsfrogs>
References: <20241002145921.GA21853@frogsfrogsfrogs>
 <Zv1ilUMwSOVeT1Q_@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv1ilUMwSOVeT1Q_@infradead.org>

On Wed, Oct 02, 2024 at 08:11:17AM -0700, Christoph Hellwig wrote:
> > +	if (ip->i_delayed_blks)
> > +		found_blocks = true;
> > +	else if (xfs_iext_lookup_extent(ip, &ip->i_df, end_fsb, &icur, &imap))
> >  		found_blocks = true;
> 
> This could be simplified a little bit by doing:
> 
> 	if (ip->i_delayed_blks ||
> 	    xfs_iext_lookup_extent(ip, &ip->i_df, end_fsb, &icur, &imap))
>  		found_blocks = true;
> 
> but otherwise looks good:

Oops, heh, I thought I'd forgotten something. :(

V2 soon, though really there's a pile more fsdax corruption fixes so
heh.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
