Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DCE2C1594
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 04:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950865; cv=none; b=ee5XuD+6CljCSfK68ZpNcP1V8RwJXttcAY+xLa242BOpis7iMcg3csp6EbK12GbLGSKMg+hSg9OQjcF8TfH54kyxaE9joe1ELI+JcVMZ+TXR7RF9fDdu+hdijY7XPXQ2q9/aANM4tWZrvc7GWLXkjIS23LB4Fne0URyb7KCwWK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950865; c=relaxed/simple;
	bh=wUSHVNnArpJe9F2ixSxmBl439t38e/T9JdQnMNClCLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UwuFsTwqSKN8PjARPUuSUt0vJMFfLZBMRrY0D6EbbZjTS2BDgLOx0IMT8gCoHVoJmzcTNZQaJrituhY4k859vmDNI5tEhocFCGmahsbOkhnFU7VU9vuDxmGVLmavOWzEZLhvGtxO1zsrJr6Dw2gYvL6yABJBDOFOnxumb4jEAKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=CbllV71x; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RqM9cYxS; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="CbllV71x";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RqM9cYxS"
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.phl.internal (Postfix) with ESMTP id EE0FC1400157
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 00:07:42 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Wed, 14 Oct 2026 00:07:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1791950862;
	 x=1792037262; bh=iIST6RjoLzeeI0qiC4sNGwdO4qiOZ3ZNM+7+uXnhemY=; b=
	CbllV71xRMN33Q3L0hREkUo27/m0aRNarfrlBH0WTDm6eh7aQHQBBNSjvLYyGVC6
	xCyxwpPs/fIf7IOcM7IzCIXQ2cfJAhHZO2LqMh0qOPnMtiQa16cF5IOm6NtyfnPN
	FTZtyu6AMnHpFU23CFRQ2UIqYt9Z2I+1j9qtKciRPYIyahA3c2qjShRQH4VAVQ8b
	FVOUx1EmSmCL5e5ESMJJE7b9A+q1bGFvUoj3OIk6uMJyxUoOUVw0tGeeN5QNYdbd
	26rgY6fehBknAotAPbqM1YjUhqseFSd9ikYQrYK6AJLIckPnvsSgIyXp/CPMgBH2
	fWlCC28U26wKS+uZFOOn1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1791950862; x=
	1792037262; bh=iIST6RjoLzeeI0qiC4sNGwdO4qiOZ3ZNM+7+uXnhemY=; b=R
	qM9cYxSQl/thaCluT4Gt2UIuU39kWX7dwZGWHjo4gzjUcWT29dsgMhKK6bEKaT+i
	nClkr4N8wG7q6gYT912VV/WVB68/rM+a1ZlFvtgO4/sT+seOhgB3TfRqwCPJJtaR
	4tLoJ7XGlMndGCXEXQezl4MswlZK9n2+OJQdfrZMITtnETMojgu3iNf60RQ8v7a0
	2s1yl41gReRL/sWQTEY1TNM25Ur7ORMwH7xeYX2t0fbhwJ3EtXOZNDPmkhQxzsrX
	XHmdm2de7ckPAgu1sjbxbSP4ZICeLC5FyNMnlbIpzHdG8fMl+l9j5LbdrEEHcSWz
	17Guvsgi5mBPqYiLlA1cw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791950862; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:lTmjK1Tg9uM1ucr4Dbzjx44UR7F6IudFN1fn8ypYIS3zZQ5
	PQ5/Y+SZaJdRqrSM1paPszT0zD85bH602Pcuqve2x3Kd/+/ZPdDBK0TY+iRXpODL
	JlpK5MziBMlcNh4q1ctVmJARLgv3ZJipQ7hCEavNK3gaMlMUT/PTthL9jxJq/ZYO
	NneB495YwTnlmzZTi6uYZRWzsOncI/2dLgbWTwdzT4Ioos8YxQrERDQfbKSd62Jf
	M/NgwEhX3h+84eEu4Rm27uzqOXfdkmXWUphfVJdkhJzC2bArOwSmb+IrjsvAJPX2
	j1zbvWp++gbz0C/Ivh6s6sHscTVDHRtYA/YGGPw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:BfTY1HlAtdUD2xbYMLYVGAPGVBTsoHTVcHz2vBqFmzM=:wUSHVNnArpJe9F2ixSxmBl439t38e/T9JdQnMNClCLY=;
X-ME-Sender: <xms:DgDPahsB9SAH7zMa6V8Tu1bSPVfuYbIyCfmMkLrhNak9qXIHiDvn0Q>
    <xme:DgDPauL7pI2vjukYzhCyiAqn4P3dXBUTfUZajCpf6GNpt6bhdPInMElyfXMD3aL3Q
    4krINALTqZ7ctb-pG8AvbdxVySDddjDTU_pOme-ZnvLRbmpweCaTM4>
X-ME-Received: <xmr:DgDPaumlpwLYPR474Voc84g-kFfkrq286JYZ3syWwg9M3XbFqg9lylD-Q5jHbdAePAw8S0vk-0HrK0QFZXKrx8JPE7bw8Q>
X-ME-Proxy-Cause: dmFkZTEYZiwxde9T/fCpcQe7X01W64Q279v9p6wGDIKwBufDYB51y4YiPS7Luw38kA1Qwk
    4UlGo/2/1eonMhx9JYdbIo81Ljjl8Ru7JLT6OXYEMcucdpdoCf3puq+ijjQcZv93C+em+C
    +6TmIqwPvRPSzLaSkbu9i/OHNUdbqTsuB3KX2BWbRyTv2cx0eOzp6Te3MyM1yK5YK6oP2c
    wmbbu3bqAqPHJvup3PH+oleD5K9zWUHPoIZka8vFX7j0movo//WMHVMigY8lEJjqhxMs6U
    BcEswu3g49WsWevuSTZO55m3Z727onP0lP4g9n0RGR6Fkwz2rVjzIihvgFxbtZwbS0qvQT
    JlbCYsv5oR8ittw9k9PnJ/3G6YUP9nyiicpsuGI21d+vtMBrJHFa6XJJbQ+LSofoSkw9jw
    TQFB/e28lsdoqh9sGrjKr4UgTvXIKW46H1LkvjF5gsW4mEOXlpw+RdYvEsghBafR8WuY2I
    qCfztV3unehS7qsol5G5BrqHQ++9ETpRF2fSDwGEJkmo2SKRh87yL27TWuBL8VwaMI+0iK
    uGpCAajcNyw6Mlkg5xTws/cDtgRA6A2f9I8gtIdg8zJiEXcx79dDOl/VuvpTJal0jA3ZsQ
    zU+8lj83SGXQF5CzO7dgtfcV1+dSn7UyjWF8AnCIk3zQjeLHvfx0J+LSNT1A
X-ME-Proxy: <xmx:DgDPavJpKqX72X9PG0Q2szVGbB_BfddhtI8B7051gm2FIaeDNih8og>
    <xmx:DgDPaj5XzFtbdKb8iakw42cApfgxXaPUUJ0ZHgyxkEtwwR4PoUr0IA>
    <xmx:DgDPaj34umzy22MOEpD5qhhkn-4PO8U00vu1qwoF9OtZyVDrsZQubQ>
    <xmx:DgDPapf25hKlMnMODFdY9v1uP3hG4edxZzigEzZVk67L65K8whnn-w>
    <xmx:DgDPagn3LjL5YTWf49K3mnDptPmCry7Eqt05N5jACt1MZ6KUZVZeeHfu>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Oct 2026 00:07:42 -0400 (EDT)
Message-ID: <de05ef54-e9aa-4616-b9cf-8090e408a4f1@sandeen.net>
Date: Tue, 13 Oct 2026 23:07:41 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] xfs: remove status parameter from several btree
 insert functions
To: Dave Chinner <dgc@kernel.org>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org, hch@lst.de
References: <20261014013505.759089-1-sandeen@redhat.com>
 <20261014013505.759089-6-sandeen@redhat.com> <as7-F3aJcKmqu3mO@dread>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <as7-F3aJcKmqu3mO@dread>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/13/26 10:59 PM, Dave Chinner wrote:
> On Tue, Oct 13, 2026 at 08:30:03PM -0500, Eric Sandeen wrote:
>> xfs_btree_insert and its callers now have no need for the status
>> parameter; either they return error = 0 / status = 1, or nonzero error
>> and status 0. Every caller now handles the error and never reaches
>> the duplicate status variable check. Remove the status params.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>  fs/xfs/libxfs/xfs_alloc.c    | 10 +++++-----
>>  fs/xfs/libxfs/xfs_bmap.c     | 22 +++++++++++-----------
>>  fs/xfs/libxfs/xfs_btree.c    |  4 +---
>>  fs/xfs/libxfs/xfs_btree.h    |  2 +-
>>  fs/xfs/libxfs/xfs_ialloc.c   | 13 ++++++-------
>>  fs/xfs/libxfs/xfs_ialloc.h   |  3 +--
>>  fs/xfs/libxfs/xfs_refcount.c | 17 +++++++----------
>>  fs/xfs/libxfs/xfs_refcount.h |  2 +-
>>  fs/xfs/libxfs/xfs_rmap.c     | 14 +++++++-------
>>  fs/xfs/scrub/rcbag.c         |  2 +-
>>  fs/xfs/scrub/rcbag_btree.c   |  5 ++---
>>  fs/xfs/scrub/rcbag_btree.h   |  3 +--
>>  12 files changed, 44 insertions(+), 53 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>> index b40c51a0f651..13a61144a2c8 100644
>> --- a/fs/xfs/libxfs/xfs_alloc.c
>> +++ b/fs/xfs/libxfs/xfs_alloc.c
>> @@ -692,7 +692,7 @@ xfs_alloc_fixup_trees(
>>  			xfs_btree_mark_sick(cnt_cur);
>>  			return -EFSCORRUPTED;
>>  		}
>> -		if ((error = xfs_btree_insert(cnt_cur, &i)))
>> +		if ((error = xfs_btree_insert(cnt_cur)))
> 
> While you are touching all of these, can you convert them to the
> more common pattern of:
> 
> 	error = xfs_btree_insert(cur);
> 	if (error)
> 		return error;
> 
> Otherwise the whole series looks good to me.
That /adds/ lines, what are you talking about! ;) 

Sure, I can do that if folks prefer.

-Eric
