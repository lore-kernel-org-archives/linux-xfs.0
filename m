Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6EE2931F6;
	Fri, 24 Jul 2026 13:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784899532; cv=none; b=UdRuwTcPtefugb3FnBw4Kj09GSKMpvox3xnV2j74QPLdTTL3K+vsG5NRsHqmTUdxieGZzdqF2JvfQiijeBpXMtSlQkRB5W2dVJoSgbIWYeuBHtMEkBn82s0V/rnl38V9mNcD+dKmV8WKm/CazAYGQqhFrZ7/5zJBOSHasCLlh8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784899532; c=relaxed/simple;
	bh=1chK9K/P6ZyTs8ZOF64gmADSEN7pnN7E10NksVJ2aFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R5CJZ/P4nHbqa5LfbpAidXt4fYX6MCsX8/aanlUEPj7cyCadZi0Se7wN+WhOfeeE81KNpmajSOTeVvqornyo7A91V6j+tGrm2nqbNBkvMS+tIhM5ZLYL5buOzP8kQifOSd9RlbQQ3/61qkDUH8crzu2OT45wzjhLxsXrq6hUMyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C935B68D07; Fri, 24 Jul 2026 15:25:26 +0200 (CEST)
Date: Fri, 24 Jul 2026 15:25:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: don't zap the attr fork on repair when there
 are queued pptr updates
Message-ID: <20260724132526.GD28170@lst.de>
References: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs> <178487405462.3442778.17642300701831053718.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178487405462.3442778.17642300701831053718.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 23, 2026 at 11:22:03PM -0700, Darrick J. Wong wrote:
> -	if (rx->attrs_found == 0) {
> +	if (rx->attrs_found == 0 && (!xfs_has_parent(sc->mp) ||
> +				     xfarray_length(rx->pptr_recs) == 0)) {

Hmm, this formatting looks at least a bit confusing.  Why not:

	if (rx->attrs_found == 0 &&
	    (!xfs_has_parent(sc->mp) || xfarray_length(rx->pptr_recs) == 0)) {

?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
