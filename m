Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C692EB5CD;
	Wed, 18 Feb 2026 06:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771396776; cv=none; b=Dx7YMataUFswagftpVe1tN7H24G0fo3HDT4oIGDLQ2S7UC5VkYIkNmxoCPvwreq21L2rMPlKIdwBFYSeH4/um+zb/+MjY5L5mCEByVtKedPBdq9QSxw+h7os+lNcKCB0hXNgk+aEa7s59x40gCCMKR2u77dIOLl1v//fwdK0u64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771396776; c=relaxed/simple;
	bh=PCJYJIBbOP3Vg1iuUnDev/lp4S1mTyYDZWn1QWG29vQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kgClgkjSercMj/MxCJdahyBH7ISlim9Hf7jeyLKAYbZLMqWCVuNI8gdA3V8VQfT6sXUaD7YTGC2GPD9CLCqbJdnqC3AZ8PLqwJp5Z29vupXSjybQFfvHFG3MLnb5KzyQxkRKNUAZRFF5jqiFuaGhJMQAkw5PsTb2pijH0dihJ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1BA0C68B05; Wed, 18 Feb 2026 07:39:33 +0100 (CET)
Date: Wed, 18 Feb 2026 07:39:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	djwong@kernel.org
Subject: Re: [PATCH v3 24/35] xfs: use read ioend for fsverity data
 verification
Message-ID: <20260218063932.GB8768@lst.de>
References: <20260217231937.1183679-1-aalbersh@kernel.org> <20260217231937.1183679-25-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260217231937.1183679-25-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 18, 2026 at 12:19:24AM +0100, Andrey Albershteyn wrote:
> The ioends are offloaded to workqueue for further processing of
> completed BIOs. Use read end ioends for fsverity verification.

Note that we need to ensure the ioend is freed before fsverity
processіng, or probably more easy use a different workqueue for the
fsverity hash I/O.  See the comment in fs/ext4/readpage.c:verity_work().

