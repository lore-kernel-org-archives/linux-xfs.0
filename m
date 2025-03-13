Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74942AD22
	for <linux-xfs@vger.kernel.org>; Thu, 13 Mar 2025 21:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741902013; cv=none; b=i+HNlTa/ysQngj7hCIhbOwJ5fdKkQWMc+EC8F0LtlFM+h2HWYB81hmJjRNU9s2fV35VEcIs85vSHomabZ6iPn02lYCFTP/OIh1i9CgdW1nWX/jZfcYWuZor5Ho0UdewuGWAdFKDxs5D8GE+Mrp7ItPp8QHmu3e+cSNcajUJzb6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741902013; c=relaxed/simple;
	bh=WBDAUn0hUuCuCSBlMeCkLX6umAaRqxkSyAu2loOP9nM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WljcfxI4V3RPAIXlW3EQLbuuxpeNJgjpYMkFA/ydoJpjFcZm0iRfyjQlCQ2PTuFqCHcbdOrQDY3r2z22ueoKQ4achcowUWhZCsmoBSP5jssLfMUGmg3wI3TIHIqZe1rO2vHleTH4vIzHicbVnTDb8uMJ8BdubfP1SyzSvrUUZNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=DZnK23Ck; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=12YdJpAG; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="DZnK23Ck";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="12YdJpAG"
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C4C3A1140152;
	Thu, 13 Mar 2025 17:40:09 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 13 Mar 2025 17:40:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1741902009;
	 x=1741988409; bh=9lSLv1pST7/vqBnMKFeP3SiWiB2kqOv/glIYQJiSsYU=; b=
	DZnK23CkG7LQL6nplU+ukHRKZbPUKBAxb4qfo6SLixoIyLZak8Q1VBN9A4nO4UjG
	m6qVT4tNgIDXoWAr7YHuSq8sB0HMewm3hxjGkKdA7psO8T4fidGzQsIRd++HWSGp
	fU77XbZeoJxyMHAl4bjQ6/1NnLm8BDxJlGpozMIolX1d0fJyzwY1qTwuqo9RwOgc
	VIpezRRWBH8dgA7CzpOMqahFne9LsuFsLUSDod/oQ4czR2V+cbK7lT6zfHalV9Mu
	ENWp9RJmxnu6ZvfNzKuWu7lUzhluifwRAHwRMpmms4Gaeg5yvFwRr8vSvtk1gFa6
	9DWi7ZpLNn1N3Ju0k1G7Qw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1741902009; x=
	1741988409; bh=9lSLv1pST7/vqBnMKFeP3SiWiB2kqOv/glIYQJiSsYU=; b=1
	2YdJpAG4dtqUtVsb4pRmv3jKXEMPaK8/2tF0Rc31rXwc5ir6qc/NN+MHRFCcpl7m
	GrMahgZWmBr7DkUw0llrsEori7DuO6SDhi6OJbg/k4R5TKk4op/ofYCxw7jrpIn7
	9SmY1eax6f1wiheEJSjKp3Ilv3GJDxcKHN6CHO/MHv8Jg6m6yNFsOqCoZ9W9oTRS
	eXRx7oC3IhPqysiCctUaEVrYuIuObzeN7c399F8q9pQlCZfbizZ2JBAB7LeaYi72
	GSpetcEVt9A1EL9ZULLyvV05qEpZ2wI/hR3mIPiXVBYpgzUSIYo/Bi5minzDvy4m
	fzqK72WznNGr60RsyY9/w==
X-ME-Sender: <xms:uVDTZ1hpCzn55rox3-f6doQLaF3axu1UCPngIB5ZDrAY6kewCSyV8Q>
    <xme:uVDTZ6AGlz8G32wzBBLPxQeIoJNVYvUQlQ9hMnkRIuTg_H2ZQ8ba5O0j1V6OABNZw
    I7I4tS8CwsOvjuOd7E>
X-ME-Received: <xmr:uVDTZ1HqIZbz1nPAlsDcG8iZVkUOHPFN98-NmSOwLbiQ_Sq380upY2g0kV2LCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdduvdeltdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddt
    vdejnecuhfhrohhmpefgrhhitgcuufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghnug
    gvvghnrdhnvghtqeenucggtffrrghtthgvrhhnpeevieekueetfeeujedtheeffedvgeff
    iedvjeejleffhfeggeejuedtjeeulefhvdenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhn
    sggprhgtphhtthhopeefpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsohguoh
    hnnhgvlhesrhgvughhrghtrdgtohhmpdhrtghpthhtohepughjfihonhhgsehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrd
    horhhg
X-ME-Proxy: <xmx:uVDTZ6T2hOofR_LCifIXrORhjTZV0DbUHMW1gRjDrYGpwiMHHo_knQ>
    <xmx:uVDTZywgqCOHeBCPBgdHt2t4uFLSyUb63giJy4MSQbXqiU_I_gasyg>
    <xmx:uVDTZw7X84w2l-ap20qsjEnBp1OZ-_CmQy84_FswjbcyY5SFs0sgqg>
    <xmx:uVDTZ3y2ju4OfPiEqABvRJLcKa5PTwPY0MkkNRjsPvhsNgFL_wJB0A>
    <xmx:uVDTZ2_QrkoFErcmO3XweJntw4jE8LbDDKpBr7Jch2Me5rY9pLdcHsZ0>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 13 Mar 2025 17:40:09 -0400 (EDT)
Message-ID: <55eac1b5-6019-49ec-85f0-d6d4fe28c5db@sandeen.net>
Date: Thu, 13 Mar 2025 16:40:08 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs_repair: -EFSBADCRC needs action when read verifier
 detects it.
To: Bill O'Donnell <bodonnel@redhat.com>, "Darrick J. Wong"
 <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
References: <20250226173335.558221-1-bodonnel@redhat.com>
 <20250226182002.GU6242@frogsfrogsfrogs> <Z9MtDf3zW8yt98mt@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <Z9MtDf3zW8yt98mt@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/25 2:07 PM, Bill O'Donnell wrote:
> On Wed, Feb 26, 2025 at 10:20:02AM -0800, Darrick J. Wong wrote:

...

>>> diff --git a/repair/da_util.c b/repair/da_util.c
>>> index 7f94f4012062..0a4785e6f69b 100644
>>> --- a/repair/da_util.c
>>> +++ b/repair/da_util.c
>>> @@ -66,6 +66,9 @@ da_read_buf(
>>>  	}
>>>  	libxfs_buf_read_map(mp->m_dev, map, nex, LIBXFS_READBUF_SALVAGE,
>>>  			&bp, ops);
>>> +	if (bp->b_error == -EFSBADCRC) {
>>> +		libxfs_buf_relse(bp);
>>
>> This introduces a use-after-free on the buffer pointer.
> 
> I'm not groking why this is a case of use-after-free, and why it
> isn't in other cases? Where is the use after this free of bp?
> 
> Thanks-
> Bill

because the final statement in this function is "return bp" - the
bp which just got released by your change, and callers of da_read_buf()
will proceed, assuming that the bp which was just released is still
safe to use.

The purpose of da_read_buf() is to read a buffer (bp) from disk, for
the caller to use. If you release that buffer and hand it back to the
caller to use anyway, that's a problem.

Note that with your patch in place, xfs_repair also issues a bunch of:

cache_node_put: node put on refcount 0 (node=0x7f6fb4073860)

type messages that weren't there before, implying there is now a
get/put imbalance.

-Eric
