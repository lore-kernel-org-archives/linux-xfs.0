Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC36E45C71F;
	Fri, 31 Jul 2026 23:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785540523; cv=none; b=eZ5YMkEcs16hHNl7p48266RaI2D4j0qcwDQD+IRosJ8r5BlxF+6nBwVdcI8IPabJr21sAnxiKOSuRJNLX7rXUKctwdh457rddMiQW1BoOgv8vIqKFm27cVpcBLvvz61+HEmpn7mIapqllcs5CSFY7nw+tIEde1fwEfIRZYXDny8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785540523; c=relaxed/simple;
	bh=E3r8FCJuBiRU3Xv8wwDurllKV87o3W+8JalvHKOq8Fs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U1xCrgAVWf+WUWpZ+TFU2pZa01g/kCih7714W48GQUQBEMP/ZxhlNDUO5sfydbiusX3kQFqNOnk2BXWgSVPW1iLfteV98SNmyY7ESDLoO0LQuEjcugKrMrRGrmSIxo8HBsd/OM3ew2COAOt0rButKz0PDohjsFJdqzhwY4sWcDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inW9ji0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inW9ji0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BE91F00ACA;
	Fri, 31 Jul 2026 23:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785540521;
	bh=aH6ege4UbeplDIKeNnhoASGAJzO6VZ7IUm4ZGuf/NLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=inW9ji0acURGuuH9OC+GrGCN39bhLtqMkHVT38p+0XjwGQxRQKgXo9+1knJdKQWi+
	 G0Rst4TgQYwhSM780PNReJeMMcrxFt5VDpQFgsR3VWsqq2cO48G5mcJvycQ2Z+iO76
	 6pR+9K+Sj9Pc2Q/pyDNfR3YvrEjZoJSCqT31aLTJcgGZAhHiTfmu8+aK2gh5ord++a
	 x6IPmlkTcW8DxlJ2XRpxdZQ10lQtgypvUWYGoclPx+/4VKOJ0nDowBRDZ1n+zrRzwC
	 53qS8iw/nlZDx1FKqFxD9fTOzUPDLptJ5fp6dgsFwHssBUtQLNf7Tu7igeHzzYdiOC
	 w2R9BRWNJMZfg==
Date: Sat, 1 Aug 2026 09:28:32 +1000
From: Dave Chinner <dgc@kernel.org>
To: David Lee <david.lee@trailofbits.com>
Cc: cem@kernel.org, Kyle Zeng <kylebot@openai.com>,
	Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: validate btree block level on read
Message-ID: <am0voArOlA31WBC3@dread>
References: <20260731120344.558808-1-david.lee@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731120344.558808-1-david.lee@trailofbits.com>

On Fri, Jul 31, 2026 at 12:03:42PM +0000, David Lee wrote:
> Btree buffer verifiers validate record counts against the level stored in
> the block itself.  Callers of xfs_btree_read_buf_block(), however, use
> the returned block according to the level they are traversing.  A
> corrupted sibling pointer can therefore return a verifier-valid block
> from another level and cause out-of-bounds accesses when layout-specific
> entries are moved.
> 
> Pass the expected level into xfs_btree_read_buf_block() and reject
> blocks whose on-disk level differs before returning them.  This
> centralizes the check for traversal and sibling reads.

We already have a centralised function that does all this level
check (and more): xfs_btree_lookup_get_block(). It is already passed
the expected level, and it also checks various other per-usage
header information like owner, level specific numrecs bounds, etc.

If we have to verify per-block context state, then nothing should be
calling xfs_btree_read_buf_block() directly except
xfs_btree_lookup_get_block(), and all the read context checks should
be performed in xfs_btree_lookup_get_block() (as they already are).

> Fixes: 3d3e6f64e22c ("xfs: verify btree blocks as they are read from disk")
> Bug found and triaged by OpenAI Security Research and 
> validated by Trail of Bits.

Great. How did you reproduce the issue and test the fix is correct?
Did you submit an fstests that reproduces the issue and verifies the
fix works?

> Assisted-by: Codex:gpt-5.6-sol gpt-5.5-cyber
> Signed-off-by: Kyle Zeng <kylebot@openai.com>

Yeah, nah. Patches have to be submitted by a real person, not a bot
account, and SOB should reflect that.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
