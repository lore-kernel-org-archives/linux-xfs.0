Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367652DFA58
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 18:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744741255; cv=none; b=A95/s+ntav6ocoVafjdpZj0xbuVUE1GTwdfXeB6fQdVf2BBePT01L4cJi8bMXvTUGyNorQzqxVvxFUpjhPMf1DKDhau6/kN7LHHj376d0IFwrzfy514TbZdtHKDHAmCIp5XSbkG1oAuYbnX+MN+C0pxHZF2HsLAkHMthtJUQRFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744741255; c=relaxed/simple;
	bh=4QU3H7QqUpe3ZaGkENF81EuiDHbuFedREo1p502Hm8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lBGdjEIi2syJaat1U8a648lZPz+Zr0J7fzi8IZlB+koUMd2FAzFj6ASNM88/CUClYaFazE7BK9JKgA3eeO+2Ent/IA8rqlJq/a3ANJTdqJiMOQaZYOBMjAcerwgytzfPwUIJvZtu8uT9F+r0VLyshE+6VW0v4QxvUuctZfuYWIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=K0K6Vny+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MrvDem6O; arc=none smtp.client-ip=103.168.172.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="K0K6Vny+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MrvDem6O"
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id 2725920034B;
	Tue, 15 Apr 2025 14:20:52 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 15 Apr 2025 14:20:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1744741252;
	 x=1744748452; bh=MVcPVsAa7Bm9FPwgTQ/Z1IcaZPPpYfXD1NzEUV4mxX0=; b=
	K0K6Vny+vX7ws1HGJ0HJhfWYYgC+Rm6J4t+4hhHpKV0BSDW5o6z0ZELsJzhA27Qh
	h6D8uQt1UwsfOAKmKTXNlea+6nDUeIbFqEpNclBmT3Sox399HIULMJnQEkyms8v4
	oFA6YakvH2unUm3vDVPUiQz45aXV/6YJH4li2fJEuZbrOZeope7PICouM2Sf1ebO
	hdOmL00PzCkDZ9TzY3odb9dj4IDvN8L5q07ybXWPBey2wzylGCnJEwTbbjMrHs6U
	MOVjKOYL/M8qsuV7EVHMELyeybJAGh5rNKOsTu2thqUK2/bynUdb8KvfuZW+3tX9
	9x4G1c2Do5W5U5G5ftV7PA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1744741252; x=
	1744748452; bh=MVcPVsAa7Bm9FPwgTQ/Z1IcaZPPpYfXD1NzEUV4mxX0=; b=M
	rvDem6O1+7pFrLLAR49KP55DZAtzO6wrMpgxGETi1SrLTL11R/4U1IbS5zTUds7i
	UKjoEPRiGHqbW8XSf3TGcfNerNBj8J1LcgBqYR8zIidK267NwhE7fr4Eis3cGTm9
	yRqXYuWPtCTIpet6aqdJFuLY7xlLTl3dQndqs5hRtzzrLUnk3LyXoR3J9Q76RfMJ
	Fm/pMWVxCl3Xj5e4TWN3zweqCBpTHUSrYlMuk7InzR4oNQDyTM9XC51oD14zFMhU
	4uxsKRm4X5+9+5pi4CcOqZtAgBaaNsniKHaNk50mo5vkYlhHgnPfmLyg8m/ltOz7
	t9s+pAI7vf9d89kuOjoeQ==
X-ME-Sender: <xms:g6P-ZxTJrxO5pfXcpXGiW-P07OsiONnhCrcrpWCAkpsy025A9J6eZA>
    <xme:g6P-Z6yx5k7jiaJLzM_RThRwK1fdS-rzt6_UZT18VZcKiFU8qAjDzwC5YuT9XUlnf
    R8EbzQzG66MmYnqbQ4>
X-ME-Received: <xmr:g6P-Z22GysV3gYmy5X_gpeUgkmcrNYpJE2oEe8meFoi_oziuLY5IGTHekE88gA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvvdegvddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefkff
    ggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepgfhrihgtucfurghnuggv
    vghnuceoshgrnhguvggvnhesshgrnhguvggvnhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveeikeeuteefueejtdehfeefvdegffeivdejjeelfffhgeegjeeutdejueelhfdvnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrnhguvg
    gvnhesshgrnhguvggvnhdrnhgvthdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopegrrghlsggvrhhshheskhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepsghoughonhhnvghlsehrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:hKP-Z5CWYONLHZo6z6EUpsMxhWM8VH3sUrbc7YhjWL9QPa_cdvWR4w>
    <xmx:hKP-Z6g_aYBPwD8Zr4IgDQxFByvX6TUnarlxlEYAXYD-GqqyN08dDQ>
    <xmx:hKP-Z9qmxxsWzL6OzXcM-I6YgSpPsYuTkBDbuxVrryy63dIhcZWZhw>
    <xmx:hKP-Z1h4f4MMP2ZVfEFPWTDFecJXNAoes_KV4UHvsBpwT3R8XU54Cg>
    <xmx:hKP-Z5oqgdMFFjbj-z7blUphrqp8Vh3tHR5usNUn-Oq-_AZf3q97Beah>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Apr 2025 14:20:51 -0400 (EDT)
Message-ID: <6297dd57-3fc3-4ef7-9cba-ff60c565a13a@sandeen.net>
Date: Tue, 15 Apr 2025 13:20:50 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs_repair: Bump link count if longform_dir2_rebuild
 yields shortform dir
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, bodonnel@redhat.com
References: <20250415180923.264941-1-sandeen@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20250415180923.264941-1-sandeen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/15/25 1:09 PM, user.mail wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> If longform_dir2_rebuild() has so few entries in *hashtab that it results
> in a short form directory, bump the link count manually as shortform
> directories have no explicit "." entry.
> 
> Without this, repair will end with i.e.:
> 
> resetting inode 131 nlinks from 2 to 1
> 
> in this case, because it thinks this directory inode only has 1 link
> discovered, and then a 2nd repair will fix it:
> 
> resetting inode 131 nlinks from 1 to 2
> 
> because shortform_dir2_entry_check() explicitly adds the extra ref when
> the (newly-created)shortform directory is checked:
> 
>         /*
>          * no '.' entry in shortform dirs, just bump up ref count by 1
>          * '..' was already (or will be) accounted for and checked when
>          * the directory is reached or will be taken care of when the
>          * directory is moved to orphanage.
>          */
>         add_inode_ref(current_irec, current_ino_offset);
> 
> Avoid this by adding the extra ref if we convert from longform to
> shortform.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: user.mail <sandeen@redhat.com>

Ugh, sorry about the user.mail business, not sure how that happened.

New VM, who dis? :(

FWIW this fix is related to the fix Bill has been working on, but it
is independent. Bill's hoping to address the problem where we fail
to build up any directory entries for a long-form rebuild, and when
that is fixed, in most cases the entries will be there and the dir
will remain long form.

Still, it is possible that the entry scan turns up so few entries that
the directory becomes short form when rebuilt, so I think this patch
still makes sense.

Thanks,
-Eric

> ---
>  repair/phase6.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index dbc090a5..8804278a 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1392,6 +1392,13 @@ _("name create failed in ino %" PRIu64 " (%d)\n"), ino, error);
>  _("name create failed (%d) during rebuild\n"), error);
>  	}
>  
> +	/*
> +	 * If we added too few entries to retain longform, add the extra
> +	 * ref for . as this is now a shortform directory.
> +	 */
> +	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL)
> +		add_inode_ref(irec, ino_offset);
> +
>  	return;
>  
>  out_bmap_cancel:

