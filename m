Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26911219A8C
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 20:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738701477; cv=none; b=XntfSSeG0ZI1wj6GLzetmquyODLHBHL9/8hcL8VTSOE3AmHSJq1phxwChAsyWlOnSOKrVKzfYu43ef4FzR/eoMF3fM6uQhq6S31bT91ZWto3Yi0INoQ3POWl0ezbeA5YfJcu89w7FIjh4PbT+wENQHvXcgzRsas4OSi67G6kOZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738701477; c=relaxed/simple;
	bh=vUf7SPV1Drj99ls9XLKXAG/9BGpy4g+42UUJQOPMcWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ezhlEVhxtxvFqpzqRqyNcYCZauwX8sTc9OIJTL71doE2N1YTL5KVfV1J4Jlk4A62C3Edrxor93NeX9GQ2Eiql2JpYhm5rHoGfLLLKstyphxMhUvvdTgofd8hVpzgwe+Bx8PkL69Hk2NzIrjHQsAxE5MkqM/XS5hBE5FCAtqyFPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=VT0505rO; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=h+eNXjPc; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="VT0505rO";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="h+eNXjPc"
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id 0C6C11140187;
	Tue,  4 Feb 2025 15:37:54 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Tue, 04 Feb 2025 15:37:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1738701473;
	 x=1738787873; bh=n1mc0NwLhmo2SdYqpzz7Z4OZxm4Xvcjwxvr74iwnAJ0=; b=
	VT0505rOMDsHKnbWxawnq4SRI5esbipIrfs0xIQnbSevDTvj7/qbKx7cMf/EEgC0
	Ixg6nTyVKiTMYE1yN/jsVdn8rAoX0OiN8QREIW+/zoLOoeKN9kLaQBzbiyZPjQAW
	4Ntnj2rrzvzGJyypzafjbyP6rTzfI+n9lOgVAygn3nRh6j2M5+ZQ7qweqL0ifAEz
	/Vg+dz7G71FoYy9yYhlNEy8Snm1lPVc7ELfdCmR3+WsM4jQUwasSq91eXvD8zERc
	jOPFRGe9aUdFxXTuu5AjN/3Yf9q08E0wwstgOdQUPZiRpkvcan0lhp196vgz5cNo
	cC8qq+4Qi8Hd+eDoFABiLA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1738701473; x=
	1738787873; bh=n1mc0NwLhmo2SdYqpzz7Z4OZxm4Xvcjwxvr74iwnAJ0=; b=h
	+eNXjPcgF5UEouNZ/IK4VBJzXuUIjEhxw6fv5vRw8NeA+JzSb7sXoFPvtpEUtFv9
	1IrHDIBr5gRW7D7M8+PA1PcvgA5Ke6D3Bzjvl8aypzBEnHVRJJkUZV9qKubck9Mz
	wKx1AtAJmLCEuJ8x2Xh9RbI1WA1H7c8ki1AyPTHuNps7oljkmVwk/UB181DLnwT3
	PKPTj4JaBRZsvqr9o5yp8N3OYDWjPZwz3KjRAHcjpn5UAdJjWbofGS9tq6jeVN7T
	rTz4vZY1dmDo8B9RFYclFQN8+2bAOJrKiWqVPiE/UZWKEPaiWAgSJmgozQpSD1Qr
	HZrjcYnuBlzr1zyFCCK0w==
X-ME-Sender: <xms:oXqiZ-HDjOHipujjQJFGYPLcIfaLFFuT8HRDlFxD2g-I7WpmWCvudQ>
    <xme:oXqiZ_WoTXpr8YkgmOHBbXxkGgopWWvts7AbT0M94lqfBZ0wja-CQaSqQS-uADGxJ
    hUKZRDKek_Kfl87Eg4>
X-ME-Received: <xmr:oXqiZ4JmGQiLrnOE1p-i9y0-Yu4WDmN85RbC-tZMcUlBs7Xn1Xoo_JW-guQcQCj4FE6Ya3Voyu1meIIxp0BoGyn9kfmz>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvudehudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepgfhrihgtucfurghnuggvvghnuceoshgrnhguvggvnhesshgrnhguvg
    gvnhdrnhgvtheqnecuggftrfgrthhtvghrnhepveeikeeuteefueejtdehfeefvdegffei
    vdejjeelfffhgeegjeeutdejueelhfdvnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepshgrnhguvggvnhesshgrnhguvggvnhdrnhgvthdpnhgs
    pghrtghpthhtohepgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhukhgrsh
    eshhgvrhgsohhlthdrtghomhdprhgtphhtthhopegtvghmsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopegujhifohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinh
    hugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:oXqiZ4HdpMXhl2hi7Knl211s1CuMOFcx4p0KH0RHKo-rCOjYhV-r-w>
    <xmx:oXqiZ0X6Y5OlBISrOFYBcPpomg5ilSniT_nkaM5r7-l3JvqVb6jU5w>
    <xmx:oXqiZ7Mp7qKMiyEh6ZdG9YcRy1vtJZPeRTxaR1rDvz158-fO2SdTZw>
    <xmx:oXqiZ70kgHZ6bUUbX1oTVn_Dj1x4HqXTm-6YYe7HV6PtMHjppiMkKg>
    <xmx:oXqiZyyumOQUCAUOK5W_yi97AITxbJ4xX9YoXnlE-6Y2G-L-q_PKxczU>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 4 Feb 2025 15:37:53 -0500 (EST)
Message-ID: <84adc332-7f5f-4c6b-bb87-b15f633374c2@sandeen.net>
Date: Tue, 4 Feb 2025 14:37:52 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] xfs: do not check NEEDSREPAIR if ro,norecovery mount.
To: Lukas Herbolt <lukas@herbolt.com>, cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
References: <20250203085513.79335-1-lukas@herbolt.com>
 <20250203085513.79335-2-lukas@herbolt.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20250203085513.79335-2-lukas@herbolt.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/3/25 2:55 AM, Lukas Herbolt wrote:
> If there is corrutpion on the filesystem andxfs_repair
> fails to repair it. The last resort of getting the data
> is to use norecovery,ro mount. But if the NEEDSREPAIR is
> set the filesystem cannot be mounted. The flag must be
> cleared out manually using xfs_db, to get access to what
> left over of the corrupted fs.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  fs/xfs/xfs_super.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 394fdf3bb535..c2566dcc4f88 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1635,8 +1635,12 @@ xfs_fs_fill_super(
>  #endif
>  	}
>  
> -	/* Filesystem claims it needs repair, so refuse the mount. */
> -	if (xfs_has_needsrepair(mp)) {
> +	/*
> +	 * Filesystem claims it needs repair, so refuse the mount unless
> +	 * norecovery is also specified, in which case the filesystem can
> +	 * be mounted with no risk of further damage.
> +	 */
> +	if (xfs_has_needsrepair(mp) && !xfs_has_norecovery(mp)) {
>  		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
>  		error = -EFSCORRUPTED;
>  		goto out_free_sb;

thanks Lukas, this looks good to me as well. And with ro,norecovery
there should (tm) be no writes whatever to the filesystem so risk of
introducing further corruption from the mount should be zero.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
