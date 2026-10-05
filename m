Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B284052A6;
	Mon,  5 Oct 2026 13:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206448; cv=none; b=ZWB5g9K3O/6OLMSuguCFFWjazzPuWjmmdFMv9/bugybz67s8TN1Oz9O/YWNCrgFXxcczjzroGpxxuvrbfqivE7Cjgoi7F49J/5yEuOmlq/A0P/NCH1fJJ6IHOH1R4+Exb17nc5v+27OO3Z4VPgSHcNOC36xZSAh4LSv3o0Su204=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206448; c=relaxed/simple;
	bh=CiqDBiiWa/CfbccGVB9BQdl0Em7XP6htBbgt1iDD6/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IF8ycOhN7q/kuydUaUTQ+136doOxRtlKVNgePZ83yVUT+tv1uoWFZZyeQNHmNJFtUAiFhglmuOLVEb8SnasMIiDF8iAdgQ2vgPZA4BJfDpMwZJooFspmbFSJVzOmToy1XwT01KinX3htZMOSkUAwLzFJ5qloIfy8nqRZtIVJiug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7B98668AFE; Mon,  5 Oct 2026 15:20:29 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:20:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/13] xfs: add a _require_xfs_data_csum helper
Message-ID: <20261005132029.GJ26805@lst.de>
References: <20260924100855.2734089-1-hch@lst.de> <20260924100855.2734089-6-hch@lst.de> <20260929013850.GH2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929013850.GH2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 06:38:50PM -0700, Darrick J. Wong wrote:
> Any chance we could export file data checksum type via statx or
> somewhere?

I think Christian would hate that.  But maybe fsxattrs?
Note that the io_uring support when I get around it will implement
FS_IOC_GETLBMD_CAP, which also has this information, although in a
somewhat convoluted way.
