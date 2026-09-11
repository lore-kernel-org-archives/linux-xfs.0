Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3BB439F88;
	Fri, 11 Sep 2026 07:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789110863; cv=none; b=J/LFFMK7b/oDOenxVtuTMPMhEUtHGu5IBVLMGbnfxIoYY2//qwLNOSKB4ybnhGiKewKjBWdsjICFwmXKU0HO1YIb1RYt/G8j9N1C4ALZNLVy2optWgbODDU1sKtSa25qTgYrTeO2fnOebpSKBMQUNbW61xjxu9IBvMexZ32dgt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789110863; c=relaxed/simple;
	bh=g0JDbwUTMKa3U1RpmUUuVg7bM1Ovdz3wIARd4JkJX6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BWy/Sb3t7uwjAD8o3mk2gBLEio9VHwiFWmgfijAncWiQ5yc1PaogVoiHKCfJtThMOOrc7Zg7PWmNDJbSp67tALDNzkmEyenBl3JuENXBfNm5eOkQblR242bR7tRUhWYdVp0hcOJ6/HAj0mjb6RwS4XBftoLaT0vKFhaKuh06KIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 95B3068C7B; Fri, 11 Sep 2026 09:14:07 +0200 (CEST)
Date: Fri, 11 Sep 2026 09:14:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: check padding field in xfs_ioc_commit_range
Message-ID: <20260911071407.GA16914@lst.de>
References: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs> <178910162042.174887.10361947656955266052.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178910162042.174887.10361947656955266052.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 10, 2026 at 10:53:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that we don't check the ioctl padding field here, so
> let's do that.  I don't think there are many users yet since exchrange
> requires a new feature flag, so it's a good time to try to plug this
> hole.

Let's hope no one is doing stupid things here yet..

Reviewed-by: Christoph Hellwig <hch@lst.de>

