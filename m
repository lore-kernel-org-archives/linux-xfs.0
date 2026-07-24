Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B91E317155;
	Fri, 24 Jul 2026 13:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784899413; cv=none; b=kJFM7c4JVs9STGwBZWD4YALByVwTLx/Bsn9xZvl/W5vLfbLWmcdrB1uhKqud/HnadNYteRPBzLDrmczb35FIMU8qoXhHOMesH2EHQThtzSibLMb5L575Qr3qMNOwJodzJTIDppOEORCah10vVRKVUl2e1jT0uP/ylhr2BxtTV6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784899413; c=relaxed/simple;
	bh=vNFf+QHJ46LQcOjrl8e7Ax2FD6tPtqDoQ/xsZgA5PEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vn+E9Bi6Lzm5Gvx93KvU8dz/Hc+O15SY35qtF6OQqLi8L+gtltZyf83KBrfIad8h4J8/SSv6sW7aNJh15q8J7BMEjcHCuTVA05OjxQ8EsTDstvnXxH+Nc7/kleKsG1D8FCP/fqhJPkHU1jIs3aKIeV4Mbgot7hOAD5GGwwNrF1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2024E68D07; Fri, 24 Jul 2026 15:23:29 +0200 (CEST)
Date: Fri, 24 Jul 2026 15:23:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: don't double-lock when deleting a
 self-referential directory
Message-ID: <20260724132328.GB28170@lst.de>
References: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs> <178487405420.3442778.11716685055970529363.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178487405420.3442778.11716685055970529363.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 23, 2026 at 11:21:31PM -0700, Darrick J. Wong wrote:
> -	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, sc->ip,
> -			&resblks, &sc->tp, &dontcare);
> +	if (sc->ip == dp) {
> +again:
> +		error = xfs_trans_alloc_inode(dp, &M_RES(mp)->tr_remove,
> +				resblks, 0, false, &sc->tp);
> +		if ((error == -ENOSPC || error == -EDQUOT) && resblks > 0) {
> +			resblks = 0;
> +			goto again;
> +		}
> +	} else {
> +		error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, sc->ip,
> +				&resblks, &sc->tp, &dontcare);

Kinda annoying that the resblks handling is so different between the
two, but we'not going to fix this right now:

Reviewed-by: Christoph Hellwig <hch@lst.de>

