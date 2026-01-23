Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179BB2D46D0;
	Fri, 23 Jan 2026 14:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769177638; cv=none; b=WEHW+2gLBLeeQ6Fz0AswznYzcy5SWHCTGvoa3WQ781RDK4TvPOS4XrNPMu78FtcI558eKlegMCnHecELWmLXJ4/3Dbs4Ch3J4GpFdKlvCMwozembK/RQ3Ivcgy0W6SkCeGOzRIHtheBv+VuFAlOEwRDQEPXWjNnj7u+bnAnzVjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769177638; c=relaxed/simple;
	bh=pUC/veZPwxl/ef5BBUf5Hj1mCvOk5R2MWBDEUFNkrS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YqiEYD27cUxKOOlBgsgIsmbru0j0fuM+IZQrxUEEkwqa+EPNBNYgigspORfgWSbHhHZSqIqi7MnZCXNrtPnnn4wrIVxrRtkEPaokTK4zR7MugH3YV1lrXfkqs4iHuBYy+ecUP9WZ5myrbKU/LQZydSnhxKU8X/ft2aXef3BgzTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A7DFA227AAE; Fri, 23 Jan 2026 15:13:54 +0100 (CET)
Date: Fri, 23 Jan 2026 15:13:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, r772577952@gmail.com, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/5] xfs: only call xf{array,blob}_destroy if we have a
 valid pointer
Message-ID: <20260123141354.GB25834@lst.de>
References: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs> <176915153740.1677852.8895419964139371863.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176915153740.1677852.8895419964139371863.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 22, 2026 at 11:03:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Only call the xfarray and xfblob destructor if we have a valid pointer,
> and be sure to null out that pointer afterwards.  Note that this patch
> fixes a large number of commits, most of which were merged between 6.9
> and 6.10.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

