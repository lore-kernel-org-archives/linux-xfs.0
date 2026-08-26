Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBDD35AC3F;
	Wed, 26 Aug 2026 04:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787719997; cv=none; b=ChOXG3BY7pkCmXGbix+NE+OCkl9lzRczCm6GbnqhoUS7FlEP6oxw3Mpz8P87+ZF0An9r/DMg9de1YN2crcJG0iGEr39CgrAYQ+i7xHRQUBYu5skl86mkIxx7k7qD2khqTSjjZnidgqrY3lFttU3gZHDriXfqrWIcC83pFnMdjD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787719997; c=relaxed/simple;
	bh=Ua43xsN2u8w61b6mmJqcXOl5OG/eMAXZkslOAb8g0rA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XvnMqM6YbGdXLE++RaBGNtEaePpmhRQ9w2TrHChSe+/bfd9vYlaHbJfQQ+PvcphmO87/MnPGEl+TL8/ZCp8fa35fUEMsahgYUHpjp9wn2yw/D/mQtzsji1E4XfnYDEDKDgZglrjkLvtzTv2ed67+F+IryVFAxmpS+HrnwAFAnFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8852B68AFE; Wed, 26 Aug 2026 06:53:04 +0200 (CEST)
Date: Wed, 26 Aug 2026 06:53:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Qu Wenruo <wqu@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <20260826045304.GA15122@lst.de>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <a1f8902b-72a5-40fd-a36b-89b6ea271cdd@gmx.com> <ao3sgEET8GuY7Rw2@casper.infradead.org> <cf3486b8-a506-4732-8274-b3179fb06a82@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf3486b8-a506-4732-8274-b3179fb06a82@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 26, 2026 at 08:03:38AM +0930, Qu Wenruo wrote:
>> Why is it hard to do it immediately at writeback time?  I think you're
>> in an even less restrictive locking environment than page_mkwrite is
>> called in because you're not under any MM locks.  According to
>> Documentation/filesystems/locking.rst, ->writepages is called with
>> absolutely no locks held.
>
> This space reservation problem is a btrfs specific problem.

Not entirely.  It really is an issue for everyone doing (forced) out of
place writes.

> The root problem here is, btrfs space reservation can trigger 
> writeback/transaction commit.

While zoned xfs doesn't actively trigger it, it still has to wait
for the GC daemon, so we're in exactly the same boat here.  The
space reservation has to be done without VFS locks, and in the
rare cases where we can't do that (->setattr for an unaligned
truncate) we have to play with fire and dip into a reserved pool.
It has been on my TODO list to fix up the VFS interfaces for
that to be called without locks held.

> This is due to the data/metadata COW nature, and that's why we rely 
> completely on buffered write to do space reservation, and avoid any extra 
> space reservation at writeback time.

That's the only sane thing to do, as at writeback time it is too late
to reserve space.

