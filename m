Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11292080C0
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 02:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754966628; cv=none; b=EBQ8PF7NuQaI79sCgJADW3HBHmfJfYp4arLsSnnjvraFyNiuGwvYIFsvRp0hd6Yi7U+NO7miwjCZMrLbKtzYW08q6QsWTDxIGkimKP7j1Y2vgVyx0U9ESzQaD4fAqKOgh1fUHEgR2lcvQIxjmVRGsdR6ofzjPCfVYfeS1NVc2IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754966628; c=relaxed/simple;
	bh=nFbxD9d4f+ukNTcg1vGxV3uMlO2DZl1OojD35lIMYo4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hUWadt4vXaQQ/M78eHdZSENXfYGpEk+UeoCcHSbJEJF7zeDnc7G694OMQLzBwGadS3OsEbWFvIQqWYBjLV/WLw8Inzn1Y2YMHJjo7hH6SoDG3RRbAMa9vS1iw+bcoYUNbtEIiMy2vfklErHzs9t0iv1IScYdU1+fw9YejYmusdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3dmhwT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3dmhwT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055A3C4CEED;
	Tue, 12 Aug 2025 02:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754966627;
	bh=nFbxD9d4f+ukNTcg1vGxV3uMlO2DZl1OojD35lIMYo4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X3dmhwT95Y0FOtQksTm3fGxxK9m0yVrNuYzj7WBSMI3E0ze/bGuCS6DJNlVRiyeCB
	 apsGe1HY0273g563zXBrQIdjQ8u/+55agaJLqcwyxJAYWRhSUWCbMdqt4gCR6FPBHc
	 mbfg+Wd3I1Ebb4jUfnlIb7fd8J5XaVfvxl1a9jB7VqMCyPOkwcO4nE7gQiaZZejgju
	 uyiWKbzovM9sZq7fQw939R6GXMN+h6WhA8YAVH/LvUitcNzcBX/JAQN3fSRfLUVleH
	 kiCFIgDYJDgzJywGLHaVHHLohh2wnFwBeHNPjLc2UPrfiDJ+8qrX6cHJ4jMgOQIGZC
	 IuPOYL4yoIOeQ==
Message-ID: <4d82475e-14d1-4aa6-b754-93a2c0a5c908@kernel.org>
Date: Tue, 12 Aug 2025 11:41:05 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Select XFS_RT if BLK_DEV_ZONED is enabled
To: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
References: <04bqii558CCUiFEGBhKdf6qd18qly22OSKw2E3RSDAyvVmxUF09ljpQZ7lIfwSBhPXEsfzj1XUcZ29zXkR2jyQ==@protonmail.internalid>
 <20250806043449.728373-1-dlemoal@kernel.org>
 <q5jrbwhotk5kf3dm6wekreyu5cq2d2g5xs3boipu22mwbsxbj2@cxol3zyusizd>
 <A4FCv62RNtu2Cv1tCo8uFKhWwDFP2oXzzlbDCWVJGngV56An4iSGWengMvx2tRkNarqFy-U0pp8dLyQcq4t0BQ==@protonmail.internalid>
 <20250811105007.GA4581@lst.de>
 <wg7fy64rleysl4zujuj3exgzfnzmvqgxi27qzkrlflqj55udal@gw2xkr7ayc42>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <wg7fy64rleysl4zujuj3exgzfnzmvqgxi27qzkrlflqj55udal@gw2xkr7ayc42>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/11/25 7:56 PM, Carlos Maiolino wrote:
> On Mon, Aug 11, 2025 at 12:50:07PM +0200, Christoph Hellwig wrote:
>> On Wed, Aug 06, 2025 at 09:46:58AM +0200, Carlos Maiolino wrote:
>>>> +	select XFS_RT if BLK_DEV_ZONED
>>>
>>> This looks weird to me.
>>> Obligating users to enable an optional feature in xfs if their
>>> kernel are configured with a specific block dev feature doesn't
>>> sound the right thing to do.
>>> What if the user doesn't want to use XFS RT devices even though
>>> BLK_DEV_ZONED is enabled, for whatever other purpose?
>>>
>>> Forcing enabling a filesystem configuration because a specific block
>>> feature is enabled doesn't sound the right thing to do IMHO.
>>
>> Yes.  What might be useful is to default XFS_RT to on for BLK_DEV_ZONED.
>> I.e.
>>
>> 	config XFS_RT
>> 		...
>> 		default BLK_DEV_ZONED
>> 		...
>>
>> That way we get a good default, but still allow full selection /
>> deselection.
> 
> This sounds a good compromise.

Indeed. I'll send a patch.


-- 
Damien Le Moal
Western Digital Research
