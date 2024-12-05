Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040FD239181;
	Thu,  5 Dec 2024 06:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733381189; cv=none; b=ao+GbNdch/Zf+AOi+v3vwt0R42pmez3FghjfhKdBl3ot0hf2VJlstvJTZUt2h3j7Nxptb4DtA6izD1+ELXbErzFfKo/9nlJ9TvoFwUv5ntSohjYGcvPwnOWzGc5X9jRWy2wCnt1bgqej4m9McVe9iKvWLJxjq0PcvmzgKKsLXFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733381189; c=relaxed/simple;
	bh=/rEaOtWzg1jLzqaMNI0AMm2LCZBoMNJy0XEKNlHUatk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oU6EDgXPvsgF9CDrTLNZjeF49xcTApf56DNyEg5mC/pqHubXOupLdlPH5CfgQietN2fmzqq+tHvJXYaNc8rojo4ghihwrdzEnnfYuB8aCGpd8QGCTPwYABjmin1/UQDF8THxz9CjX6tnzvx3UvZrNNEv4wrkkyiCtY2I+bB+Btw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ig+Y8/R8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ig+Y8/R8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mEdCHMysbLAJBp5pZwh1kS1dGokAs0KWR/dNXpXrync=; b=Ig+Y8/R812zi1TKQUZQVMXoykd
	y/B3nTTnnHmVjC1LnIzz6OKjnMKUeTq/ijATrcfHkmOMJtx7FNN9t/K5jnRMuJEpqavuk1/noiIac
	fcCpf6dSlf8sIfOhrp2yCc4OTd0OQj2wzkcYHE/NOEt8+CdBEUTVux6pNAB8WViCha14Q8Q3Ixph1
	RTDe8n7pLN7R7uaG7mrOipKvnCMEl2tF4/fYAEd4saBCQ/TiOGYIaDmdJ/NUjaOcCgCOqElzOJaDh
	N5/mx8AAiikV7vg6hX+7otCdbfhP5MOAmTbsG7ZnlSQI6BDYgcXfGOZvOKTLEgPBA8YWkEv0g1D0Q
	aZgjBTSQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJ5d1-0000000EvF3-0q71;
	Thu, 05 Dec 2024 06:46:23 +0000
Date: Wed, 4 Dec 2024 22:46:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/6] xfs: don't move nondir/nonreg temporary repair files
 to the metadir namespace
Message-ID: <Z1FMPzO9DX9YKTmx@infradead.org>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <173328106602.1145623.16395857710576941601.stgit@frogsfrogsfrogs>
 <Z1ARxgqwLYNvpdYS@infradead.org>
 <20241205061450.GC7837@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241205061450.GC7837@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 04, 2024 at 10:14:50PM -0800, Darrick J. Wong wrote:
> The function opportunistically moves sc->tempip from the regular
> directory tree to the metadata directory tree if sc->ip is part of the
> metadata directory tree.  However, the scrub setup functions grab sc->ip
> and create sc->tempip before we actually get around to checking if the
> file is the right type for the scrubber.
> 
> IOWs, you can invoke the symlink scrubber with the file handle of a
> subdirectory in the metadir.  xrep_setup_symlink will create a temporary
> symlink file, xrep_tempfile_adjust_directory_tree will foolishly try to
> set the METADATA flag on the temp symlink, which trips the inode
> verifier in the inode item precommit, which shuts down the filesystem
> when expensive checks are turned on.  If they're /not/ turned on, then
> xchk_symlink will return ENOENT when it sees that it's been passed a
> symlink.

Maybe just write this down in a big fat comment?

