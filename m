Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D293B4EB6;
	Fri, 25 Sep 2026 06:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790317635; cv=none; b=JwmUh0H5VrK1Xd/ZR66yqzLIlF7K/PitEmxFeAHiWtz3v6kSFIC7VtbVMztmfzlQtQdzhy9POUT4qrDxrJXzyMRZVHy3ZTsWjwczHbqQAwe3UIDCnHhPjMB4EoATDO3gHAWprlqlKksnRVBv4AYcuL9EC8lls86tDlOQRwGuf4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790317635; c=relaxed/simple;
	bh=CJZnjBMypuXinDaUZSzu2joRXU4L9U5e2acxj43h5Pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H9Z3VuiXRoU6Or9vwlvDJidR4oBQR9gZwaQEZ/T/aNdNaBWJai0iVqBxLlylnFJ4gbdaoiOlnJuqGqhNLmRzl1UCYSUtMJ6YazIklvEHWGTsbbDc4QGT+leYgHmqhbq+84vyVMqthSqP7ZVs3ntx0bbVYEoSHlptRP7/fWz4cic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 55AC368BFE; Fri, 25 Sep 2026 08:27:10 +0200 (CEST)
Date: Fri, 25 Sep 2026 08:27:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: support for RT data checksums
Message-ID: <20260925062710.GA3798@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <arWpyhFyV3ouYAEx@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arWpyhFyV3ouYAEx@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 25, 2026 at 08:52:58AM +1000, Dave Chinner wrote:
> There's new buffer and inode locking in transactions,

Not sure what is new about that.  Tere is a single new transaction,
which logs a single buffer per transaction.  Not exactly new and
dancy.

> and there's a
> whole new buffer cache interface to "read a buffer", and that is
> used to open code reading checksum buffers and joining them to a
> transaction rather than using the existing xfs_trans_read_buf...()
> interfaces.  That in itself needs careful consideration, and clear
> justification for why it must be duplicated to stand outside all the
> existing BLI/transaction APIs, especially given all the "use the new
> async buf read interface to do sync buffer reads" behaviour across
> the patchset that could just use the existing interfaces.

I'm not sure what to make of this.  The paragraph almost reads like
AI slop to me.  The rationale is pretty clear and documented: it
turns two dependent reads into two reads that work in parallel.

> I'd also like to have the format of the new on disk log item format
> structures clearly documented (because we're going to have to

There is no new log item format, it uses the standard buffer log format.
The buffer payload is somewhat new.  It is is the standard rt format,
a xfs_rtbuf_blkinfo followed by the real payload, which is an array
of checksums.

> validate them) at recovery time, and also have a clear explaination
> of the data vs metadata ordering algorithms that ensures that
> checksums are always valid in crash+recovery situations, especially
> w.r.t. data integrity operations like fsync.

I think I explained it pretty well, but happy to repeat it again:
The zoned write path writes data first, and then records bmap, rmap
and used space tacking in the zone from the I/O completion handler.
The rtcsum code builds on that and only logs that csum from that
same I/O completion handler.  I.e. that data must have reached the
device for the code to log it to be even called, and for devices
with volatile write caches the generic cache flushing must work
(it did not until recently, but the verification of this code found
that bug and it is now fixed upstream).

