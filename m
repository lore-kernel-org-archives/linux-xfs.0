Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F350D35B632;
	Tue, 28 Jul 2026 05:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785217843; cv=none; b=br06RDHHO3SCDawhn1dIPlmvKFSkqfL/jB3jR+c1p775DrgUpWDj92bEqA0JiPgf8yEon1isCb1oA+6MzY3bRpmDXPNyDhIc/mZoeudIV0NAJaGclgA6vrVfxjOQMaTdneIvwsLdMInjOUWnlanqtEUeKUdsGYt5RNz4UkRxwak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785217843; c=relaxed/simple;
	bh=0Bk3w2HZPHK5McCODseQxLGZFerJ+I90wc3Xzw9+Y0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V4cSvDgYzUxOESHvxeFi6AnLwrCbcokXEXV1sShC+Mo7G0uEq92l4v6EJA7NmvGM9N0LGqMbqgyII1zjS6F5+/RAAbXldjBw2np4NWMeKbR7eWeF124P6iM+2KAxhS+OHo70Y5ke2Z47IPI6BkbHAjjM2MVULr46RqUZ4BJwTS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VKV0GyIj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VKV0GyIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5175C1F000E9;
	Tue, 28 Jul 2026 05:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785217841;
	bh=7RSQlSZ74tUvUSC0pLiC2vJIgfUaYlvS5eLq7/7sfks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VKV0GyIjK0GL4FtieY77ZquJC4YCLVOOeIePgpFVQtZ9FE8QwEl3XkYUCBacc63Kd
	 bhX5juOiJVyrnkYjGP4FCXg6+R6tiCKn6hlpoQY350cHeC56BcpWXV0ozB5l8dhdKH
	 NGyExdX52ZCRm2DhlM/zqxWLMS2Ohsbt5pCYVgYbozmFx6GasQoqiKVbmLmIqH7wfJ
	 nSGTo/mn0kEWS1Z/uqitZTNAzSnJeOtzH1gMBBcqHFPWeJxt55V79/js1dowNtioQH
	 Hu1bT/qlVCKKKPqafvWZsCPKTqZByyk7xQ52ChMJWjlOQKTbSgYMoFdgXSZVCLknTJ
	 muZQaurdChR/A==
Date: Mon, 27 Jul 2026 22:48:47 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com, djwong@kernel.org,
	David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 00/12] fstests: introduce fscrypt support for btrfs
Message-ID: <20260728054847.GB99797@sol>
References: <20260724133328.1837318-1-neelx@suse.com>
 <amgfuk12imPN2XJe@infradead.org>
 <CAPjX3Fd1KPswrsNe=BeDpkDwi8CmL9HNKcPScMsgGN16MDyVEQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPjX3Fd1KPswrsNe=BeDpkDwi8CmL9HNKcPScMsgGN16MDyVEQ@mail.gmail.com>

On Tue, Jul 28, 2026 at 07:44:37AM +0200, Daniel Vacek wrote:
> On Tue, 28 Jul 2026 at 05:19, Christoph Hellwig <hch@infradead.org> wrote:
> > On Fri, Jul 24, 2026 at 03:33:16PM +0200, Daniel Vacek wrote:
> > > This is a rebase and cleanup of older patches [0] from Sweet Tea and Josef
> > > fixed to work with the recent kernel and btrfs-progs changes.
> >
> > I'm not sure if you post this just for reference or what the intent here
> > is, especially with a cover letter like this that doesn't have much
> > information.
> >
> > Before we doing anything for the btrfs-specific fscrypt changes in
> > xfstests, those changes should be accepted upstream first.
> >
> > Maybe some thing like splitting tests might make sense without that,
> > but then it should be posted separately.
> 
> Hi Christoph. Thanks for looking into this.
> 
> Yeah, I could have been more verbose, perhaps also using an RFC tag. I
> wanted to get feedback and a review from a wider audience to see if
> this is a viable direction. This is currently the base for my btrfs
> fscrypt development testing.
> Especially for upstream fscrypt changes, when sending those patches I
> was asked about tests support. I understand to keep fstests OOT as
> long as the kernel part is in development. But at the same time I'd
> like to make fstests complement the kernel part and ensure they are
> ready and available for everyone throughout the process. Kinda to
> "bundle" them all the next iteration.
> 
> Would you suggest otherwise?

Please keep sending out the tests along with the kernel patches.  But
yes, they aren't for immediate merging and should be tagged with RFC,
and the cover letter should mention that the kernel patches are pending.
Thanks!

- Eric
