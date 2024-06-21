Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81A213C802;
	Fri, 21 Jun 2024 06:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718951349; cv=none; b=b1rCkNOIxbtRV/EWuia3msNpxLxmsObyhk07RRxbDiiFBzlGt5/Fi1+NWcQXcC5IqTUt/qs7xyfcPpPUW1ZMUCvH7VIu2oAOJDC/AJxst5lylQR3xXgj+TWKI88d6y+LuHwY5jiN1CqVA633qnpBU+fM8x2+UqZMnIxvF8pnzaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718951349; c=relaxed/simple;
	bh=lt8EwRSKyLAED73wAVk4zYb0ESdLZYj9bhUO+/u8UPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IjyswvzL3d8PlUJidOErVdztaLcwO1G/v46v3/6eBD6AoZyjB14o++r/YZvrYslZp0nqlGjrwJDMN4WNnxDaMy7U7hW9beZ9bdiB6pzGe973zLHnJE74CFZu/EIVSG29zKWqO9dl5iYsWm2Xi0UIMg6G7rJ5b9J4cCA72WEzUhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DD2FB68AFE; Fri, 21 Jun 2024 08:29:03 +0200 (CEST)
Date: Fri, 21 Jun 2024 08:29:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/011: support byte-based grant heads are stored in
 bytes now
Message-ID: <20240621062903.GA16866@lst.de>
References: <20240620072309.533010-1-hch@lst.de> <20240620195606.GH103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620195606.GH103034@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 20, 2024 at 12:56:06PM -0700, Darrick J. Wong wrote:
> > +	# The grant heads record reservations in bytes.  For complex reasons
> > +	# beyond the scope fo this test, these aren't going to be exactly zero
> 
>                            of
> 
> Why aren't they going to be exactly zero?

Given that frozen file systems always have a dirty log to force
recovery after a crash we also have space granted to it.

