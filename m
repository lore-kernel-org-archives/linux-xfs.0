Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CF6368D7F;
	Wed,  2 Sep 2026 07:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788333880; cv=none; b=jOpwJkS1wlBe7zW3sDjGMRj3d5waUSetJ+4cg7t5EOVyc5paeb+2zrBiIPQ6hu9mBargZG0rtABygbXcFJW/9Ft0+aH2KU7vxIRloHE+Qai+djrSelBPfeWh6dNveAkiKvx2EmAXTXIyWgnvuII4ov4ryQrOyIcGmf/svpMrxog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788333880; c=relaxed/simple;
	bh=KKGuc+mr6sOA4wbtlSrYMD1DCM4rh8TkxNel202cCCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AAKdqY8s1+rP30fMRf/ycfcPvEZTWnpn5QM859VmF3Smi8m2eUajnsQYf8FtcVhWH/NUVRDDO7DTcxDifi9qINd3xRNQ3NBN3y+9GngH7p1l9G8pVm15DocWpm+OJvguMMUSzhAkYTVUq39vaPyfQG6uav92CcR2KVEBOj/Qdk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8343868C4E; Wed,  2 Sep 2026 09:24:35 +0200 (CEST)
Date: Wed, 2 Sep 2026 09:24:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: fix backwards skipping logic in
 xrep_quota_block
Message-ID: <20260902072434.GD26173@lst.de>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs> <178832750794.3508131.17764052841526629326.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178832750794.3508131.17764052841526629326.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 01, 2026 at 10:49:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains about the logic in xrep_quota_block that skips
> reinitializing the ondisk dquot if there aren't any problems that would
> impede a dqiterate walk later.  I got the type checking logic backwards,
> which is the source of the problem.  Fix that.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

