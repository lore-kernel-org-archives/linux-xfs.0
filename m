Received: from fout7-smtp.messagingengine.com (fout7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BBE1AE046
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 19:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724960132; cv=none; b=YHTcHnCZ69x/KN5xy6yftQx90HdZWZ2PGFqQH6HICJdSr2wymyahw+17YfG4CJc2XCE/8Z9ksoaWI31F+veQKTPp265ZQsdlCVdc1cCdNiR8zOKGQo9/HbTk3Q/+KvVLDOD9HbipZusSQDHTqtmxC1dp9pc4Uz/E69cZ9Iwdvyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724960132; c=relaxed/simple;
	bh=pscOede67zBoAwasDUkO2NpwVyMP5KCIqT0JftlgZdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LuZLTIKrVCRZIueq9ZzgbVVgFw0SsL/l9u6YHIIKfyZpFsS4eQXR0qZ4DiG9Zn0WLHje1eBTABPNw02yHf3J3332I8Pv8uIKAE5I0/CrnGAzLELnaqATHeCpcdxwAHW0379lz70yHBPNwEq4jvFNoUcltGqNpvNHg/yE57OE/Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=tH1cy7+w; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BC4MUqa4; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="tH1cy7+w";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BC4MUqa4"
Received: from phl-compute-02.internal (phl-compute-02.nyi.internal [10.202.2.42])
	by mailfout.nyi.internal (Postfix) with ESMTP id A55D41390034;
	Thu, 29 Aug 2024 15:35:28 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 29 Aug 2024 15:35:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1724960128;
	 x=1725046528; bh=5/UclGWuMdPMRjPp7kT99lbKuucG046pGEkV1Ch4mA8=; b=
	tH1cy7+wA0nKppCvNz6gHrlEY8gOQuQxBzzJuAouyi8jfA5GssCUxIy1uriNR6X8
	DnteO3JnziZvIH5t7tov9cHH0zmHicYswxyujpHVJ0rduul2U2j9UY46oksiZJ77
	lIarmQYp6ykrMQ3OFUnI/iA7vADuetrFQPioXmwfVo4DBiWlUhIZT9mx4DS7Io3a
	Fec+C0UJkl+569LG5fZ9aLahrMaLUNjOruC52sKyoiu1TmnX8oGV8lQZBhRuObIS
	DdWeMomHFICqiFgEgD+TlUF1O0NnS7/93ZhHhCSAuuaQXvlk9SGR2cyGWi7fjEZs
	bVuTxRpwSjGikXqMg7Fagw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1724960128; x=
	1725046528; bh=5/UclGWuMdPMRjPp7kT99lbKuucG046pGEkV1Ch4mA8=; b=B
	C4MUqa4BzuOnuhXLA2RgVNnbTPWk1Vh6dd6PlWVTCSyhMeDqW5PPcefUzyiS/rcE
	kcf3b/GRE+nYZDKuhF6jrxsi0r9Vq0qIu84ajRRwz5ejfqfXvEfGKaYt4im7SfJ6
	/ENg4wa1AtNgVvgJx5h1/8WiHYw3QJ5OBLM5W6rLkIiJQbPjGsEVoUPc3kN4/7yH
	5G+oj8fiVPoU9Jm4B5wuqthJ3SKUDg4DwqpbdkctTvd9ZPGALprcyIfk7ZRPnM6Y
	DAXqAMytr1RWRm7CwtDDyyiYP00bjx2wBUkTIwYHMMuMACLbViGStd/zo+nAB6l0
	O45uCkd07u3oKkCR7/iXg==
X-ME-Sender: <xms:gM3QZnQLQOHAznxN9PmwH74j9_VaI3etTvCdFEEcB1GciDCkUi80cw>
    <xme:gM3QZow0deFoQc_Atr80C_pedxIXPP1Qx3RV-1nyJ9Iss59ud3LqWStebphdUBZPh
    vEU4u9Mrvfgom-Gl6U>
X-ME-Received: <xmr:gM3QZs1_jRznZk-M25R8GYXy6BlM4ecFVxD_LsLfhkKbVx8T9GW0ieC7rD6KN6e5WHI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudefgedgudefjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepgfhrihgtucfurghnuggvvghnuceoshgrnhguvggvnhesshgrnhguvg
    gvnhdrnhgvtheqnecuggftrfgrthhtvghrnhepveeikeeuteefueejtdehfeefvdegffei
    vdejjeelfffhgeegjeeutdejueelhfdvnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepshgrnhguvggvnhesshgrnhguvggvnhdrnhgvthdpnhgs
    pghrtghpthhtohepgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghoughonh
    hnvghlsehrvgguhhgrthdrtghomhdprhgtphhtthhopehlihhnuhigqdigfhhssehvghgv
    rhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheptggvmheskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtohepughjfihonhhgsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:gM3QZnAE8STP1TiZILjIHwjlgycBVrDUZwjUdGytO1mI5xkEkRwrRQ>
    <xmx:gM3QZghIH7iLlimf4m6nAcm6gktbz8j-5wmFqVFbG9MUOk1Pms79cg>
    <xmx:gM3QZrp3T1iFuRD8jbVeA1kD_qSvB91IuQDJwUtZfBGzQHwz4WiPFg>
    <xmx:gM3QZrinfB0hEN5ml4G3NGlfnd6tjUa-3EvP0f7dKuc0Vi14EJeckQ>
    <xmx:gM3QZqZK1FeQrLNd-r-IKyF-6yqaseJ5z-7oJ22WRxYxttsP-CTcymPG>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Aug 2024 15:35:28 -0400 (EDT)
Message-ID: <c2ca3889-1a25-434b-a990-c75dd79aed39@sandeen.net>
Date: Thu, 29 Aug 2024 14:35:27 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfsdump: prevent use-after-free in fstab_commit()
To: Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Cc: cem@kernel.org, djwong@kernel.org
References: <20240829175925.59281-1-bodonnel@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20240829175925.59281-1-bodonnel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/29/24 12:59 PM, Bill O'Donnell wrote:
> Fix potential use-after-free of list pointer in fstab_commit().
> Use a copy of the pointer when calling invidx_commit().

I'm not sure how (or even if) the use after free happens -xfsdump is so hard
to read - but ...

> Coverity CID 1498039.
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> ---
>  invutil/fstab.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/invutil/fstab.c b/invutil/fstab.c
> index 88d849e..fe2b1f9 100644
> --- a/invutil/fstab.c
> +++ b/invutil/fstab.c
> @@ -66,6 +66,7 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
>      data_t *d;
>      invt_fstab_t *fstabentry;
>      int fstabentry_idx;
> +    node_t *list_cpy = list;
>  
>      n = current;
>      if(n == NULL || n->data == NULL)
> @@ -77,8 +78,10 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
>  
>      if(d->deleted == BOOL_TRUE && d->imported == BOOL_FALSE) {
>  	for(i = 0; i < d->nbr_children; i++) {
> -	    invidx_commit(win, d->children[i], list);
> +		list_cpy = list;

this copies the memory address stored in "list" into your new pointer var "list_cpy"

> +		invidx_commit(win, d->children[i], list_cpy);

If invidx_commit() frees the 2nd argument, it frees the memory address pointed
to by both list and list_cpy.

Storing the same memory address in 2 pointer variables does not prevent that memory
from being freed.

>  	}
> +	free(list_cpy);

and then this would double-free that same memory address.


>  	mark_all_children_commited(current);
>  
>  	fstabentry_idx = (int)(((long)fstabentry - (long)fstab_file[fidx].mapaddr - sizeof(invt_counter_t)) / sizeof(invt_fstab_t));
> @@ -101,8 +104,10 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
>  	invt_fstab_t *dest;
>  
>  	for(i = 0; i < d->nbr_children; i++) {
> -	    invidx_commit(win, d->children[i], list);
> +		list_cpy = list;	
> +		invidx_commit(win, d->children[i], list_cpy);
>  	}
> +	free(list_cpy);
>  	mark_all_children_commited(current);
>  
>  	if(find_matching_fstab(0, fstabentry) >= 0) {

