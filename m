Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564FB1A288
	for <linux-xfs@vger.kernel.org>; Tue,  8 Jul 2025 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751987127; cv=none; b=o4ZT7cfzEoDdGbrZZLf7ck2JnfYNorwzeuBP++MJVHIAw2crHCeKp01y92WPjwQvR6iKLuvozeUw3mPsS1VleRuxNeCNLaxDnYWnyMnBHB7samkPwDt7Fxeu6LLNYbotnYcWWwcuYGL4zs8uYUic8n1BYy4Ko/Cfv6/0oKC65pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751987127; c=relaxed/simple;
	bh=7+iRLuzk9MR2rswY+DJYqjXBZ6+JMziwfi4/v0Peo7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bsbIDe91As4PJ6ffreWUgzUJBWv3DJwkR3gRnBZPsp0L1I8hDnPl0ApnjKJdnPe6znJrsLgk64zHBwBc4Y5XqSbX/povrn2S1Vi4k4oizTk+JTNGORaVe/SSEWbebeWOcutwg+itGybDChPLMqr2GdYE/Z0b9kVn38b9oA4YwRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fpigu2Fx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fpigu2Fx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3440C4CEED;
	Tue,  8 Jul 2025 15:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751987126;
	bh=7+iRLuzk9MR2rswY+DJYqjXBZ6+JMziwfi4/v0Peo7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fpigu2FxqZehYL0yXCWEDYQXpFXHQp6Ncfx9IG8D1hEyTDY/0Wz/c2G3eKwbUI5Oo
	 KojsOcNAv6hWMFSlr3nUbjDzB6FAQX/Ztw7lvYF0I7PV8Q5S1tTpTKCkdsDp22gygU
	 mwmVZAEShGuU3ok3gbDtMgq3vzgnl7ee3Qni/B9mqRjogJdgTkLZUMkLY9uMpP0AIE
	 K9MZ3TYKSm4jqc5r25dB670+rjEyzCCz/FIcD5blY+8EwRKiZPB6RwFh7lt5YQBv3g
	 BY79/VTiUDq6Ht9KNbpM/jsYA06ZGbaNdQ97y/oqtsLkRb7i+8XdQci3vNueR4smNB
	 kEr2CsYgM8mLA==
Date: Tue, 8 Jul 2025 08:05:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org,
	catherine.hoang@oracle.com
Subject: Re: [PATCH 4/7] mkfs: don't complain about overly large
 auto-detected log stripe units
Message-ID: <20250708150526.GD2672070@frogsfrogsfrogs>
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
 <175139303911.916168.9162067758209360548.stgit@frogsfrogsfrogs>
 <874db4d4-2fd9-4f48-afd5-dcdab88ca7eb@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874db4d4-2fd9-4f48-afd5-dcdab88ca7eb@oracle.com>

On Tue, Jul 08, 2025 at 03:38:10PM +0100, John Garry wrote:
> On 01/07/2025 19:07, Darrick J. Wong wrote:
> > From: Darrick J. Wong<djwong@kernel.org>
> > 
> > If mkfs declines to apply what it thinks is an overly large data device
> > stripe unit to the log device, it should only log a message about that
> > if the lsunit parameter was actually supplied by the caller.  It should
> > not do that when the lsunit was autodetected from the block devices.
> > 
> > The cli parameters are zero-initialized in main and always have been.
> > 
> > Cc:<linux-xfs@vger.kernel.org> # v4.15.0
> > Fixes: 2f44b1b0e5adc4 ("mkfs: rework stripe calculations")
> > Signed-off-by: "Darrick J. Wong"<djwong@kernel.org>
> 
> Makes sense, so FWIW:
> 
> John Garry <john.g.garry@oracle.com>

Um.... is this a Reviewed-by: ?

--D
