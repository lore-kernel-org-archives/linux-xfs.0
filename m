Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15013932DF;
	Wed, 25 Mar 2026 07:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774425259; cv=none; b=ZifLl1NR7hHJ5U6fCCuwf3dilyKgkljUS1V94+rCPPBYcwX6nzlBqpBvTDdoNNROnEWENWzKcT16D7z0vKG33Li+1myGKRQdsB3SVAdlbL0zkQEDh4sQg9b4eO03PojfwejqUWXZGsXRSsY/eaL/q48oczJExv/scIdD8g81uVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774425259; c=relaxed/simple;
	bh=EaXT9HmbR9PH7MMGDQtr7F4g0w+7g/tpOBPVP78jS2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D9u54H+bBqPNDmcJReKukRfWicyf7LigfehDbVbbX/x0KUtJt9OpLb2yJiALJAWXpdYDbg7VZImHQ17qnz/CkJu3n0j1zMkjr+Tt3ejSDVdQRmKHaFYJ6bdUvSTSVvGlK5NM2C6LbAHXkrEdhttRq/HAQ7N39gLPXHv8kn413Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 11D6C68BEB; Wed, 25 Mar 2026 08:54:03 +0100 (CET)
Date: Wed, 25 Mar 2026 08:54:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v5 01/25] fsverity: report validation errors through
 fserror to fsnotify
Message-ID: <20260325075402.GA952@lst.de>
References: <20260319170231.1455553-1-aalbersh@kernel.org> <20260319170231.1455553-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319170231.1455553-2-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 19, 2026 at 06:01:48PM +0100, Andrey Albershteyn wrote:
> Reported verification errors to fsnotify through recently added fserror
> interface.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, would it make sense to enhance the interface to tell why the
data vs considered lost?  i.e. checksum failure vs (part of) device
disappeared?

