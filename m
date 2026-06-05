Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51069242D65;
	Fri,  5 Jun 2026 04:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780632498; cv=none; b=LLEHEPadqHbIqBnhiSC6Wl/VuTaXvtn6gmj1K9kZu8lEgKv2GTrgQ4fPsDHE47m1Ef43goFg4NdOZI8V74CKPNxkfXixv2T4d12a/FyQKIhvmQfS+ujxpm3m6hukLNg/orFzIZq4qyz58Bmy4KB3usKpo5Jpkb2hOp+DlObY8aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780632498; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SO24FYnB3Ul8jIcgDeeLHSrXDBOA8vQmfE78Qo9fDHGmNcIZoxiPj7CrhpbM7ckTMKFYmR7ggI+YYIarYFHoeYZ555A6EChBK8GsrEQvVusfuPHdLnGpcf/8NkjpnafeTtrSrlUna6r+vAIQSukHnQ3LjOd3wTGz3/iWnbKPDZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5F2B468AFE; Fri,  5 Jun 2026 06:08:07 +0200 (CEST)
Date: Fri, 5 Jun 2026 06:08:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] common/filestreams: check zoned device before mkfs
 with small dsize
Message-ID: <20260605040807.GA23963@lst.de>
References: <20260603052706.349877-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603052706.349877-1-shinichiro.kawasaki@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

