Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EBF3932FF;
	Wed, 25 Mar 2026 07:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774425464; cv=none; b=C2TlFVTlie6wCfBbLFkH5WxiMFb4W2HJ/8W/WTjuCld7SRkmrQMFtgAIH3jzl9qrbZDbnDDoeVUZwDfLxlQQ9nrHK2H4enKBpLULA7XJn6ogn3kZgO+VuduTnny7mJPDsElPncpJDtdDvw9SeAXdUwVlNMqq8e+rNXLqM9O/z9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774425464; c=relaxed/simple;
	bh=q2c/xT6XJwEKIiHJmT8558WCfx4UGROZ9aBuiUzMmX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=krhq4y3z2Tknyl94woDfgMgbg8r8Jgw8hhuo15C98wYdbPBFIg5T2VLYOx8xGC/PX3LxTKtZoNZAlQHOftfNHKeuudPIyGtYqFldJeHfHxWlClUUba09TzFBKXa0vvafsMmLvesmggIJTSgfTOwkXCR+LtB9iiPIaAVhIPSKAKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DAD7968CFE; Wed, 25 Mar 2026 08:57:37 +0100 (CET)
Date: Wed, 25 Mar 2026 08:57:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v5 04/25] fsverity: introduce fsverity_folio_zero_hash()
Message-ID: <20260325075737.GD952@lst.de>
References: <20260319170231.1455553-1-aalbersh@kernel.org> <20260319170231.1455553-5-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319170231.1455553-5-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 19, 2026 at 06:01:51PM +0100, Andrey Albershteyn wrote:
> Helper to pre-fill folio with hashes of empty blocks. This will be used
> by iomap to synthesize blocks full of zero hashes on the fly.

This should probably be merged with the previous patch.

