Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B3043900F
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 12:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780575473; cv=none; b=sasqR6TDgwxwkvrOvIdSiSlESJWXxQZBmmvGthl/T7WEsQP3u1epQsRBC7vaIU5nlloqH0KpxMMdQ5jfrb98xve4sicvULq3Lsm8yZoPNeNfuiLH5HWtZQa012d1kyKg+fKvaH4y/wR5BnbDvjdnugvIzut25zGwOLc25VzMtD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780575473; c=relaxed/simple;
	bh=6VubSvQuUBBgCr72i5SxD/K5hruoa2UZZyHHH5RzY+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZwkACuPEoNEBfED8sV3+nlFejkkELlVPgOboWJ5UxvFTlvU8ExyTgsxKjTTxuMz3OOW/a+oOX6rQMbOyQyxJ/96uOhELYY2qVa8bOT+UXVBzqRRfoXgBA3+G3E0j74nF7y1mvcFmtUxYAajyrSCgi2skDowlTu8hWyGPcSYf5ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MgcW5vxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MgcW5vxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC8C1F00893;
	Thu,  4 Jun 2026 12:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780575472;
	bh=dsqQluB0u2y2sXWf7exBUbDaVStAOxoTD9IV+XdYTiQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MgcW5vxglA3z70cc9QZ7Vht6429lup3wqnqn8ProPgvxIMioL0J/er2lOAgO67VJi
	 VZReykFobClevrd5D8TVchBlrpEp5NupRwyjMCB6eLC45r2ApnEMU2d7QmxpNUjrGN
	 972usj7FHo8mzF8kHkW7SKwaZ0etlPfer8iALBei4vtEfKsOm3AQYN2bWD+dZzEis9
	 IdEt/4AzW9XmRRVzW6QwqRWTD65976guHiZxETzxyIA46N4EeQl+eCxX8gwm8g31hi
	 5FsS2bzm2AAt7DeQLzJHuRAyfhkGSgg8bRyKSwdujjySMnjxsanCfGL57+SUpJiley
	 VkwkXMzCtrfGw==
Date: Thu, 4 Jun 2026 14:17:49 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 02/21] xfs_scrub_all: fix broken command line string
 array construction
Message-ID: <aiFs1qRG_UKaOrYd@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303146.2608728.14242967527737251351.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303146.2608728.14242967527737251351.stgit@frogsfrogsfrogs>

On 2026-06-03 23:04:52, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In scrub_subprocess::__init__(), we construct cmd as an array of strings
> to be passed (eventually) to exec.  Unfortunately, adding a string to an
> array of strings doesn't do what you'd think in Python:
> 
> >>> x = ['moo', 'cow']
> >>> x += '-x'
> >>> x
> ['moo', 'cow', '-', 'x']
> 
> Fix this problem, which Codex has sharp enough eyes to catch.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.10.0
> Fixes: a290edcfa0a391 ("xfs_scrub_all: encapsulate all the subprocess code in an object")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
