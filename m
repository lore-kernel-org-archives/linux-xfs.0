Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C443254AE;
	Fri, 23 Jan 2026 14:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769177679; cv=none; b=pFhb0PsR+aC+YCP3RMcZFfF3x221kW/cbNnSUMiEl0/9Mm/Q47DOjHaVk7Ddw1w+sQteJVpJvnbNZVkAi9z0QNegP5QCKjFXxAvapsfKkZkwkgleZaRaA6gB1+mVuZqzG3jKkXYqo0DhlgsZ7Imm0yXzyP3fNE5vVvtNM3zOhWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769177679; c=relaxed/simple;
	bh=lh0COwkhDGyi+ulhHaNRWA2/tKiWqHpUzaat2myrZjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SWNESE5YPeinCXcewHuNWnKER0nDSk4m091WpDDMMfejil/OzgOvj2qgPouAkh67M+MTQL3WKqNsjLrZuWHwt6k/pRsXarAcuAIjmChHx7PIDVO06Mn31VJbexwZTlumhSWKkZ4Vn7txNFxLbcy65ZwTu06yIS74hLyc4AxWfPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 42E81227AAE; Fri, 23 Jan 2026 15:14:36 +0100 (CET)
Date: Fri, 23 Jan 2026 15:14:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, r772577952@gmail.com,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: fix UAF in xchk_btree_check_block_owner
Message-ID: <20260123141436.GD25834@lst.de>
References: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs> <176915153782.1677852.511726226065469460.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176915153782.1677852.511726226065469460.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 22, 2026 at 11:04:08PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We cannot dereference bs->cur when trying to determine if bs->cur
> aliases bs->sc->sa.{bno,rmap}_cur after the latter has been freed.
> Fix this by sampling before type before any freeing could happen.
> The correct temporal ordering was broken when we removed xfs_btnum_t.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

