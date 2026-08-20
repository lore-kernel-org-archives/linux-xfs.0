Received: from mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CAD3B27CC
	for <linux-xfs@vger.kernel.org>; Thu, 20 Aug 2026 11:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787226358; cv=none; b=fWlkjoOUId+1VnxDNxN4xKGOcjwZuEz4yiuqVI5KqmGpiYtVGxeoYqBdWEAOBsLappVChi7U36SVUGon5YHuJF8MNharfClUdDEWseNVXge8rRgQiTevTPLMUX4P6G2HqOC2lfJKhoLZXyJdOiJC+riOhkXq4i8NW0UtWrINKyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787226358; c=relaxed/simple;
	bh=uQbXgUL4/UgUkMAm/aGx481TgJhQ2YEatKjNQvhyDWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TDXTJF6WrCbdUhsOPG3V3yTl05hvirrJvi6v/J6N+Ql2Sm1dOHS9oyHYuosYEBHfFULZNtz7akqWo9utkdiDbo0kgvSIjeYXJ4Lx+lv+WIogLl3ck+6AT/6IE7F2ENJkzFN8cb0duZoLPX6R6crgRNgTwFMu8zD4pKlqG++3kMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lNXhIaZr; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lNXhIaZr"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uQbXgUL4/UgUkMAm/aGx481TgJhQ2YEatKjNQvhyDWE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787226354; v=1; x=1787831154;
 b=lNXhIaZrEvhCqADkflQjWIhf+ssUWv8vo3smk5iNLPBiB2khA9TvNiSeb3oOwst1PN+2imB4
 pF9CX1QfDZteFyHNu/3AT83n5LGHHV0+tGZSI96SBFBhGCmtE7YgNsQiV+8JM6TTr3xBIXhMU/H
 gXpidl1ikWOUZ1DGNOjykBdk=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: from localhost (87.104.0.147)
	by smtp.migadu.com with ESMTPS id 60091b113213af75;
	Thu, 20 Aug 2026 11:45:44 +0000
X-Mizu-Trace-ID: 60091b113213af75
X-Migadu-Flow: FLOW_OUT
Date: Thu, 20 Aug 2026 13:45:37 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] iomap: follow the alignment requirement for
 iomap_dio_hole_iter()
Message-ID: <aobov7x4-1uXpJwG@quentin>
References: <73bd4d9b39e821453028ca8e567eaad2ebe0fc18.1785880740.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73bd4d9b39e821453028ca8e567eaad2ebe0fc18.1785880740.git.wqu@suse.com>

> [FIX]
> For iomap_dio_hole_iter() round down the copied length, and revert
> any excessive range that is beyond the aligned copied length.
> Also use @aligned_copied for the size increment and iter advancement.
> 
> This should only affect btrfs, which is the only fs utilizing iomap dio
> with page fault disabled.
> 
> Fixes: 001397f5ef49 ("iomap: add IOMAP_DIO_FSBLOCK_ALIGNED flag")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Looks good,
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
-- 
Pankaj
