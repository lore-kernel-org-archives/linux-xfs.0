Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5301411EB
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 04:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734408422; cv=none; b=MUyNWo2prwyV8//ATf+olbWXOqZf0YoVvSosZEPh3RYDAmXCw14uywCKqzsb7hywnfCz7tcAOTG4naMxfSvd+0cIQtqQI3EiOrdR0B4NCJC4z+PSVSPc/jBPdlyBySgrB2/glnx0DM9kkMPI2tVvU7PpCkaYiFH/tY31N/Ceft4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734408422; c=relaxed/simple;
	bh=qsri7kM3d8qoB0Rz3hTM6nIogZjlaBIslfB/nBlRJJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=thHXKF/nIqaUDuJq0v+QkLFRoa4nBKBAI+cdNnAuHH/mDCPnbcxKsNhR0vYSctSV99CJ0uHZ5pvgrOUFVbrrK8vO0IYzIliGkhciQFXtupMf859XkODY3e7+Bh9W3h71eQcCyUhddD9qD0VlEN93xDK+zDBxOhjKjyguU6lRHus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1DBE868BEB; Tue, 17 Dec 2024 05:06:56 +0100 (CET)
Date: Tue, 17 Dec 2024 05:06:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/43] xfs: implement zoned garbage collection
Message-ID: <20241217040655.GA14856@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-27-hch@lst.de> <20241213221851.GP6678@frogsfrogsfrogs> <20241215055723.GF10051@lst.de> <20241217012753.GE6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217012753.GE6174@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 16, 2024 at 05:27:53PM -0800, Darrick J. Wong wrote:
> > lot more work to move them and generates more metadata vs moving unshared
> > blocks.  That being said it at least handles reflinks, which this currently
> > doesn't.  I'll take a look at it for ideas on implementing shared block
> > support for the GC code.
> 
> Hrmm.  For defragmenting free space, I thought it was best to move the
> most highly shared extents first to increase the likelihood that the new
> space allocation would be contiguous and not contribute to bmbt
> expansion.

How does moving a highly shared extent vs a less shared extent help
with keeping free space contiguous?  What matters for that in a non-zoned
interface is that the extent is between two free space or soon to be
free space extents, but the amount of sharing shouldn't really matter.

> For zone gc we have to clear out the whole rtgroup and we don't have a
> /lot/ of control so maybe that matters less.  OTOH we know how much
> space we can get out of the zone, so

But yes, independent of the above question, freespace for the zone
allocator is always very contiguous.

> <nod> I'd definitely give the in-kernel gc a means to stop the userspace
> gc if the zone runs out of space and it clearly isn't making progress.
> The tricky part is how do we give the userspace gc one of the "gc
> zones"?

Yes.  And how do we kill it when it doesn't act in time?  How do we
even ensure it acts in time.  How do we deal with userspace GC not
running or getting killed?

I have to say all my experiments with user space call ups for activity
triggered by kernel fast path and memory reclaim activity have been
overwhelmingly negative.  I won't NAK any of someone wants to experiment,
but I don't plan to spend my time on it.

> Ah, right!  Would you mind putting that in a comment somewhere?

Will do.

> > 1 device XFS configurations we'll hit a metadata write error sooner
> > or later and shut the file system down, but with an external RT device
> > we don't and basically never shut down which is rather problematic.
> > So I'm tempted to add code to (at least optionally) shut down after
> > data write errors.
> 
> It would be kinda nice if we could report write(back) errors via
> fanotify, but that's buried so deep in the filesystems that seems
> tricky.

Reporting that is more useful than just the shutdown would be useful.
How we get it on the other hand might be a bit hard.

