Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E27D1E520A;
	Wed, 25 Mar 2026 08:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774426108; cv=none; b=SCWX3k7I6ZTvqE7G6kyfGylwYDMs5D6ngRg+/ftOcmLqALByDfxGRNe/FbV80lzXRoq2q6g/zpm3/kSWpzwesOnEG94H20H0ob3DmgbmOb7b6w7uG4LPJGt9kKsJUJAVMeqmKELPNBJVLPp4Fk4mRKNIYJ4QGcXqzQLcHZYUEmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774426108; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IRIH1vYLKwBcdT/LitIXRI11YZ0eOVDpoR5NjTzZ/jdVfb2CNwT3zdSUn5vKGBpUktW3Rg7S9jI3V3aygT40i24rrRnLJHaRJHjwUkhlNvMaofFtXd0rkxuZQ4gzWn8KwYl8/PN52VfEzxJSGSjfMlj7O8JDE7uQ9IiKdjE9Lwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CC21D68D16; Wed, 25 Mar 2026 09:08:24 +0100 (CET)
Date: Wed, 25 Mar 2026 09:08:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v5 18/25] xfs: add fs-verity support
Message-ID: <20260325080824.GO952@lst.de>
References: <20260319170231.1455553-1-aalbersh@kernel.org> <20260319170231.1455553-19-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319170231.1455553-19-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

