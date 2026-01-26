Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFFE3314B9;
	Mon, 26 Jan 2026 11:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769428166; cv=none; b=rW2RXU6W+aHmFG9u65kHuDB4SPtL37tzjU82Rhdr8IIxQjHQnreGUBxfBbmdOGlxwpvhUCoUqKejKZ62cA/6wg0cKV/sH5qhUZ1Ab2HZC0Wip/s0YhUC6nJ8o4Ep7lH3cT+sz6QvP71K6cB7PHefkexCTGnr5yTBgTvw1UNReuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769428166; c=relaxed/simple;
	bh=+6yDB44WLT2wxWGFozgz1t46XALOOvrPkLAvGhdLOlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W1CyajYrQyOJcTJo135gh2PPUPngQHaF9AAjyTQHlqtptwUNKW1/s+rzl0dAANL/jeiXQ6tKQClGq964c7oJsCf99z2Fzb71+NDzxJc6dsRsQWL3VQhXYZjpLrpvw/2QGXAwliPzDo6t+YH8zuIzyBlXBZlc6mtfil8NgU7k/zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 28070227A88; Mon, 26 Jan 2026 12:49:22 +0100 (CET)
Date: Mon, 26 Jan 2026 12:49:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 11/15] iomap: free the bio before completing the dio
Message-ID: <20260126114921.GA23923@lst.de>
References: <20260126055406.1421026-1-hch@lst.de> <20260126055406.1421026-12-hch@lst.de> <3360b495-b66d-40af-9274-bdb614455f6d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3360b495-b66d-40af-9274-bdb614455f6d@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 26, 2026 at 03:22:41PM +0900, Damien Le Moal wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Repeated tag...
> 
> Looks good to me.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> 
> (which I think I already sent :))

I guess I messed up and pasted Darricks' review again instead of yours,
sorry.

