Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF41030BB8C;
	Wed, 25 Mar 2026 08:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774425979; cv=none; b=YxGfPz5LhvDeh7bvSms2TCGYMCGmXni3L5vB4fq7LgUzdJTuS0LAz8y5mEPbw/e0wTLMrpxwDVUJ/4sUR8gBEhyeQ2UFf7LO5K6kv1bPQme7SoCwj4h22uZiJalYRpbrGUiG85zEv5kCFQx7TCCjs1nW7NNqQhaTX3Q41waZzWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774425979; c=relaxed/simple;
	bh=lkyrVN/yeytDCGV59Hg4yyxI3LvldlmwxgEEOeio8XY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ogKt+DY11WHCusJdhNYqbEEJPUqjoj3vh95lrk1Qmx1KEeJpoODyiPIaUYTuyhmO838oOSL82qxS3W/EEMPP3RJj/ruccsxYr2dhYorhNZ5lKAdMQOoJ4KJYZAwFaSsf55Q/fvUYrE5mk3GMGYxiiG8lTg93aEYYe9gOX2TA16E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9A6A568D0F; Wed, 25 Mar 2026 09:06:15 +0100 (CET)
Date: Wed, 25 Mar 2026 09:06:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v5 14/25] xfs: don't allow to enable DAX on fs-verity
 sealed inode
Message-ID: <20260325080615.GK952@lst.de>
References: <20260319170231.1455553-1-aalbersh@kernel.org> <20260319170231.1455553-15-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319170231.1455553-15-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 19, 2026 at 06:02:01PM +0100, Andrey Albershteyn wrote:
> fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
> inodes which already have fs-verity enabled. The opposite is checked
> when fs-verity is enabled, it won't be enabled if DAX is.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

