Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EB83714E
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 18:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fZ1Rs+Vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD652C433C8;
	Mon, 27 Nov 2023 18:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701109658;
	bh=SXw3JQDvfGtTxKyzB9B10XIHjsrobT6sLLMy+GvcxhA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fZ1Rs+VmUuBuAH7+KzTPke51HlP2CcvWuBlg4Y7zIu86BJgpWpBHGGxDmgmmKgrkS
	 ERVhL+P8QV/A8qHXDW0LSfz9wxDg4cQb8PQ4/KgVblSkp3pyWyypBxFuEgAGzVqb84
	 ZGcdR53/0uLrBxKQ2BAYRGrbhtaapSmEMKyyswo33n3E4XIw0XJRRCHORqRpo2D+S7
	 y+zRssvB4+uDWkpQrbbVX7fW28a2Ta6dxzt7nci8ukc46TLSE1oPetq7xRDZTNOW9F
	 Dh7smc99ay41TO2IcVnkAtZ9EJHURZ/4qIzDnGGSfjfias2E46OZl9ROeSHezW6iCo
	 Gang5kG+FQSMA==
Date: Mon, 27 Nov 2023 10:27:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs_mdrestore: EXTERNALLOG is a compat value, not
 incompat
Message-ID: <20231127182738.GD2766956@frogsfrogsfrogs>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069445376.1865809.6391643475229742760.stgit@frogsfrogsfrogs>
 <ZV70YNvPWauYckC4@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZV70YNvPWauYckC4@infradead.org>

On Wed, Nov 22, 2023 at 10:42:40PM -0800, Christoph Hellwig wrote:
> On Wed, Nov 22, 2023 at 03:07:33PM -0800, Darrick J. Wong wrote:
> > @@ -280,10 +278,8 @@ read_header_v2(
> >  	if (h->v2.xmh_reserved != 0)
> >  		fatal("Metadump header's reserved field has a non-zero value\n");
> >  
> > -	want_external_log = !!(be32_to_cpu(h->v2.xmh_incompat_flags) &
> > -			XFS_MD2_COMPAT_EXTERNALLOG);
> > -
> > -	if (want_external_log && !mdrestore.external_log)
> > +	if ((h->v2.xmh_compat_flags & cpu_to_be32(XFS_MD2_COMPAT_EXTERNALLOG)) &&
> > +	    !mdrestore.external_log)
> 
> Nit: overly long line.  Trivially fixable by just inverting the
> conditions :)

Hmm.  Or I could decode the ondisk field into a stack variable so that
future flags don't have to deal with that:

	compat = be32_to_cpu(h->v2.xmh_compat_flags);

	if (!mdrestore.external_log && (compat & XFS_MD2_COMPAT_EXTERNALLOG))
		fatal("External Log device is required\n");


--D

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
