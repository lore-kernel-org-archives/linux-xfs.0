Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412B22F616A;
	Tue, 21 Jul 2026 04:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784609361; cv=none; b=VY58YMiX1NfugRxhuj4kdzixPO4FlFVm42Np9+pjdRJmhicwpfND31VEhtLdWh62YZ/lX4SFPphyhvVeEvNvCUAZQJPYJ4rvdqcE4UrjyNPBXyfBNz2wR75O1vPjzAvXCMV3jA1VjP8afFnzCit6MqrbuxjQfCfFM+7JS66xgwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784609361; c=relaxed/simple;
	bh=zBM0T/CPwwUwNSwFMTRM3OLAwn7YdZjiyu6BYqDinr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jRzxL8ER5l3jFUh88so3nrNC5BL+xYnhugLOf6yTV46b8NoPqpAzTIfh7SX/j0t5eaoh5hJ6U2KrFNa2xllgE01xgvVljE4HNddWGzCEGI57N7nYDHUfmOF1tpKCSnFW8MNdQqAlRANVrg8vc9DY+XIa6DKFKTAsK/WNoIir3ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8D29E68C4E; Tue, 21 Jul 2026 06:49:17 +0200 (CEST)
Date: Tue, 21 Jul 2026 06:49:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: test unlinked inode list checking and repair
 with loops
Message-ID: <20260721044917.GD6644@lst.de>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs> <20260721034105.GX7380@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721034105.GX7380@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 20, 2026 at 08:41:05PM -0700, Darrick J. Wong wrote:
> +# From the AGI definition
> +XFS_AGI_UNLINKED_BUCKETS=64
> +NULLAGINO="0xffffffff"

Oh fun, on-disk formats in bash :)

The tests themselves looks good to me, but by now everyone should
know I am not to be trusted on advanced bash code..

Reviewed-by: Christoph Hellwig <hch@lst.de>
