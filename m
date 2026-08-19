Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2B93CC315;
	Wed, 19 Aug 2026 07:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123352; cv=none; b=WFvoBpnw116DRrLPX2TNcu/KyxuYM59rayKNv9LtZ/YgotOn3QtW1t63CGjEMH2yEPxu2a0tKxcJUHJiIZYvZ5Ew30tKbU0OD80KSrgLZlUiR2ECgV594k4Bk5RdsADKWXeuBRUsDKl14y0HYCWppfQanxeL+YZ6II5432Ho/xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123352; c=relaxed/simple;
	bh=PtBJd/GfJ/Dp9CJrFLzYyQlbYLzNT6nJi3OI8l71ZP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S+rH2U6YjFQKVr+SsKXC0DomK3EdU2yRU9Mu75hfRP5IDsbLzVMn0ELDXLyQeR5uIo1fs3wF5P/RLToaet2/FzRrITkkXIWrtBxWBNZ3s39qTBjwAR5Rx2wE0hV6WQT8Zz0vCHLJXc4qGLKPkm02QeKRJNFtxjHmwhtSmm71Yf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 57F6D68CFE; Wed, 19 Aug 2026 09:09:07 +0200 (CEST)
Date: Wed, 19 Aug 2026 09:09:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com
Subject: Re: [PATCH v4 2/6] iomap: introduce and propagate write_stream
Message-ID: <20260819070907.GC1541@lst.de>
References: <20260717125538.508925-1-joshi.k@samsung.com> <CGME20260717125630epcas5p362b2f527ed32de9cd4d59a89bc6d64e2@epcas5p3.samsung.com> <20260717125538.508925-3-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717125538.508925-3-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 17, 2026 at 06:25:34PM +0530, Kanchan Joshi wrote:
> +	/* 2 bytes padding hole here */

I'd drop this comment.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

