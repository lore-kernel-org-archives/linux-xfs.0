Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFCF18E3F
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 02:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755570455; cv=none; b=rKblyksnu4Tj6ZFusTWvfvXWxPaT6jyAWijQvGs8voDSnGgJQUHCB0QqFqqIi1TtNN/r1P/0kDoL9p+T3D8QfS635iyay0xPkTeOrrnuDnF0EGGRb3vdEtNbl+FBb2wDTQUQu6kPZHR+xn724MpjW9J4r03DNhD4k3lnepMccEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755570455; c=relaxed/simple;
	bh=PMn/7gIMySmOk4R+A7zu+ge+u9qtneQuwrtJGwwU2yo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=neL4Eh6sDDew7lx3fa0DkOSxng9KCvX4lnrPWdrTwED0qKFExasXUxs+gj94HfgtIcv+bfuI4xguR/MbjYNSAWMBgkmtjCqFH4OIfWAn8Y3PYp9wzm6l3LY+SwJATIAISrZNkQYYnFigIlj5xDTnimwh/CQMLvQE7UMZExLmOkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=RW1bsYTc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=g1RB77Kd; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="RW1bsYTc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="g1RB77Kd"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id AEC351D00260;
	Mon, 18 Aug 2025 22:27:31 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 18 Aug 2025 22:27:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1755570451;
	 x=1755656851; bh=ITC9AskXLEh9LUrxkGN0fD8wdZXLHvKMAHH3kk9WYHo=; b=
	RW1bsYTcgllAAgZvnkskDzxc0Z+iQzJ7IMzfzxaMGRfqeUI2oF1WX23Rz/FZrzxD
	Dkbkj4vvj0CLSltT8y8+q34g3XBwEyGelfeCSseC4PoY4dvnyLu6M1dXawscUTri
	7kmXBHuwHUHVxhpFGkd+JdU3PusdR679bAlhchkbQ8dTrVqDWgy+ezjC1KZn64e5
	QxulS1wmjGrc1W6ZXIk4P0iGgtv4hiSxa/ru5GwOkzH2SzQq3O8fXc3iDu5V+F/O
	HreKWTez/vm2a5ERH6QiCKH1eL97FOgBS7t6WTf97BGEXJcF1hbdBxicx5pNqk3/
	ZGHEUSdiozuylZ72BbW00Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1755570451; x=
	1755656851; bh=ITC9AskXLEh9LUrxkGN0fD8wdZXLHvKMAHH3kk9WYHo=; b=g
	1RB77KdKfZxvjJsmkoyrk3zsyz2OF2/1JHnXQYPtsDChhu7FUeVYvDKUc7E85jsi
	wznJR7SjVnkqgWkSjcd2Ny+XQG4m1bwrnT+RB2F4oW/MfMahFeyZY4ZYkF00CtRk
	2VF/5XlOdabTzjrT3FrjRgB72q4OHJJLr5zRSbWetM+QeJVz3OSRrTXaoMEHxYHa
	BTqmGa2zr5h0DRaQpdMVgFg+MApIREQ64c1MnBFl8dPblBIljY1b9V03ZU6KaWvG
	t5mUD7ecWdLlB2KXtobehNZmilKD6TZ3Bu0npwoTfru6Inb6lWm26tjRKMRBltXy
	QTlHb41LdO4MzhVuEiY0Q==
X-ME-Sender: <xms:E-GjaDSj0dVcPKNYNcZjKqq-uVR4y0LdJD4ynVzjhPzdmaadXCXLlw>
    <xme:E-GjaPVCvVwHJmWEItzrTUeLYdGOENbtxAGCPQpuQueV7rzq2d9x4rBRTJtQTiudz
    kGifmryx2deOnljcZw>
X-ME-Received: <xmr:E-GjaFauuY_GoxjH1L7k2ksgRwtq-bnK4GCh9-3HNxD-psbrB2tnOcyaNwyJynlIw5NSh7cZ9QcBe3WsX63WPL2joQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduheegvdekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpefgrhhitgcu
    ufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtqeenucggtffrrg
    htthgvrhhnpeevieekueetfeeujedtheeffedvgeffiedvjeejleffhfeggeejuedtjeeu
    lefhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhnsggprhgtphhtthhopeegpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopegurghvihgusehfrhhomhhorhgsihhtrdgtoh
    hmpdhrtghpthhtohepshgrnhguvggvnhesrhgvughhrghtrdgtohhmpdhrtghpthhtohep
    lhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopeguug
    houhifshhmrgesrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:E-GjaF20Of0CFNTIH_5x3BF3m0XW9cTaR96r_6EexHhdi5oPu-EMXg>
    <xmx:E-GjaHin7-P_1aJomi3Mc8sE2RoyYzGLKJQP7quLX2qJaEhv_r6p4w>
    <xmx:E-GjaJYxC1i26HusJm9wFpRCAQ5oWEoiYIjMDmfCqtPmhOOD9GTWrw>
    <xmx:E-GjaHTHxXAkTGWXOGflODoSzVxO-6ummsTwQfo7PPkcYUNnGGsmfA>
    <xmx:E-GjaKDje7ltQ9kkoj0jn2XOhCLux00qYlwqzZ75G2toq5bx09rSy8Pg>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Aug 2025 22:27:31 -0400 (EDT)
Message-ID: <52429b81-7e7f-41e5-8d73-bdc26a237746@sandeen.net>
Date: Mon, 18 Aug 2025 21:27:30 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 Donald Douwsma <ddouwsma@redhat.com>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <aKOkqUL17skszJ4e@dread.disaster.area>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <aKOkqUL17skszJ4e@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/18/25 5:09 PM, Dave Chinner wrote:
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
> Not sure this is the right place to map this. It is only relevant to
> the XFS xattr layer in the kernel, so mapping it for everything
> seems like overkill.
> 
> I suspect that this error mapping should really be in
> xfs_attr3_leaf_read() and xfs_da_read_buf() so it is done for
> xattr fork metadata read IO only...

yeah, that's partly why RFC. The higher up it gets added, the more
risk of adding another caller later that doesn't handle it. I didn't
see much downside to doing it lower, and just saying well, ENODATA
is kinda another way to spell EIO.

So I don't really care, but doing it in one place seemed better
than doing it in several.

Doing it lower might also be more consistent - only remapping ENODATA
for xattr reads is a little strange? But you're right that other
IOs shouldn't need it.  *shrug*

-Eric
