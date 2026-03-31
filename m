Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F551EEA54
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 09:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774950084; cv=none; b=uYEGB+DyvimbFJp9BF+HO8IIrh9ZBTuwfvai8HR2Xm+IPNPyEelZKMS6kyAZuxzh3rx8tXFuMY6XVlvpBXfufDMzbFJjCq/5MDK90Nc4WHFMQsULXLnoe53s+cqSZ0DyD5HRj3OjFBYLyPWLNaGNI90WHNGHTMujRynXBMfGmuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774950084; c=relaxed/simple;
	bh=t4LWetj2sN4aTGHm6r9p1p74mw02rkqo00R5Dntks5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L9HYv/hWSuNRXSB6+3M80RYRrCz+H+J0dF27QN6kAjolJvBnkeT7Ggq4BlGyy0SFSKppTqXaNW5eyse196tmluxZrrwnAzZi9LKUwU57pynbJdhYEvTEo5aVbB2FJsFG+D9rUSOi3wrXG9T24HEuwjUrZnXO6k8wlE6U14bXlGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GdUk3mgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GdUk3mgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86761C19423;
	Tue, 31 Mar 2026 09:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774950084;
	bh=t4LWetj2sN4aTGHm6r9p1p74mw02rkqo00R5Dntks5Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GdUk3mgPaSM+Z96+UC+A0kepePRovmzsfHqqr0iuWB8TeaLv6vnM+z3wuSe8xIY2C
	 p94E5gu4w3S1GW4upz/WnUhcltbD5yOBvq3esV/oqnC0N1pkaXlEFZ1LTtsIz4EZ6e
	 n2IxYc6WpMQlHp7gju6FUfQYruj00llF/GOaKcDfSycY/HNb6w/TGndAd/9h7mYsvy
	 EZFdM9ujFET53I+RUNkdXZnHGFegSJea0VqLb6paCNlhAiKUX4LGCYXUzbh86/UHyy
	 SOUwMcRHCrnqYjiZnsdpAaYz2Hnv//nLp1q/ySQx7nDIhMA7my7YXsdHfmK6emIx+Q
	 RSnoiA/0YibCw==
Message-ID: <ec35836e-71d2-4972-b72c-2df82f0faaa8@kernel.org>
Date: Tue, 31 Mar 2026 18:41:22 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] xfs: put the open zone later xfs_open_zone_put
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-4-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260330054533.3856339-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/26 14:44, Christoph Hellwig wrote:
> The open zone is what holds the rtg reference for us.  This doesn't
> matter until we support shrinking, and even then is rather theoretical
> because we can't shrink away a just filled zone in a tiny race window,
> but let's play safe here.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
