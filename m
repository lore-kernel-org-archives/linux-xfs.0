Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7093431717E;
	Wed,  1 Apr 2026 06:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775024910; cv=none; b=dXgy3FNKlc/5BbNfADId3zEnPyELhcJZiYfu6OkoQ9ABoSak0HvNW0FS4gHjqeO9+UvMl+a1d3yr5Vq9ER4APaeli0XSQOijT+UJ33z2zF2q2EdoMcD2nFRPdmSGY5tqmwioHGPfRGyCP7qSJWgSE0nwSRfkC05q++6o4Jg/QkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775024910; c=relaxed/simple;
	bh=4PVgZsRzb1h+Cnl6OsgEmbFKQiZlUNPk5oZMk0BoXbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C7NtoUs1kfwdM0RRCnJC2HSjFFmJlJwlMEpKjawL562d5rsIb0zyIREy8aC2+QFbA11bJS0GsyV17IN0VykxBPFQd3rjPcTb9rmSkjj/yKCCjfqOCeydWBoY47RyscS4GNMnRN/Vc/9Altd7AJxTI8w9mrqedyebnUppYOFs9ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1E16468AFE; Wed,  1 Apr 2026 08:28:27 +0200 (CEST)
Date: Wed, 1 Apr 2026 08:28:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 06/22] iomap: introduce IOMAP_F_FSVERITY and teach
 writeback to handle fsverity
Message-ID: <20260401062826.GB24459@lst.de>
References: <20260331212827.2631020-1-aalbersh@kernel.org> <20260331212827.2631020-7-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331212827.2631020-7-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +	/*
> +	 * fsverity metadata is stored past i_size, we need to read it instead of

Overly long line.

Otherwise looks good.
