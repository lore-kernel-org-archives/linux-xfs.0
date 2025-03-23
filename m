Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05122E339C
	for <linux-xfs@vger.kernel.org>; Sun, 23 Mar 2025 16:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742746222; cv=none; b=GHJBoRLhYxWuBYRN5wcntfVWCWmdq01rXm3FqLrDARxcOzTExwSBiNXj3yIj3E6bigGWj1uinwCTHFMI5HTrJvkIvXNnCacaMPrjnwcaPELGshmRwQWseIQd3oI1DAsXZTsDuHfQE3nZBwDVJHtrlwZ5vNKqkRv8fMoNq/3vKlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742746222; c=relaxed/simple;
	bh=5jkrBGx36rQ+VyyA90ltKE3yBrRIdqchEsxmlWAzI04=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=sCDUIPaRHV7DQlQ1t/nv6AzTNsVV+C4gcNFE2AP5ZSGZXi+eRgXqbsGa0fsuAaGfAteIx42iiOETN3a3P6/qv4YCZAW++oHZJk8SnsNNbBlJrWYJr9iD8h9nXAhmmC9HYWBzBCkxRSOuFUOXJ37XD62sHUHrTlP/iNSX1ynjmr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=sA30Jc5Z; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Rx12ifEu; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="sA30Jc5Z";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Rx12ifEu"
Received: from phl-compute-12.internal (phl-compute-12.phl.internal [10.202.2.52])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B4997114016D;
	Sun, 23 Mar 2025 12:10:19 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Sun, 23 Mar 2025 12:10:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1742746219;
	 x=1742832619; bh=NDluIU94iIH7XdJjo2DUh3GzzCG1PUOlc6EimXEt5xw=; b=
	sA30Jc5ZwAVtL6hIYN80OLa/1v1PFasmWGRN/AWVkMS6kBNSuHZBRNQaxZ6OoX0j
	cH9zPjIA67QzaKJTne3Ie8UfDBwH6k7Lk93UOy/6TbZrwrtxTa32MqLwY/O+r40Y
	86Dji4Z1ae8VtV9MEzvkYQbqEIwb2A4rS9sFZpuvt10C+JINEzKXti4hCnAnwmOI
	Lhux0VHKPZPLKWA37lurFavOPDlBNcF56BjsjWvwSAYiFMj0hXhbQhNNdaIQNE4i
	SuaVO1myNqV5wO7vjI1S+YgHKC2oLLIXrA0+zlAzbOj9V/aBBOm7y1B8VTagpkC6
	sAIkrhsNo9+9/GyqsVTr3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1742746219; x=
	1742832619; bh=NDluIU94iIH7XdJjo2DUh3GzzCG1PUOlc6EimXEt5xw=; b=R
	x12ifEu9tB5hMYarR0lasIfyhMeVgpD7nYRzXnHPGcwd0AvsIB5XZL2zQAXBffBb
	31AukQWAvmhy1yF5wJ9QRZBD4Ir6MO80dciRx5ikfnGUM9QY/8lrAoBvhfAfDH7X
	PZ0L2aLidfuZBZXVtX1ff9qP2qopFmV3QMDQMw6WGa5qLx5cB/frdcnY/+zsvLb4
	vU0VjfksmWzXGrbMUlBa8oElPMekNukm8FjFzkjtkbaqzfFK7YJmtnLd6N753v69
	sxxGjUL+14f9d2//KRJrAIB8JvBsdElG3BwdlsJGi8OdhWS2uMNFuZPc4xZKNFim
	0nh0xBHuOv6kuf2OuWsAg==
X-ME-Sender: <xms:azLgZzaTGjvzFiErWWPGO7Cd8P1gLBxxF3xCL8cTnGdgTe4lfXPo4Q>
    <xme:azLgZyZOUdziYo4acQG7D08a8zGXNUZwOSBS8SYy0wQSj4VMK2Ab1wVm6zNZcg6xC
    n9hPO0wSPnl8dcMGQs>
X-ME-Received: <xmr:azLgZ1_CPNEQQtH6Rp56VSq5wVAzwgs-uEzTR6JXQlNQWrFp5Xw04ruaZL_fLEM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdduheejfeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefkff
    ggfgfuhffvvehfjggtgfesthejredttddvjeenucfhrhhomhepgfhrihgtucfurghnuggv
    vghnuceoshgrnhguvggvnhesshgrnhguvggvnhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epleevuefhueejheevhfffhfeigeeifefgieejheekteetkeejteejtdehkedutdelnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrnhguvg
    gvnhesshgrnhguvggvnhdrnhgvthdpnhgspghrtghpthhtohepgedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtohepsghoughonhhnvghlsehrvgguhhgrthdrtghomhdprhgtph
    htthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepughjfihonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehhtghhsehinhhfrh
    gruggvrggurdhorhhg
X-ME-Proxy: <xmx:azLgZ5qI94MXeVuOYt685LdT01fzvUFsKtr96Hf6vrGGQ7MhB4wrtQ>
    <xmx:azLgZ-pJW0sh8FI3bNFJoVEYO3eClSkAcA2rfQXH2FZvbpoHuONOkQ>
    <xmx:azLgZ_RQ5apB2ovcKjVzLwx50I7-pIvm-YuBI7DSgLBnJs4r3rn0VA>
    <xmx:azLgZ2pB7HVCiXNrKmj58r9tK38ULLVEX-JevLVYEjjwgo8xDG4lNw>
    <xmx:azLgZ3nTWI8fKjaS5P1kNUFmc45o7xSi9FiFxmgbHPyvP_LsceqvvsMV>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 23 Mar 2025 12:10:18 -0400 (EDT)
Message-ID: <b435c47f-ea38-471b-b273-71144d052ca7@sandeen.net>
Date: Sun, 23 Mar 2025 11:10:18 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] xfs_repair: handling a block with bad crc, bad uuid,
 and bad magic number needs fixing
From: Eric Sandeen <sandeen@sandeen.net>
To: bodonnel@redhat.com, linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, hch@infradead.org
References: <20250321220532.691118-4-bodonnel@redhat.com>
 <19fbe9e4-c898-40b3-a4b5-5347f78e31d5@sandeen.net>
Content-Language: en-US
In-Reply-To: <19fbe9e4-c898-40b3-a4b5-5347f78e31d5@sandeen.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/23/25 10:51 AM, Eric Sandeen wrote:

...

> But I wonder - why not call longform_dir2_entry_check_data() before we check
> the header? That way it /will/ populate hashtab with any found entries in the
> block, and when the header is found to be corrupt, it will rebuild it with all
> entries intact, and leave nothing in lost+found.

Or alternatively, since checking the header first makes intuitive sense, perhaps
change the logic so that we still check the header first, set fixit++, and if we
are in XFS_DIR2_FMT_BLOCK, allow longform_dir2_entry_check_data() to be called,
and then if errors were found in the header, goto out_fix; at that point, with
a populated hashtab.

-Eric
 
> 
> Thoughts?
> -Eric
> 
> 
> 
> 

