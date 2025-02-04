Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DECA215F5A
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 17:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738691704; cv=none; b=p/0lRiHMJsRj3O6Sn44huBy8mapQZfVORC3Y5G3sOGR5myE8BynIh+TRFZPJWMxBc50bCbjONgekYwWw1ueh4C9Gf7KnAuqb5uV5lm3piU2zkgL3yXGMfxNX6ZslECo6BMC2nU8yjgFGxYQcrQvxgiJqC/mYyJtfzW+1h69JIqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738691704; c=relaxed/simple;
	bh=BrA5hQeeQ+9hwXmqEOc0IdDqye6c0ilmN4xQ9RqTqOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=De1JO/Ds96uNSwXh6QGl8rj2OkfcUV6n9oMPr7G3uSADuM+kBVHcj0O9eM9EHoPW9a+B6OOUcXw4v+aDTZQENpwCg43XQME7ZRGUD+bWkxyc70Wi5KA7hLKAElAGOhzCFOOFibhcpJiSb34/04ypXAldsIE8shzCEuw8xUHrUdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=Pn9BTWRT; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=s42jZCqv; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="Pn9BTWRT";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="s42jZCqv"
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 949B3114011A;
	Tue,  4 Feb 2025 12:55:01 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Tue, 04 Feb 2025 12:55:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1738691701;
	 x=1738778101; bh=eC4i9cJJZZ4nRLNyHUCA8cLDp3MGTurJYIzGbcH29qg=; b=
	Pn9BTWRTyAvqiRQpUv99mikWmT2DzU7rLXTZ5dBub7uxl/IiPOx3Dwu4Iklyqe1g
	/QnORvbx0yk8+2gV+SIKacJouyGmhIhrm/TVkbkeBs2M3j0o+S1F+s54Ul2FOgki
	EFtwy5Qj00CSQg0GXY00mPLjaqilDakaeb/40MCkJGRe0KyTXKrfmZOHmI/4fIHK
	5F9Oppb+JwKR5wOPFBOelnobRlC+DoDm+G/0Fg5cZ+0N5o23OsFSzmKmmRuJwTim
	c6VwbX7X2Fv//ql4GFltOql313PvCrbti/OmR+gCUrYINoi3GwE+f6H7Qx5Pa9UC
	qPC+w/z/Yn8bYFE26JIFEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1738691701; x=
	1738778101; bh=eC4i9cJJZZ4nRLNyHUCA8cLDp3MGTurJYIzGbcH29qg=; b=s
	42jZCqvYK/EOUxRYe9D58wlE8CquYntRLrK2GPpywrTpnG6Ge6vwdaR2R0BiR8og
	i6GxWMF0A+RY4/oUnsknxeBvXJOujHEaSprVhzgXK4OfVQOZ6yzAS6LzJ7ntCts3
	1O+xMvxZOPciovKr/nnnJw3y0sRqKdqJ+2VMxn5VbyvXWB7wGcAygaHHb17nLiQk
	MMZldFupyKgDOuQK6K8GPSP0lpU304dK41zhah4KzpJ5MNPM3GpKvxs3pd9wHwOw
	aT76oyjSe4WTGYxVLADyrcFhw1y7Xe0SvHbF5/G0FEdHq0L0wsK64hpEefy6al1G
	zGQm5U+vam+MjyFWI8Bdg==
X-ME-Sender: <xms:dVSiZ28mSiZjPdjYU5TEi4W9ZldeYb0DUX1422MP7exRS8xrzTrTvA>
    <xme:dVSiZ2szZORPsRZ24RiUR5-xL9ewPDWVwDSFKh7MDcjTLtRAdMg85F0qVS8OA7FA-
    IYJzgJTrBL5OdE09p0>
X-ME-Received: <xmr:dVSiZ8Be4GxXg9F-ib0UmLj7AzUy0pIdjKeXwQEFsEej0-uoCY9ETRwkEPUAcvXi65-JUNsRBWdvRf2upNElB_c48DNX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvuddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepgfhrihgtucfurghnuggvvghnuceoshgrnhguvggvnhesshgrnhguvg
    gvnhdrnhgvtheqnecuggftrfgrthhtvghrnhepveeikeeuteefueejtdehfeefvdegffei
    vdejjeelfffhgeegjeeutdejueelhfdvnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepshgrnhguvggvnhesshgrnhguvggvnhdrnhgvthdpnhgs
    pghrtghpthhtohepgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepughjfihonh
    hgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehluhhkrghssehhvghrsgholhhtrdgt
    ohhmpdhrtghpthhtoheptggvmheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinh
    hugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:dVSiZ-dDjA7Mt46c3SqU5kzJ4IXSimD_8QzDW2Yw0o03CKcflQEb_Q>
    <xmx:dVSiZ7M38l1x7DHM59MOcTIhNxLraf4mhZFqaKkjKUsACg6fNSTTKA>
    <xmx:dVSiZ4klF7KydRAXnuGKjBI-UY2kqXWo0BNYeeGBOGTuC1HuckknRw>
    <xmx:dVSiZ9uifXoGABDS3SYTBYC_jGSi4LRC4fIyNxWa4FWH6wj0bmgn1A>
    <xmx:dVSiZwqS8LUFuDa-ASK6IgdOEW-EUsRokAs2sSf4-rku1I01LCtjDxGF>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 4 Feb 2025 12:55:00 -0500 (EST)
Message-ID: <0e383591-7023-47bb-a202-2277e2d4f7ad@sandeen.net>
Date: Tue, 4 Feb 2025 11:55:00 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] xfs: do not check NEEDSREPAIR if ro,norecovery mount.
To: "Darrick J. Wong" <djwong@kernel.org>, Lukas Herbolt <lukas@herbolt.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
References: <20250203085513.79335-1-lukas@herbolt.com>
 <20250203085513.79335-2-lukas@herbolt.com>
 <20250203222652.GG134507@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20250203222652.GG134507@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/3/25 4:26 PM, Darrick J. Wong wrote:
> On Mon, Feb 03, 2025 at 09:55:13AM +0100, Lukas Herbolt wrote:
>> If there is corrutpion on the filesystem andxfs_repair
>> fails to repair it. The last resort of getting the data
>> is to use norecovery,ro mount. But if the NEEDSREPAIR is
>> set the filesystem cannot be mounted. The flag must be
>> cleared out manually using xfs_db, to get access to what
>> left over of the corrupted fs.
>>
>> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
>> ---
>>  fs/xfs/xfs_super.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 394fdf3bb535..c2566dcc4f88 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -1635,8 +1635,12 @@ xfs_fs_fill_super(
>>  #endif
>>  	}
>>  
>> -	/* Filesystem claims it needs repair, so refuse the mount. */
>> -	if (xfs_has_needsrepair(mp)) {
>> +	/*
>> +	 * Filesystem claims it needs repair, so refuse the mount unless
>> +	 * norecovery is also specified, in which case the filesystem can
>> +	 * be mounted with no risk of further damage.
>> +	 */
>> +	if (xfs_has_needsrepair(mp) && !xfs_has_norecovery(mp)) {
> 
> I think a better way to handle badly damaged filesystems is for us to
> provide a means to extract directory trees in userspace, rather than
> making the user take the risk of mounting a known-bad filesystem.
> I've a draft of an xfs_db subcommand for doing exactly that and will
> share for xfsprogs 6.14.

I think whether a userspace extractor is better or not depends on the
usecase. I suppose there's some truth that a NEEDSREPAIR filesystem is
"known bad" but we already suffer the risk of "unknown bad" filesystems
today. (Or for that matter, the fact that we allow "norecovery" today,
which also guarantees a mount of an inconsistent filesystem.)

"Something is wrong with this filesystem, let's mount it readonly and
copy off the data" is a pretty time-tested approach, I think, hampered
only by the fairly recent addition of NEEDSREPAIR.

a userspace scrape-the-device tool may well be useful for some, but
I don't think that vs. this kernelspace option needs to be an either/or
decision.

Thanks,

-Eric

> --D
> 
>>  		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
>>  		error = -EFSCORRUPTED;
>>  		goto out_free_sb;
>> -- 
>> 2.48.1
>>
>>
> 

