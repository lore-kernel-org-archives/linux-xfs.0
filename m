Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DF82C10B3
	for <linux-xfs@vger.kernel.org>; Tue, 29 Apr 2025 12:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745929471; cv=none; b=rM7f2OzDxkln0yb3RrWiapywPUZuKvYlUU0OUZpLewQSZWDH9XNwoV3vve0ajPC7h2x4K04MtiCpAE5T1vm22aryv6z3lTs/Lc6ndh1vFrsnTyjXBmakQsAuPrOwlosYXQYqj3+8kTNbpFmjX1zTwykeryxdS+/zjMJ1M648vMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745929471; c=relaxed/simple;
	bh=5jdlM1YIYOMOcpq/EOdOlValI84ZK+fk9ZPMGqFhQvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p5j+NhqnT0v0Po3EnUo7g7rIaOKM2usQOaSjAopVJcsRfttPu1apGmDs45fRdbzsgMt6hjBQTmPQSn5XvAb2PLcVL66xPpbhYiyWGdh64RNzzbUbf629sZSXtds+5k+TSG0N9ioFDL9wBQ7BYz0S47jDUQ9wk3DZ0gb9jBQOobs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 494D968AA6; Tue, 29 Apr 2025 14:24:26 +0200 (CEST)
Date: Tue, 29 Apr 2025 14:24:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 44/43] xfs_repair: fix libxfs abstraction mess
Message-ID: <20250429122425.GA12778@lst.de>
References: <20250414053629.360672-1-hch@lst.de> <20250425154818.GP25675@frogsfrogsfrogs> <20250428131745.GB30382@lst.de> <hrbhwqnymqgvp6l36s7r7mdnnmhhm76zoibtxtfo32iishzhza@fbuuly4t2fyn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hrbhwqnymqgvp6l36s7r7mdnnmhhm76zoibtxtfo32iishzhza@fbuuly4t2fyn>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 28, 2025 at 06:28:58PM +0200, Andrey Albershteyn wrote:
> > Andrey: let me know when it's a good time for another xfsprogs series
> > round, and if you want the FIXUP patches squashed for that or not.
> > 
> 
> I'm preparing for-next update, do you have any other changes for this
> patchset? I can fixup the commits and fix "inherit" commit message.
> Or if you want you can send it now, I will take v3.

Fixing the inherit message and folding in this patch were the only
todo items on my list.

