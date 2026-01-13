Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66803387352
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 09:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768296432; cv=none; b=ou/vSPipahD/3M24iXrHj68q4x79MGal7CF78JbkDcVqJ13jBdv1QltB9AF/9RPdOJxXUCHyXtRPoNw9vgufZKiyv+4qdjLMCNVJ7YKmwwI2Yy4fglD4TnbdjHKx+O2iD339zaA9X1sLsSIoMTHe7fTs51oRl4xgcHDi3tBiMnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768296432; c=relaxed/simple;
	bh=TEHI+NcH4oQ5+5u0ilkbZzklVuCnBV7sz4cUZ/kJ1Ow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mrq7NfpSNdRgcSaU6luYgmQL5TggGxVArFkH9o9+gwQcCwjCbEz8G0XPFwHpn7IPIZFYOnxlgmjiZQLRwirWFhkA2jJm8cTuRhFIaqAmZMOHFVSARsbs7peHjWuli7pbvMeeYxbLPE4vC4vRHWJRqSMHVDy+60OGxqoCpVZgxJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sXtR93UX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sXtR93UX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B392C116C6;
	Tue, 13 Jan 2026 09:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768296430;
	bh=TEHI+NcH4oQ5+5u0ilkbZzklVuCnBV7sz4cUZ/kJ1Ow=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sXtR93UX49qvOzlw/8VBBHS7AkIgMULRVKxvdt4RkQoCZAnKsJknfrY8Xnla3SflL
	 +sZcvWq6x/i71EqJ8GDxb5NCLzLuwv3QCHiwp3MTmxlOv/9JP8tt+Cfu9VrViYP9Cd
	 nWPN9OasKbwjgz5ScPyH1KOi2QgKQeK5jFcEuELrWxJxXNw9ZeAYWQFT7KQrKuGbT6
	 oiq0RGCpHJO16cYxnM1jm5sZmfGS/D4OHg6aaAwCoJL6YR9jPEHTHce4FVF6+Nd4pm
	 AbUZmO6b7ngw7BFz1Z6E4aHMmxRpe8UKBBLxCcprRErOTT/TC2MVMEFaU9YTU4p90b
	 JfJE3kyIswvUg==
Message-ID: <7c7e2918-3c90-47f2-9886-bc00857f3f88@kernel.org>
Date: Tue, 13 Jan 2026 10:27:07 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] xfs: pass the write pointer to xfs_init_zone
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
References: <20260109172139.2410399-1-hch@lst.de>
 <20260109172139.2410399-4-hch@lst.de>
 <ce23e24a-d671-43bc-a5e1-28ccf7083aff@kernel.org>
 <20260113074700.GB28727@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260113074700.GB28727@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/01/13 8:47, Christoph Hellwig wrote:
> On Mon, Jan 12, 2026 at 11:15:07AM +0100, Damien Le Moal wrote:
>>> + * pointer.
>>> + *
>>> + * For conventional zones or conventional devices we have query the rmap to
>>> + * find the highest recorded block and set the write pointer to the block after
>>> + * that.  In case of a power loss this misses blocks where the data I/O has
>>> + * completed but not recorded in the rmap yet, and it also rewrites blocks if
>>> + * the most recently written ones got deleted again before unmount, but this is
>>> + * the best we can do without hardware support.
>>> + */
>>
>> I find this comment and the function name confusing since we are not looking at
>> a zone write pointer at all. So maybe rename this to something like:
>>
>> xfs_rmap_get_highest_rgbno()
> 
> Well, we're still trying to make up a write pointer.  I've renamed
> it to include estimate, and in the revised series this goes away
> as a separate helper.  But what is confusing about the comment?

It talks about zone types but the function code looks only at block groups, not
struct blk_zone.

> 
>> ? Also, I think the comment block should go...
> 
> In the update version this goes away as a separate function and I
> think the comment gets into a better place before a function that
> queries the hardware or estimated rmap write pointer.
> 
>> This code is also hard to follow without a comment indicating that write_pointer
>> is not set by xfs_zone_validate() for conventional zones. Ideally, we should
>> move the call to xfs_rmap_write_pointer() in xfs_zone_validate(). That would be
>> cleaner, no ?
> 
> No.  xfs_zone_validate is about to become entirely about the blk_zone
> and not XFS internal information.

OK.


-- 
Damien Le Moal
Western Digital Research
