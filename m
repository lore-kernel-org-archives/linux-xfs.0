Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DD33D3CE4
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 13:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774876813; cv=none; b=j5eCxACUQoZuSpV8UsQO5N0MJlECKJI63I1rgoplG0LXZXinDzoT7H5XOL49ZEJutGz82urrHgWJYwL7gM6tjgCLDoSmCbOQFKXNDG07B/FKZaqkwW/GxiyyEK23qm+yolmeSXXvgGhxVPEh/uNNEDXbwaMOoFFPw4r3rxYZNgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774876813; c=relaxed/simple;
	bh=RckkfRkC7LzjyZpLmezzaAUi9G1MueiiWZRpPpDeS70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHhvXwW/Xa3PUL3aRejSiWwt0gFwejILLsLtcrpSx7MxH9VzHinn1S3AK/42LlMwG+0fKBn/vdVLVTZ1PNfu9Aizwgfo0cDZp0KJ8i/SCvJLiHdUtjt+CK0rEusvxEQJIe2bHXW5hlB6lC3HbYcr9fK1qILizb7yHrSa+xVH+AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uf2GKmNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uf2GKmNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E99C4CEF7;
	Mon, 30 Mar 2026 13:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774876812;
	bh=RckkfRkC7LzjyZpLmezzaAUi9G1MueiiWZRpPpDeS70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uf2GKmNRNcQ2ht/8ENJFJKwvOYE4gUGzPpzrfJZ15sysv+1zFUTUlk1jsH/YOiry8
	 FMgcCy5VYlMwwrvc+2rLOtiT8Bk4vzUBn1T3B/i3SaH7rUYBwC78p3EPN1RFxeZUva
	 ATNSO8uL/ztFQ5jvdDrHn900yjA1NGYj7eDE16H3gmHMQH3Farryd/qT52Eg5p3Ypd
	 UywoUNWp2rQMWg5jR5o5mpGHCUAgj8K9q8MiXg5kksjrO0Yoh8I3A5sN8nLR+RG4R0
	 h1NB2lzcWQm74KYR5rewfj0h0U7DxMdMiQe6i9eL+TRlKvQZyoceHwlXLhgpJf2QFz
	 z7p8vFKfZofmg==
Date: Mon, 30 Mar 2026 15:20:08 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: delay opening the GC zone
Message-ID: <acp4YXKa89OTBY9X@nidhogg.toxiclabs.cc>
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-2-hch@lst.de>
 <acpnEIzoiBuAJ9E9@nidhogg.toxiclabs.cc>
 <20260330131257.GA546@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330131257.GA546@lst.de>

On Mon, Mar 30, 2026 at 03:12:57PM +0200, Christoph Hellwig wrote:
> On Mon, Mar 30, 2026 at 02:16:53PM +0200, Carlos Maiolino wrote:
> > On Mon, Mar 30, 2026 at 07:44:11AM +0200, Christoph Hellwig wrote:
> > > The code that selects a new GC zone when the previous one is full also
> > > handles a zone not being set at all.  Make use of that to simplify the
> > > logic in xfs_zone_gc_mount.
> > > 
> > 
> > I might be wrong, but the subject looks misleading to me, wouldn't be
> > better to just set it to something like "simplify xfs_zone_gc_mount"?
> > 
> > Not a big deal for me, just kind of confused me while reading the patch.
> > But changing subject or not, feel free to add:
> 
> Well, both would be correct, but I think the current subject is more
> useful as simplify could mean anything.

Fair enough
