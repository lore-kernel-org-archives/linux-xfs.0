Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC285625FB
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 17:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792171210; cv=none; b=s/llHzO3GgVlBDqYHAZxztJXyje9e4Ur2CFO8X47smS/ZFqMrS211PuIfZomNk2O0JqdKd0weQzwZSxDVskHqyYbgChtPaDwHpCtw9GJwFtwhB6ZVBWvouQ+kDDU5T8ro6Hj3YBzV8kL8x0rEzFD0kdEIg8D1RymSVVYfd2RZsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792171210; c=relaxed/simple;
	bh=I7ZoW4uccEcuENKoMKnDO3ZaJylR2bac5gHDEqfybMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kNIzzIyoxlpXtkcU2YmJnvpV6FoQlNPR+GUgrMySfcurFxvRvKugGLSaF6qUelzeMofq8yfmsXF9YqK0JBaU2knGygn9ithyj/HrwE2YwpQ8X84RNOW2oGjDq2Zrb7DKsWQAc50ErNleo+8/GGcLaxJ7voCZE6yIdIUpwtYcpS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=mDvSbS/x; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BkaZ+E4L; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="mDvSbS/x";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BkaZ+E4L"
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id E55277A00C0
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 13:20:08 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Fri, 16 Oct 2026 13:20:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1792171208;
	 x=1792257608; bh=ckdCtaUfSngKV//vMwspHbYEeaHR3JUgmqCPskCmFCg=; b=
	mDvSbS/xVZp2Nci2+8TGo8lwPnBqNMZKqnCz4NuHPv+gz9lWdST2dYLLXYeSBcvL
	9HaVAO1Kj8vtDgm9ciLQlbwBsYOKaZBf3RZ0VFHadB36Yp8mdeQPnvJsVIUjEZPu
	0V4fhle9xy6Abr4J8y4V2ZSCe0WfbSiwoCsIyBqjjE+KQkamn1JlgzkrnhBF/KF5
	PVWjwX14LA6ulcHTXluifd52+iLjQL6gD7KcOe9kgOhFWTWXfOsJbq2H1rSzt6OG
	mIX3rWKNzQLKxVrB13ATnmZ7cfr/zc5DW+37fjh67+ulJvcWA89zkoQpiO10dJhi
	dZSCRjXDX+oxWGnrLuyLcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1792171208; x=1792257608; bh=c
	kdCtaUfSngKV//vMwspHbYEeaHR3JUgmqCPskCmFCg=; b=BkaZ+E4LsPDuIkuD9
	JU4kij4EuzlNZqgfZjoDZVRpdyj2lHyoJIkJLYOp4iXXfWPr7u/Hb9IUpGJwiAHE
	17Juce61YQpbo/cLvR/y6oCGLPIcFNBoFnQ2MyWcKMEw9rgtGlZ4pX5Mk1DaLt66
	W0J65LTrLLQwjGLOEQKTijs1Rs7DYeHTaLey5nRFUVyFovHn1+a1+diXstJAo2/A
	W1q110/oFZuJV2zZkZSXJtGmp/U4fqLkb8ij1aAOhsKvUvnTqWVJlmAxecab2135
	pP0xYQha4G6wd820FjtVnR6UnwWM6KZBQ98v9StsEkF49n9BFxCw82YA74w+mJOB
	5RyOA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=sign d=bsbernd.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792171208; d=bsbernd.com;
	mf=PGJlcm5kQGJzYmVybmQuY29tPg==;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm1:rsa-sha256:L007ZpjpsAxqufWoP20uBISEZzqm5zKGsH7CDX25oI5X+tZ
	uyv14l4tSJ39U6WTEG673x4AM5nftsntjaAktCS/mRCjyWy+FGt3/9eB/ioOf0O1
	dNHz+ty0+UV/xcYzuqfCRvN0E4kcVYOIj11r5x3WwtBsKGNoJkpZ5G3dijTOBS7S
	St2bPYWl0cV0IroxLi53vrJf+6zoIXVNj15MN/W6tLweVKAAh4pj1qH+d5dmGgqG
	1/qCxIToChzc1RnVEQAqulz58tJOJaZDSv7PY3ZQqSlxF3B2fmQb4Y8D8rvuX05W
	UeHzz8oyYdSnXpwY5q2OyTjnHfcSIkRgd3CD7Ug==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=content-language,content-transfer-encoding,content-type,date,
	feedback-id,from,in-reply-to,message-id,mime-version,references,
	subject,to,user-agent;
Message-Instance: m=1; h=sha256:82LYqGdpR+9jO20ogmTJdDFKj2bbH9N+lkG+Q0kVdgM=:I7ZoW4uccEcuENKoMKnDO3ZaJylR2bac5gHDEqfybMU=;
X-ME-Sender: <xms:yFzSahU5uH9q9sS4AKumcOCu8m0G9HloBdx8EHivzLMyPK9FOdo9PA>
    <xme:yFzSaiSaxEjsSh1SuS9U-3xRRQScF8gD6Fj4C6w_cULYGpinyNSAZ1fQtEKgRL9SE
    fdUNDHJ7JxG3kh0YiGM7lKltA8lNJQLrw1U6JwYBOCKKTvJ_RTqIw>
X-ME-Received: <xmr:yFzSarnNFjfqFY2g7cFoSuurMET_uemQBR4pzKOt3yd0K6B68Rd_xYW3m3R2nBqKoNwh7NFgjleoN3BHPHVmEdVbRWhkcVQ8z-FEzgDb3RpSjNIghg>
X-ME-Proxy-Cause: dmFkZTFVQow3e5k208uUNYLFxnIEeMlaj7P73DH4OSwdquSZi7XIHey05Db2z/r3SQNF/p
    Rtc52lhZkoWGzNq2T5QDC7NkJe6AzsFOnQpDIWr+743/XCF28GRLjPPD1AXxJZY/8Dr/QO
    GXu+FWfQXPha6re6YgZHHdi8QcRO3XwCJoXWGiZz1jqk5eIcSSq2Owb4Zzsl+q7m7cQs7T
    F7aaaZOy1lXrQ45nWYgvdQViCilP95V6Xa63ErPxovFkDLDF4x8lszP0QExPidcav3LHq/
    76zvnIORKJickkz2000tF2Th6s1B2zuqJiX3sDslw0d5B2rP1nXaXDwnZ4pBZdwgNnoaQW
    uGvziEHITabyRpk4oy6EfHYGFxkNUVpE9Vu6lNnvx8T55a7WW5adUkq7/7gRc+fkDJ71yq
    r8V0UB77qq47uNMSB+uhJucFbbsxoHvU/bGakBN0Ev3NccxoG9nmVDu9QSdLH7JUt88Jld
    dYlrlffiG9o/cao6vNO44kRtYAJi8cfAAOdIvEk/41w7QfxfaAQshMR45ZgXRg3VdgGbHj
    O3TU5ldTxk75NNYWFi9oBpZzcW/Rv1VAJhiw9Lt+74UAgQnHJVgTYNedEis76LqlmnyHaK
    N01OzSQArK5O1XCETEx9LVBGBL8Td3Pt8axP2I/rWhTttZXiKXSf7wKM3nkw
X-ME-Proxy: <xmx:yFzSao4tY1gs7e2C4lq7CnZ0QId5JP_3I86qlIYUwuOEYWHqCGtJ_g>
    <xmx:yFzSahhV6lNqDlOO6mI0nW8b13zCu25tO_y72h5x_-x1N05eiG4IcQ>
    <xmx:yFzSalHGwhO3HUda_mNTbdEnIJCL2nCWlThnu_znNUEZgJ8K8DxpIw>
    <xmx:yFzSanT0UwwYG6IlHF9cydf40iBs_X71YzrQ4yTc_d5w4LUwRwA5rw>
    <xmx:yFzSai6s4T_qO1QR2mAFoFmuByrzI6_i_-7xfOMo_bM4sd7k5qWh7yGd>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Oct 2026 13:20:07 -0400 (EDT)
Message-ID: <10b98657-7d10-43de-a51e-0e738e02a4d9@bsbernd.com>
Date: Fri, 16 Oct 2026 19:20:06 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Farewell!
To: "Darrick J. Wong" <djwong@kernel.org>, xfs <linux-xfs@vger.kernel.org>,
 linux-ext4 <linux-ext4@vger.kernel.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 fuse-devel <fuse-devel@lists.linux.dev>, fstests <fstests@vger.kernel.org>
References: <20261016160037.GA107919@frogsfrogsfrogs>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: fr, en-US, de-DE, ru-RU
In-Reply-To: <20261016160037.GA107919@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Darrick,

On 10/16/26 18:00, Darrick J. Wong wrote:
> Hi everyone,
> 
> After 14 years at Oracle and 23 years working on Linux, I've decided to
> take an extended break.  Today, October 16th, 2026, is my last day.
> 
> I don't have any immediate plans to drop the djwong@kernel.org
> forwarding, though ultimately that's up to the sysadmins to decide.
> 
> I have very much enjoyed working with you all, and I'm proud of what
> we've accomplished together.  Good luck!


it was a pleasure to work with you and thanks a lot for all recent
libfuse reviews, all merged now and next libfuse release coming.

Also thanks a lot for all your xfs and other Linux work!

Good luck for your future endeavours and I hope we stay in contact!


Best,
Bernd
