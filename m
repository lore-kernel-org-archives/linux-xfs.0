Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DD924A076;
	Fri, 26 Jun 2026 04:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782449544; cv=none; b=FcIuHH2r1lIgT3O+okjNJkQQFaeDJL7iksiFYSB1xMb14tUu65DtxluDBa3JxG3f11fFPNunJLjQZFo/zwUaU9xMIXFaVenOoNByd3I4Od9kjmyciu/1524nxnzxtkGni1ttM3MvR2bf7w7WMpdGsCXCAMaG2M2uD+MtVjuLeDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782449544; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XH9k1ZXarn5n0GAEgT5br2lS54C2aLuFMDM0MDW8Qvxr0SmmNhhaJ+TWEFtKczZPM5OPD8B+cMk1WQZaEWVJ7ibwBY+NrEwfHuu6YR4/bWMWNiaKNHQKGL7gI/4bNhZE+EM4afgq+cJG9sq6pf7dMe6GUgnEXAd7ReuV+YTXsnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 862AC68B05; Fri, 26 Jun 2026 06:52:20 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:52:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, fstests@vger.kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] common/xfs: fix
 _scratch_mkfs_xfs_supports_concurrency
Message-ID: <20260626045220.GE8613@lst.de>
References: <178240619625.1665857.3954516357764795627.stgit@frogsfrogsfrogs> <178240619650.1665857.270820682280764430.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178240619650.1665857.270820682280764430.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

