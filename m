Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8405E296BD1
	for <linux-xfs@vger.kernel.org>; Fri, 22 Aug 2025 17:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755885162; cv=none; b=ai16lJRh8jDFmLcsWKoEqMnz2yuELfrGAoBW3TcU9PsOlhMJA1b98bLfnNpBGfIciUN5+o4ZPMxCGwoBIeFZWC8mXYsS7oLP+3Wt0rqdVJA9CrsJ4eH0PxvfNA3QkHEPWHdw4uR4YgP/jp4JsMwwerpBdjji55TMuSypMpHWVMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755885162; c=relaxed/simple;
	bh=7IhcQqnLuUkXXpPOfM1Ds/L48DNavYhPxrzcWHKTo7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sDBKlSmozF4SrEKZVOKH3Fv4ng5BlnIMDA0en+Sm4nMm4XV9D15e2ixASLVnYerT1xZFtlIo0oAylmMeOaNdyIpNPtM3QYCsikiMnQk9zipjI1mhgrwIhAYk0kbu6UHOtXAaoymY1Izr/x55CawNM+HWoRJhevX0WEjfkvh0xTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=D2M2iAnq; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LBILPBrg; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="D2M2iAnq";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LBILPBrg"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 91E90140007F;
	Fri, 22 Aug 2025 13:52:39 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Fri, 22 Aug 2025 13:52:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1755885159;
	 x=1755971559; bh=/3kpky0bNQFCC99Udr888RsYcemKnIM+DbrFnr/SnLU=; b=
	D2M2iAnqjI/sbwVahOHxbMezyP6rgQivQ9AC4PfNqsyRSgOSelZ2SqfzPE481U6O
	wQ0tkJnT1OuUKdtWQwkJO9VYoO1QrF076pSG4Log1RbTL+gM9Mrui+e8zEYNeVvQ
	6zRIGutsCi8yAKUCg56Lt8G6RTKpwfBLy7AZ+2A5uoOdVdi0qtKr0Ow+g3iFDjU+
	+5aRyY8rPiT7Zf8vuIUy6v0PAm2Nus8UYGKra1kHY2Carajeer/QDzYl6FGOxG1g
	NKOh6qHZ1tlI/Xi/d0niNtmjSNiP2kRezxqjh5yyeHDuJeMkT6fmjTbkz6ojh6Ef
	zdZBIIVeAo8avre1EyZ0RQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1755885159; x=
	1755971559; bh=/3kpky0bNQFCC99Udr888RsYcemKnIM+DbrFnr/SnLU=; b=L
	BILPBrgXUD1xMJH2QijItFrpUybJDhqFORSi/qVfDEg90ZQrnxteGhgh+9AZhMDq
	GOksduof41MRJ5T9D6ZX/kSF3g+EzcF1WxliLZsLLT8wmOrY69FJGKTgRbSB+SlJ
	5tXZiWtP/4XDa7w3WD21JHR+eG6EJ7Jsz4df516bL5aKvvv6wlkrf0VLSImQmdVo
	o+MSsA+iTr46urvCtW+9O5da1gHj02BBGI86bgmKZgc7f/Oy4awhOWlvFVv8VdBj
	l1uklvHwgIT0uZjzMqESDWo1sBT3mX5OPVS3POKxZ5H6/MvnzfhsMRM1bwrI6Iwn
	GyKp2HgwtUIeGF+kwXEcQ==
X-ME-Sender: <xms:Z66oaMuMqEBic-IBZehcqL9sV1qRSwc_FcBepmrw7vXjU_s7zORzWw>
    <xme:Z66oaB6vKRQTIYl4g2IvWgOkTVH_PTtcrlelZaL3-1ntl8mb0kDEf7MJWzQeBV0Dk
    TttKXS-qlWxZL_RYRI>
X-ME-Received: <xmr:Z66oaIPzqWCmONB6Ys9-aZ6JnZJcmkspQEmGbtx6uRnL95t51YM1re1XImuyAmDRQ66zx3qix-xNnfeD3cnmNW8a_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduieeggedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpefgrhhitgcu
    ufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtqeenucggtffrrg
    htthgvrhhnpeevieekueetfeeujedtheeffedvgeffiedvjeejleffhfeggeejuedtjeeu
    lefhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhnsggprhgtphhtthhopeeipdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopegujhifohhngheskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtohepshgrnhguvggvnhesrhgvughhrghtrdgtohhmpdhrtghpthhtoheplhhi
    nhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopeguughouh
    ifshhmrgesrhgvughhrghtrdgtohhmpdhrtghpthhtohepuggthhhinhhnvghrsehrvggu
    hhgrthdrtghomhdprhgtphhtthhopehhtghhsehinhhfrhgruggvrggurdhorhhg
X-ME-Proxy: <xmx:Z66oaPsvXlY0bGYuiqzFDrjDCpZ_l5YH8NF2XCwEMQrUiy8kEwk3Mg>
    <xmx:Z66oaLYOytlu0IkMyzqBP8fUyxY4a5-AlL2NBRSJ43hN6KaPB-XtpA>
    <xmx:Z66oaBw-ELa0SavdgKHoWDi2deCKwcTtI5hMjMrXa2V-I0v8dbIYcg>
    <xmx:Z66oaDieVaVH74n7w33aPRDU1jS-FtnxUYz4l1GvA1KUpWghvruDfw>
    <xmx:Z66oaIyeiwWDFKXEFF1OZ0Cb5X4Q0KDLV1Za8VObfAQUsjeXNOYrLTro>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 Aug 2025 13:52:38 -0400 (EDT)
Message-ID: <06d91448-99ef-4023-bcb4-94608f45b050@sandeen.net>
Date: Fri, 22 Aug 2025 12:52:38 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: do not propagate ENODATA disk errors into xattr code
To: "Darrick J. Wong" <djwong@kernel.org>, Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 Donald Douwsma <ddouwsma@redhat.com>, Dave Chinner <dchinner@redhat.com>,
 Christoph Hellwig <hch@infradead.org>
References: <a896ce2b-1c3b-4298-a90c-c2c0e18de4cb@redhat.com>
 <20250822152137.GE7965@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20250822152137.GE7965@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/22/25 10:21 AM, Darrick J. Wong wrote:
> On Thu, Aug 21, 2025 at 04:36:10PM -0500, Eric Sandeen wrote:

...

>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index fddb55605e0c..9b54cfb0e13d 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -478,6 +478,12 @@ xfs_attr3_leaf_read(
>>  
>>  	err = xfs_da_read_buf(tp, dp, bno, 0, bpp, XFS_ATTR_FORK,
>>  			&xfs_attr3_leaf_buf_ops);
>> +	/*
>> +	 * ENODATA from disk implies a disk medium failure; ENODATA for
>> +	 * xattrs means attribute not found, so disambiguate that here.
>> +	 */
>> +	if (err == -ENODATA)
>> +		err = -EIO;
> 
> I think this first chunk isn't needed since you also changed
> xfs_da_read_buf to filter the error code, right?

Doh, yeah, I guess I got tunnel vision on that, sorry. I should have caught
that.

> (Shifting towards the giant reconsideration of ENODATA -> EIO filtering)
> 
> Do we now also need to adjust the online fsck code to turn ENODATA into
> a corruption report?  From __xchk_process_error:
> 
> 	case -EFSBADCRC:
> 	case -EFSCORRUPTED:
> 		/* Note the badness but don't abort. */
> 		sc->sm->sm_flags |= errflag;
> 		*error = 0;
> 		fallthrough;
> 	default:
> 		trace_xchk_op_error(sc, agno, bno, *error, ret_ip);
> 		break;
> 	}
> 
> We only flag corruptions for these two error codes, but ENODATA from the
> block layer means "critical medium error".  I take that to mean the
> media has permanently lost whatever was persisted there, right?

I assume so - I guess it's "corruption in absentia?" I could imagine EIO
indicating a similar "data is gone, sorry" problem too, though. I honestly
don't know what EIO or ENODATA or any other errors from the block layer
mean in detail, or how consistent errors are across device types etc.

-Eric

> --D


