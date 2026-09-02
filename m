Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848604399F4
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 23:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788392931; cv=none; b=glsEOebuF8ORkAwABD8IzjBwIOT/aY4vwUlmyIYz9sN/y4YJPWjy8rL9r/eOnRDVoR7OLFK7lnn5F234LKgbQh4/QJC0T2w8UWweGDJCoArmXwRtUyAq+mHQYZJhSkbBFO+KUUBJ8dW5H+ehlc9AXEYYnUj6P1GZuShbf89vCXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788392931; c=relaxed/simple;
	bh=7EZORutM4XKe2kzwChjTGjlPD3q0WETrAfJEoYx/uG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cKseU7Cx2574Rs89N0VPKyM6xPOegoQoCDbJYIxLreVoK0hKCXHsq+LA2WkDrmrexoT3AV3MuMgkqaNHDwze44kANXgStDP0E8/PkefmoVAsfkPsG4ucxVW3ZRizGIKVp723o8fbR1kU/Vjq6TV4kYt7rQMdtiIL2FYYLSf56Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JKgHGkEQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JKgHGkEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129811F000E9;
	Wed,  2 Sep 2026 23:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788392928;
	bh=Vo1fAQVnEWNKkxssaAjBI/x/bWu5BbBYib9d86qCvuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JKgHGkEQ5M9fUvMRdQzSQvjCuxi5EAdhN8PHMrYD1ZbYG1MxPh2pAUui7JnrvVEy4
	 bghWnXt/xgpHMr7ZEE14/ERKzR2fua+MBRyoV0YGKIlmA0q1+4GreEc2m6/CcaOkB4
	 +1kLOYxcD/p3WzIg77UxYa+17t14deGx5sT8iITZSt+FL85l4jldJNTvxZfriCtkxv
	 AEuEoa5OOuconjZCAIL3JNIT/cKSHu48fhPMzqEirdXeMCcmcLp4TW+nRzDV/hTeSd
	 kpLSZYWSQLNPCWP/Br62SRaQr0OB4W3Cph9bfndJEC2vz/CzAQQjHxWhw3zVHiZya1
	 wKOAZfrKa/G5A==
Date: Thu, 3 Sep 2026 09:48:39 +1000
From: Dave Chinner <dgc@kernel.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] libxlog: import the kernel's log recovery, log items
 and AIL
Message-ID: <api11z0M--RCj_p-@dread>
References: <cover.1788110147.git.cw@f00f.org>
 <49d9d6c177ed570d0ee5668df8a6d65ac3a27c6b.1788110147.git.cw@f00f.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49d9d6c177ed570d0ee5668df8a6d65ac3a27c6b.1788110147.git.cw@f00f.org>

On Wed, Aug 26, 2026 at 10:09:03PM -0700, Chris Wedgwood wrote:
> xfs_repair cannot replay a dirty log.  The code that can is in the
> kernel, and xfsprogs already carries kernel code rather than
> reimplementing it, so import it.
> 
> libxfs/ mirrors the kernel's fs/xfs/libxfs/ and these files are not from
> there; they are from the top level of fs/xfs.  They go in libxlog/,
> which is where this tree keeps log code, so that each directory has one
> kernel counterpart and tools/libxfs-diff can check both.
> 
> The files are copied from Linux v7.1 and are byte-identical to their
> kernel counterparts apart from their #include lists, which is the
> adaptation libxfs has always used.  v7.1 is the kernel this tree's
> libxfs/ is currently in sync with: comparing xfsprogs libxfs/ against
> v7.1 reports no difference in any of 102 files, while against v7.2 it
> reports 33.  Importing from a newer kernel than libxfs/ is synced to
> would mix two kernel versions in one tree.

This is not a direct code import - it mixed modification with code
copying.

Call it intuition, but the first thing I looked for was xlog_write()
- the function that writes new log records to disk. I immediately
notices that the kernel compat header neuters all the xlog_wait()
meaning iclogs do not work.  Hence I wondered how intent replay is
writing to the journal....

Yup, as I suspected,  the iclog code has been removed from the
journal IO path.  i.e. there's a heap of custom code buffer writing
code that is most definitely not the same as the kernel code. This
path is critical for correctness, and I have little confidence a
massive rewrite like this gets it right the first go.

Hence this whole patchset needs to seperate out the "lift to
userspace" file copies from the "modify for userspace" code changes
so that we can sanely review the actual code changes that matter.

This means -a lot more work for you-; these patches need to be
broken down into much smaller chunks that we can actually review;
a 14000 line patch that mixes kernel code with custom modifications
is not reviewable by anyone, not even a frontier LLM.

I'm not going to look at this in any more detail other than the
cursory scan I've already simply because it is impossible to find
all the changes that need careful review in this massive code
dump....

If the next posting of this series isn't at least 50+ patches, then
it probably still isn't fine grained enough to review
effectively....

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
