Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA0C40913A;
	Wed,  8 Jul 2026 09:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783502200; cv=none; b=EMuVHsav/HAoipOseeiIozn0VGeIyGNJRY7PzsFa5z9SEf9FjM/FSNGg2HMqbhKIZ7evcCu0s1hZUEqOz9IIa+nkNXygwEVUA1nY2TD0EsyRoXmfDSQZnfnJWXCzpZxCTkmrx078okWA5DIQt9dJCH1a1iiDypLUkCwPu28QJ5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783502200; c=relaxed/simple;
	bh=aWoJHM2+vZIo96on1TSCXf3EjwOkuqA/GG6hutk2LKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZtjsQI3rG+PpSKp7NuoMOwfmRTVsnHeCa5tjZ6s4RsntTWaJdNen3ipsRls/QiLzExvwLWQpODpdTBHQTYQZlun9+TIlFE9B2YdqNnQ/dCJwTlJ4NYVJVCSqFrikR2IvdTYvwCCs/uWmDsQ+Q7u9CbQsiEiRBzYpD7qSak+WSfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 93E0568B05; Wed,  8 Jul 2026 11:16:36 +0200 (CEST)
Date: Wed, 8 Jul 2026 11:16:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: grab rtrmap btree when checking rgsuper
Message-ID: <20260708091636.GE5902@lst.de>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs> <178346726213.1271589.14188309471369607201.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178346726213.1271589.14188309471369607201.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 07, 2026 at 10:04:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that we aren't grabbing the rtrmap btree when we check the
> realtime group superblock.  As a result, none of the cross-referencing
> checks have ever run.  Fix this.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

