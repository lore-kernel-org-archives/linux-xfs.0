Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82C93595B
	for <linux-xfs@vger.kernel.org>; Sat, 20 Dec 2025 00:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766188812; cv=none; b=oaFfzqH/xVP4vj7K3kyyo+orApS6dnHSv09FPGCT28ZLP9904/NUjbUVkiUulaFQMj4AIAdQhHBtoZxEJGP4KQsHo1kdrmOPB5M4oWFT9KRiGq6IdP8gaY6OsE+QMOtTq7hKpU72d1bTD3FH52FWypyw/R3sbNP1+ZtzSdUm5lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766188812; c=relaxed/simple;
	bh=fMq+VWCOjySFUcUGD1Pedun6ed1y4TOi5Q7P4HnlX6w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V+xPU3nAa13eiLFE8Kf/8jD9YtcMXtrxOn9w0SunKYulunKK/DJwAF2JKnjYtOfQkqqS8cyw6bz2dTydFI0uILhS4U20895rwwrxTt+I0MbrUXeXLRZ3fzSsW4CkY1c6kveSY/304ChOEPppJpvNN1SnGj0Nx5MK0H8va2bcs8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g8jT+CYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g8jT+CYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8C8C116C6;
	Sat, 20 Dec 2025 00:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766188812;
	bh=fMq+VWCOjySFUcUGD1Pedun6ed1y4TOi5Q7P4HnlX6w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g8jT+CYbG+B7j2RLHh93Vp9qEH+r/oVc2El/ohDD55a0u/K8NZ1CJKi8MLg13MFem
	 ZD5vYNhN0Gs2fRbmdMyb7w8p0HS+4E8KFMiq0rkZTMQh7uK4dsuceMQzrZ7T3oLznD
	 9NGhepbzU03w2ZKzn+worGTeS+pvDQhAF9hUvAJJVkIDZsW0i+bDVhVdegFPcG0WX7
	 48Ju+R1Moa8yPmMP4hG8krZOesTh8Kb/sNDNjXLPkzKUzZQg0fp6VkGeS5FgEnHfQV
	 /FbRWhOnWaLlHK92wcMTVb485zXseSSIzH9ONnNuC/07VQhpTW6Meg8rhYEDNTWWDr
	 IiRQWRLfR1ekA==
Message-ID: <1f635a17-adf3-424f-b504-71a97562d226@kernel.org>
Date: Sat, 20 Dec 2025 09:00:10 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] Enable cached zone report
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
References: <20251219093810.540437-1-dlemoal@kernel.org>
 <20251219235602.GG7725@frogsfrogsfrogs>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251219235602.GG7725@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/20/25 08:56, Darrick J. Wong wrote:
> On Fri, Dec 19, 2025 at 06:38:07PM +0900, Damien Le Moal wrote:
>> Enable cached zone report to speed up mkfs and repair on a zoned block
>> device (e.g. an SMR disk). Cached zone report support was introduced in
>> the kernel with version 6.19-rc1.  This was co-developped with
>> Christoph.
> 
> Just out of curiosity, do you see any xfsprogs build problems with
> BLK_ZONE_COND_ACTIVE if the kernel headers are from 6.18?

Nope, I do not, at least not with my Fedora 6.17.12 headers (which do not have
BLK_ZONE_COND_ACTIVE defined). Do you see any problem ?

> 
>> Darrick,
>>
>> It may be cleaner to have a common report zones helper instead of
>> repating the same ioctl pattern in mkfs/xfs_mkfs.c and repair/zoned.c.
>> However, I am not sure where to place such helper. In libxfs/ or in
>> libfrog/ ? Please advise.
> 
> libfrog/, please.

OK. Will add a helper there then. libfrog/zone.c is OK ?

-- 
Damien Le Moal
Western Digital Research
