Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2182E1723
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 07:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756280192; cv=none; b=AN/xNWBdnTBqqfplai33I5Rs7MhwqQeM2amP3uN+OPMhB3CfHya3l7bYfXAWh9NszEpCqoPxM6/fZcoepKFiuppgYsx9oSZnpDcWgcaSa9asiOgBIHNoNMdXdL7EuDrmcsH9hOrtOo+Onz9+2U5yzLVLfCzpiaEYDZit67Anb10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756280192; c=relaxed/simple;
	bh=pjoF9dBg+Z8A239Ho8dS2/dPjT72t8sv7P4yS+xIH04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I1eU/ZWhOeoSNvG6va+KsxlXtdf0RQRg+qMUlU49hyy6A1E0Gd3LneIn4IOxK+eqSIqgHqZvsYJXXTJ55765r8AHJguNb21MUIjlXAy0K6jV1afTpEnCQYJUwycO4lxvzBnbnWEcSN++cQ8nEuuhoDuG3N6C8txx89mIOUgzLDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6810768AA6; Wed, 27 Aug 2025 09:36:24 +0200 (CEST)
Date: Wed, 27 Aug 2025 09:36:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: implement XFS_IOC_DIOINFO in terms of
 vfs_getattr
Message-ID: <20250827073624.GA24895@lst.de>
References: <20250825111510.457731-1-hch@lst.de> <20250825152936.GB812310@frogsfrogsfrogs> <20250826131447.GA527@lst.de> <aK3neNcY1vA9lubz@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK3neNcY1vA9lubz@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 26, 2025 at 10:57:28AM -0600, Keith Busch wrote:
> Not sure what to say about this patch right now, but it triggered
> a thought: if I can successfully get filesystem and block layers to
> tolerate the hardware's minimum alignments, how is user space to know
> it's allowed to send IO aligned to it? The existing statx dio fields
> just refer to address alignments, but lengths are still assumed to be
> block sized.

Length as in total transfer length?  Nothing in the block layer or
storage interface will allow you to do sub-sector transfers, so this
just won't work.

Length as in segment length?  If we can support that we'll need a new
limit for that.
