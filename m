Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E414C0428;
	Thu,  2 Jul 2026 14:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783001070; cv=none; b=D8uctOX53hhwUMiKR7XlPioJ5/zGZd1o72e0z99P0mhd03vKUm2coiz0nGlDu9u+3C8NYd7Idk9fKqUKzBlPu3ztbgH9ccF+K8Vho0LzwdqVlfobJ5GORiytdDdbfotasV5R0f2XAwrqgARk0YRes1UpH0xMEM5p4avuOOjdE8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783001070; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jqKqWwgJuwhUc1rwVXTvHWmQZjfSlxhx6WGdAvlWURs7cFcdZqIVOgHtp0LIxrrKV8thM7Sz5G8KpUdzPEcy1XJNQktiFXvsq4Xt4oleKtk3YrLPRFLvagbyRojnlnEt+ECAJbSa9gtZ0+1vvnnvX4P4rmo2Xyf6/kEmiV3NUcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1A10068C4E; Thu,  2 Jul 2026 16:04:27 +0200 (CEST)
Date: Thu, 2 Jul 2026 16:04:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 16/18] iomap: remove ->iomap_begin()/->iomap_end()
 legacy path
Message-ID: <20260702140426.GD21339@lst.de>
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <20260701000949.1666714-17-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701000949.1666714-17-joannelkoong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

