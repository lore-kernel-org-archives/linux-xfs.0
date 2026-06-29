Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA287402422;
	Mon, 29 Jun 2026 12:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782736183; cv=none; b=J2mUCJAU7bq9y28+/spKsOhVlfefNVeUzqF0GlTSNf5USZGMPVr0dfzkeNwV70modo89Vjh3BOlE/yMmvGOexevdTVksmcUzb+0SXvb8oDGX1UTg4cWGS9rnNGBJTlK4kcaCoIXUTdkOBj0GV4xsABwHIr6IhZ8a+Eu+8L+Azj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782736183; c=relaxed/simple;
	bh=iuKwvg8LH6IMhpmk/3pREyTGtQALQSP+FQ22IEBECZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E+itfrM2TTMK5fRfnV/MWdaBzH2+rabd9/bCBP8pUMZdkR+CebFcERNzxuRzQy9uivs3OI7Xj+UDPqrm7Px077dH4Eyd1OFNCl0L6mfErUhZHos672Lp7LYe8nrRWUasmJv60kT5+h7SykXDqHwAMPLgrlWTyMHRyY2BEFTEJJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 47DE968B05; Mon, 29 Jun 2026 14:29:39 +0200 (CEST)
Date: Mon, 29 Jun 2026 14:29:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suze.cz, djwong@kernel.org,
	hch@lst.de, serge@hallyn.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] capabily: Add new capable_noaudit
Message-ID: <20260629122939.GA21958@lst.de>
References: <20260626114533.102138-1-cem@kernel.org> <20260626114533.102138-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626114533.102138-2-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 26, 2026 at 01:45:20PM +0200, cem@kernel.org wrote:
> +extern bool capable_noaudit(int cap);

No need for the extern.

Otherwise this does look nice an clean to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But if the security folks don't like we can live with the more
verbose version of it I guess.

