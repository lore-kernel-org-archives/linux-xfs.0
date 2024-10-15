Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478EE224D4
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 01:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728954354; cv=none; b=cHkqZiCDfmgZhdk0q7z/+lXGsA/xkFdFqsUlUU21kSvdkUxGJAiv0opIfuBMtF472wM1lSeMT/z1ZYlmAokQnOY3Mplk3oxQlSJYS+ll8tvW/t8fW+g87CeDryGSEU/YDISzEsxoNZ+8q0cisBKx/PmD3e+FcMOpF/zo7phrKOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728954354; c=relaxed/simple;
	bh=dm7Q4g3dIGDqjdnbApibKhE14rNNA0KamzCQJUkZqpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KPXcsneGF9HEN+/w5MehUTsfCxtRxje8KbwJ9c4DyB5pM22Y3wZPsVslGYuNi2m2UjTvUdxvsWXPHz+P+PvWaa+l99DcIHREoMDkWeRf0QaW9zF/JRE2WwNBHH1/yGak2taxWowZdKI1dKVnAC1/OxTqdrfxODhNVBVukh5F4wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XLKf9/oc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XLKf9/oc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0C6C4CEC6;
	Tue, 15 Oct 2024 01:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728954354;
	bh=dm7Q4g3dIGDqjdnbApibKhE14rNNA0KamzCQJUkZqpI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XLKf9/ocgH+1bnp4RTqLGjpjDihPdOHjKTijLEeSZ/M/lT0zLXEZHYqeh0wcSH49R
	 AorTh0DRlkEScO6laiIV+8Gvws1Ooqooiei8cjtJXeoIZaQFrpVEeNZRmXDF6b04jo
	 vDJLffCVOiWPPsyr+jzCcG688cIQ26nvixb4rMZ8ZmSfUmcerf0xeP1sItdeHkpzTh
	 +xtl8Y9s1txM0xssE5lWf4WPyKazjp8AoFlN60uho7hEElUKXPArjpbkP5UAIMbFxK
	 Zv5S7POOBg9hN0ZeBMfo2zeO4hODg+Kolla70ix8DRzFWRY5a2Sa1zBy+3HRdJJ23E
	 Qj7JQi8+yZ8vA==
Date: Mon, 14 Oct 2024 18:05:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 02/16] xfs: factor out a generic xfs_group structure
Message-ID: <20241015010553.GP21853@frogsfrogsfrogs>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
 <172860641288.4176300.12597066672597648144.stgit@frogsfrogsfrogs>
 <Zw28ugUCTXtRLFWS@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw28ugUCTXtRLFWS@dread.disaster.area>

On Tue, Oct 15, 2024 at 11:52:10AM +1100, Dave Chinner wrote:
> On Thu, Oct 10, 2024 at 05:44:42PM -0700, Darrick J. Wong wrote:
> > @@ -232,9 +276,9 @@ xfs_perag_next(
> >  	xfs_agnumber_t		*agno,
> >  	xfs_agnumber_t		end_agno)
> >  {
> > -	struct xfs_mount	*mp = pag->pag_mount;
> > +	struct xfs_mount	*mp = pag_mount(pag);
> >  
> > -	*agno = pag->pag_agno + 1;
> > +	*agno = pag->pag_group.xg_index + 1;
> 
> pag_agno(pag) + 1?
> 
> >  	xfs_perag_rele(pag);
> >  	while (*agno <= end_agno) {
> >  		pag = xfs_perag_grab(mp, *agno);
> > @@ -265,9 +309,9 @@ xfs_perag_next_wrap(
> >  	xfs_agnumber_t		restart_agno,
> >  	xfs_agnumber_t		wrap_agno)
> >  {
> > -	struct xfs_mount	*mp = pag->pag_mount;
> > +	struct xfs_mount	*mp = pag_mount(pag);
> >  
> > -	*agno = pag->pag_agno + 1;
> > +	*agno = pag->pag_group.xg_index + 1;
> 
> Same.

Done.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
