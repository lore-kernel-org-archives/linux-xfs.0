Received: from fout8-smtp.messagingengine.com (fout8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62DD15C138
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 21:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724968567; cv=none; b=r9XRhzyluzr7U+nV6S9aTphI+GorJ16YFJ2OrYh7VD21V8//gXkScUdlPp3djI1cjcqcujljNRGwbJkDh6VlOA9VR1HpRXc5g4DZRgu3dvrbCopgviTmSa5UVSUC/7ffwdV7eZuiBJ1WOKVW/eTPfswbUzows2JMGcVI09wXQkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724968567; c=relaxed/simple;
	bh=+VBZx+wcnf0RQ+bXmOs55zhTxVwdUmFEv4ffl4hqmTc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bGCn678gGlDEfYaf86A7dwCOveajBjLRpnsPhdjomx+Hu3ksKapkGzbtDFx389bjSPJTrNheBs4rCj7DCX5/hYyr94TU8vuNoGQF9FAO6TLNJnln753x5zM3mK3lDF+09cVeW6qdhcFyxRblwEajf9o7t2hw7Kf8tK9sDe/TonY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=PMribWcV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=FMKTmyRA; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="PMribWcV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="FMKTmyRA"
Received: from phl-compute-04.internal (phl-compute-04.nyi.internal [10.202.2.44])
	by mailfout.nyi.internal (Postfix) with ESMTP id B712C138FF43;
	Thu, 29 Aug 2024 17:56:02 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 29 Aug 2024 17:56:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1724968562;
	 x=1725054962; bh=biVC1PkEPuhL7ghzvsDAwWreppyJ4/IAoXj4uCykOtE=; b=
	PMribWcVL+bz6OGfgsmBQG5Vo8DaXhuuoZxie926GPtmB05x6HBHFspkYZVGeJZr
	Tscs3CsG3+G0wmZ6phAHLC0u8QefqNw5FK+Ynx9xwNX2Et9KFoB4LiFg6malkMwo
	2DrDdsmlIwIiKdItXMhoMpg4OCeAfx+1a35Ayh2PC9PBMZbL0B3x723ficEbtdAM
	8okdVOChKTy8QylBpbWZpRzKqYYGT/T9mMES6a+4fhI92VSU6fcA8JXf+0D2VF6a
	QrbtOWV3OBTNOCbStStjCt4raj9rxwi9+i1qNpGlpHTEkFFUKPrTvxaFJ1eAMWPo
	nnKT8d5cj2MBq/HUZWrKRw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1724968562; x=
	1725054962; bh=biVC1PkEPuhL7ghzvsDAwWreppyJ4/IAoXj4uCykOtE=; b=F
	MKTmyRAVWuSf5nTS03ZiPsYR+cPhGbfP7/4cJh1Bwbyf1jjj5cRzihYjsj/Xcdwm
	fR7quexRF1cWrieHdKX8ZEOtpmhS58q+9V/eDN31n2NsbnYhL1q8sLskSqAfY1T4
	1NUi2kW3Z2mY0P+8nMEPnXr3s2pmcUS/L2uEP3p801nw6AFFymKdO1ivJcli93q3
	/Ab/QQCv6d32h6jfifgcmfTcMZB2hHNNv7186frgRiFe9y57Z6bjnKxyx5u2lPUy
	MwU4YJW/SkA+UH6tWzqjSOJi9yyoR9iQMTMwCbYXrUSEDV63Fdf34na/vWN9Fm6l
	kCyzkjSNdUAmzuIc4NRHg==
X-ME-Sender: <xms:cu7QZn6FLyQe3MJxHx2v6HqlBnuJWCNaROeUm47wnq6rfcPEF_m1cA>
    <xme:cu7QZs4mSbbLke7ROtddBAjPXYzeCIfxlElxuNjRgnQOsGyaYsBx3nfJqAJ1MSmkN
    tvnoAbcBc2JlOKf6Rc>
X-ME-Received: <xmr:cu7QZufxSretPYaB356zJlRXqguA32MBbRppTgwL9kauE20v_Cx5HT2cCVpd3D977lE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudefhedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdej
    necuhfhrohhmpefgrhhitgcuufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghnuggvvg
    hnrdhnvghtqeenucggtffrrghtthgvrhhnpeevieekueetfeeujedtheeffedvgeffiedv
    jeejleffhfeggeejuedtjeeulefhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhnsggp
    rhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsohguohhnnh
    gvlhesrhgvughhrghtrdgtohhmpdhrtghpthhtoheplhhinhhugidqgihfshesvhhgvghr
    rdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegtvghmsehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopegujhifohhngheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:cu7QZoL1Ffh0hrBk8KTVQcd3GnMztCx9oZ3KoWm6CVBudVSE3eC4wA>
    <xmx:cu7QZrIYCKhK5Csp-C9GU5NcE4hR9CgTYITrtwuYrOZQkEnLA_ytkg>
    <xmx:cu7QZhwMoXJVogUdhqjfCVXIJKtlErT9lZpYUyiRDXJ6jtdi46WbNw>
    <xmx:cu7QZnLh4GNtajACg4t2z06xlACYoIOoie9jf3NXe6IkFqgKWUiXoQ>
    <xmx:cu7QZhgPtXFDU5Uj-hoP7rEERy1eSEY2MZxmIsR1owSVKRbb2udahw47>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Aug 2024 17:56:02 -0400 (EDT)
Message-ID: <5e5e4f37-2cac-416c-844e-1b2bbb426f91@sandeen.net>
Date: Thu, 29 Aug 2024 16:56:01 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfsdump: prevent use-after-free in fstab_commit()
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org
References: <20240829175925.59281-1-bodonnel@redhat.com>
 <c2ca3889-1a25-434b-a990-c75dd79aed39@sandeen.net>
 <ZtDQTKc336_Y_FcD@redhat.com> <ZtDbOSVV8k__YxMx@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <ZtDbOSVV8k__YxMx@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/29/24 3:34 PM, Bill O'Donnell wrote:
> On Thu, Aug 29, 2024 at 02:47:24PM -0500, Bill O'Donnell wrote:

...

>>>> +	free(list_cpy);
>>>
>>> and then this would double-free that same memory address.
>>
>> I see that now. This code is indeed difficult to grok.
>>
>> Perhaps (if this a legitimate finding of use after free), instead of having the memory
>> freed in invidx_commit(), it should instead be freed once in fstab_commit() after the iterations
>> of the for-loops in that function. I'll have a look at that possibility.
> 
> i.e., Removing what Coverity tags as the culprit (node_free(list_del(dst_n)) from
> invidx_commit(), and adding free(list) following the for-loop iteration in fstab_commit() may be
> a better solution.

I don't think that's the right approach.

invidx_commit() has this while loop, which is where coverity thinks the passed-in "list"
might get freed, before the caller uses it again:

                /* Clean up the mess we just created */
                /* find node for dst_fileidx */
                dst_n = find_invidx_node(list, dst_fileidx);
                tmp_parent = ((data_t *)(dst_n->data))->parent;
                while(dst_n != NULL) {
                    node_t *tmp_n1;

                    dst_d = dst_n->data;

                    /* close affected invidx file and stobj files */
                    for(i = 0; i < dst_d->nbr_children; i++) {
                        close_stobj_file(((data_t *)(dst_d->children[i]->data))->file_idx, BOOL_FALSE);
                    }

                    /* free_all_children on that node */
                    free_all_children(dst_n);
                    tmp_n1 = find_invidx_node(dst_n->next, dst_fileidx);
                    node_free(list_del(dst_n));
                    dst_n = tmp_n1;
                }

"list" is presumably the head of a list of items, and this is cleaning up / freeing items
within that list. Coverity seems to think that the while loop can end up getting back to
the head and freeing it, which the caller then uses again in a loop.

My guess is that coverity is wrong, but I don't think you're going to be able to prove that
(or fix this) without at least getting a sense of what this code is actually doing, and
how this list is shaped and managed...

-Eric
