Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D0426ADC;
	Fri, 23 Jan 2026 08:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769158478; cv=none; b=QclYgSvJ935sPkuAP7U7gSgHuYX1/aZPwCtWvRJXOTMBU47A73vglbtwxPJCDFOB60+49bQh3pBzezRYKzMnzD+g1tKzoq/i20WSReIxYTqLZp259auxQfbVEyrBcHzYAWm7chNc9bWQ9XSWfiZS6Gsi0HwPYjyi3VyPqdHk9S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769158478; c=relaxed/simple;
	bh=5tspAZvYOf1OZWpIiHGdZkAvcBDjt76r35rQpOx9fSw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KHxRs9TpTh2qK+x4/MChdMhvl0waeojhCMPeL1SshMGYRkyzxRC3D1l7rMMwUrimdHUTl+6DfYT5NAndy/cDqnpbacSS2XnGtfJDjlOGysM8TUEhLRRL5xtJ5cMX+xAAymIuoxruggcnQ/j99GNlAPXTj3dECUphUJk0jwf4Wqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uf0svvbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uf0svvbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A28C4CEF1;
	Fri, 23 Jan 2026 08:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769158478;
	bh=5tspAZvYOf1OZWpIiHGdZkAvcBDjt76r35rQpOx9fSw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Uf0svvbflJV6wJ1uNwqneX5adAYNJRrmAeFHE2DCQPBSirRYca9lioUUJOoZyU91U
	 QLGyBa/TRbTFNFHd5KHuKjZa0VOWROpprk2KlzS269gWXA10IWI9WqweBZP8fT2LZL
	 ZS+ZSUsrGIT54oYsU/AqtctPhzSBGKt8OUl2Jn7bsSTVJcrJBrswCiCsJnnM1jZwEm
	 t7ng0Q/3r/TR+v8zDZbNSTKq5RfWRtwcHNrHWlBMydEq89FNerNrJ4tcJdpIxaDuSx
	 JkEUkJp0I8qQxD2mqnl4tbiXjVkliGnF17JqCllA3C+O2TosMUA+cRf9a2XYyVT1pH
	 PI1iTNaec6YFA==
Message-ID: <cf6099d4-6b05-4c74-b92f-ee0cf1ed15e1@kernel.org>
Date: Fri, 23 Jan 2026 19:54:34 +1100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/14] iomap: fix submission side handling of completion
 side errors
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260119074425.4005867-1-hch@lst.de>
 <20260119074425.4005867-7-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260119074425.4005867-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/01/19 18:44, Christoph Hellwig wrote:
> The "if (dio->error)" in iomap_dio_bio_iter exists to stop submitting
> more bios when a completion already return an error.  Commit cfe057f7db1f
> ("iomap_dio_actor(): fix iov_iter bugs") made it revert the iov by
> "copied", which is very wrong given that we've already consumed that
> range and submitted a bio for it.
> 
> Fixes: cfe057f7db1f ("iomap_dio_actor(): fix iov_iter bugs")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
