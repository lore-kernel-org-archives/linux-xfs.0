Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206EA34253C
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 15:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762959768; cv=none; b=g/szvYcGJuDoEzWq0wHWbyMgw0zBO3i3tJ+Sywyh4qvZEohlBqNySojsf+7a8eeBZKfwrDnwEh8G8oCzU/+34iDyPU2cGxaw/ksXzBGMvWytbRLiMsF6GfP9QtRtuLd+lVkTgaDDzmHtgJxIdvW5qZrMV1C0UrjEam+qBzXL0L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762959768; c=relaxed/simple;
	bh=6rmMY/Oj3/cJvqgkPh2RodHydAVpZIHj6Z7BufldRgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h801dPbx0iDMUOs/CaTrYZVZxtrZYKrVyuqVAax470AmbFl1oN6FfwIVTC+4NAbfUJfoxKF+USnMBur2fct+4C9xVEJuV6s+6u6gdwJATYzeQbGUz8xWs1l2e9V9HPoYj8T8qovDqMh31QA97u4eL5HkS4DfLj7/Q31SP77Q9Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NG/zrz1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NG/zrz1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99B8C4CEF8;
	Wed, 12 Nov 2025 15:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762959766;
	bh=6rmMY/Oj3/cJvqgkPh2RodHydAVpZIHj6Z7BufldRgk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NG/zrz1TWqUwvGU37wxEwlKHCIz/A83Bo4E0zojZ1CE5JBKX78SxvnjVGhqKe4mZy
	 07x/xkrcHS40mfbzMvE+QDfh+SHPDMJAIq2YSiPuZAOLhFK8GCFGxYDBCp9WT3pLC0
	 HEqXIVOvrnPxoXGPgupkBj1R/zBbGN6/551l2m6Ka5loxgjHxRcbPFef+PSwJEWXf5
	 ALAT8WxmZ4VVuVRtDQYnWwdy+i2uLroozxdKVUTlH04SQKgg+7D8qtIbrbcSByttqe
	 2+2VhJkOxj5AZvV8FK34dR7jrmo+rOlIF1Z5OzcIgZg0R+An6e5LdjjlEikEnj0XbL
	 7ti17RKIZgkuw==
Date: Wed, 12 Nov 2025 16:02:42 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: fix zone capacity check for sequential zones
Message-ID: <csatwege2eyfxtu3jsvfacujo3r4k5llzfsxo3usyxk2srarvd@elo3xdzhrj2t>
References: <20251112123356.701593-1-cem@kernel.org>
 <uUmqo8OzhTSa5OB27aq49lemNQh91fH_TCYzB5kvOcruOsQHbBfzrdozvkQ3xIWvFb_iB9od-8CjKaC8vQGP2Q==@protonmail.internalid>
 <20251112125056.GA27028@lst.de>
 <na5s5f2afoc3w5sijoq4xqni3oex7ivxqkrqfz5pt7dtf5aivr@3xvsap3qzpcw>
 <mvklXBppM-m8PSwyLfKBeYzNfaaakGcIzcjUJTI2NUOM2pv0srN-XDQ0yOavvo6S2CXPeOa98W-Ly-q59i0VgA==@protonmail.internalid>
 <20251112143659.GA2831@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112143659.GA2831@lst.de>

On Wed, Nov 12, 2025 at 03:36:59PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 12, 2025 at 02:25:11PM +0100, Carlos Maiolino wrote:
> > Your call. I can add it to the V2, giving I'll rewrite the above to
> > remove the unneeded braces.
> 
> Nah, let's do one thing at a time.
> 

okie!
