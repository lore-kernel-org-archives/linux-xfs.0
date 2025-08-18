Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1132571BD
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 21:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755551505; cv=none; b=BcCWsJ5qVc/jldpWRG7sTqAB5vFyVko33k/8oBvWuYo9213GCD+W87RLCYxq8imSuWFYQfN+LwoFZldLkRYPjv1X45cW3YD+rK1WIXOndQSRkwbAa4i9z7comnaXgZXrnJ642ous4xM9MbfNW/WHNOKyyVhr5s2Mtg10eJo9o+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755551505; c=relaxed/simple;
	bh=mbDiTNwNJlQg/HzZXCUCcIXGxM5SM8RnWZ+/fwiRYwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MeLqjLlnQlw6rFDqvePaE7xKaHvmiX+N5GbU7dWChqR9Ydazf/MXQ1mBGBHx0MzDP5AixNX7Hyd7C+6WFzUKBlFCxhxfQkTjja1MtxFs/dTeK4TeI1L0mh1qvaaZO+EqvgqYF32jjjxjEEo+jxR6BJ6xcfyj6fDwOHXpkn6xl7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=ORK6Mp+O; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jQ8332Hk; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="ORK6Mp+O";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jQ8332Hk"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 182C21D00198;
	Mon, 18 Aug 2025 17:11:42 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 18 Aug 2025 17:11:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1755551501;
	 x=1755637901; bh=BNYCVuZD+4T1f+Cxst0gJCYta1TpTZxPuJIY4BHy9ns=; b=
	ORK6Mp+OsWjLN03RzUx/roe6SCe3hC+d8qPGwSFsoVRuTkbytIo6Gh52IDrU3GCU
	aZWsrbXJO4odtE9wDdPc9bFzp3Ldt6hxGbhbpdCHWdEucjseDMmPzPxH4Uu4aejX
	V/JFIYasoLjcix0OeJRQHHtO7RPBjlea3TVfCNQJGlPTYoTB/wYQoPKsD+RCbdv6
	ItO8MxcW94B7pr9B0VFtgVmTzRHuRyTzyiIzDgZIq/jNhspo09digR1hNB2/XKAm
	oCEExLwaMYk+7YkgQ/nUsgE8mM5vbXBgXiBrZN8JuOgqZ0+ud+i4Mi5Q0vRnqqpV
	V4aWhtM3i+Ydt14uvGZADQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1755551501; x=
	1755637901; bh=BNYCVuZD+4T1f+Cxst0gJCYta1TpTZxPuJIY4BHy9ns=; b=j
	Q8332HkAjJ/htG94KkoOQAoNvk7JXLZbW5ZFBOxx3mw8GlUMSOUNhqaDvPLhfkKf
	tDhGzXaBrWjxF+ftQUH52T/bas3IzgnNVWMaXFLOHciofss9Z/FcEVDWJ/SV7hxb
	xRky7OGU+nP5LEc3ASIVkzc/wPKGip2W4ccP+61oR92mQL1oMGZ4PvBoJKORWLxW
	ysnS8GMwiN5uaskx4xA5cWMj073h64EIFYrdCgA/goa/q73IeAv+KgNTYM5ttc0t
	f1SiFsBUSF4Nu1BzaSOBN4bOiFyIsicxKFf5y5Hp3oK+EvUAN670QlJlOjoCE7j2
	U0vD5dvVchPo4NGZWePSA==
X-ME-Sender: <xms:DZejaHQ5zP4U_VTBNYJR3X84qPtSoHLNQaSOW0yR3hg9LJ-td6tdLw>
    <xme:DZejaDW8bPWzF79BwMMeub3ziXJZTqZEW6H2-RhDsGNjWfjR14M3NBN55oiEye2rm
    zVQEweSqAQplWRIrEQ>
X-ME-Received: <xmr:DZejaJbOX4DOhBH8oe7N3rcRX5C459keESpHKmNYiAwm0WXVBFRY4gMhDZkLHTdFAc1zCkpEx_ZfHOfS9QBf8WfK_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduheefieeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpefgrhhitgcu
    ufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtqeenucggtffrrg
    htthgvrhhnpeevieekueetfeeujedtheeffedvgeffiedvjeejleffhfeggeejuedtjeeu
    lefhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhnsggprhgtphhtthhopeegpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopegujhifohhngheskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtohepshgrnhguvggvnhesrhgvughhrghtrdgtohhmpdhrtghpthhtoheplhhi
    nhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopeguughouh
    ifshhmrgesrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:DZejaJ3v7u9sa2syVYAQ2_PC0QdW76fviYdTKWy5f9mOtOe7eT9b6Q>
    <xmx:DZejaLhhVS2lEhSeD_5rMzCw0FEGhJpX-hC18-Xt1EbpUaQhq6rehA>
    <xmx:DZejaNb-sDAOl0-mVsS1Vue2xtwkF7beeAjlj5-Xe7sYLGHc9ooy9Q>
    <xmx:DZejaLSrxVwY2_mWzZxGpSKY3NcfQpAxDoq-xr6r-j7hE_hRa_plnQ>
    <xmx:DZejaLemDRE8camJPQpA9vhSkB-AmCwK3v5nkPGpE6GiHRdCOgu044Dw>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Aug 2025 17:11:41 -0400 (EDT)
Message-ID: <8fd28450-d577-4921-96d9-69af0c9b1aa4@sandeen.net>
Date: Mon, 18 Aug 2025 16:11:41 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
To: "Darrick J. Wong" <djwong@kernel.org>, Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 Donald Douwsma <ddouwsma@redhat.com>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <20250818204533.GV7965@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20250818204533.GV7965@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/18/25 3:45 PM, Darrick J. Wong wrote:
> On Mon, Aug 18, 2025 at 03:22:02PM -0500, Eric Sandeen wrote:
>> We had a report that a failing scsi disk was oopsing XFS when an xattr
>> read encountered a media error. This is because the media error returned
>> -ENODATA, which we map in xattr code to -ENOATTR and treat specially.
>>
>> In this particular case, it looked like:
>>
>> xfs_attr_leaf_get()
>> 	error = xfs_attr_leaf_hasname(args, &bp);
>> 	// here bp is NULL, error == -ENODATA from disk failure
>> 	// but we define ENOATTR as ENODATA, so ...
>> 	if (error == -ENOATTR)  {
>> 		// whoops, surprise! bp is NULL, OOPS here
>> 		xfs_trans_brelse(args->trans, bp);
>> 		return error;
>> 	} ...
>>
>> To avoid whack-a-mole "test for null bp" or "which -ENODATA do we really
>> mean in this function?" throughout the xattr code, my first thought is
>> that we should simply map -ENODATA in lower level read functions back to
>> -EIO, which is unambiguous, even if we lose the nuance of the underlying
>> error code. (The block device probably already squawked.) Thoughts?
> 
> Uhhhh where does this ENODATA come from?  Is it the block layer?
> 
> $ git grep -w ENODATA block/
> block/blk-core.c:146:   [BLK_STS_MEDIUM]        = { -ENODATA,   "critical medium" },

That, probably, though I don't speak block layer very well. As mentioned, it was a
SCSI disk error, and it appeared in XFS as -ENODATA:

sd 0:0:23:0: [sdad] tag#937 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=2s
sd 0:0:23:0: [sdad] tag#937 Sense Key : Medium Error [current] 
sd 0:0:23:0: [sdad] tag#937 Add. Sense: Read retries exhausted
sd 0:0:23:0: [sdad] tag#937 CDB: Read(16) 88 00 00 00 00 00 9b df 5e 78 00 00 00 08 00 00
critical medium error, dev sdad, sector 2615107192 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class 2
XFS (sdad1): metadata I/O error in "xfs_da_read_buf+0xe1/0x140 [xfs]" at daddr 0x9bdf5678 len 8 error 61 
(see error 61, ENODATA)

> --D
> 
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
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
>>  		return error;
>>  	}
>>  
>>
>>
> 

