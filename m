Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B273EBF1C;
	Fri, 23 Jan 2026 14:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769177437; cv=none; b=StUmR0oue3IotKIGvSOfaZosHoDm31Wt0MMuPELpH9bz5YaeFhq2T6CxsICCM0zPVZGyy88raZwkDvq8jQBR9LVZfXnuX5lQMr87fgAW2qE3fJnFnrIjwzYkEj3EZzZX/wcG2jN9Hts5MOuowBEv12PwFyhcodmGVL19kSrMlMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769177437; c=relaxed/simple;
	bh=dqFAiW6R0VgQFIfg8LUG7M5XR9YxXILu8hOD3xuGMag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aza4p2rBQhc2lYar0sK0KjXwNwNdcdQKR2InoQ5QXzHK1ubTChjEri8qm7L/5KaWZff08NloiTAeTwBSYWLwXJ9wkDgwOZyivw3Uceye0ScvrUdeVZks/oyQb3pL8O8x8ypVidd+B95idteR+5GOqWJicZt6NSFsSgQzlbEXPFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8F48E227AAE; Fri, 23 Jan 2026 15:10:32 +0100 (CET)
Date: Fri, 23 Jan 2026 15:10:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: block or iomap tree, was: Re: bounce buffer direct I/O when stable
 pages are required v2
Message-ID: <20260123141032.GA24964@lst.de>
References: <20260119074425.4005867-1-hch@lst.de> <20260123-zuerst-viadukt-b61b8db7f1c5@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-zuerst-viadukt-b61b8db7f1c5@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 23, 2026 at 01:24:08PM +0100, Christian Brauner wrote:
> Applied to the vfs-7.0.iomap branch of the vfs/vfs.git tree.
> Patches in the vfs-7.0.iomap branch should appear in linux-next soon.

Hmm, I have another minor revision in the making.  This is mostly
spelling fixes, removing a duplicate page_folio call, adding a new
comment and adding symbolic constants for the max bvec_iter/bio sizes.

I also have some other work that would conflict with this in the block
layer.

What do you and Jens think of waiting for another quick respin and
merging it through the block tree or a shared branch in the block
tree?  There really is nothing in the iomap branch that conflicts,
and nothing really coming up that I can think of.

My current state as of this morning is here:

https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/iomap-bounce

I think there's another spelling fix pending from the more recent
reviews since then.

