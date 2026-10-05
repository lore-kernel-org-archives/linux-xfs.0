Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98FB13CF82;
	Mon,  5 Oct 2026 12:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205039; cv=none; b=k8XJVHxuxlHMMDkW6Dy7ejKoywJWOz2am50J7zQhwH0felVBVtc6JRUXG6R/uVHfgSMtNzbMTSI50tUNFyTOlhjNgiwZsLHAxoG26HSHpAqgrqV8mMConGM4OwfbnzwNML6BSSn65sOBh5Ps/XlTojjLSVhvRoci902+49X2eqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205039; c=relaxed/simple;
	bh=2kT5Fyy4+aMJUyfzMYqi2O6k6QwA/ncsnDvVthXVltM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pzuknCNzq0zmi6p0lCGQ/qRSzqEX8u/h4J14/yiXHS97Te1f5+fOst772V518ImrvHEfiEB8dnUqn03KiUMvlUWBnrjIGyHtf6H4LtQDzSW6ny4L/1GT5gjzvwTuajLZTWac1yt9SID3ySDEYXa1XYku9DmUY1S9C0Nd4AxfF9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zxCrMc7d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zxCrMc7d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZMYvSSuErJ8eWjPhFkMYw7fI6alXRrmGOy5umAdtGYc=; b=zxCrMc7dS5kVzVIbzsmgg6GH4U
	TFkNTzGvsk+BmBVul8GDf3aYvqim9qcagABPvgbxOv24ZY67/c6pu9xgmJ3qJk9UEtXPpmxJzn+MK
	J+PR4owyoMYci87diWuJ3cn28ARSJwADJmYRRW1OEotcv89Q2j27IPhADjmyuGkDQr++TXm3HnNI8
	kXU+gsRNoyWY0gA5aH52EJmPaQn6yhMBzyKBk+DL3IeV2mY72I5iQF+KUev6TDAF83ol3Uq3pN1eI
	Bhh47B30zwkpvg856MV9fNA3qPSMtMKrN05xum4fJ7tgrQiFCrm7QdvKQImj+2rz4FSvZAoNSAFbW
	4UXW4jTg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDiFp-0000000GR97-2bJu;
	Mon, 05 Oct 2026 12:57:17 +0000
Date: Mon, 5 Oct 2026 05:57:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] common/xfs: add zoned/rtstart info to mkfs filter
 output
Message-ID: <asOerXtPevsUCxRt@infradead.org>
References: <179060965752.790984.3511820348115861306.stgit@frogsfrogsfrogs>
 <179060965805.790984.4333974916537243304.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179060965805.790984.4333974916537243304.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 28, 2026 at 08:36:27AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A subsequent patch will want to be able to extract the start of an
> internal rt volume from the xfs_info output, so add the necessary lines
> to _xfs_filter_mkfs to transform the output into bash variables.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

