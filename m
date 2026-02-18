Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E563A1DF73C;
	Wed, 18 Feb 2026 06:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771397390; cv=none; b=sNRYvOV8utVxrHUeADceTOXCI3a2gfTnRYeiAAS9c0TBC1ZVMHTh5XBHuDD37DoDFWKJNGcqqoTuvq/ZaPnmMHfznuG32hpoYBq//klgbtWims9nmFhh7l0xFds7eMuA+nkZDkXNV8WAsVUrlfc3Ui+s/jx2Qppyiq1N6UqW6GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771397390; c=relaxed/simple;
	bh=gDsbxl7dlP7PIWNLTCdTNfanHBtZlYBjSw1OA4L1rog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OgFTeeq/6STnqCQi3D5ubMeziRP5XsIlItfj/fmE7iIfYArWSBAxbS3OVFM4EGOVc8O6q6mnb8g63QXwFiR8vb6HtYkhXRK6o8VPCZTqEXRMjC31YCvMmCGkaI3WkmMWK10NUn010OIZY0bi98QGBFWV47S0gRv4JjNczckZsq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8ED2868BFE; Wed, 18 Feb 2026 07:49:42 +0100 (CET)
Date: Wed, 18 Feb 2026 07:49:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Jan Kara <jack@suse.cz>,
	Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org,
	Andres Freund <andres@anarazel.de>, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
	ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>,
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
	vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <20260218064942.GB8881@lst.de>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com> <w3vwdaygcz3prsxwv43blo4co666mragpdwaxihbirt5stl4vr@agyz4mnaxghj> <aZS18m1eIxjDmyBa@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com> <aZUHHvNl6cQr-uwd@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZUHHvNl6cQr-uwd@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 18, 2026 at 11:26:06AM +1100, Dave Chinner wrote:
> ISTR mentioning that we should be doing exactly this (grab page
> cache pages, fill them and submit them through the DIO path) for
> O_DSYNC buffered writethrough IO a long time again.

Yes, multiple times.  And I did a few more times since then.

> Regardless, we are here again with proposals for RWF_ATOMIC and
> RWF_WRITETHROUGH and a suggestion that maybe we should vector
> buffered writethrough via the DIO path.....
> 
> Perhaps it's time to do this?

Yes.

> FWIW, the other thing that write-through via the DIO path enables is
> true async O_DSYNC buffered IO. Right now O_DSYNC buffered writes
> block waiting on IO completion through generic_sync_write() ->
> vfs_fsync_range(), even when issued through AIO paths.  Vectoring it
> through the DIO path avoids the blocking fsync path in IO submission
> as it runs in the async DIO completion path if it is needed....

It's only true if we can do the page cache updates non-blocking, but
in many cases that should indeed be possible.

