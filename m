Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE1A27A462;
	Tue, 28 Jul 2026 03:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785208207; cv=none; b=egH4hT9etubyHJD1JzjujGkSfTvv6KBB2DFKgOMwTy8KpssA4UqGyqRFUdru+fsS/PY7U5XjM0SDksF9Vg35a3+VkfcSdrGhy0cuQh48A7AkatUpzPyDKtcVCW3OR1fDLOMXcAaDGQqJbhFH0kkMvQruBTYetbeGUAyf8m89MdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785208207; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UCL8JCkwshvXNo4E8JPXs3BDu7XD3wPY5MKNGnyWXAKVIDJhD80/zAsG62q9itcz6Jw7vTwKx0uoMO9z7AUX4mxvsAl7M/U8p+GfKw3bzjUsU8cWWSiXo5qKvuKD8AOSCeO//b9MvnlUnUK8DlLBaf4NIYIj3/D1uuG5UI/E85I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D2C5268AFE; Tue, 28 Jul 2026 05:09:55 +0200 (CEST)
Date: Tue, 28 Jul 2026 05:09:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] common/rc: add argument to _create_loop_device()
 to specify device size
Message-ID: <20260728030955.GA18364@lst.de>
References: <20260725070412.1636557-1-shinichiro.kawasaki@wdc.com> <20260725070412.1636557-2-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725070412.1636557-2-shinichiro.kawasaki@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

