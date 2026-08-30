Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8768E283FE5;
	Sun, 30 Aug 2026 21:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788125222; cv=none; b=nr4UVAxQdJ8kF0ybOfJH6WhYgr+Qb2E+FlgCd9skz/GXWMoJD+0lRWAKO6W5DfTP486VdO0e8Abo1XMhBr5vc/hRqxgIN/D+WADkdcfD3MqY4MCQ0p0tiJ8INobbSTC+DqHqIS4AMNNbGn97NrzWPGBAXRZCoe763S5COQplFA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788125222; c=relaxed/simple;
	bh=aVdW3BvEcbrycslt8Hyb+i4ZB2SPLEswpYHsRGMpHnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JX8WZkB4CoZ4joxyXvFLYGtSPCT8ChEC+TSZt+r1RI9fGp7YUjt3Xgpuivyweo8Dk6ZQg6fmBtSp/NomxlquTCPqxyKfFqU/AzD9geQdpTdKqyI7Yw4aORUAaVc/MS5yLruRUZPE2Fs4dwuE8pE0yPS2TTgc4aa3B9eJZSKS2xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ksmRdfUm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ksmRdfUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDEC1F000E9;
	Sun, 30 Aug 2026 21:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788125221;
	bh=3Y7cQIIUkLF3AFKNozzptSjXt1bW2+TYRTBhbmQb0p8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ksmRdfUmxvF4VmmK3XwpsyHGqIxR/3hBLIPv3xSMifPoHzx4BjDsI3wBnpX81m0Fg
	 apM0eUq7Qxw/eKqrk5siegU06JR+4iHTWHo+pKyDYNFV26gNjerOV25rtoNnWbgk9v
	 u0uc+3KmBS598zdLnYuSrCZFD15a7KJ56Kb92hOoj8cL5kTLd6aPsbY5/Et05lkGNO
	 ohvfhxtmUUa5thNgU5MttqFY1EDJohz2JpgKWPh6nI+opybCnHFohu8OisNDuS4H+g
	 BGtJSEBgFNik4VlnaNe7SbZRNNBOrJi/kAEotYpkhILf0aRIo5UnRI3uNT8dTaunmN
	 bnvXlCeqRVnHg==
Date: Mon, 31 Aug 2026 07:26:52 +1000
From: Dave Chinner <dgc@kernel.org>
To: Eric Peterson <linuxinstalled@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Eric Peterson <eric.peterson@hpe.com>
Subject: Re: [PATCH] xfs: add per-mount read/write I/O completion counters
Message-ID: <apSgHPl4er6Jy9xi@dread>
References: <20260828033429.4070267-1-linuxinstalled@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828033429.4070267-1-linuxinstalled@gmail.com>

On Thu, Aug 27, 2026 at 09:34:29PM -0600, Eric Peterson wrote:
> From: Eric Peterson <eric.peterson@hpe.com>
> 
> Add two per-mount statistics counters, xs_read_completions and
> xs_write_completions, to complement the existing xs_read_calls and
> xs_write_calls counters. The existing counters count I/O submissions
> (entries); the new counters count I/O completions. The pair (calls,
> completions) lets a consumer compute outstanding I/O as a queue depth
> (calls - completions) and, via Little's law, derive an approximate
> response time in userspace without any hot-path timestamping.

I'm not sure the fs is the right place for this - the bdev has long
exposed enough information for filesystem-wide queue depths to be
monitored directly.  e.g:

$ man iostat |grep -A 1 aqu-sz
	aqu-sz  The average queue length of the requests that were
		issued to the device.
$  pminfo -t disk.dev.avg_qlen
disk.dev.avg_qlen [average read and write queue length]
$

and so on.

Hence this really doesn't seem like something we should be trying to
infer from indirect filesystem stats. Why can't you use the bdev
stats to get the actual filesystem wide queue depth information?

-Dave.
-- 
Dave Chinner
dgc@kernel.org
