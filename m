Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01C92B9A6;
	Mon, 14 Oct 2024 06:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728886050; cv=none; b=mzpjwfEDYPDkTrT1z8vp5ok+UUZ21vVHomZdioCX5oq/WIzxQMRaarN1gwnGRYl4DDpiwyXA2Dqx6LN+tMoPJqzKLYTcbBpZeHx52wPUcZB516aTiJxtV0OFO+5wjMEqb6LnqGlJbKnPPx5NJxlxs4rqV8H1w9Uae4+qw7tMtNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728886050; c=relaxed/simple;
	bh=JMoI+CaQ5Y4QIWumu2BuCGGl0L95GC8RIRefdqHfBDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZAOaIb89d0WpPfnZxIxbT6fobDeZyOF83HkFT4TuW9MKXPI6zoN/ikS/nmelKEawgnf65SpuHaYgq3hO2Kwo3MW0/MECW5TtCV07JF8WcoLlHBlfrD8RMpAi1M9hCufcGDyKjQGmHwY/9sJbRWC6GCfxCyYhvUE5EK0KhusgEH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3165C227AA8; Mon, 14 Oct 2024 08:07:25 +0200 (CEST)
Date: Mon, 14 Oct 2024 08:07:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: new EOF fragmentation tests
Message-ID: <20241014060725.GA20751@lst.de>
References: <20240924084551.1802795-1-hch@lst.de> <20240924084551.1802795-2-hch@lst.de> <20241001145944.GE21840@frogsfrogsfrogs> <20241013174936.og4m2yopfh26ygwm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241013174936.og4m2yopfh26ygwm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 14, 2024 at 01:49:36AM +0800, Zorro Lang wrote:
> Thanks for reworking this patch, it's been merged into fstests, named
> xfs/629~632. But now these 4 cases always fail on upstream xfs, e.g
> (diff output) [1][2][3][4]. Could you help to take a look at the
> failure which Darick metioned above too :)

What do you mean with upstream xfs?  Any kernel before the eofblocks
fixes will obviously fail.  Always_cow will also always fail and I'll
send a patch for that.  Any other configuration you've seen?

