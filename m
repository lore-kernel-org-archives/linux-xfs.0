Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1E5129E93
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 19:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719949778; cv=none; b=N/0bEOo0eKfTrflX1Nlg//4vCqHvZUv4SJPPsHoCdRyY7EhQZA5sndtPedCnTb4lnNDNX4/UHf/xvIdobbrLdGvw6kKH98XbaRJVamKyxeQPbynuw5g3iIngo8/y8zrS/m4s5pItK9ZPt1Zc74thtkXKHyOeo80vXlbE0XTOHdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719949778; c=relaxed/simple;
	bh=o0d8k/Tw9ViTf4Mm2SPbFR3UQ0orkT65HEL1kWdRXUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RSuc4ol/G3APGuXnF29sRbxHtxD+0ZeCXZ81fotKrQ1pI2oJLQ9e5goGqW2+FdaCQZHSCxUiGX4ITWzdwvg8pHnAK1uJEjqume8mYhjVeQnwY+Kb05LD0l9w7ROa32oQn8y88Ixkfk8/Ldpv9GxMWhXN/+Cf4pzJxtsts30/A3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ofl7pHjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ofl7pHjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E348AC116B1;
	Tue,  2 Jul 2024 19:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719949778;
	bh=o0d8k/Tw9ViTf4Mm2SPbFR3UQ0orkT65HEL1kWdRXUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ofl7pHjMIkaQLc8+sfLcypg7JxUHmdjksSHVSmcR8OEIoRJ1wr54ieTDHW43vS8yz
	 BaYemTnjKRcdDT70VO149BM7q5jNOYlYqz11aaV9VjvaSyfLC/26RX5y0Dv3yI+LWe
	 gcsq3J3zLZxZDKRro4HVf9dJI1gEX8mrL+zBJSIRpyppL0anLwYWYDxkZzQRug/TPw
	 khqvqxxPLPD+89hooO/QRDow+kovuvE2OKQh3r/Xux/rFCtjxtFlHsCsPJaFaKZgoT
	 uEGzCEt4ZuHteF8muHHauuAOJox3RPbauk/wQguqlq9kiFrwJQ2UjUBG8FvwfB3PGK
	 cnUZK1vTTND6A==
Date: Tue, 2 Jul 2024 12:49:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs_logprint: support dumping exchmaps log items
Message-ID: <20240702194937.GO612460@frogsfrogsfrogs>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
 <171988116801.2006519.17657789199852782439.stgit@frogsfrogsfrogs>
 <20240702051154.GF22284@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702051154.GF22284@lst.de>

On Tue, Jul 02, 2024 at 07:11:54AM +0200, Christoph Hellwig wrote:
> > +extern int xlog_print_trans_xmi(char **ptr, uint src_len, int continued);
> > +extern void xlog_recover_print_xmi(struct xlog_recover_item *item);
> > +extern int xlog_print_trans_xmd(char **ptr, uint len);
> > +extern void xlog_recover_print_xmd(struct xlog_recover_item *item);
> 
> Drop the pointless externs here.

Done.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
