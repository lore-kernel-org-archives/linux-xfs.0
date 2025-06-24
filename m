Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D362DCBFB
	for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 14:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750775924; cv=none; b=QQjBJsAOAYtdQ0i0JTn5FBPeGiACLAYkElg9CdkCy0UDLmTyaNRLQ/o9HA78JB+Ycyb6Wh8dXQ7MCOapZP5aE8+OwigaI8dWh/m1Fi/RyjSfdomCqLEr5rVP/Ct2fMWvl+757XdWy2hxhJTl+GcAt3y47M+XhULMh3C9vnNOSX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750775924; c=relaxed/simple;
	bh=7ZButkUl/V2s88DqO3LEYPRfB4EremJ23TjXxNYqQcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MBHMVpkQCC96bt+wU1iiVDIgNfB9ZCYgToKfCMlAcNd5TXmNFz5x3tGSi+Zr07vYk8tNKv7S1VKkK66DfwcMPIxcO/ZlIKZVVyyOUmWT51I5zmFgqiRHJ88sfUxFf5JCegOy27CqNSM5O481lBDCJOkxTggue8CgV6V4AfF1I+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3B0BE68BFE; Tue, 24 Jun 2025 16:38:38 +0200 (CEST)
Date: Tue, 24 Jun 2025 16:38:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: cleanup log item formatting
Message-ID: <20250624143837.GA27160@lst.de>
References: <20250610051644.2052814-1-hch@lst.de> <aFKF2taXrSKl3QoO@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFKF2taXrSKl3QoO@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 18, 2025 at 07:24:42PM +1000, Dave Chinner wrote:
> [ 5060.295341] CPU: 9 UID: 0 PID: 2180403 Comm: mount Tainted: G      D             6.15.0-dgc+ #338 PREEMPT(full)

Just curious: what's the exact tree you are running?  Because my branch
is based on 6.16-rc1 and should report that.

