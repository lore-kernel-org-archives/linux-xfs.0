Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45937258EC2
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 09:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774950529; cv=none; b=Jz1ACmQW3f4PYumRMEQK3GekU1N3HDeh0ppl4ueyyaAcmaFKA5LO1YQKoCFZhYynX0WYhIY9ImLe6uQPIaojES1IK4t2ozo+qBlW7cAR9cUAuXBB0q91JhSoBy51jeDOeYHPI3XaHT81/lCFZDsEXy8dI2590RjlK7dxMCPUJAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774950529; c=relaxed/simple;
	bh=x4I7cBi9gjj8Oyh4HpJkEHBBLtZbUdDdj11OQ4tef7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JcD3iP+kafCsgfy2zb2oRT2uYdCazCNGM1xAu65kca5zHQRoAY80KE/vfhjlhlETM3aB6yeyMjunMgp2M9VSYK8QalQZUfRqYnkl3aM+Qwtp/usYgc7peYIto7CkF+a74cMbyU1eFYloVwUQvgmBCoQSo20AqbY/XYR6OBmwnSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JVTmF7i2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JVTmF7i2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F1BC4AF09;
	Tue, 31 Mar 2026 09:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774950528;
	bh=x4I7cBi9gjj8Oyh4HpJkEHBBLtZbUdDdj11OQ4tef7s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JVTmF7i2BXJYfKt2wsjdNPpsq4bS2F4ywax6U+5H9eu/GPYFysDm65C8SqlZbBVJt
	 EtOphkwbNxYZMNLOnSgYr1oYanEVV+SOM4JQqSLLJcYAW1INeQUADMvAXQJ1/Kbajb
	 m+aSbHqask04nmNe8KcNdcZ59iAOYy6h6hIO1Zio70reubrnYEiCcyvHDpI5jlaktm
	 H0Es2l8z/tM3WyJgjqoJOY9a8uz/N68A0o46CRPBXjYNzHE7fFky32z+eU5OCavvCr
	 VzhTs41WTa/AT/jfBQqDVFXkHH6aZCyKO3iJGWYU3+GFAN0l/9p4VLYWeV2Zj3qQBz
	 5C1863UD//Yfw==
Message-ID: <2e7044dd-ac3e-45cb-8007-5aacef710d1e@kernel.org>
Date: Tue, 31 Mar 2026 18:48:46 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] xfs: streamline GC zone selection
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-7-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260330054533.3856339-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/26 14:44, Christoph Hellwig wrote:
> Currently picking of the GC target zone is done a bit odd, both in the

s/is done a bit odd/is a bit odd

> main "can we start new GC cycles" routine and in the low-level block
> allocator for GC.  This was mostly done to work around the rules for
> when code in a waitqueue wait loop can sleep.
> 
> But there is a trick to check if the process state has been set to
> running to discover if the wait loop has to be retried all this becomes
> much simpler.  So we can just select a GC zone just before writing,

But with a trick to check if the process state has been set to running to
discover if the wait loop has to be retried, all this becomes
much simpler.

may be better I think.

> and bail out of starting new work if we can't find usable zone.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With that:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
