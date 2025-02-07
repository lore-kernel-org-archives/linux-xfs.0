Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D6847F4A
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902878; cv=none; b=FJerOMPVDXWNnSV3enLrKYO30e2f9x26b6GAptSPGqCY6aTCguBoj9py2uHppY31A+o5BzfFLHuIOIvVhNUsCfEyLVcWP1ICPRnl5Q0q4b7QQggd8OPu/p5272vIt0OpCiGPkz8fBu/x0GPjmElUBpcN2xr1KsUyAnP+bI58N7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902878; c=relaxed/simple;
	bh=tUt4EfyuK1g9HkIPQIpfaXa4VlnyNoTMZcmI/amaC+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQsnjySsxIyecYSbqOmile7UOjV25MvZC/4mIgY6MhaNN9HhBvgrtGV072dbrBSue1j6Jmvt4ZkrXaMtYAbLYSpvawv44OU0RHh+90GlJjNe4J4HzKEgTi+NUrp/LehVPR6StUifUF/OkBtGDKWQnAzmi2ljnMGhlgE+pJbrIq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N3UPqQr9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N3UPqQr9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1LRfiu5R4EXr9x5QdT9yHjcMguuU08mLS5nvKrqiOdw=; b=N3UPqQr9ydGbgVAjV5KoqS8jsO
	2irwqHaWktEXzLUu/hvS48BTkfELVyVs0wSg1FBGr2o3UWPz9+a0Z0KLH0CwnYw7NZujkKqKR2VHu
	lNglBSInpvJND5WjIFZlfYwnCoHAzSj6QSPyK25B+UDJgj6eRY64L1MZLirfwve/2lT/Sgr7TwPo7
	ix1Mo6KwKZyYUhgLZ6xWEizF08KoBzHCB5215OveOiHdjAIAzBIgKRTcggv0lgfV5GxfoVWmUa1S4
	fudsSUaqKKI4vzzoWleQu/VHAebaQtOR0Rw+/3MsduQJVvfiRsa4T+79HWNtDxirWFB82iYyNdTvX
	g11H0wUQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgG4a-00000008Ip4-3YSZ;
	Fri, 07 Feb 2025 04:34:36 +0000
Date: Thu, 6 Feb 2025 20:34:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/17] libfrog: wrap handle construction code
Message-ID: <Z6WNXCVEyAIyBCrd@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086121.2738568.17449625667584946105.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086121.2738568.17449625667584946105.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 06, 2025 at 02:31:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Clean up all the open-coded logic to construct a file handle from a
> fshandle and some bulkstat/parent pointer information.  The new
> functions are stashed in a private header file to avoid leaking the
> details of xfs_handle construction in the public libhandle headers.

So creating a handle from bulkstat is a totally normal thing to do
for xfs-aware applications.  I'd much rathe see this in libhandle
than hiding it away.

> +		handle_from_fshandle(&handle, file->fshandle, file->fshandle_len);

Nit: overly long line.

