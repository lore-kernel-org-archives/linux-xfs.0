Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9673824169A
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 15:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755617938; cv=none; b=c93bze7p7EELsL1Hl4Ty6mTG9mdPHRqG0fxpQhMbI95bSqrBiMe+vUsRzEiHz060T55ZHLWo+Nft4Eq4XSPvwT00DiBgGpCVpVzWKE4htCiM56htwSoV6UvMhBpwvxMTid5ewZeFrnw6wTFoOc8UtuRuHX45Q3BpMpO/ElXsqIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755617938; c=relaxed/simple;
	bh=ufRZHYzKOp9pfG9/gjuy6ayNx/FP/UuoeofGCLoIhbs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D7UG6MYMf+g7drbv0q8RYIqI+d3okSbl2bxRUcwH77S0qy6Uhc9pF99PHN8cuBuaNSZUNjE6QX97MN5VIfu+xZxjassHnyrfD/dlcsEXlopq9OmXbQyh8liZv71vf2tuU+k6OFQiXGI9gNJeby0JXw8xqgKSdAYqCK3qHwI9+K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=lA9Cp4N4; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KD85Ud0I; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="lA9Cp4N4";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KD85Ud0I"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B007C1400206;
	Tue, 19 Aug 2025 11:38:55 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Tue, 19 Aug 2025 11:38:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1755617935;
	 x=1755704335; bh=IWEp3aTqKC60Entds+XDw96n0GiYdTuOeXaXEmb19oo=; b=
	lA9Cp4N4bnyEEvu6Fc1GKksYKQ3WB5ZqHzQzKtlDCCNIK+cyFQN1TBwTTUNt0rIt
	BrmIZYifLWTNe08rHhi46gZe5XMWulJh4c/W4z8scAyhy7uZkX1DT0n/lLpt1k9y
	DGA2eCKQT1b8VzPw6H7yvSpSkZ3NPJ2fz/+JPutmtLi/e5StCV/T2ZwS71UMo3TS
	ChQP1nC2NmiqVygf3a7+RmnkkRT0vI6YfVy7uRBz3Odx5bz3m1A9AZEkDZq3sBSB
	QbEJlPGjIqNj9FrcMrzyb3vjHN7Id+kZEm4c1YwDf94bW7/OiqAsNfoMEHRiBeeb
	KLUERCZFIWfPhDcrNubpSw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1755617935; x=
	1755704335; bh=IWEp3aTqKC60Entds+XDw96n0GiYdTuOeXaXEmb19oo=; b=K
	D85Ud0IwFk1Rubo3NwgJHGfQbRe2jlKGjA7Th36NNGCnNegwpB5a2tOMeSgQgFIZ
	BV6O8zsYgNVYu8tpXtChLvwUgYIf8qy8pls7CEdgzsSzobEb1nQhLmKJiUXldG7e
	U7yaPu/nRAaUcBawidfxhY7F6ykmGajb2knDm9GygEh9yehUrxydBo2KZQzp12Mi
	ElA6anM40mjIrZr3ORpLEp4L47NNmhAem0kNSA00sOOvse9owWe04EhKGy4UCADu
	bx0JH/2UFi7Z8CQkkiDM15VsKeUnKXnhgeDNa+vfETTN1FGsQulMWPY9MCeMlnGd
	9909ndMb41MIYW/9VULtw==
X-ME-Sender: <xms:j5qkaFU_qmsF7ZfOJjCJZRnIOZMM1VMxxgplBNH-Tz7Wf08czr7pnA>
    <xme:j5qkaAJjqVLsYUnKT_Oona3C2ipVZrLYi780UzolXM9QMOSPDJs3_9Cc7s4mCXbFu
    bz6n8ofAS-v33HuMqs>
X-ME-Received: <xmr:j5qkaN8BCzwuT4m137fiL6cFumOnA-ZZuvy1WcoC2jMpE4nTH3iViKjqb6GmOA335yqalzBIIgbNvXJCLYtIbR0NFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduheehkeejucetufdoteggodetrf
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
X-ME-Proxy: <xmx:j5qkaLJbMz1KSpSBtFunjmBsFntpSZWjntJriUb96QCzMDkkZvJ64w>
    <xmx:j5qkaKlE7mVwXQ7zEXE52J35_s-NV4_XT91rZ-EuPSSJfn4zw1uKmA>
    <xmx:j5qkaHMl2tlFoS8zk2mWxm2rlQq1bgQd5n3BGaa6E62QXCKEdCaZWQ>
    <xmx:j5qkaI0quBo8TAfyuT2qfohvYuItAWOFmt3599i7kJarNFSPo1a92w>
    <xmx:j5qkaGiUDudr2lVmYbgj1RRbFnZbJMJxy7DN_z1mcSp3J0wjwoRHLF3G>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Aug 2025 11:38:55 -0400 (EDT)
Message-ID: <0d424258-e1ba-47c3-a0ae-60e241ca3c7c@sandeen.net>
Date: Tue, 19 Aug 2025 10:38:54 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 Donald Douwsma <ddouwsma@redhat.com>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <aKQxD_txX68w4Tb-@infradead.org>
 <573177fd-202d-4853-b0d1-c7b7d9bbf2f2@sandeen.net>
 <aKSW1yC3yyR6anIM@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <aKSW1yC3yyR6anIM@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/19/25 10:23 AM, Christoph Hellwig wrote:

...

> The one thing we had a discussion about was ENOSPC, which can happen
> with some thing provisioning solutions (and apparently redhat cares
> about dm-thin there).  For this we do want retry metadata writes
> based on that design, and special casing it would be good, because
> an escaping ENOSPC would do the entirely wrong thing in all layers
> about the buffer cache.
> 
> Another one is EAGAIN for non-blocking I/O.  That's mostly a data
> path thing, and we can't really deal with it, but if we make full
> use of it, it needs to be special cased.
> 
> And then EOPNOTSUP if we want to try optional operations that we
> can't query ahead of time.  SCSI WRITE_SAME is one of them, but
> we fortunately hide that behind block layer helpers.
> 
> For file system directly dealing with persistent reservations
> BLK_STS_RESV_CONFLICT might be another one, but I hope we don't
> get there :)
> 
> If the file system ever directly makes use of Command duration
> limits, BLK_STS_DURATION_LIMIT might be another one.
> 
> As you see very little of that is actually relevant for XFS,
> and even less for the buffer cache.

Ok, this is getting a little more complex. The ENODATA problem is
very specific, and has (oddly) been reported by users/customers twice
in recent days. Maybe I can send an acceptable fix for that specific,
observed problem (also suitable for -stable etc), then another
one that is more ambitious on top of that.

-Eric
