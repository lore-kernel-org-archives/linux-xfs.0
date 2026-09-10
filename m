Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812703D5244
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 09:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033567; cv=none; b=VgoN1i+vwRl8A7loD6NiAnPgLVDtxHxEkcGlWCEDeddN0YVq+SsL4PU+hdUAysvhukc646OF5DueZA60JtJBtXBWXMRUY3eK04A1cgTrdXg5AOLRXD+mxvR8nB4IFOl3duk52PZEYp4ysJZW28KpaR/bSk2UPvB06U8LNMvMajc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033567; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u2awVB88kmlTsKgsfL/h7d+eUNqRVcejJUW9bwNGWiAOcd1zCU1j4KB6p28QLSui7sB9+iZTVj9v1crwxvXtWfQ+U54KDTuxm9ulylnNpu9Xg135vPIpZFl2GAKMS5XJlZhpvvSkYpufgNxNgjsJIzSLtQ/h9s3P8LPcMrA+7vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3D1D968BEB; Thu, 10 Sep 2026 11:45:56 +0200 (CEST)
Date: Thu, 10 Sep 2026 11:45:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: release AGFL after walking it during rmapbt
 repair
Message-ID: <20260910094555.GF5330@lst.de>
References: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs> <178901989937.361651.12871680046411144305.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178901989937.361651.12871680046411144305.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

