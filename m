Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBEC1B29BB
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 12:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724761491; cv=none; b=FIYDlyOKYer1yajIiUDH7Lzdpu83rS7qBQ+7xmpXqKFtiqLqq9uYOlFif8uZ7RVi0le2BbaO0n4L9m1U5dZSAR7KHugKGI9pTlOSfsiZ2QDB10GUhTJT/4l0KlFduXhKwRw0qeFlX9/21XNgTyvakaAZ+0VnG6HNNP58HV1dMRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724761491; c=relaxed/simple;
	bh=OrKDbHUiMlXwM5N2auszweDSa2CmfhlxdInYLSyWVYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ELkiZFk5Wcj5NyVVzVrDEwvZNYTAw+bwTw5KmCchH2Xz7jinJQ24ABHEMJOy+0Duh3wq3qI2mSD/xOeU0GkQyS7wrsXfGtifBfBtSRQObvDkhyn7CAxWTSHapwdC2CuhcIZ3fyRHV/BF//nsrhE8QjR5QGd2QPyZh438NR3ALgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TlT0WcZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TlT0WcZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA799C61044;
	Tue, 27 Aug 2024 12:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724761490;
	bh=OrKDbHUiMlXwM5N2auszweDSa2CmfhlxdInYLSyWVYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TlT0WcZHwIo9MGBd2oeHzkVceNu8KUd1lF8MKHGKEv0zjWbCMljoHJCn+GO/dtdcl
	 PRyMjiCuq2v2U+38wgnxeH5EOdgr89aiSvw/6c28wnAzVENZMILaLJ1MvH4ao58MJc
	 ZW7hjGDatVab+i4BKUghR2n97HFnSObdsHav1IRLweZae9cDW/GiU0tRnQBibF1dCg
	 ifgMR9JHK//xX3qlP9IpGuEON7pVkSxZE7LzKtGNtD2iRAsmchETjPVXSzKqwwhwlJ
	 7fj63UDMegxeeP9bMnHYTBkQ0jZ4pft7I6mG45LQjN6tV0f1B64j1PZVai0Rtr3VW7
	 lS+lJ6iKtDvrA==
Date: Tue, 27 Aug 2024 14:24:47 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 2/3] libfrog: remove libattr dependency
Message-ID: <63lsrz6ydile3ylltpzk2a2cqufv55tfkinw7gkcqjljpm66x4@4k2szxoqx7tk>
References: <20240827115032.406321-1-cem@kernel.org>
 <20240827115032.406321-3-cem@kernel.org>
 <Zs3DTPfDfQZxD0r1@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs3DTPfDfQZxD0r1@infradead.org>

On Tue, Aug 27, 2024 at 05:15:08AM GMT, Christoph Hellwig wrote:
> > + * We are redifining here so we don't need to keep libattr as a dependency anymore
> 
> > +#define ATTR_ENTRY(buffer, index)		\
> 
> Maybe add a XFS_ prefix to distinguish this from the attrlist one
> and match the other xfs_ prefixes?

Sounds good, will update it.

> 
> > +	((struct xfs_attrlist_ent *)		\
> > +	 &((char *)buffer)[ ((struct xfs_attrlist *)(buffer))->al_offset[index] ])
> 
> And maybe this really should be an inline function as well.
> 
> > +	struct xfs_attrlist		*attrlist = (struct xfs_attrlist *)attrbuf;
> 
> Overly long line
> 
> Otherwise this looks good.

Thanks for the review, I'll wait for darrick to take a look and will send a V2

Carlos
