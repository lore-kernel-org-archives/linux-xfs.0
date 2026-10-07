Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAB94AA3E0
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 15:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791387147; cv=none; b=ApTstQadzosCBUHct25Bn//y9LQzToEFJkovjKBZR2hhA4mex6GkMUy80GOlvWOGVuO7/zKhiMjnpYbt31RqJGohe549/m+enCGuzKgqwPvPdx7doLBetNwnSguCtl8/F2nyBS7EWHbIwcuJbP7enK6fcjNRDdbZGYRZ+HxnMeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791387147; c=relaxed/simple;
	bh=RWfuUoym+ThYp2coQkrujeCF2etIoDbGq9YvvCl4WAI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tETABbKRLqCQ4IUS2iHOc1H3HN311uFWa+JYkhnXHH+UTh1R3eHfJxkAbxhwLnFgsCkxd55XQEVB09Rq3uYlZCCvuPqDUyt2dJXmyy+lc6mI64ZdvaO2cxcPAJobm+qYP1LLrnpGnt1N7fsAOFBVOvddIXK7ZkZswod1l2TbYjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=X8DLidC6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jwmwkEMz; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="X8DLidC6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jwmwkEMz"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 531381D00055
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 11:32:21 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 07 Oct 2026 11:32:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1791387140;
	 x=1791473540; bh=Hl76ASqhl02vw80jud8Zwuxpk8S6nn9mfHr39/k0iLE=; b=
	X8DLidC6UvfQtzCcl6yHY8IMVF5GbrgeraIL8eT/IcVju22lGq1e6drrrpWTyAJ6
	79nL8Ku9fRTx5nzHlJhH+iB6Q/O5rfevjfAW0whkkNklMAW8rc0nW4EayPz8swAG
	/hdzuIm1MF6UZlKaSxjSuZ44s1XN1inHfDxvcZAi6jVTq/VPNBRUAKiZpqtb72mG
	rBfssCMpLPYMTjtpQ7yWwRklb8cny+J+K1vOs1TCy7K3GL/2U/FPv0SxGoEMwyBe
	Ps3IyhH0wIm+MoZSZifIEiaWYsQQhFZEETt4tgtBJte4hVuIMqEqsHlovpYO+Jn0
	SdoHvhDfYojwceywPnyfXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1791387140; x=
	1791473540; bh=Hl76ASqhl02vw80jud8Zwuxpk8S6nn9mfHr39/k0iLE=; b=j
	wmwkEMzTomCHubLU/EK2fmsVf4TiFqgF2mtVaM+k4iez56POqsl4vn96P1hIU8Rz
	WI5NVVY+6ehjh9TcDNYqL/M69El1VYnCfvrOzdNQFphjto6wT1L2m11dF1gf3rMD
	+lO8lyH1ANwW534FBcLt4wX0dOTAe24errLhNfZ8Zpg/bEFf6QtYwt+wg5zQ/BHQ
	YjU18cgEGRyzfaxC0HL+O0iehJ0HEq1l6YBTewYabnQe1I+NO2MZ9yFyH/dBcqX/
	Rpe181y+jcQS3A7s36Pd/0N10DjoJY8+ztTJMPbSFrrCJzjVyveJp8qfaJyU6WYQ
	34okw1beeLgips/ae4UMg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791387140; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:KOoEUeEPnNyqW0bODdnAJT0i8b9Jg/h30Pti/wQ3+q7DE3k
	cMSX2FbolM86KJayvJNF26fUurvFqzm1CgtrQ17nd49nPJ3KqgGei5OE3etOyrXN
	evjHDcvc/qk7xLsxXDy2ZIUNaHT4OUkm2UvJYOy8SJX6f9qICyzPYFS2HdNBIKii
	kLXyBak4E//nWz2m96rYaJhhyxE3p92tnkHEL2nvo4dN7yJ9cB1cMmhQnqE1cfUN
	1FM9zrFElrHfRMFRC7a22DI2bRHoFJn96L0sL98U8pm9YTR8c+I0e2cvEg4/khx4
	wkcT/W8+uxkaCYp2o/21BknVfCIwciG9xn4XcUA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:UkRJBiafNT4XSNNho/deQlHC3CHldROawGGn31c8gCI=:RWfuUoym+ThYp2coQkrujeCF2etIoDbGq9YvvCl4WAI=;
X-ME-Sender: <xms:BGbGauHFyi2bB4ReynrWb3Gh_9Ivh1X86odwE9BjaU76yaJWh-ZrFw>
    <xme:BGbGaq35nNnehN67SWhPkIvJs-neA0WnFhzO4CG1dC4UAkgTCtbTNMCIyPUuKufJn
    Y-0FBuGEvpjq54NGFQIYEu-w_YviivYWz6p1aI9AI6R9vBY_P3dIAN2>
X-ME-Received: <xmr:BGbGaunmRGdupy2Mk28ECNKapBDGL8XN1Ceq5Far-Mz2kEK4ZgMrMU4dsvP-RMNptWhN9Nz-Jf0IJL3Wht1TcTSZyUySAg>
X-ME-Proxy-Cause: dmFkZTGNymKh6dgBK3MyBE+0FqsHxcEU9gZCp/VLuAWWijYxi/eXGhF/lDnwvSQKdD0K3k
    MOS/RP29aGy7D7RVCJ3oieeewXRYn+URoY9TUFmqCX1jb4AXN+87wRPKlHHUk/aoUQstsd
    Yw0WwIH8Ns/9BtE8cAcWSh/BLJypUuah749KEF2A4mVHDCvFiBkU7opH6QqTw5e9Gesq+/
    Pbr8vvLZzdXi2445DLJ1p1xuiISnNWUJWZ2Tgj7DgJTrWBlhTSjC4EBGr/F2ZWcUpGHwm1
    nEXXCZFPnA0F4h4/WFJnkRKl5oVMFu9HgnI8zavxN3i7wvatGysxNnyU23wjgjQz9XAabA
    Fye0qlBZ3z5ndeLK7q3cG6eQ1orC89qJFPDOj1SAWMQ2UlNSxJi82aNIC7djyXirH3KdOE
    mXxCTrIguO3e5cXlSEze/ERRBo30rb2qCeP3ShaAKgjFZjGk3j5aFSm3j20ymlHbb4otEB
    PQUkfs8R8aDUzlrhZsWAv4YYuE39xwQJwPDjx/iLUAIFJ9UGMl03Qmo3BqrSD0ugzB174N
    xQ51roMUv3h9xBrD82Gpb+36HQKFY1bPJdSspxhNZGbYqDNBCx21uh88wYnS0+dUcRrm1P
    BNyBsFGZ3MNeYnFvOaPxEymJ4uA/t3nfTmrEFtt09AHaphKqEYqc3cZz+qZg
X-ME-Proxy: <xmx:BGbGai9krQHYE22YjLyNBDmqM7lor9tKFpX9ZBvSYw4sxu_XO8dw5Q>
    <xmx:BGbGaro7JqBbiE0rT0SRuD01Zqafs-RGhOheZZGo8CjQIfQ9nmUV5Q>
    <xmx:BGbGajnSoTtRrrOc8SjowELeTnX5mRpTTBatN6398PML9Fx82Ar-Dg>
    <xmx:BGbGaqj5wvgnFrfHBqDJ-Y4SmdvnnrIkaUjRm49yuDr2i6MAVsFlKg>
    <xmx:BGbGalfm2GHMJ6Ni-o5D52oXIfCb7RstY5ZIeHr4vqy3NC-u_5KVZWjR>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Oct 2026 11:32:20 -0400 (EDT)
Message-ID: <7206d033-2082-4591-81e7-43a5c5bd631a@sandeen.net>
Date: Wed, 7 Oct 2026 10:32:20 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] xfs: re-use refcount scrub/repair code for rtrefcount
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-4-sandeen@redhat.com>
 <asZOVQfQU3TpEBgv@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <asZOVQfQU3TpEBgv@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/7/26 8:51 AM, Christoph Hellwig wrote:
> On Fri, Oct 02, 2026 at 04:08:11PM -0500, Eric Sandeen wrote:
>> Some code in scrub/rtrefcount.c is copied from scrub/refcount.c; it
>> differs only in function & structure names and a couple types and
>> macros, which share the same underlying types and values.
>>
>> Similarly for code in fs/xfs/scrub/[rt]refcount_repair.c
>>
>> Export the refcount versions, use them for rtrefcount scrubbing,
> 
> Not really an export fortunately :)

Oh, uh, yeah. I didn't mean like EXPORT_SYMBOL just un-STATIC. :( 

Maybe Carlos fix it to:

Make the refcount versions non-static and use them for rtrefcount scrubbing.

on commit, or I can send another version if needed.

> 
>> eliminate the copies, and add build-time asserts so that the type/value
>> matches mentioned above do not drift.
> 
>>  5 files changed, 72 insertions(+), 316 deletions(-)
> 
> Nice code savings!
> 
> Looks good modulo the commit log nitpick:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Thanks,
-Eric
