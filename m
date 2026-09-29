Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4F6280A56;
	Tue, 29 Sep 2026 22:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790721285; cv=none; b=BgXV5WEpF0qzJzP7N9CDe3fCZNlJ+BBK1e6SHRYrVZNXWpiYdfnnLNw4sM5DHsgnp1DcznOQYLDJTfDf0Ub7PYBcjPCds5dDVZVEKEezs2cPMH3BQbW3DZupIa2izgW1Zf2ZX65ZWBksIZPNs+apa//X1SeGwiFf6fQUyaTT6N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790721285; c=relaxed/simple;
	bh=hjiyCzqQvSUxQc6HxHqYpELnZBmj+6fiYQGh3i6wxHI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FYWP7XInuoLLjv1gszrKXyfk9ERYtXws/Sm88RraRuF9J4EHkZkNLW7T6mwV8xzY+/al1IyplIh2HvpRBfMcl6ILUsiIMcpqVYPnV7K7Z6NeEqlI1/JwgI3O88io9YynR13lmWYgBDa1VLWfuE3W+Iz/e9Bqz3mF9JsIhUkZpl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=bN6FyHVh; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=vq4IaGJ6; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="bN6FyHVh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vq4IaGJ6"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 47C791D00713;
	Tue, 29 Sep 2026 18:34:43 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 29 Sep 2026 18:34:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790721283;
	 x=1790807683; bh=tQAdlWKXz5EQMHwvsvgdi9y+wBZ+lxzMIjOPtdt65Po=; b=
	bN6FyHVh9gMvmDQVOn+mhDd1hU1zVCuU4Y1OiD0XdDEvA2WZ175JbooIaGE2A/NV
	/hGYNNK6mluLocBCfI/kb0j8zJk0u7MM/mTkNCXDAa9J6F3Fy9eMUxis753oPVrP
	RH28VEd6TkFVGFXHhU5wd4clNFyyZJ8zqLc1L+4yNwenAoalfZoCLbupi29ofTwo
	i8SC6POy91T//NRJXNUNV0Gt06Zc7FkQsuXsFXCanTKRbrf+Rvai/dxGGplC3aYq
	2BAb63a2n5d/FELCDYhgQv0gEVZePBCDPqIA+7unKqb+TABtZlz1efGZ0KDgRbYK
	bVeb7InqLlQiTB0P7LwhTQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790721283; x=
	1790807683; bh=tQAdlWKXz5EQMHwvsvgdi9y+wBZ+lxzMIjOPtdt65Po=; b=v
	q4IaGJ6GNAK5+guJj9FevcyWd8oSPfrItT/76Lfo4hYIYI7iaeTMmieKzpNh7RiD
	V87ptlxhrom25NPLhwzFOVAoIYOn2VSKrDwaQnMYFWSikkQGInPn1FRXjHrTI6P1
	GbFzlzMZcIazpnD78YXgEc4PnW1nRaCYDaUUAnxBKeeCMSePEdRRgz2HQWOFSzgE
	JOvodTxiMjsVhlUERm6/SHQNjS/vqzTpxg9MCvgR98iUtNNS8qU3TsUunFB0OfuP
	I+IP+F95CuK9ZAbodtwapc9q7Pxk4WDFzOHy7hZt5bGyEocXZFRv2PO7Z4ffi/Ez
	+BJEkDM6y2Dmk8lLYjSaA==
X-ME-Sender: <xms:Aj28avryL6aAfOcSIrNcut_hdSAS8gmafm2DjayNN-wPlrouR-Fe_Q>
    <xme:Aj28arI60Cbou1qqDaVJ89r9oT5zF_j2ttji_A2g-BcYUTKrWSdUY9gpx5wi_4Zna
    iIefZll1b3fz4hR1L9nQr494KY8RPJD3ZFJrRHrqGSYff63irlhY2Dt>
X-ME-Received: <xmr:Aj28asSmkkiQS2uTMF0mD3PHd_xdJYSer19MSLzmRk1-szPQKayPdyUsNp76J-vHEpzhtprMVhtt0kEFpsic2UMZawEKvA>
X-ME-Proxy-Cause: dmFkZTFdD0qsqzxhN/w3zhKEVysFSuExtFBanCI989UljJcKvuZMzeOTX4qkkEgiLaELeg
    IbtTUi8R/xvtJ9oPMVy4zfNuOJdkLzuHn1t1RHpW6uoRYnj/F46R9M+/QnHm4S/H/4sG+m
    uDSjB+IAL4+CGpnBFeKvhldOBkOeXgUZLRioFT01gJ+DqNkFupJMlM8Pzlz7XRdwkeee1W
    EGi1EEsK3ZuPr/R7xGW6C5vFSy0fsolnZPPTPNiaoQkSbVvbPhT+fiaz41Pb3TCH3ATfYO
    PoEm74CaGru64WuZQ8WhKZ19MIN88wJ8ROML9GzlBVvxXeW/6Df5aiby0BQE7fIgoSgtjG
    2bKvNQ8qDw/EpJ4FiRPnSeDsZAmvfEzfozHNfFfssBDaIQkMndDi6s+ntLziBasd8+lH5P
    rsvWvBubfPSgBCvmdmQUHLs1MvBuwOjplqoOwfTYeL4wg+3RcHXaA35Ingmk6/bUGk7fUu
    8WGRnBx2ol48EkTQeZ7SWRrPr3IyTpAbbKHk/4a+ONSW/iG0jj3sF25q5Pq26vGzrKT/DD
    2c/tCE6Q332dlMCVsp8bgI3uoRkKTKEvO/LpWTi7Q7E4Etc5vvFK3VVhxYvepkTn4D4c+r
    mRYB6Ip/D5hH5mFU3JFnhETazgDn37Rb2xFXXkQPwrj4fXogDN7qrhcZzWwA
X-ME-Proxy: <xmx:Aj28aitz8WB6Tfi_WogOoP3ANoCd3qMxizdbaZTmhnI2EMBQ6sX7kw>
    <xmx:Aj28albzIwDDel2AW8Ze4UJlIkE9cIUvmVuUh_W2_mzRGKV4BPYyuw>
    <xmx:Aj28agEhpzrpuLfD8JE9--GmPDVI7f1e5Bcc6CojZftaM0nj0RxTrA>
    <xmx:Aj28ahxOf7QD9btGjijP9aNNjPu3-WP3xOMSN-Eqpb4eNy8qavfM2Q>
    <xmx:Az28apjQRUDy2mCWuBOzmYf7N7IExbO_nLUkLL6v6q2zWtVBJ2I_nZGz>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 29 Sep 2026 18:34:42 -0400 (EDT)
Message-ID: <21ce40af-eb29-4c78-a5e2-1021c3de075e@sandeen.net>
Date: Tue, 29 Sep 2026 17:34:39 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] MXFS: a shared-disk clustered filesystem derived from XFS
To: Steve Shoecraft <spshoecraft@gmail.com>, Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <56847E8D-EA83-4984-82F3-9BC93E4C02FF@gmail.com>
 <ardhDI-Ko7b5RccH@infradead.org>
 <BC228018-42A4-4715-B186-057AFDE8A4D0@gmail.com>
 <arj3Mp6Cq2_qwaIb@cronus.toxiclabs.cc>
 <1B01BE22-06A8-412D-B141-CD94026E0A39@gmail.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <1B01BE22-06A8-412D-B141-CD94026E0A39@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/29/26 8:19 AM, Steve Shoecraft wrote:
> I’m disappointed in your responses. I would have thought that you’d at least be interested in how well the AI did.
Not trying to pile on here, but still echoing the other "disappointing"
responses:

This developer community, like many others, is already oversubscribed.
This was true before the LLM onslaught, it is /far/ worse after it.

Review has been a community bottleneck here for /years/ - for the actual,
shipping XFS project code.

We've been victims of turn-the-crank work generation for a long time, whether
it's running xfstests and throwing un-triaged failures over the wall, or
fsfuzzer,  husyzkaller, now AI-found flaws and exploits, etc. Generating work
for humans is getting easier and easier, and the human workforce is not growing.

(FWIW, many of us do use LLMs as a force multiplier, both for coding and for
code review. It's still a struggle.)

I ran cloc on your repo:

github.com/AlDanial/cloc v 2.10  T=1.87 s (1565.8 files/s, 466746.3 lines/s)
--------------------------------------------------------------------------------
Language                      files          blank        comment           code
--------------------------------------------------------------------------------
C                               306          39193         121404         284212
Markdown                       1195          22872            715         143738
Bourne Shell                   1046           6436          42299          82939
C/C++ Header                    222           5834          23461          37391
JSON                             34              0              0          32925
Python                          103           2306           3392          15533
Text                              6             85              0           6819
make                              9            102             45            424
Perl                              1             53             20            190
Bourne Again Shell                3             16             84            152
JavaScript                        1             10             13             72
Expect                            1              4              7             30
Snakemake                         1              0              5              1
--------------------------------------------------------------------------------
SUM:                           2928          76911         191445         604426
--------------------------------------------------------------------------------

a quarter million lines of C, never mind the rest.

Your project sounds interesting, but the humans here are not going to be a
review workforce for it.

I'd suggest that maybe you continue your AI-only approach, and continue using
AI to design a comprehensive test suite as well, and let any potential users know
that it's AI-turtles all the way down. If they trust it enough to use it, and
it works without eating anyone's data, then your AI-only experiment might just
be a success.

And if it's not a success, thank you for changing the magic number. ;)

-Eric

