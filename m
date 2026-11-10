Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794327754;
	b=vS6+wVaFy3QdzaH41eMiCdScuknVvk8T47ZB0+DCKfHKeb/oG1cBzybUX+GEJLj4XUy4
	 0Q73HVsRxigfNe3VA4QLWjfLabU9hnqnFsdJsmAXzAQc9hsH1hB+x3YUYWWcg2XYuR/zZ
	 LbUKPqRgKyEVHsWN9fKHXkApMm59l+es9Ynmi+MRScnNRb+qVJtawXn0guG95qJPCsaaH
	 XvTJ2Scjh03XF39FvNbLw+fkJq7mlajvYulhh56/YZv50OkYf/dYFBdDHBOwMOAbCrRoG
	 6jrij7EFbhPS0Hd2pNQ+O8AsgTCZP6oU3RVoznyPeqYB2GsXk2equOWvUMgz9FRQ17A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794327754;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=TAzU2GMT3C22UAXmvxHpngiY/xaBbQP4pL/5peBRgpE=;
	b=OuPBuPPBIAZXjY6riiRhbZbL+aBLxfrIYmBMAKXdScKFDfUAx2BSlHb7IiplKAbDs8o8
	 3+6sKGCp6EEsFMuDxJLmVrBddQeccDqS3OJwwNWEI0CjVghSCXpRpV/vAzJ42tywWh/q9
	 M6VoHrWUVGHhdsywsqR/BHjFq+gAJvqJQEFmm6WKjmgppX7GLCDbcRJw/DP2KLAEonn+0
	 GUhPMuECUPv3arVoJBljs0P12htEGm9UseuM8kvNzPfaRDLQ2mXItc1U3ekCnV9lIGGmp
	 3tv7Ma91BoUj4RvvtcvjFHjtmKFLhBA6iiQVtUKuxGoeSSIjTFNJ7eqPPkYrPifTnGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QafUKl1R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8208B606A320;
	Tue, 10 Nov 2026 16:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QafUKl1R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B56C1F0089F;
	Tue, 10 Nov 2026 16:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794327754;
	bh=TAzU2GMT3C22UAXmvxHpngiY/xaBbQP4pL/5peBRgpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QafUKl1R8c388noCv38EBBSU2fhsBJOSiYRTywushhDAc4SWd+01X6Hmm28Ftwsvw
	 tgplyjiVHQQCKjl1rD0At1A70HC/VUxuSXscwFHvqI2nvAX1gG1Rg4a+9vIwStJryI
	 UnDonbCoo0A9iJCn1Gsefh5rUWa4qahnCIwcgOi3+6hAVuOfhPfPCNfiTWFNcLMCT+
	 o0F5Ge60BT9r8z4tUVmgQF+sj2oQb6YQH77vkMi3DVETWh7AFLMRxoaXl3hN8Fs9aF
	 4jiByaTAAaX5sWWbGAis1tZ5ZcmFJnLkyK9kGGgi+vt7RcoKppvZST54XYhec1juAE
	 w3Fmzm2Yr3wDg==
Date: Tue, 10 Nov 2026 17:22:29 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Chris Mason <mason@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, 
	Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 00/10] reflink and atomic write bugs
Message-ID: <avNEiPY9D2ItmEMu@nidhogg.toxiclabs.cc>
References: <20261109235111.14129-1-mason@kernel.org>
 <avLnU46F6YZckcbo@nidhogg.toxiclabs.cc>
 <d17350c0-0b93-4421-8bab-8266419fbd77@app.fastmail.com>
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
In-Reply-To: <d17350c0-0b93-4421-8bab-8266419fbd77@app.fastmail.com>

On Tue, Nov 10, 2026 at 10:56:34AM -0500, Chris Mason wrote:
> On Tue, Nov 10, 2026, at 4:45 AM, Carlos Maiolino wrote:
> > On Mon, Nov 09, 2026 at 06:51:11PM -0500, Chris Mason wrote:
> >> Hi everyone,
> >> 
> >> This series did a few rounds privately, but looks ready for the list
> >> now.  Except for Christoph's patch, these were all found and fixed
> >> by an LLM.
> >> 
> >> The meat of the series is fixing reflink corner cases that incorrectly
> >> let you write into the source of a reflink.  LLMs also tripped over a
> >> few ways to use atomic writes to expose stale blocks on the drive, and a
> >> few races with realtime flag manipulations.
> >> 
> >> Carlos and Christoph ran these through fstests (thanks guys).
> >> 
> >> Chris Mason (9):
> >>   xfs: don't skip the flush before shifting extents
> >>   xfs: flush the shifted range before changing the file
> >>   xfs: don't change the block map under a dirty folio
> >>   iomap: don't punch delalloc under a dirty EOF block
> >>   fs: validate atomic writes after O_APPEND and limits
> >>   xfs: recheck direct write alignment after write checks
> >>   xfs: test for reflink after the dio write checks
> >>   xfs: refuse fallocate racing with realtime flag changes
> >>   xfs: restart faults racing with realtime flag changes
> >> 
> >> Christoph Hellwig (1):
> >>   xfs: refuse writes to files racing with realtime inode flag changes
> >
> > Sashiko found a few issues that I believe are worth looking at. If there
> > are no objections though, I'll pull in the first 4 patches which are the
> > most critical ones so far until we figure out the other ones. If there
> > are objections please let me know and I'll revert them back.
> 
> I'm generating fixes for the rest of sashiko's comments.  Looks like they
> all existed before the series, but might as well fix them while we're here.
> 
> For sashiko's complaint about patch 6, the patch intentionally creates
> the behavior sashiko mentioned.  We were inconsistently falling back
> to buffered before so the behavior is new but the writes are correct.

FWIW, I pushed the initial 4 patches to xfs-linux/xfs-7.4-fixes, of
course I didn't push them yet to for-next as it depends on you if you
are ok with me pulling them first before you deal with Sashiko failures.


> 
> -chris
> 
