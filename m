Received: from fout4-smtp.messagingengine.com (fout4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B148F1B5ED6
	for <linux-xfs@vger.kernel.org>; Fri, 30 Aug 2024 15:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725033368; cv=none; b=cBMsO7TAz+4ULX2onFA4Nh8clDjd/4jcKbWzPb6mT6IApmhHB8bxuAV8ySyUzc5gFYdUh/PVKFWoVM9BU5jbw7Pf/XqDXKUe2IpEXfHMMUJPnuPRrixJplB6ZJxbglqC3OtASjPtd7Y4AzvwOAsRaN7FGyzHVmclv3pJ1VWKqhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725033368; c=relaxed/simple;
	bh=XOmqwpfYUuDR/5gy0/QYzrI0Wqw1nddrHa28vONQCVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RNQQe5lISFv8MHZ4bv84IQ69zFa7E30vLIJV2gLbfr+yEEjVNyRFV5xsPCaQM53X9ZqpD4gPpABEHdAljh40kSO5gygovaEroiMUHYdOKR4aJy7pRmas40gA04g6U4HGOqAMZBCrW5d/J8yVm1G4fWXoande1zKYEXdKPqLIiX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=RUZGovPl; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ajs7nbw8; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="RUZGovPl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ajs7nbw8"
Received: from phl-compute-08.internal (phl-compute-08.nyi.internal [10.202.2.48])
	by mailfout.nyi.internal (Postfix) with ESMTP id A49AC1380266;
	Fri, 30 Aug 2024 11:56:04 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Fri, 30 Aug 2024 11:56:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1725033364;
	 x=1725119764; bh=wBYAM/UqQZlUUKI+DTMgpAX9EMWUeUnutTatoQ1Nbu8=; b=
	RUZGovPlUF41Gk5UTjfT5yiuIdv9GUQ+Q6kTE9d/xKxUfu2/YRbwHWEnYWXKQMXW
	Buy+ooG/jHVqfJEDXtlDA2FEJGZj0eX61ICP65BbHYV01iYJE6MkzUzwWUqdTIAM
	H796On3WZQ9BxS3r+tC06MUSxS9lK75rfUzefTKI990oMagG7AcllizO7pQygViZ
	TRZlacBnegLKq4CRA6QgSmZiQE0V4NI5hoWlbK/kYxEjSopnVyXd6kppmWAhqM/i
	ik1WsqYZv5qsaeNqeV/S2cRhqYLxCvgTK11+71BpG3SIgr/8nEJpKAD3fXVMXzrR
	aBe88Ls0WpxQcZzWDGDPcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725033364; x=
	1725119764; bh=wBYAM/UqQZlUUKI+DTMgpAX9EMWUeUnutTatoQ1Nbu8=; b=a
	js7nbw8yYVWY21CPRFP9YgEfCKXRhnTwYfR/dQbax1ODI/gBg38mOkv0mdb6wdnH
	QQif523tgvWYGPpgjp6TzGAQ3hElzsAEufxC+twR7tivBvAER1nesLmU/ONW3di6
	S59rpSYfYmyMFB/vHQ6RXjC/ISqQTAA9dbFSn/nEKPHSl9RsppCmpXldbpm7QebT
	xBPwfL2YC4Vd2IJtLwP13rKUUtiN+/dLXGgZgoI1dtwbyuq7VH7U4CxwNGuHoGhN
	S+MQItU7BC2q3vkP7aO5FUbQhyhnK9B446a7xpJwaYH046lvNTRAjGhjCUhC3Is7
	BBKzgOEdL/nARZiU7AeXQ==
X-ME-Sender: <xms:lOvRZi5nVODz8uw9EwTJUU4AqH8A-3bdqY_zQx7OeXIt2yBL63T1vw>
    <xme:lOvRZr5eAaMbONH0DeZ9T_BhrhaYk0ElPqKEc3dwdVnB77Ys8oS1_MyidZfi5PFQL
    YdCK8E9ILIpCj5VIxQ>
X-ME-Received: <xmr:lOvRZhdjPLUGPM54Il2gnUwo6vq3NrJiAF2zzTnJpKf1fmNaeL9XC-yxEVVaRRILlHo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudefiedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdej
    necuhfhrohhmpefgrhhitgcuufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghnuggvvg
    hnrdhnvghtqeenucggtffrrghtthgvrhhnpefgueevteekledtfeegleehudetleettdev
    heduheeifeeuvdekveduudejudetgfenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhnsggp
    rhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmrghrkhdrth
    hinhhguhgvlhihsehorhgrtghlvgdrtghomhdprhgtphhtthhopegsohguohhnnhgvlhes
    rhgvughhrghtrdgtohhmpdhrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopegtvghmsehkvghrnhgvlhdrohhrghdprhgtphht
    thhopegujhifohhngheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:lOvRZvJG1PusCB9fNar2EJb-YdvFPcAqfz6hLPyxbw2rXm7gqtQ10w>
    <xmx:lOvRZmJle3Bf7kgJ3kjEjvGcfnn45vGLtRUziAomCXEtHxBlv4VWKQ>
    <xmx:lOvRZgzT3rTDT0ryeIe7ubqB_v-kyypKRdw94IXdvDHAq_5WJ2ybNQ>
    <xmx:lOvRZqI1Kp4nuZ7GONYu1EK4z4b4utIP7eJWnHPiDJ3EEm8JRQVD2Q>
    <xmx:lOvRZu_zgUrN2yJr4gSiZHwfFOkWSkc15knScq9HA1gVkVPI4xMA6xH->
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 30 Aug 2024 11:56:04 -0400 (EDT)
Message-ID: <6af92cf7-eac5-4a07-b05c-e9f398365970@sandeen.net>
Date: Fri, 30 Aug 2024 10:56:03 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : Re: [PATCH] xfsdump: prevent use-after-free in
 fstab_commit()
To: Mark Tinguely <mark.tinguely@oracle.com>,
 Bill O'Donnell <bodonnel@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "cem@kernel.org" <cem@kernel.org>, "djwong@kernel.org" <djwong@kernel.org>
References: <20240829175925.59281-1-bodonnel@redhat.com>
 <c2ca3889-1a25-434b-a990-c75dd79aed39@sandeen.net>
 <ZtDQTKc336_Y_FcD@redhat.com> <ZtDbOSVV8k__YxMx@redhat.com>
 <5e5e4f37-2cac-416c-844e-1b2bbb426f91@sandeen.net>
 <ZtD6xQmXRd9BF0HE@redhat.com>
 <SA1PR10MB758637A0D3EE774C9DF5B94489972@SA1PR10MB7586.namprd10.prod.outlook.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <SA1PR10MB758637A0D3EE774C9DF5B94489972@SA1PR10MB7586.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 8/30/24 9:56 AM, Mark Tinguely wrote:
> I spent some time in xfsdump/xfsrestore but am not an inventory expert…I don’t see a use after free problem but I am scratching my head with the node->data->children memory.
> 
> The callers all do a free_all_children() which marks the node->data->children pointer to be NULL and then calls node_free() which does a free to node->data->children.
> 
> IMO, the inventory management code is not worth a ton of time.
> 

Thanks Mark. Agree on that, but certain security orgs think that every
"finding" of a certain severity needs triage, so we're a little bit
between a rock and a hard place here. :)

-Eric

> 
> Mark
> 
>  
> 
> *From: *Bill O'Donnell <bodonnel@redhat.com>
> *Date: *Thursday, August 29, 2024 at 5:49 PM
> *To: *Eric Sandeen <sandeen@sandeen.net>
> *Cc: *linux-xfs@vger.kernel.org <linux-xfs@vger.kernel.org>, cem@kernel.org <cem@kernel.org>, djwong@kernel.org <djwong@kernel.org>
> *Subject: *[External] : Re: [PATCH] xfsdump: prevent use-after-free in fstab_commit()
> 
> On Thu, Aug 29, 2024 at 04:56:01PM -0500, Eric Sandeen wrote:
>> On 8/29/24 3:34 PM, Bill O'Donnell wrote:
>> > On Thu, Aug 29, 2024 at 02:47:24PM -0500, Bill O'Donnell wrote:
>> 
>> ...
>> 
>> >>>> +        free(list_cpy);
>> >>>
>> >>> and then this would double-free that same memory address.
>> >>
>> >> I see that now. This code is indeed difficult to grok.
>> >>
>> >> Perhaps (if this a legitimate finding of use after free), instead of having the memory
>> >> freed in invidx_commit(), it should instead be freed once in fstab_commit() after the iterations
>> >> of the for-loops in that function. I'll have a look at that possibility.
>> > 
>> > i.e., Removing what Coverity tags as the culprit (node_free(list_del(dst_n)) from
>> > invidx_commit(), and adding free(list) following the for-loop iteration in fstab_commit() may be
>> > a better solution.
>> 
>> I don't think that's the right approach.
>> 
>> invidx_commit() has this while loop, which is where coverity thinks the passed-in "list"
>> might get freed, before the caller uses it again:
>> 
>>                 /* Clean up the mess we just created */
>>                 /* find node for dst_fileidx */
>>                 dst_n = find_invidx_node(list, dst_fileidx);
>>                 tmp_parent = ((data_t *)(dst_n->data))->parent;
>>                 while(dst_n != NULL) {
>>                     node_t *tmp_n1;
>> 
>>                     dst_d = dst_n->data;
>> 
>>                     /* close affected invidx file and stobj files */
>>                     for(i = 0; i < dst_d->nbr_children; i++) {
>>                         close_stobj_file(((data_t *)(dst_d->children[i]->data))->file_idx, BOOL_FALSE);
>>                     }
>> 
>>                     /* free_all_children on that node */
>>                     free_all_children(dst_n);
>>                     tmp_n1 = find_invidx_node(dst_n->next, dst_fileidx);
>>                     node_free(list_del(dst_n));
>>                     dst_n = tmp_n1;
>>                 }
>> 
>> "list" is presumably the head of a list of items, and this is cleaning up / freeing items
>> within that list. Coverity seems to think that the while loop can end up getting back to
>> the head and freeing it, which the caller then uses again in a loop.
>> 
>> My guess is that coverity is wrong, but I don't think you're going to be able to prove that
>> (or fix this) without at least getting a sense of what this code is actually doing, and
>> how this list is shaped and managed...
> 
> That's my take on it as well. I'm leaning towards a false positive. I'll have another look.
> Thanks for reviewing.
> -Bill
> 

