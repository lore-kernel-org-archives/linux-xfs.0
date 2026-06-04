Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F32F425CC2
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 12:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780576639; cv=none; b=OHYSrM9CD9aNVJKPgHJF6YZeSAomd6viZj34lc3XwBeN0Zmzsvvn/cWGbLf/XkRpgPbv7c0Wwcm8xtwybxMtklErxW2hrElnnd/0UHzulFV9Bik3VnG9NcHIu3yfaIAGp0UqCSdb+F5bX/Oc+qyBUboQPfXgzmZ3davnIup0w1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780576639; c=relaxed/simple;
	bh=wEmT/BdJBeL00K5yimO0UMQ1Y4Y/XQH5Eo/78ZfGF34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pLIt8B9HyaYaM68MddShGBM0rUGhCAiPW9BcKtOmGTyacKEbQiIaXJoUfJ6L1I7eGc6LLYQu7Q1+fhB0CmoewVBH1QGNjOkmrT7LNQ3usiC9rCsDPrA79Y3bpEN16DA0gTOMjyLfozcZmmQsUflSJXH/5sI/c3rwXWX+2FAj0bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXempQ2T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXempQ2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B3A1F00893;
	Thu,  4 Jun 2026 12:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780576638;
	bh=EIJGqaEMu0tt1sTM4HTSHqf0YXDzwPWivGlXb19O080=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BXempQ2TTRAab2QYJXXNYgMz08VxPr1SHjHTl5k+xyBkzAH9pesuFHr0QFieCWbQj
	 T3KrJEkulKkDrIZV1Hjt1MUkQCiNmytqyscO6rKL/FIf2Hj4x6JmstEXIp98vn6Ge1
	 sWtYRgOAxUT5lGuo4lZXm1SVsq7f5TFp4pYSbtg+NanInKv/Ae7BdPU5tDuYCzOufj
	 lCkHOjGvu1koDDb3sDzDU5mkKpdjO85mNNri+jIxp1k82EblANszccyZHJLRlBNun9
	 HQ+0VM6bBjptbgnopMRVUkb4onPOyXqrw3w8I4h7Tmjtson5iVHZ5zkjxzzCKYbkTY
	 H59bbcKscxe+g==
Date: Thu, 4 Jun 2026 14:37:13 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 08/21] xfs_scrub: widen scrub and repair dependency mask
Message-ID: <aiFxZ6YMpqcsaNfz@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303256.2608728.4779400218969576550.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303256.2608728.4779400218969576550.stgit@frogsfrogsfrogs>

On 2026-06-03 23:06:25, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex observes:
> 
> "Since `XFS_SCRUB_TYPE_NR` is now 33 (`XFS_SCRUB_TYPE_RTREFCBT` is 32),
> any scheduled scrub item drives this loop to `j == 32`, where `1U << j`
> shifts a 32-bit unsigned value by its width. That is undefined behavior
> (and will trip UBSan or allow miscompilation of dependency scheduling);
> the dependency mask and shift need to use a type wide enough for all
> scrub types, e.g.  `1ULL`/`uint64_t`."
> 
> The presence of a shift overflow is correct, since there are now 33
> scrub type codes.  However, the local loop variable isn't the only
> problem here -- scrub_deps and repair_deps are masks, and they aren't
> wide enough.  As a result, there's a lurking logic bomb because RTREFCBT
> will never get selected.
> 
> Fortunately this is benign because no scrub/repair type depends on
> RTREFCBT, which is why we haven't seen any complaints.  But let's
> eliminate an avenue for us to forget to fix the problem.  Widen the
> masks and the local variable to fix the problem.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.14.0
> Fixes: b71fbe4c3da263 ("xfs: scrub the realtime refcount btree")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
