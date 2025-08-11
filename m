Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847FE23B613
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 10:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754909075; cv=none; b=jIgswFBeSsfC26ecqTawXqBXzXfXTcgjm59Gf2E519ORGbArmUSeIcuv4asjDH8YNN9CE3RBG/cuZFPEv8wba4F2pLN+7Q62StYV1mleeUbKLsfpHCwxtm29hz9yWFMmQg6uUAHp/WhS+9vQ2ZhfuK7jStHo7ijjPsqMxRpMUUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754909075; c=relaxed/simple;
	bh=k+ih4hQ8xPnlkeQwWbp/AF82hbQ7kRCmfiYWKPXaHHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JOmjBRtj47N7XVSH+YJm2PgvT96QnBw8r9a0vz5j66WjtvX+mndjvi3Fe7JGTo92W1Dk9HiUOZr9rUIyhYE0Vr+B6BhZtZul2BOl9shFyBer/X6GjPepndKxDxAD0BEBhtsAaTXvcf0G6cztW4CMh110205/H9mFrAxHr0OjLWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5CA81227A87; Mon, 11 Aug 2025 12:44:26 +0200 (CEST)
Date: Mon, 11 Aug 2025 12:44:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: Improve CONFIG_XFS_RT Kconfig help
Message-ID: <20250811104426.GA4514@lst.de>
References: <20250807055630.841381-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807055630.841381-1-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Aug 07, 2025 at 02:56:30PM +0900, Damien Le Moal wrote:
> +	  This option is mandatory to support zoned block devices. For these
> +	  devices, the realtime subvolume must be backed by a zoned block
> +	  device and a regular block device used as the main device (for
> +	  metadata). If the zoned block device is a host-managed SMR hard-disk
> +	  containing conventional zones at the beginning of its address space,
> +	  XFS will use the disk conventional zones as the main device and the
> +	  remaining sequential write required zones as the backing storage for
> +	  the realtime subvolume.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
