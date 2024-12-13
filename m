Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CE217B421
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 05:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734066051; cv=none; b=sDz9bY5G7/0kpBpv8JxIzkgZJfn/7097CNmEcu0yG1PNJY4q5YQvZ9RCULBBobFZ6gihnQmbm6aDQZTJGWOox1GpYQDXeB/yHu0N7BtCqd+/VxNueECNYy0y1Hon/p/jHAhjFAjQ7ArngVS8VBbumx8iNa28hrI0hzV3Nqs/1XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734066051; c=relaxed/simple;
	bh=mzaaUc9qpBQZt/XSyEcT/3j3HRdUXB1cNMRw2YK2xsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQhWkR2TsNpl6Qvpvy61S2kkTm5Y7+0itFcV/IEbcQRhKOCdlfuAinYFgmmHvlapUzSi6h9swP9h1ed36i1jUj2JFkNc67Lcie7Iz1NFqKOEYETsVsoiFsaq/3fc0H06pwtlYKQtrH4axXyLiVuwQ1vWQg6X+dz35l8T32H3/qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9CFF468BEB; Fri, 13 Dec 2024 06:00:46 +0100 (CET)
Date: Fri, 13 Dec 2024 06:00:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/43] xfs: add a rtg_blocks helper
Message-ID: <20241213050045.GA5630@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-4-hch@lst.de> <20241212211225.GP6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212211225.GP6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 01:12:25PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 11, 2024 at 09:54:28AM +0100, Christoph Hellwig wrote:
> > Shortcut dereferencing the xg_block_count field in the generic group
> > structure.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks good, though I imagine there are a few more places where you could
> use this helper?

While the zoned code uses it a lot, there are surprisingly few uses
in your baseline.  But when reassuring me I noticed your recently added
RT-aware failure notifier could use it, so at least one more.

