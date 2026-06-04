Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D4742DFE8
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780581801; cv=none; b=JqrhDZfGFntaI7XjQ7KeYmTSQfgwc0eLq5nJ97ite2160wz+qtKIXNW0Opde7gb/uNWm7l0V3rUAvt2HdDKxOLTBn/uc3RYehSVoC8X+3hTKSiyAHjI9yvuvu5xxA0PaGKWaRMIrLhNgT8z8IB6xnqVBGF7nCOlRbgFB7pVtSgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780581801; c=relaxed/simple;
	bh=ivnZdO4THnwI/USN5VMl/cE6HrMINvUHcOoEU3P1l6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MSSoq6UBywy4IUGtcQMZSOD4ZnYtTPma17iubFUJesnj3M/7Yd0nANyTMVfrX9s58FMTF3W+G7Uieir/bvbZ6poFpO5YTOTYMzZKtgXVJ6llm2qXm0TsMI5vJMGPCO+abTOMw+JcGz7V8uxDcMKQ1/tDoTKG1Lis5G4IEmWAcWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TEqzhfjg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TEqzhfjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEFC1F00893;
	Thu,  4 Jun 2026 14:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780581800;
	bh=VS7vdjGJbyzNAKZMc6X03pGHS4lwJ7Jvwz9lzlfxqxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TEqzhfjgad8rHMP60FmYjWhUOrCsEpJQXozUFuhXS10QiBDWNXGVngWyCBozwReFd
	 vhL3FiCcpjVls5nmQ8C37K0cZc7ywI5m1w7Ntw+TT3PMVufXjnk16S2W+tYxtMo+wl
	 Wsb92OvHY3n0nM7CH9iCboEMdGNYX+pYiHSqcb2dRaLJCICMYwrXWbpEJ9WkI+sL63
	 kzbGrKmKftLgdXwJ1VGKciuNmfHnnaCDVzykg+KgMtUdpngBKbrceRd8cMLVLnMk11
	 Cu5tMAxRr0982hWvZs/nZKiLkVQ35JhvANjrSm8T+0YR7/cm+6gZo4MeN7GoQYz8IT
	 jCcjVz6SGjcqg==
Date: Thu, 4 Jun 2026 16:03:17 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 13/21] xfs_scrub: don't allow NAN as fstrim percentage
Message-ID: <aiGFl2IWlOyqQ0V-@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303346.2608728.5900831081865002391.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303346.2608728.5900831081865002391.stgit@frogsfrogsfrogs>

On 2026-06-03 23:07:43, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't let users pass us -o fstrim_pct=NaN, because strtod will happily
> return what looks like success but isn't actually a number.  Codex found
> this fun little nit.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.10.0
> Fixes: 34bed605490f93 ("xfs_scrub: tune fstrim minlen parameter based on free space histograms")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
