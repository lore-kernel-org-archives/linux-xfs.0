Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4041DE2AD;
	Wed,  7 Jan 2026 09:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767778577; cv=none; b=Yuiq+zcLjnFtiNiMn494WWlUe8x0qglogbQH07qRjwWHkP1AclTnmoHFXlotFbVlBhwTLvXEgZ32wb6Fnw9LMoWoDBs4t6cNFTWhcm6GMObr/o6KpKDTuw2C0EASOU2CmtvNNRTKMNRki3SgFRzilvl8FVEG+Z1CgnejqEq3qUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767778577; c=relaxed/simple;
	bh=M+i3R+fH6m3sK7SeYRSBBTe3fuiMdx7t79dO1fxkW+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P6F4HhaEmRikeFRMrO+xMSn7WLlyOVjH+Wvtjv1YUOp+nUbZoQNnouLCFrdE8dA4QcIGonunaLU9IikMAPJQ51ayQGDZeESh+7xYU+3dhkLmYgJOkR1VRfX5cs+xqg64VRzBOBZ1ebCezVsH64YOUrweBl5QpZacUZg4gWDxlMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 481EE227A87; Wed,  7 Jan 2026 10:36:11 +0100 (CET)
Date: Wed, 7 Jan 2026 10:36:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: add media error reporting ioctl
Message-ID: <20260107093611.GC24264@lst.de>
References: <176766637179.774337.3663793412524347917.stgit@frogsfrogsfrogs> <176766637485.774337.16716764027357885673.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176766637485.774337.16716764027357885673.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 05, 2026 at 11:13:29PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a new privileged ioctl so that xfs_scrub can report the media errors
> that it finds to the kernel for further processing.  Ideally this would
> be done by the kernel, but the kernel doesn't (yet) support initiating
> verification reads.

FYI, I'd much prefer adding the kernel support than relying in userspace
doing it, which will be hard to move away from.

