Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FF312C486
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 05:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718946490; cv=none; b=ca8IugLIeFmg2EQprFsr0f3rgiuFqG98zISukxBZ4GTjw92LfGM0gJsKp2Fc2LjqSmwfwrAVsm9cPO/f+kyowcmeLnVG8whrab13RitdE4eChN0wPzt8CpOlaKqXljqNGYmCvGKLagcFC1528qwnxTx2k7UQ2b1vDIPrMoWy8TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718946490; c=relaxed/simple;
	bh=k0ZSefOXzEoZMEX+3Q+K5y+jbNNGdNJnsr/XPSKajeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s79yALWD50fv0OPQSZ9Ah4fR5FH5ZP7U8Xo7EKLQZGcr3WlBmQLoeOWJ9DUpxdR8M/gKUaE73CqEUBcM58UMFqRDDqPfQmnstVu+At+pcXUFU1Ph77oOJ+BV+HEMbB3csX1v/rI1XW4SAHTTRxjBh2Ua02Avmly+2au+ubJaFx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 508A568AFE; Fri, 21 Jun 2024 07:08:05 +0200 (CEST)
Date: Fri, 21 Jun 2024 07:08:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: refactor __xfs_filemap_fault
Message-ID: <20240621050804.GC15463@lst.de>
References: <20240619115426.332708-1-hch@lst.de> <20240619115426.332708-5-hch@lst.de> <20240620185406.GB103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620185406.GB103034@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 20, 2024 at 11:54:06AM -0700, Darrick J. Wong wrote:
> Oh, hey, you /did/ split the dax handling into two helpers.
> 
> Would you mind renaming this xfs_dax_read_fault since this doesn't
> handle write faults?

Sure.

