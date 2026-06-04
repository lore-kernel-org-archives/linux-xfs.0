Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F4730FF08
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 12:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780575880; cv=none; b=TDUFT4beO7BwMyf1uaH48Jojp7MYcEBE1/VmWJi2SC5yqMU5/2c9dzAPpuOTlDUx6lNZZ0rI/F2+ikM9qpYGzjTwigCYuH+/PbMzP97a/haePYEBuDjYq6Ur3mgiweiJRz8dleHzI9tepGJdXBT4IlNkLWzEhKL0df43vl0/Zgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780575880; c=relaxed/simple;
	bh=Jd+DPx2gZXfeCe4skExnR1jyOMV349GcIgAjdL9tcQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nqghw4SSvp+WQSXbyahHpDWN/ZjrQZMYoCzhS3DoC1mIQ3vKN+JEYKkhmo0JtXnSU629ORjanvLh1Jwu35wpij+W/2/iImKYvG5bNos1nUnIUoSzS7bBRzl5OBKo/AaWMbcXoDTWJPjfLCATtbE9sooVXp7qf70WYPirZrWjWmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SckV8ZSz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SckV8ZSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DB71F00893;
	Thu,  4 Jun 2026 12:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780575879;
	bh=TeYCmxTwl9otFqKkmzzIoLY9X3OlQgydHlflUIc9LoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SckV8ZSz9UrEs0UIDvPIei2osTqzMrrohA5m4yO8v1bCizZSulMGmYmKcJ33jOITq
	 trcwgfUEVxKYkvCGkzQE8erz5bfZ/4mdwzY7tty3U3FHGy99Zt9KlMoyU3ln2bvhuF
	 x/4I+ikoBus92ARTbBV68J09NQ8yeBgHLqOrLSfcpAeyTaiJZ0SjrVDi++CZuP1X+v
	 Ul8M6/LEXLULkzMoHQKeCLNI2KqZcyjfU4pSuHxV3+Dx05pcqCnoWlz8cJOULK8juV
	 JyJib+ouNLCkbJfOJVlmRT74SSZHUKwApUgA4hSNWYwM5G0ymF9IOI4JEISYptjPXW
	 sS81fCYMpI6FA==
Date: Thu, 4 Jun 2026 14:24:36 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/21] xfs_scrub: fix uninitialized variable
Message-ID: <aiFudO4uzu7qHBgD@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303201.2608728.9617306419340909584.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303201.2608728.9617306419340909584.stgit@frogsfrogsfrogs>

On 2026-06-03 23:05:38, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If the action list is empty, we'll return random stack garbage because
> we never set ret.  Found by Codex.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.10.0
> Fixes: a18f915ce76bc8 ("xfs_scrub: use repair_item to direct repair activities")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
