Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5B7EED8;
	Sat, 11 Jul 2026 01:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783731972; cv=none; b=iwfUknhkoDp95C/XX6yK1eOdH7kdIhe69ksO8mH59cwzJ4slyAKBQcrl2YpTgLOxmCMPDko9mXxOqseI3HfKmCKXVXTzasxnl7tw+oGOZTU1SHtMLcUoh6tP+Vc7/O706q469ReRKY5mVQDS4xliB0T2nWU+IGIxLeASeAjzT+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783731972; c=relaxed/simple;
	bh=uIqPh2KSP9NazaagUlhNW6JsbW9jIMkwWO+OWBL96dk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DHbG3XyrqfAv9kyacOPXbVJPAx+VOIp1SLqy5Bw0N0nwPMo2Q6gNLCBSfginrX/2TqmaP/D4kvxeDVCsANRslp1KMm0uMRET1lyl0x2ua0nt1yWx988ykQR15DPF48gcNBcSTA25Um1GzTNn0g2Hf/rZokCWoxYYKdkTXANTEnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMcBEoZt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMcBEoZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78EB1F000E9;
	Sat, 11 Jul 2026 01:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783731971;
	bh=Z1JsX9peK+DaHBSGxqPCV8pzR9YubUyAgMDuHcT34Uw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mMcBEoZti/qlk5q85oCFNhg5hB8rgjzcrSp/g4Xr2T00+GghMjSubevYIYhM1p2wQ
	 BwzqSGg0PLLZqtHYZbiWJyu5RyWKnki0m33X3fEv3MaevCjrwxQ7sVQvQq1EYzolz1
	 M444jLc6MVu8hc/ctEXaimlk2Ifs/vpZPDlQmMAQxPxWvn3MdGToQCueC4DCdUfuAM
	 yX3NrZfLS7JjMtvb7JXLpgbary8SVf7CON43//x9HZYY0xusUWHToLk7gGxSMXQxfX
	 bzV9k7CIq7zZUx+3tzO2djkQJ5emGczx8/WnRDFLJdL8o+4b2Rx1KLg5uTxmEvQpmC
	 Fxyb0jrmT9Ysw==
Date: Fri, 10 Jul 2026 19:06:09 -0600
From: Keith Busch <kbusch@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, brauner@kernel.org, aalbersh@kernel.org,
	jack@suse.cz, tytso@mit.edu, jaegeuk@kernel.org, cem@kernel.org
Subject: Re: [PATCHv2 0/5] direct-io file extended attributes
Message-ID: <alGXAan8P6mnbvvz@kbusch-mbp>
References: <20260710210646.3576365-1-kbusch@meta.com>
 <20260710215328.GE1911@quark>
 <alF5BHEZ5czyJWaY@kbusch-mbp>
 <20260711002412.GG1911@quark>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711002412.GG1911@quark>

On Fri, Jul 10, 2026 at 08:24:12PM -0400, Eric Biggers wrote:
> On Fri, Jul 10, 2026 at 04:58:12PM -0600, Keith Busch wrote:
> > dio offset alignment of 4k, and a virtual boundary of 4k.
> 
> So each segment's length has to be a multiple of 4k, *and* it has to end
> on a 4k aligned memory address?  That implies the segment begins at a 4k
> aligned memory address as well, which is just stx_dio_mem_align=4k.
> 
> What am I missing?

I'm apparently poorly explaining PRPs, but I hear this is a common
experience.

Simply put, any virtually contiguous buffer that starts at a dword
aligned address is a valid io vector, no matter how many pages it spans.
It doesn't matter where it starts or where it ends, but every page in
the middle obviously starts and ends on their page boundary.

Simple case: pread/pwrite. You can consult statx to know you can provide
any dword aligned buffer with an aligned length, and that's a valid
direct IO.

What I'm trying to enable here is the vectored preadv/pwritev type paths
for hardware that don't need to subscribe to PRP constraints.
 
> What is a specific example of an I/O request that you'd like to be able
> to submit that the existing UAPI can't declare support for?

I want to support NVMe SGL. This allows virtually *discontiguous*
segments that we currently can't distinguish with what statx reports.
I'm trying to report limits that let applications know what constraints
they're dealing with.

> > If SGL were supported, there would be no virtual boundary gap, and max
> > segments is 256.
> 
> Can you elaborate on why DIO users need to know max_segments?

 * Logical block is 4k.

 * DMA granule is 4 bytes.

 * Max segments is 256.

That's very typical NVMe device contraints under SGL capabilities with
the linux driver.

You can provide 4 byte vectors as needed, but you'll hit the max
segments limit before you have a valid IO if they're all that small.
The average size needs to be larger, so we need to communicate that
somehow.

To be clear, I'm not interested in trying to enable applications
dispatching thousands of 4-byte vectors to do an IO. That's a stupid
application. The applications I'm trying to enable have unpredictable
offsets such that a tiny fraction of vectors are indeed that small, but
that's not a typical vector for the payload. But I can't enable just
some without generically enabling all.

> I'm worried about the UAPI duplication, as well as it going to be very
> difficult for userspace to correctly use this information.  With just
> the two alignments there's at least a chance of them getting it right.
> If we throw virt_boundary_mask and max_segments into the mix, I don't
> think there's much chance.

The blktests framework test case "block/043" does this with great
success with these exact parameters, but it takes these paramters from
the sysfs attributes. The same test works with filesystems too, but I
haven't gotten around to porting it to fstests because it's gating on
having this series.
