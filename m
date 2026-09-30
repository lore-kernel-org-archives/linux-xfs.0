Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E98472068;
	Wed, 30 Sep 2026 09:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758895; cv=none; b=ENWCjSmnH1EYyU/bUYCxZnOffDjmzl7/XzAoCMnOh/hzU0cJUJjNPoZxDbyPUow5YxRgBTJpHCy/EBMuy0pGWa75HvBI3bSbL8d97pH6QYv8p1+cauAa/A+O0Qm2T0nLBCNUchuBh9q1IP2CDAjMYnDf+Xw0WBSCe6a+FcyLa6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758895; c=relaxed/simple;
	bh=NFXmMbDu6fLF7FvzuqyNMK8WMZXRuTUOckFrmWlZez0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gjfobtrlOANyV2YDD7sWAx0eZf2SB+lMMPfelT5pBQif+uJl+s/nb2iQvVv0QNJSai8fwIu+cZ81gxX8/DJmTQwieldoZQt8g9HI6ORprV+vjyZFzd/38Hv8WSLc14VMorT+Y6zXxFgcQnE7B/ptENGwmt+LbH+cMrInr1EgAVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lQSkbE55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lQSkbE55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19A01F00898;
	Wed, 30 Sep 2026 09:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790758893;
	bh=Zf6eMLjYKuzeiP6lZQwHwghJA/LU8V6bqrmvEI01344=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lQSkbE55GUe+ub+5+fiWnVseCz9XkzdUo5XG12hMhqmoGcUa76Vi1komRrZVfGd/S
	 K9iIw2KdfH0oUYd56j4FIJDiMuPYyorRnFwF8kmqiljDIh4etvU3DGrkGkq47h09ml
	 58BLptGsHMKSFpaXhKM/L1eXmlwUNWdaCwb/Q2qusouzFMwep2rjRXugAB9C6H8e0K
	 JgVlCNBNUgZcNH4uO/ad6l2yQXiNgiE2xL4mhVsMgIXn8wYxrEk7ZMlPnnv4zpU54C
	 zA6Yg3wvcpCIWB3R4HApZcgJI8SdWD40vOAp9Ckqe315wT7RSn5DBl36wcSKXWrHRl
	 B6qi8y/rA10PQ==
Date: Wed, 30 Sep 2026 11:01:28 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Steve Shoecraft <spshoecraft@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [RFC] MXFS: a shared-disk clustered filesystem derived from XFS
Message-ID: <arzPGSQWTot6vmU0@cronus.toxiclabs.cc>
References: <56847E8D-EA83-4984-82F3-9BC93E4C02FF@gmail.com>
 <ardhDI-Ko7b5RccH@infradead.org>
 <BC228018-42A4-4715-B186-057AFDE8A4D0@gmail.com>
 <arj3Mp6Cq2_qwaIb@cronus.toxiclabs.cc>
 <1B01BE22-06A8-412D-B141-CD94026E0A39@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1B01BE22-06A8-412D-B141-CD94026E0A39@gmail.com>

On Tue, Sep 29, 2026 at 09:19:39AM -0400, Steve Shoecraft wrote:
> I’m disappointed in your responses. I would have thought that you’d at least be interested in how well the AI did.

And I'm disappointed how you didn't get the point you should not demand
others to validate code you didn't bother reading yourself.

> 
> It’s going to get better — not worse.
> 
> Since the initial 2-node TCP/DLM release (0.89.77 on September 23), Fable and Astra have completed 2-node CAW (0.90.7 on September 26), and 4-node TCP and CAW (0.90.24) have now been released on:
> • Proxmox VE 9 (kernels 6.17 and 7.0)
> • RHEL / AlmaLinux / Rocky 9.8
> • Ubuntu 24.04 LTS (GA kernel 6.8)
> • Debian 13 (kernel 6.12)
> 
> All are distributed as native DEB/RPM packages, with the kernel module built against the target kernel via DKMS.
> 
> The 0.90.24 release passed the complete release criteria: 4-node TCP 31/31, 4-node CAW 30/30, 2-node TCP 31/31, and 2-node CAW 30/30. All four platforms passed their packaged installation and validation runs.
> 
> The goal is full 32-node support for both TCP and CAW DLM.
> 
> 
> 
> The next project is OSN — a fully AI-written OS from scratch.
> 
> 
> > On Sep 27, 2026, at 7:03 AM, Carlos Maiolino <cem@kernel.org> wrote:
> > 
> > On Sat, Sep 26, 2026 at 07:32:27AM -0500, Steve Shoecraft wrote:
> >> 
> >> Good catch on the magic - I had it changed in previous attempts and forgot on this one - release 0.90.0 has MXFS unique magic.
> >> 
> >> I’ve been writing device drivers since the 90s on FreeBSD.  This was a research project to see if an LLM could do it with the right harness.
> >> 
> >> Release conditions of course included 100% data integrity and 100% stability.   XFS was the right choice for the base.
> >> 
> >> Intent is a good clustered FS for Proxmox to compete with vSphere and VMFS.  Yes, I’m aware of the differences in implementations.
> > 
> > If you are not even bothering reviewing your own project source code as
> > you stated, don't expect anybody else to spend their time or have
> > interest on it.
> > 
> > 
> >> 
> >> 
> >>> On Sep 26, 2026, at 1:07 AM, Christoph Hellwig <hch@infradead.org> wrote:
> >>> 
> >>> I don't think too many people are going to care about your LLM dump,
> >>> or even review it.  But please make sure you use different magic numbers
> >>> so that a mxfs image left in the wild is not mistaken for an xfs one.
> 
> 
