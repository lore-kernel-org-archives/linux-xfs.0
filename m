Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233C0221549
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 18:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744742671; cv=none; b=ernsSA26kIRVW6A4SnQgzVCl3QIoAbAl5fOM6LuV6ztNVyBEErHFE3uriG3/RM50B6+Q65c2dXO9CoehUWKLElf/HD5zDW/FSn2B/jWcFqCGdoyqkIn5qEfbDe0bx9ZDTp2y4xe3IRKqbCAhiqmhpbQNKYnJaQihqjpLjQRbRXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744742671; c=relaxed/simple;
	bh=eTrfEy4H9o6c+TtK//73y311L3j6mLCbttODmT15zlA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R5pPnM2L9xI3pSXuXuq/Y0FIjTR1kfX8lYZ7MFMbumOyG2KJ6gntaCaK4/LZ7eSzBraZ6NfWr9jVfH1vaxoZuSCEDymcQw8jxYERO2ViYXw3K4J4VbemqEPM9dtxsEWZS14dryBV19NCoyq4AidZ22VKMp9sFVNrijoLooKRRS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=LV5ZsChT; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=T/Cr9Mk4; arc=none smtp.client-ip=103.168.172.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="LV5ZsChT";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="T/Cr9Mk4"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id 06D3C2002A5;
	Tue, 15 Apr 2025 14:44:27 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 15 Apr 2025 14:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1744742666;
	 x=1744749866; bh=So6lJ3SbU8vbrO3U8ayEggINZEC8diuUcsQeFiQxy4o=; b=
	LV5ZsChTqIBd2tA0IEo5K3O/WuWCtCHQN3i10IOtEAqjTHK6EO6DJj3RWF3KmEtT
	UjPJrNozxA5QqH6uR27YyOR8iWx6rcmyufboe6rb2qjnAxBx/0pccK/fsjHFw9Wk
	qFGXofv4i8KRBZzdXQLiiDAm6ikwfGjrw3A1QnGsf1Ljb4Pi89jhB5ZFl6vdSb22
	KbW2Pn7b/1u9Iuadsgvo7sIiS5shNviu98zG2q6sWX+qMl7nOXoFlIeFWkUnF56x
	X1zEUcAXTLmLXoL95IVbEebOPajuHRE79QKV1N4rXyZncwxwoiEJZjqKm/poRqOq
	hy/4z3hTyI856gxW8F4h8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1744742666; x=
	1744749866; bh=So6lJ3SbU8vbrO3U8ayEggINZEC8diuUcsQeFiQxy4o=; b=T
	/Cr9Mk4md7m8UCZ0TyHtSpa1YE1cVmBB8IAIPSRM9ngkaEV0OWjI3gQvGsDkin5n
	TcDwrdJpLUmyV6nacxqbcG41aL8L69Z6swjD9/pj5XRl4R5hbTjExjhcaI8EkUvO
	o3/I2s/00z49mkIgUrpW1uQCRY2UCTMFYL3fAiK4yZL4QQvh2+KUM++RkeFbzV1/
	tYSofgOx1YNjylh3f8Qb9asKYNDMuoahLkTkJum7etfbhOSk0DeWsF0h+4bwZFGC
	jUAOdks1RdqzvV3atGnBMYnrpwr/UzEL4h0w/gzhT6hgRktmBnhtJkqxLgrWarkE
	siP5Uwbp/+ZjPiDt0A4Lg==
X-ME-Sender: <xms:Cqn-Z0zyupeuNLgJgwg3C8JAz1gjWSkNi5xOVIXkBye8jF5puYkeag>
    <xme:Cqn-Z4SOTx4Oant0syWhFAd-EgCFbopFDMycLh0_mRBQMq4FGymgz8_BvzCp-Sz8j
    3q7y72isUbpeuQlVgY>
X-ME-Received: <xmr:Cqn-Z2We-jL-tfeeqDfwmYPkYp9SYl6jkxYMEo7fCQF_S11PvnWyQcHJMwHttA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvvdegvdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddt
    vdejnecuhfhrohhmpefgrhhitgcuufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghnug
    gvvghnrdhnvghtqeenucggtffrrghtthgvrhhnpeevieekueetfeeujedtheeffedvgeff
    iedvjeejleffhfeggeejuedtjeeulefhvdenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhn
    sggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsohguoh
    hnnhgvlhesrhgvughhrghtrdgtohhmpdhrtghpthhtohepshgrnhguvggvnhesrhgvughh
    rghtrdgtohhmpdhrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlh
    drohhrghdprhgtphhtthhopegrrghlsggvrhhshheskhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepughjfihonhhgsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:Cqn-ZyibA7_Gu-F2EHFE3Jvqi5OAZcpj2nN-hQUiaiauV3rWx64jrA>
    <xmx:Cqn-Z2DEEoe7npaAFRhwV7lz3PSFOPOtvKgPdC_4y-ve2jYemc8Ycg>
    <xmx:Cqn-ZzJ50ijEh9hfaHjued3Vp-6n5Nx-zROfJbSfU1hzRXQTkQGtcw>
    <xmx:Cqn-Z9AXNgNOs9Y1FJr4i_6nSZhLNx2JOQHRH4OtigPUUoQg1hpgBw>
    <xmx:Cqn-ZzVqSptJluI9TXzt-A2pmR1YE2C1ivgWc8vwRCgtzJD6I2AOyeV5>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Apr 2025 14:44:26 -0400 (EDT)
Message-ID: <b894a2f0-db12-4eef-aa6a-c14756fe812b@sandeen.net>
Date: Tue, 15 Apr 2025 13:44:25 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs_repair: Bump link count if longform_dir2_rebuild
 yields shortform dir
To: Bill O'Donnell <bodonnel@redhat.com>, "user.mail" <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org, djwong@kernel.org
References: <20250415180923.264941-1-sandeen@redhat.com>
 <Z_6kCAHGNoSnPc27@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <Z_6kCAHGNoSnPc27@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/15/25 1:23 PM, Bill O'Donnell wrote:
> On Tue, Apr 15, 2025 at 01:09:23PM -0500, user.mail wrote:
>> From: Eric Sandeen <sandeen@redhat.com>
>>
>> If longform_dir2_rebuild() has so few entries in *hashtab that it results
>> in a short form directory, bump the link count manually as shortform
>> directories have no explicit "." entry.
>>
>> Without this, repair will end with i.e.:
>>
>> resetting inode 131 nlinks from 2 to 1
>>
>> in this case, because it thinks this directory inode only has 1 link
>> discovered, and then a 2nd repair will fix it:
>>
>> resetting inode 131 nlinks from 1 to 2
>>
>> because shortform_dir2_entry_check() explicitly adds the extra ref when
>> the (newly-created)shortform directory is checked:
>>
>>         /*
>>          * no '.' entry in shortform dirs, just bump up ref count by 1
>>          * '..' was already (or will be) accounted for and checked when
>>          * the directory is reached or will be taken care of when the
>>          * directory is moved to orphanage.
>>          */
>>         add_inode_ref(current_irec, current_ino_offset);
>>
>> Avoid this by adding the extra ref if we convert from longform to
>> shortform.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: user.mail <sandeen@redhat.com>
>> ---
> 
> I was about to send a v3 of my patch to handle this (fix link counts
> update...) based on djwong's review. This looks cleaner. Thanks!

This is related to, but independent of, your patch (see my self-reply).
Please continue to fix your case, so that all entries do not end up in
lost+found when the header is bad.

Thanks,
-Eric

> Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
> 
> 
>>  repair/phase6.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/repair/phase6.c b/repair/phase6.c
>> index dbc090a5..8804278a 100644
>> --- a/repair/phase6.c
>> +++ b/repair/phase6.c
>> @@ -1392,6 +1392,13 @@ _("name create failed in ino %" PRIu64 " (%d)\n"), ino, error);
>>  _("name create failed (%d) during rebuild\n"), error);
>>  	}
>>  
>> +	/*
>> +	 * If we added too few entries to retain longform, add the extra
>> +	 * ref for . as this is now a shortform directory.
>> +	 */
>> +	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL)
>> +		add_inode_ref(irec, ino_offset);
>> +
>>  	return;
>>  
>>  out_bmap_cancel:
>> -- 
>> 2.49.0
>>
> 
> 

