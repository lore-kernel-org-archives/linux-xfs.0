Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5F63947A9;
	Wed, 25 Mar 2026 08:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774426005; cv=none; b=dFNvodc5gHkDWhxgwoHOYg0OEW8cR5sC9X1rsWerqt8hZF8KdCVdoijrmB8Dd06oEuWmdLd+N/vdQLRIgqbluDSoI4N2M87QAmioSaHUlQ8UHYTcHtWv17V9TkgGvyks12owqx8umrrdoV9EHSYGrj/9GFLOwKD2crPRItmJxUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774426005; c=relaxed/simple;
	bh=rNL6GJd5Q5tmhNn8On5YLiKnN15MDWCklKjJxCXufAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/8fAyzND6D/FgRhI7y00R750ltNOJ7XJDoPh20ek/QjxRup7LHx3cap098cGUMx6gQ6m7G7A5xl91KAr/kaXkvI/FoPM1lmvSsSalUuzovAiEuY/kjSvQkemDZAMLyIc0XFprwdZAUg39yVBP8Jhj7IxoM9FjV1yb80I8hzN8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AC4C968D12; Wed, 25 Mar 2026 09:06:41 +0100 (CET)
Date: Wed, 25 Mar 2026 09:06:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v5 15/25] xfs: disable direct read path for fs-verity
 files
Message-ID: <20260325080641.GL952@lst.de>
References: <20260319170231.1455553-1-aalbersh@kernel.org> <20260319170231.1455553-16-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319170231.1455553-16-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 19, 2026 at 06:02:02PM +0100, Andrey Albershteyn wrote:
> The direct path is not supported on verity files. Attempts to use direct
> I/O path on such files should fall back to buffered I/O path.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

