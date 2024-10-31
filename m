Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85511411EE
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 20:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730407535; cv=none; b=dUmfe2//1eXzwSQp95lACt9QH78YPEWvXHSsC00xnjf4ppgwej2s92hn7anEcGvRuEnFo2uauTFPdhyNw1qqdA3NwHr9PHeDwOzxoc0YzQ6gT/aF1+apJ46gsVC1H+W2OD40BJ4GK2wLU3O1eTlEUyAVyShUDrcteD/dkR8ckLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730407535; c=relaxed/simple;
	bh=iJtORRUM9QRHXn8Uc3uROlqx/GJcHyn7pzyblXTnSms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GSDa3y3bOedOKEG4x3fJoabuaLdJ+6p5GLr1Droky/uTHWz4kboOzdCXfbdLVPtVbfu/kvkG8pZNk7BJhJVLT6PYjML2AvUjWszByzCYq7rsB0GHanE+r5Ykp209EOV6wZuvm7O6ZfGcNzkmgXyin6aj1eEkMdbgCL8xhDcnGxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=FWNz1ApG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=YGlKV9Dy; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="FWNz1ApG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="YGlKV9Dy"
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id C7E1B138022B;
	Thu, 31 Oct 2024 16:45:30 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 31 Oct 2024 16:45:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1730407530;
	 x=1730493930; bh=jGVlEg8puAQuIBzbFz1te2M9a2vxi4MAKubodaLRLzw=; b=
	FWNz1ApGmjhi3zXSXgpcGVBX6vg7L/rvlcNRgt5uyeNoLQn/70zBd2PfpNoXdnUd
	ot0/dVeOEj3ruvPXCyCW4wSwzEi6ToDFAr0xROi2iMKzrIVOjSDuKHi1cP9T3lhc
	wX12m7+LFJFcjlIYKheEd1qXdOm/GPqE+P87BcC8bBkDGHNPyBYgIFWXPdadP3FY
	GapnCrm0/d9jXrK5A74jD0FC+aueq6jPbcmrayIVUlD4E5TCt1kk8IVDdlPD+QbM
	YzpQHpxS/IJ+nB9idVRX1iJ3RTO1p6V3ekaGg2Q4+Zv782E81ys4zF5uAkiwauQZ
	CTrDg0R3v3oPUIvYsYckmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1730407530; x=
	1730493930; bh=jGVlEg8puAQuIBzbFz1te2M9a2vxi4MAKubodaLRLzw=; b=Y
	GlKV9DyS1SQvd5psiWHuULSQl5WZdScQG2e1kcxzKfRODjPrkq/j81Q2r8s+zYBM
	/zlx/59+i8lFl5E7yXxy5Y9n7/sWIPx0cs6nuDaXcFsrU5siqRg6zigpijW4GXBV
	bNMPmEJm8Pq9jYA8pmCpvCpz9M+z33g0fJ+O+TdbMPy9ju7CWXCCvHTM8Lc2kW8G
	fZ1U9QEfERndhmLkxgeKJzdjkZXm9RFU8lrzb22nc+wNeE0Dkk5+epzZxBiZQaw6
	a+oLG8TExOLfnKSUOsKC84y8RFUuGZXW9xJa4W/SxvSGnBUXcBKhvstpMt4LtuBI
	o4qQNs21YPt/hiogU8H7g==
X-ME-Sender: <xms:auwjZ6qZmHkl8M4iyQ1gQ6g_h__Io5_RJnHICQDW_Si0J7Z1Bava6w>
    <xme:auwjZ4pFtjy_caGvkIog30P4ljdkMxpaZb-jIAVZQU2akTqVe5SH69HW-FJTgXbIF
    hmko5iPGNDlBQWl6oI>
X-ME-Received: <xmr:auwjZ_PvrVqam6bWUScSADFzZIbpkYg6ThzNz2qSMBPlDBRnNDyNQdxRhc61AA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdekjedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefkffggfg
    fuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepgfhrihgtucfurghnuggvvghn
    uceoshgrnhguvggvnhesshgrnhguvggvnhdrnhgvtheqnecuggftrfgrthhtvghrnhepve
    eikeeuteefueejtdehfeefvdegffeivdejjeelfffhgeegjeeutdejueelhfdvnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrnhguvggvnh
    esshgrnhguvggvnhdrnhgvthdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhhtphho
    uhhtpdhrtghpthhtoheptggvmheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepuggrvh
    hiugesfhhrohhmohhrsghithdrtghomhdprhgtphhtthhopehlihhnuhigqdigfhhssehv
    ghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:auwjZ57oihTDDXFrZtJWhRsi4Vv6K2S3pofpPxSgNtIc8TO55vnYHw>
    <xmx:auwjZ57DDj5oQeD9Y-JZH4PnVlnf53uOKAgVxSmUxwhWqy0cwdeOwg>
    <xmx:auwjZ5jal4qqrkod5K52VBit8rmPpeRG6FYKkwUTl3g32Jjth28W_w>
    <xmx:auwjZz40yjeWCka_4QXOvU4uG4kghva8ni8y4PdJmfJJhF-wkiV40w>
    <xmx:auwjZzn79xMT_Ocl8En36BPTtiUclIhnmP1HgnIZIIys2IRdWiCBmAAb>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 31 Oct 2024 16:45:30 -0400 (EDT)
Message-ID: <6a609643-5bd1-4a5a-bb40-79cd87075fc2@sandeen.net>
Date: Thu, 31 Oct 2024 15:45:29 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] xfs: sparse inodes overlap end of filesystem
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20241024025142.4082218-1-david@fromorbit.com>
 <4da62d9a-0509-46e7-9021-d0bc771f86d9@sandeen.net>
 <pdaherlfgonztg2woct5w5o4jukxvq2ealhq7mxbnkzm5rtuhq@vvevvao2aua3>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <pdaherlfgonztg2woct5w5o4jukxvq2ealhq7mxbnkzm5rtuhq@vvevvao2aua3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/31/24 6:44 AM, Carlos Maiolino wrote:
> On Tue, Oct 29, 2024 at 11:14:18AM -0500, Eric Sandeen wrote:
>> On 10/23/24 9:51 PM, Dave Chinner wrote:
>>> There is one question that needs to be resolved in this patchset: if
>>> we take patch 2 to allow sparse inodes at the end of the AG, why
>>> would we need the change in patch 1? Indeed, at this point I have to
>>> ask why we even need the min/max agbno guidelines to the inode chunk
>>> allocation as we end up allowing any aligned location in the AG to
>>> be used by sparse inodes. i.e. if we take patch 2, then patch 1 is
>>> unnecessary and now we can remove a bunch of code (min/max_agbno
>>> constraints) from the allocator paths...
>>>
>>> I'd prefer that we take the latter path: ignore the first patch.
>>> This results in more flexible behaviour, allows existing filesystems
>>> with this issue to work without needing xfs_repair to fix them, and
>>> we get to remove complexity from the code.
>>>
>>> Thoughts?
>>
>> For some reason I'm struggling to grasp some of the details here, so
>> maybe I can just throw out a "what I think should happen" type response.
>>
>> A concern is that older xfs_repair binaries will continue to see
>> inodes in this region as corrupt, and throw them away, IIUC - even
>> if the kernel is updated to handle them properly.
>>
>> Older xfs_repair could be encountered on rescue CDs/images, maybe
>> even in initramfs environments, by virt hosts managing guest filesystems,
>> etc.
>>
>> So it seems to me that it would be worth it to prevent any new inode
>> allocations in this region going forward, even if we *can* make it work,
>> so that we won't continue to generate what looks like corruption to older
>> userspace.
>>
>> That might not be the most "pure" upstream approach, but as a practical
>> matter I think it might be a better outcome for users and support
>> orgs... even if distros update kernels & userspace together, that does
>> not necessarily prevent older userspace from encountering a filesystem
>> with inodes in this range and trashing them.
>>
> 
> I'm inclined to agree with Eric here as preventing the sparse inodes to be
> allocated at the edge of the runt AG sounds the most reasonable approach to me.
> 
> It just seems to me yet another corner case to deal with for very little benefit,
> i.e to enable a few extra inodes, on a FS that seems to be in life support
> regarding space for new inodes, whether it's a distro kernel or upstream kernel.
> 
> It kind of seem risky to me, to allow users to run a new kernel, allocate inodes
> there, fill those inodes with data, just to run a not yet ready xfs_repair, and
> discard everything there. Just seems like a possible data loss vector.
> 
> Unless - and I'm not sure how reasonable it is -, we first release a new
> xfsprogs, preventing xfs_repair to rip off those inodes, and later update the
> kernel. But this will end up on users hitting a -EFSCORRUPTED every attempt to
> allocate inodes from the FS edge.
> 
> How feasible would be to first prevent inodes to be allocated at the runt AG's
> edge, let it sink for a while, and once we have a fixed xfs_repair for some
> time, we then enable inode allocation on the edge, giving enough time for users
> to have a newer xfs_repair?
> 
> Again, I'm not sure it it does make sense at all, hopefully it does.

I think Dave agrees with all this too, and I may have simply misunderstood
the proposal.

paraphrasing a side convo w/ Dave, it seems to make sense to have 3 steps for
the fix:

1) Stop allowing inode allocations in these blocks (kernel)
2) Treat already-allocated inodes in these blocks as valid (kernel+userspace)
3) Re-enable inode allocations to these blocks (kernel)

Distros can pick up 1) and 2), and skip 3) if desired to avoid problems with
older userspace if that seems prudent.

I guess I still worry a little about upstream/non-distro use after applying 3)
but it's the technically correct path forward.

-Eric
