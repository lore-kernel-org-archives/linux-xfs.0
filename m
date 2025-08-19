Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34681239E62
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755616445; cv=none; b=syg/Cs7GNnoFd2fJqQ1WTmD7zIQqvqtb8qz4nZydeApsRKIixnPIz1MaxIDeISdlVtu7sy87vZ9vxu4uuhOF8PS7Z9+xpNqviRLS9YJ2PEgL4jRs0DVvZV6OTLLsiFm8t9NkGyfXLipQWqNdqUe6SixjKVu6bp2tDo5FdevbMfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755616445; c=relaxed/simple;
	bh=AUll8LsbXG8Vf3hEvg1nhA/QXP8ZtgMUD43kmuVO/9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K0L4ibyMonylM6VEAGNrmZM/N9wazoWLOxXTVc+6yx4hr/r78DWelua6doy/en6fpvAQVjdiuzp0EEiiM+3eFcWXm2zawytdUw5dHXJpvag/01Xsfxiy/Yr5yx+ipT5dcudO2l7P+wHNc9pXCS14I2KWdNVand1r+u77Rx7T7Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=uqHMU3kZ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LFEcuTIy; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="uqHMU3kZ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LFEcuTIy"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 51CFAEC0453;
	Tue, 19 Aug 2025 11:14:02 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 19 Aug 2025 11:14:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1755616442;
	 x=1755702842; bh=z+qs6RL18xjnJQuQi8YlCzeWFF89kBOshetF5qsZfUk=; b=
	uqHMU3kZbSFTXTn4sA1ALSfTQJUAj7rowcPiuQQBqr5ggs8uj+I5/KcYr0dhNy4O
	97Ka5o0c+jsZffPKQtuz+2GFujzNhqrekdqM1FbqZawNuTE63MZwNogkZWcCw4ix
	2op/+bl1uuS6QSy6efp8aTPtvl4ECQ+hLhRh4jjqljHXcYsiFJS89WIvWyjyldwe
	eJv+FMRHLeOwYzxubYFuf7ak7h4Vw/q2+aOfco27Gr608esbl+ybMqPqsaasvvvZ
	2498VGfnXJkDQdZsbyBHkRdVW6UR/Y/qqbi/2IKc+0nFsafBIPn9OfAWm1fq0KnQ
	Lgcmp78EWDruYnm7IxVpJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1755616442; x=
	1755702842; bh=z+qs6RL18xjnJQuQi8YlCzeWFF89kBOshetF5qsZfUk=; b=L
	FEcuTIyIuSQDOVYDRcnaUs4S9uSlIRxHLWIl93E8ok19pvzxrunyzAOlTRbBf9TP
	WEaG6jUA4pHC5HxDjZl6pXtem91pMZyrlaEnVYfzql4sZil9vyJoepHubsz1r/Ft
	DxV15dcaQKYUcUCT9vBKMDkGHPQei5imWNTyVNefGV0Cseun+zd8inUOhWw9N5Fl
	TZ04jTlK9zR6hnRnhwEBpaS3lqutgSXm7a0vUGPHt8bo4E6jhL2I0h6mdkjSGa1I
	EaBg7RRAXEsne0OeyFVW/mH0C8bdCGCmQ8p35P6xdLISXxfrNXldXez6scDCPkPe
	WxpqXOZglS50/vRHEORZg==
X-ME-Sender: <xms:uZSkaG7R6veYU71knAY3xVXiu6F44k_HRqoJsKOfIcuNLXHaKNCjyA>
    <xme:uZSkaKcNdmqfCoR52aRuj4tp9sqmevjqeXVaPNqEpRu3-1PBxEssWhlaxU1GI8vZL
    469ygDItpkvS3JZ1_c>
X-ME-Received: <xmr:uZSkaCDom6UoMpsjLytGV77t7R9xvCeuk21aTmbkj0QpFpdYLnnz2arabUj4g_Mc7zvuxJmfcPO7ASKcXET_vtTTBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduheehkedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpefgrhhitgcu
    ufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtqeenucggtffrrg
    htthgvrhhnpeevieekueetfeeujedtheeffedvgeffiedvjeejleffhfeggeejuedtjeeu
    lefhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhnsggprhgtphhtthhopeegpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopehhtghhsehinhhfrhgruggvrggurdhorhhgpd
    hrtghpthhtohepshgrnhguvggvnhesrhgvughhrghtrdgtohhmpdhrtghpthhtoheplhhi
    nhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopeguughouh
    ifshhmrgesrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:uZSkaF_LrwCcYq5YXGIixzoydm5fxgro-vTxUj1Mg5EQKEhKftMgZw>
    <xmx:uZSkaFI_u2d33doL2s-kw6V6zTWYaa4FTzQOBgLQhiXpTIJy0sn-GQ>
    <xmx:uZSkaGi1IGkWrBgQ7rz5nHuHDWd9qTAI6-DasOKu0S6B7n-knkJkoA>
    <xmx:uZSkaN6T9axxtJ0Qdl4MD8agvO9c_sphQYyNh96e1LZd3edtLB4CKA>
    <xmx:upSkaNEzHsgBgiUgmCNbVPFBOB9fkHHqrmZ954-SP9NuMB74FSuoqTIS>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Aug 2025 11:14:01 -0400 (EDT)
Message-ID: <573177fd-202d-4853-b0d1-c7b7d9bbf2f2@sandeen.net>
Date: Tue, 19 Aug 2025 10:14:01 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 Donald Douwsma <ddouwsma@redhat.com>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <aKQxD_txX68w4Tb-@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <aKQxD_txX68w4Tb-@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/19/25 3:08 AM, Christoph Hellwig wrote:
> On Mon, Aug 18, 2025 at 03:22:02PM -0500, Eric Sandeen wrote:
>> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
>> index f9ef3b2a332a..6ba57ccaa25f 100644
>> --- a/fs/xfs/xfs_buf.c
>> +++ b/fs/xfs/xfs_buf.c
>> @@ -747,6 +747,9 @@ xfs_buf_read_map(
>>  		/* bad CRC means corrupted metadata */
>>  		if (error == -EFSBADCRC)
>>  			error = -EFSCORRUPTED;
>> +		/* ENODATA == ENOATTR which confuses xattr layers */
>> +		if (error == -ENODATA)
>> +			error = -EIO;
> 
> I think we need to stop passing random errors through here (same
> for the write side).  Unless we have an explicit handler (which we
> have for a tiny number of errors), passing random stuff we got through
> and which higher layers use for their own purpose will cause trouble.
> 
> Btw, your patch is timely as I've just seen something that probably
> is the same root cause when running XFS on a device with messed up
> PI, which is another of those cases where the block layer returns
> "odd" error codes.

Ok, yeah, I had thought about just doing basically

	else
		return -EIO;

as well.

Though you and Dave seem to have different visions here, I do think that
for XFS's purposes, a failed IO is -EIO unless we explicitly need something
different. Anything finer grained or distributed to higher layers sounds
like a bit of a maintenance and correctness nightmare, to me.

-Eric


