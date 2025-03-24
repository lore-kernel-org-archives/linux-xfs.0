Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41739264A62
	for <linux-xfs@vger.kernel.org>; Mon, 24 Mar 2025 18:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742840972; cv=none; b=nVAex6r4JtahrEpeiWaQgMZPr1mgid3Vm7b5ZStCRLAX5MGlZT3SYlPPsqeiwNNj8gKS5LOvnfPb9mBr6t5xL8SY1JYZVX3aQwZjvoxlUYK2Y7QrDGddEJjdVoD7EpmlbRsgEePQIHn14DLdT3VTwmLbEanqXTq7WTgjRv/S4gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742840972; c=relaxed/simple;
	bh=9Th2KGGcHdxqdC9dWfssH0Q8H/XkXkPRkTwgRcvCo1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mNRhwrUeYsxae0fW1LaJCRUnBcshLBU/++ZMILsm7OcFMbY9uyJDN0umxqQae1EyJekp3UdHCPhGnFkeiGHCjV5kj07dY7Ji4SlboLG5ZGfOPWZdQ/kEQKRdJ67D+z7yx7EgJWAqgBAvQqtV69tBwOQ7dIdfYKM+NzLDaiEwl2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=y4yvKR61; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=o/vshfh3; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="y4yvKR61";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="o/vshfh3"
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 516D31384841;
	Mon, 24 Mar 2025 14:29:29 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 24 Mar 2025 14:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1742840969;
	 x=1742927369; bh=YStRs5Upmrcdcqn9TngEcV/IDHcika4GDwcEq8blA3k=; b=
	y4yvKR61EjKxOi15IBlt8PWdOyMG3MC8NFAQEqJubFIl72j9f1dGZN92tPB+cXp3
	EBR0QLXQ2uiovqwOxwhhKp6FEqogmyz8W9n1c6yFnN2fjhwbzwKQwltQZhFi4ypE
	8luiy9BZUt7w07/e46e5s3rdde8oQ336LMtNNg0vArbyDgtt9QdKthhMZIi9l3GC
	T7lrjcnmaTRUSoAnh4EgopssJYeB5v2PRM8Zp2LkyihLMEU8PZLH94fD9HxjQTqM
	h+BjLumkTwz8CZD73yShdWEIdBoJcTzJ/95q4IXsCi55wQE+0MYD85L6bSr1LSUa
	tb+NqYMkOCbUFWfsY7ZR+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1742840969; x=
	1742927369; bh=YStRs5Upmrcdcqn9TngEcV/IDHcika4GDwcEq8blA3k=; b=o
	/vshfh3SUjlyL5cvuPUtpHDoJwz0ykPgw4A+j/zgymMtE8AOgcIlq6jXEcBDthNr
	3fcPLHPWt46kphmuHEu1CbH82mp41PicnioMs8PkwY9iptSNpMbSTvbYtOtmQgbP
	nmfWXGhPUxGP2TUELANuO8iDYmUd1PeyN0OAemt6Vl64Brx5jKw67wCRnjMwaJjF
	MYDzNpdZrPLSFFSY6yOagR8DUdVIA5G7yGPvPRZstUYGLobAJIGpGfd/aCbzqWVP
	TGMxdJvj8k+sI00A/IUDs/CyEFUiHBlN/QwQu6ONOaCpexo2ZOBWXd6AnE0urvcD
	pz2qoDoyNLRY6by0iVmXQ==
X-ME-Sender: <xms:iKThZ53fcoA9-KlzbzAxKlhSA_jUa0RO7fhRdL46CCmW_ZCXM4VG3w>
    <xme:iKThZwFggni2FYJvYzOHf1Y0HQQpd4xeF_NyyCz4dUtEZMCagdSj7BlK3BnQTySn7
    e2OKj4GMklXIoi-ALU>
X-ME-Received: <xmr:iKThZ54eEMjnVcdnV58NFil5LZfhVFtYvU-zKMJpSyPo_8t7g_O6giECjK7gKOE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdduiedtgeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefkff
    ggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepgfhrihgtucfurghnuggv
    vghnuceoshgrnhguvggvnhesshgrnhguvggvnhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveeikeeuteefueejtdehfeefvdegffeivdejjeelfffhgeegjeeutdejueelhfdvnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrnhguvg
    gvnhesshgrnhguvggvnhdrnhgvthdpnhgspghrtghpthhtohepgedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtohepsghoughonhhnvghlsehrvgguhhgrthdrtghomhdprhgtph
    htthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepughjfihonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehhtghhsehinhhfrh
    gruggvrggurdhorhhg
X-ME-Proxy: <xmx:iKThZ21p6ixw5mkemaUSb8DgToqkDHAWtpCZgMGCZkQ_9oGfDsVt7w>
    <xmx:iKThZ8GVRq0nXAVNnG5xPiVL7K4bSrD-nO-Al7sY0EiHc9vzdbYwmQ>
    <xmx:iKThZ3_Fax4upve_U3aZ__svOmUCLK_Gp-M9xzBctYwmj_4bgYir7g>
    <xmx:iKThZ5nCBG0D538Wjo-b1p9M5lH3KnTPtb4l0knQYJpbXsVNast0Jg>
    <xmx:iaThZ4iriH4bpFhh5UjNZeUVJ5lvvVrMmNWwJU0ie79endZcoFujiEAC>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Mar 2025 14:29:28 -0400 (EDT)
Message-ID: <a34c8320-de3b-482a-85e4-0973b2359bea@sandeen.net>
Date: Mon, 24 Mar 2025 13:29:28 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs_repair: fix link counts update following repair of a
 bad block
To: bodonnel@redhat.com, linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, hch@infradead.org
References: <20250324182044.832214-2-bodonnel@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20250324182044.832214-2-bodonnel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/24/25 1:20 PM, bodonnel@redhat.com wrote:
> From: Bill O'Donnell <bodonnel@redhat.com>
> 
> Updating nlinks, following repair of a bad block needs a bit of work.
> In unique cases, 2 runs of xfs_repair is needed to adjust the count to
> the proper value. This patch modifies location of longform_dir2_entry_check,
> moving longform_dir2_entry_check_data to run after the check_dir3_header
> error check. This results in the hashtab to be correctly filled and those
> entries don't end up in lost+found, and nlinks is properly adjusted on the
> first xfs_repair pass.
> 
> Suggested-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> ---
>  repair/phase6.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 9cffbb1f4510..b0175326ea4a 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -2404,6 +2404,10 @@ longform_dir2_entry_check(
>  
>  		/* check v5 metadata */
>  		if (xfs_has_crc(mp)) {
> +			longform_dir2_entry_check_data(mp, ip, num_illegal,
> +				need_dot,
> +				irec, ino_offset, bp, hashtab,
> +				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
>  			error = check_dir3_header(mp, bp, ino);
>  			if (error) {
>  				fixit++;

This change would mean that longform_dir2_entry_check_data will never run on
V4 filesystems, so that's not correct.

I think we can approach my suggestions in 2 steps. 

1) if longform_dir2_rebuild ends up with a shortform dir due to very few
   entries, I think it needs to add an extra ref at that point, as is done
   elsewhere for short form entries.

2) longform_dir2_entry_check() logic can be improved so that even if the header
   is bad, we still do directory block scanning via longform_dir2_entry_check_data
   so that longform_dir2_rebuild has something to work with.

-Eric

> @@ -2416,9 +2420,6 @@ longform_dir2_entry_check(
>  			}
>  		}
>  
> -		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
> -				irec, ino_offset, bp, hashtab,
> -				&freetab, da_bno, fmt == XFS_DIR2_FMT_BLOCK);
>  		if (fmt == XFS_DIR2_FMT_BLOCK)
>  			break;
>  

