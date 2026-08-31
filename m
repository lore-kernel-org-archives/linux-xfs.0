Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFC03BFAE7;
	Mon, 31 Aug 2026 06:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788159289; cv=none; b=bOmOHD7AvqUFzNbKdW95CnAoG6Kb7lEuHkHDOpERPoU2Rw1goQ3awtQZYXEtrXXT0HG4l4Ck3jojxWlMBejWhkLTqGKsV39m7B2mUDMJecNZYfq2m/AEEMkrb+ZdmqHUHMNTXiGW1vvxXpu0xaWaiFwttGEdfjboShCuHMYZ2k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788159289; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rPRBdkDfBkJc3OkYe9E/IwPE/MpbXgguIZWzfAZ+yRdbz27tT/pT7kZUZN40KHnHdf2c41ZJmdBtBFSDKydxFmuCdUp2M/XwOMYMdFzeVAPISB2/v3eQlGsapmgND92TD1Y5NK794jeZfn4xikLPgUdb4RcXi4/h5tImvRa3Nzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B055468BFE; Mon, 31 Aug 2026 08:54:41 +0200 (CEST)
Date: Mon, 31 Aug 2026 08:54:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: always set xfs_healthmon::first_event when
 inserting at front of list
Message-ID: <20260831065441.GB24602@lst.de>
References: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs> <178780640604.3528467.14704360442661766846.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178780640604.3528467.14704360442661766846.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

