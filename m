Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795198642;
	b=L1hyMqlS4SXBgxSzyXrDTf1CkF+fkonvtcTNUNitfYRIKmsKkXSyYaBMs4W5zfoaeHeS
	 x7xRBMNi0id/x+WLYswsrf0rPxjMAiQUEcUvUDGpt0VstO/fcolO8tdS4FsiZ3YowFo0q
	 5aMRahsLucKcoLjPgDNu/fRj2xqbgReYKPWESioxG38c+yDGLOqNi+lNNMPYsT7j8V34v
	 9Qz5O9Kc4LO3NgyN0QQnBKgRtPHUG5SEpG2KiFzli0cKnUAldnlnpxm0B8juF+HYbvf9p
	 Nt7GJ1E9OaSHTiLLutiw9g8rKQ67IWLshDhW2vKuWMlQVsz2jhZgLrwD85HikSEnMGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198642;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=o64F6puh/jpTTljPaTS4hEAr7aIVTEpAG2fIdQOzvjI=;
	b=kWA6mcoym36Nf8b+JNfCP/rhrh+bJKG94w2p8CoU3gb0azWoxUtgvIs09ak/TFEcs5ml
	 1F2NUYCjpDUEEYuuSDxG5cm1UZ1ViDVuPbTUqAMKWRLcrehp+G4yBYW5/w9D+P6yjb+QX
	 7te+/M8ECSb7cix37dUU3vYTo0oC+BFbdsfUtwEjXSWLd+ll0GBquDRgO1thvUklRw+UA
	 Nzu0NP3Jm13yJI3yjLQgPBsvcvfOFug78fiOyX0OhpGMC9/wQtADxhZLUZokT9fMyqE8T
	 QAvpY5i4dUFmtDkr7n+raky2THkO2Rh9TGSr4fk1ppzUEu9RX+A8fv8qlJ/QU84fv1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EA26076C6D;
	Fri, 20 Nov 2026 18:17:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39EA26076C6D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3913468AFE; Fri, 20 Nov 2026 19:17:06 +0100 (CET)
Date: Fri, 20 Nov 2026 19:17:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: skip the fsync flush when a later flush
 has completed
Message-ID: <20261120181706.GB1954@lst.de>
References: <20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com> <20261111-xfs-fsync-flush-seq-v2-2-b5c00c25d276@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-xfs-fsync-flush-seq-v2-2-b5c00c25d276@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 11, 2026 at 12:17:12PM +0900, Daejun Park via B4 Relay wrote:
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
> Christoph's 2017 mail with the sequence counter idea:
> https://lore.kernel.org/20170830142134.GA650@lst.de

Heh, I was going to say I didn't remember suggesting this publically,
but hey, if it wa 9 years ago I at least have an excuse for the memory
loss :)

> With an internal log, an fsync that takes the new skip can miss a
> failed flush on bio-based dm. dm drops the error of a preflush sent
> with data, unless the table is linear or stripe on a single device.
> The skip trusts the status of the iclog bio, as the log and the fsync
> that wrote the iclog already do. Before this patch the other fsyncs
> sent their own flush and returned its result. With 8 writers on a
> two-device linear table whose second device fails every flush, 2590
> of 4000 fsyncs returned EIO before and 37 do now. From the code,
> bcache in writeback mode drops that error too. md reports no flush
> error at all. Neither was tested.

I think you've fixed this bug in dm in the meantime, right?

> @@ -119,12 +122,21 @@ xfs_file_fsync(
>  	 * file data target cache here. This can happen for fdatasync/O_DSYNC
>  	 * when no metadata needed to be committed.
>  	 *
> +	 * Flush the file data target unless a flush submitted to it after the
> +	 * data writes above completed has already finished. That is usually
> +	 * the flush before an iclog written out by this log force or by
> +	 * another task, or another fsync's flush.
> +	 *
> +	 * DAX writes are not block I/O, so DAX only skips the flush when
> +	 * this log force flushed, as before.

I don't get the DAX part.  As far as cache flushes are concerned we
don't special case DAX anywhere else, why here?

