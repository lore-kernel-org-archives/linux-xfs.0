Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87ECF28688E;
	Wed, 27 Aug 2025 07:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756280085; cv=none; b=M7oZo4vBpZxRa+FhCDlQb/P2fJcxu4B0tWjvAgmPg7uPw9hip+QYqApSgPa/uYybUN3qZLxrs7X1BAdbpf2erMqtuxzxO60Kv7Vbuf9ZiSpYtv8LVvjyP+MswhdLGnrfNANsYxvkadYKa7kdRZWWW80niCa3Om1SDrmARYhNqD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756280085; c=relaxed/simple;
	bh=g92ghK15enc1n0onrs5hKTJfuRgAC8IlvFVjcfvMDD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pwWWM1o0NYkHy+ipcfpEuIUdpNvTUcYINrfQyl4l+2H51uc9X9+zIfCL53/KMvrn2HPMnXrYYK1rhrs6xs7uC1GSTolO1cF2VQkhG27GfH5ShR6cMAf8MCRzJDKAU0OtxGyLwwkzLreJ8mj3om5UjqTmAC0GEpUsPkjQ5beG0rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Gp9uPZWd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gp9uPZWd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FB6fJ/8c1+jY55pJr5lV6RB6vPB5EZ/lVIPbgDGZ7r4=; b=Gp9uPZWd9/7E4LWiD+EyIEKtDY
	xSoULtqqBQ8VA/RH6/PMiPG4YEPrzzYqmF+JLnPfDRyjSjLdBYnekBlIOch1MCBgU6a+Kg1ao6TeU
	nSkBfvDtFO/CC9b/KU5ZA2u00pxSLT4hnL9BCvbyJTdiHnQ9N34viqhN8Qr0n5e6h3vzDzArFeNs2
	qVOo6nHMYQq2QZevPkTBb/DHq/zEwpZoXKiBaXqKlQN/XAeAtsd/xjhhQWGEQMXrguv6z4VUCIBXK
	820VozJgh49GwgR/8K/Z8Uv+mtG0e3tvS7wwmJ7GldyiFSScNtXxy8qXhkyWSaJTvybXin59jsVIR
	+jj7x1kA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1urAg8-0000000ERQH-0D5t;
	Wed, 27 Aug 2025 07:34:44 +0000
Date: Wed, 27 Aug 2025 00:34:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>,
	Dave Chinner <dchinner@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: do not propagate ENODATA disk errors into xattr code
Message-ID: <aK61FCz0wgz1s2Ab@infradead.org>
References: <a896ce2b-1c3b-4298-a90c-c2c0e18de4cb@redhat.com>
 <20250822152137.GE7965@frogsfrogsfrogs>
 <aKwW2gEnQdIdDONk@infradead.org>
 <20250825153414.GC812310@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825153414.GC812310@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 25, 2025 at 08:34:14AM -0700, Darrick J. Wong wrote:
> > +	case BLK_STS_NOSPC:
> > +		return -ENOSPC;
> > +	case BLK_STS_OFFLINE:
> > +		return -ENODEV;
> > +	default:
> > +		return -EIO;
> 
> Well as I pointed out earlier, one interesting "quality" of the current
> behavior is that online fsck captures the ENODATA and turns that into a
> metadata corruption report.  I'd like to keep that behavior.

-EIO is just as much of a metadata corruption, so if you only catch
ENODATA you're missing most of them.

> >  	if (bio->bi_status)
> > -		xfs_buf_ioerror(bp, blk_status_to_errno(bio->bi_status));
> > +		xfs_buf_ioerror(bp, xfs_buf_bio_status(bio));
> 
> I think you'd also want to wrap all the submit_bio_wait here too, right?
> 
> Hrm, only discard bios, log writes, and zonegc use that function.  Maybe
> not?  I think a failed log write takes down the system no matter what
> error code, nobody cares about failing discard, and I think zonegc write
> failures just lead to the gc ... aborting?

Yes.  In Linux -EIO means an unrecoverable I/O error that the lower
layers gave up retrying. Not much we can do about that.

