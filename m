Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D713DDDA1;
	Tue, 29 Sep 2026 15:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790694077; cv=none; b=h5LQMKZ7yJoqRIWJmMpS6dOQLBW4TAiLiNc/ExP3KclsuPetyhA3WPk4LcRAqATr37g+pHJJMB0AsKDu9AqDjRNlYIilQw3NHqijyJFRyrCj3hwVbWJKpSkt6Eesw+BfNz/nhFVbAU+S8G9+drdV8Y2AnAPajSGc1c062Vj5rnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790694077; c=relaxed/simple;
	bh=19zJL66XvCJ/TaYGHp0xcb/QRzdhe4G2rZ5ROWvlZVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNPue5u7VaJ6in9kqyUiJOVNlQSHHDZK3QWxzgIqfDOh5ZbLENyA23s2CiTkxISqk0ovHje/5wcBFcYi8lVkNGa8RBxNv32jhDsvtA3a/aekPVxiImbsHzq4YEMgzkG7Z3uPvzsgy0+/U8Qh6+b0YXfIHxx0c0EhX5FOjc0/rb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gR8PMQaV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gR8PMQaV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AD2A41F000FF;
	Tue, 29 Sep 2026 15:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790694056;
	bh=sP+JRMUCh1L3/Op/O8+puBriEmtt0jW98gKpRGY5Sdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gR8PMQaV3MtQSoZ0SVepw5NSSxcOfO0XbaAXVkB4uCf+Gm56J7DY/RHrp8bLpPiqR
	 utlfm38IWHa+VHbuuRHXPU1R0m/ytrRqrv5kVqflU7kdxMw2Lo+4es5a81NCM7gaVm
	 kQknz1MuXCvEhjXAB5c9QG13xpZhkzK51lPGjoN3GVm+aWLIr0bD9OQgaJfMuJ/Ao6
	 TQdNhTKgvb+jw6qnS5FFGpg4BEIG6uu8B9oX2jt6yp/0Y4L6P1X3N6hSw1IAsFNSDW
	 IdMJivbpqpXFk7CFfFMip6fESUBh7cli15EcTy9q+2nlmNayhhqxH5X1qC/UF97EXL
	 eNx2G8GpxBKYw==
Date: Tue, 29 Sep 2026 08:00:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Steve Shoecraft <spshoecraft@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC] MXFS: a shared-disk clustered filesystem derived from XFS
Message-ID: <20260929150056.GG6244@frogsfrogsfrogs>
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
> I’m disappointed in your responses. I would have thought that you’d at
> least be interested in how well the AI did.

And I'm disappointed every time someone unfamiliar to the (xfs)
community appears out of nowhere with a giant pile of code (LLM
generated or otherwise) and a request that we read it.

If you want people to review your code, start by watching the mailing
list for a month or two to familiarize yourself with community norms,
and to ask questions when others post patches.

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

Good luck with that when you can't even be bothered to llmcode a test
to make sure the magic numbers do not match standard xfs.

--D

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
