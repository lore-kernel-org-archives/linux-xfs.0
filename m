Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90715653
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 06:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734244019; cv=none; b=ZZgzVXosqsK4+KvHIlCEfivRkUPyqY4aYEdigUUq7/q6UsuGtzoWj7sYyITUguKYjnCnEduXkWRhewqYS1zrUZ8yFm9KAaSQ83F+OcBjprycgRQpP+27em4praNe2cWTV0HlR1F36C7DxnczR1S0PktSCeIf9WE6Y42yIFfxG+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734244019; c=relaxed/simple;
	bh=6vAiOIcX0paM0nl6WF4ZPUCOOyYtuvamx5LN2H1MJmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBeBJTnsLAGC4h1XTIB/MGAVbQsgquuRx5/CeJMaL3fx+c7xxyySV0Y90tAHeRkz9h4YXJkO85kzWqqCfVv71aZmDlEyvusC7CpLmdMPqvgAkKiNDqZ5wT4CBONLAqLDSFnwMc6l78xHh3zFWHnYwKHk2ES92cIQz4EKlVlpiU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EBC2868C7B; Sun, 15 Dec 2024 07:26:54 +0100 (CET)
Date: Sun, 15 Dec 2024 07:26:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/43] xfs: disable reflink for zoned file systems
Message-ID: <20241215062654.GH10855@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-37-hch@lst.de> <20241213231247.GG6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213231247.GG6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 13, 2024 at 03:12:47PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 11, 2024 at 09:55:01AM +0100, Christoph Hellwig wrote:
> > While the zoned on-disk format supports reflinks, the GC code currently
> > always unshares reflinks when moving blocks to new zones, thus making the
> > feature unusuable.  Disable reflinks until the GC code is refcount aware.
> 
> This goes back to the question I had in the gc patch -- can we let
> userspace do its own reflink-aware freespace copygc, and only use the
> in-kernel gc if userspace doesn't respond fast enough?  I imagine
> someone will want to share used blocks on zoned storage at some point.

I'm pretty sure we could, if we're willing to deal with worse decision
making, worse performance and potential for deadlocks while dealing with
a bigger and more complicated code base.  But why?

