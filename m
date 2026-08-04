Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434CA47045B;
	Tue,  4 Aug 2026 17:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785865864; cv=none; b=NbXZl6qvhxEjtEfkOOTkWF/9wNZ1/VD5kZSzwZGhm29fmn8hPgqyzLx3ympcMeXruVFYIuGy+lZPQQkbC9WQlCFP60Gsr9LHTlcqLCaxqV8D9pfJtFBR1QqTDFjjohzSy4QWMeR2EekGcK5nmr4cjh5WSElRUvYUBl6VO/V8f3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785865864; c=relaxed/simple;
	bh=i4L4VJZVnwf438qepkJWN4BnAJpuXHdWhvSUzADVgjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nTi8SFzLz/I0aaHvlixVcEuSJJ4Tstaon9OGlxC5Wwt/R9ZioPI5zODQMJsnDDDZkbUJsLrlxYFs1+XbCtnMC1EtSxjwybJ3zqqosjQeWf+MVNSRZxuSiYhLd5JYZSkqI8y5HMLHHECzFYPqw7NfjY0gcJwa/st6KXqSq70CdAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m5IdKNug; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m5IdKNug"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A3AE21F000E9;
	Tue,  4 Aug 2026 17:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785865858;
	bh=I8LRWH1bi3T0NweVTozAAvIupKrxRjTY2/DR6XsfcMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m5IdKNugeqjKEi80s7/8HVn0HhRqgSmpAUwVfhF7lEwEt01cIIdZFGH1TPlSgXoG4
	 n4Gqj2oxtEXTz/SdBs8zvo5Q0S7BihKBmPf/L/ewhvM9yFMKmAwm+nTWo7MxWldluv
	 0LAFKyJWRKKm1NrlfOgQiVNFlXef+4UnlCIaajYZZohCNqojSyM6WTwfwq8EqvdM/8
	 1DZ175597j8AGHtL9/Rl02fg6UNrXCNtk13Y8p9fxj2wBuUOERImKgJsSAvUTDv+h7
	 F53YaYAe+mQjnTFzlrj4LtabzalCuj7ORZluhc3ywBi56EnBS3qOFyv85Nf2xkPple
	 rbMDYQxY3k1Ew==
Date: Tue, 4 Aug 2026 10:50:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v14 11/21] xfs: don't report dio_mem_align and
 dio_offset_align for fsverity files
Message-ID: <20260804175058.GH3556460@frogsfrogsfrogs>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-12-aalbersh@kernel.org>
 <20260804174347.GC14046@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804174347.GC14046@lst.de>

On Tue, Aug 04, 2026 at 07:43:47PM +0200, Christoph Hellwig wrote:
> On Mon, Aug 03, 2026 at 10:08:01PM +0200, Andrey Albershteyn wrote:
> > Sashiko.dev reported that while fsverity files falls back to the
> > buffered IO for Direct I/O, they should not report non-zero values in
> > dio_mem_align and dio_offset_align, meaning it's not supported.
> 
> This doesn't make much sense to me.  If we didn't want to report
> we'd also want to not set STATX_DIOALIGN | STATX_DIO_READ_ALIGN.
> But in the end there is very little upside of this while adding
> extra special cases.

directio is supported; the implementation merely falls back to reading
through the page cache.  Unless you're saying that xfs shouldn't
shouldn't set FMODE_CAN_ODIRECT for fsverity files?  But that also
doesn't sound right.

Personally I think sashaniko is full of it and this whole patch should
be dropped.

--D
