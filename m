Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1910C2749DC;
	Fri, 24 Jul 2026 12:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897681; cv=none; b=LGcqxQkHo/aMD+qLFZbiJqV/kxmca7zQJoMwcN3W1E2tGOYBS66/N3xOXnGtTW1Mvp+lzl6w+KvG2aS9efiCzv8ajDm8Xn6kV6GHQNVzw7e4A5mGG++Vm4XrLpxXIur0t+aqNOMZirM4ltyMH0fP1cPhatDujjW6FgIvVRI8sHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897681; c=relaxed/simple;
	bh=tqRxpgQdUJ7Au5eLmLySTDovM0MWNImE4pIPqVY7ztk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T4Xd10t8t6/TfzyOJzboRqgzeYSnCYL1JEH7wD8bPXFMuXEHiHsfK/L9VaZ14CYsJk7fN8EgDVNA9C7Txjcsut3S2J0FBOr7oanfnCZUfRFO+TW1K5RDLhLvtBpcP8YlbqFUtID5NJDf6bLE24jLUbXm8gMXdN0quMyo3rJqYas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1BE9F68AFE; Fri, 24 Jul 2026 14:54:35 +0200 (CEST)
Date: Fri, 24 Jul 2026 14:54:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 18/22] xfs: use BIO_COMPLETE_IN_TASK for bounce
 buffered read I/Os
Message-ID: <20260724125434.GA27168@lst.de>
References: <20260723145000.116419-1-hch@lst.de> <20260723145000.116419-19-hch@lst.de> <amItES6s54i1QSHw@aalbersh-thinkpadx1carbongen13.rmtcz.csb> <20260724062120.GA4953@lst.de> <amMvIEtEtRrNE7A_@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amMvIEtEtRrNE7A_@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 24, 2026 at 11:38:53AM +0200, Andrey Albershteyn wrote:
> On 2026-07-24 08:21:20, Christoph Hellwig wrote:
> > On Thu, Jul 23, 2026 at 05:58:49PM +0200, Andrey Albershteyn wrote:
> > > I would probably need something like this for fsverity.
> > > 
> > > When using integrity checksums with fsverity together, both file data
> > > ioends and fsverity metadata ioends get onto the inode queue
> > > (without checksums there's no metadata ioends). This way worker could
> > > self-deadlock if data ioend processed first in xfs_end_io(). It will
> > > call verify_bio to read merkle pages which could be already waiting
> > > in queue.
> > 
> > Yes.  Same as the situation we have (or had as this is changing
> > for 7.3) with fsverity and fscrypt.
> > 
> > > I initially considered changing xfs_end_io, for read ioends, to just
> > > schedule them instead of adding to the queue, but decided just sort
> > > metadata ioends first in the queue [1] as a bit simpler fix.
> > > 
> > > The difference is that work won't be scheduled on the high-priority
> > > fsverity's workqueue. Not sure how critical this is as with
> > > checksums all reads would be the same priority.
> > 
> > I'll need to go back to your series, but just sorting isn't going
> > to fix the problem, as the reading of the verity metadata could
> > be kicked off from the completion workqueue and you could be blocking
> > the rescuer thread.  So either verity needs it's own WQ, or we'd need
> > some way for a currently running I/O completion to exit and get
> > restarted.
> 
> Oh I see, then, the data reads could be queue further with
> fsverity_enqueue_verify_work(ioend). This way bio completion queue
> can continue process incoming metadata reads while data ioend is
> waiting for verification.


fsverity_enqueue_verify_work would actually really benefit from doing
a list (percpu or otherwise) so that the caller only needs a single
or doubly linked list entry instead of adding another struct.

But if we don't want to do that work yet, adding a verity context
of some sort and using fsverity_enqueue_verify_work could work.

