Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A617B223DFF
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 04:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791951753; cv=none; b=QLwtnUEzoB2q51L4mub7bxDW8tqYbVhL6Kh5VDWVJHAkC0YtaQKIQz8Bx71vAiBN5JZ110cQZ72tpe0K4Lnh0JdHgJwY9Qjy/7tZExUCvnpDvDbgi87VpV8rKS8uHKKYwjWIos7FrNkm4Wg9qfNQlEXk9t3uC5iHMPrJgi4B4zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791951753; c=relaxed/simple;
	bh=NeTbrXsj8Qcl9G0F8kZ2sjE55p6tOb2pTezu+eD3eEU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b9tc4EzOT1/U0fEKrRrsoOkMccz6roqynRWyCcHSywCYZGzieiZ5lENPLwsRC27GSf4RgGk6THAzC+2IRLZTgQ7vBVNWemhISJzWgMsxyt7eCBdEs1HkIenjPXh4HRQXCEAVwRpS/W3QnA4tnUTkxEiz+b09HnN2FNfD4i37LbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=SC7i/lGe; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GQJZV29a; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="SC7i/lGe";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GQJZV29a"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B66EF14000D7
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 00:22:30 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 14 Oct 2026 00:22:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1791951750;
	 x=1792038150; bh=qJ3ttwl5WVN0PuYYARiirQarYBQJx4FeYN+wo5uKkZU=; b=
	SC7i/lGePVh03Y1xh3AduitlxA2Pn9vA04sVQwv9errd2fGBCiXCsw/Bs1eF4+DN
	1EmsLqHZ+6fOoh2CjXFNXDQvHKi5Sdal3jL3puSslg/uos/1fPW3ZBbVmzn9QtHF
	wjSSFh3nKJjODAZdvU35ziWHcRU3RqC714SfVZdpJhc4M70pnV/SjW9Kx/5kPLz6
	79undv0fKYm1g6zZ3WTR7HyDI0GiBGfokCxGB2+C+zmzjVA8pZ4yXU50tv37BRfl
	n47OxsKn9UK5+BZSnVe2AB7iPYLFY2YJrItiQnzQ44GDJ7Srk+hbmM0Zz9eFWjdw
	OeJYqbvGc26QUB6j6/TFYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1791951750; x=
	1792038150; bh=qJ3ttwl5WVN0PuYYARiirQarYBQJx4FeYN+wo5uKkZU=; b=G
	QJZV29ahO1xoXflgasTN/ROXfesQAgcavfxfMwYAm2cRcalao5PyDID1XlRLnKz/
	ZkAMwaa3h1867rngz8bF2gt3RDmHGCctQ2OW8dfmQ2tIFB94Oy/w07eXCFcrJpXh
	A/zAlhWL8xYqNhs8ibX5PODTmTJe9/xf6BBBTdwPGXobLy7TcN3/hDdA22xXJeDT
	20mFxqvC7LRRu2xuUEcS22snEL8FNsHOcEfOk8A7EIgR4UIWRn9WUPCXDAjBsTBK
	FQNGzzadWI0i5/ngRrMKvZ/2+1NQLAsPPCW5NLiViNSp5BHaZLFbHv5WJY1BEEAz
	lEgG70mxIksfy48BGHQMw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791951750; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:IpMgH1XI9S5ZPU6jj3aNHu/l/HKJ/45yj1MyFX7IdqDBJom
	tVYMPadswPeLY31JW1OIuRXKb3GDZJzbcGnUoik63QyLib6by3xub7gkxO5AGOAU
	EZklWcqW2GYJhvj/9djewPt20EeDTuKFk+AQ6HS9ZTlZCl7QnYKm10TlXkMj4uWw
	UFClzDGmN5VVgCYJ7XgSkOCrsa+uZw6DrM/QIhuiZYCokJZ8wR6uY7yTeCC9n9Z0
	WtF5xsu/HXnXSYdOFxtIZbTfR84VNGp5AFW5kg2TRr3f4/pITKu8UZRpEA4wHbI8
	TLKg9Hc54VOUw/wRxNvHvmUT9zgbcMY3UrDCduQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:wcEeeyKNp84kuqz/4SVSibCvk/tsUWuSbZiOZsRKe5Q=:NeTbrXsj8Qcl9G0F8kZ2sjE55p6tOb2pTezu+eD3eEU=;
X-ME-Sender: <xms:hQPPauwHQIYM1L3mQnbIwCAtReG4UOriF_q7WKZbxeLgDI5E1IIg5w>
    <xme:hQPPahJOHsF39AKhCUDIfOXC06RJXmmGs3GDhfuBB0yZPLHNUMHuXXyXk_Sqp8_gZ
    c97uOy_2aTHE_xTz7mbewyrQ7ajtA28LKXN89XA8_RR3fmQI8pqIpU>
X-ME-Received: <xmr:hQPPaor8tatdno7QJ9IuJi3S4MiX7rovYNycEMkKe6Zali755Gqa76r_W9N2_Bg7uOqX6WHcgglEVGBPgq5eVbd1JP9JAQ>
X-ME-Proxy-Cause: dmFkZTEsvUMTxurBXK5sGbYWQqFzaUqhWrfQhjQr918vrhxjtsFFJ/C3BbkUMwE2HkcNnu
    JB/ZzsIzE85mU6hZcUrOtkv2NfR/f4rqLRJcLJSsNe4V157HWRQkYmn4P4edHF5KzG1e+e
    5Na0K0fzrMbQ+g9GbG/Sv+pwyiS9K68okVwMrD1fb9c9ZhBStaXI4Tj8xNGx1Lr0OFhlHt
    Crp7kOssjapvg4b0/YiCY67Oq2wZNTxDmnmnSQ8mXXEJ8LzwgJjXH4i9IlaHlmYgSWv7ny
    Iwurclr+WYncfZuwezN1EH/RpKe3L7WKp0+DoC2B5+ILmZbXOViQpZYLNTuXahG4kjLYYM
    lKNGv3wPuxnt3ZdEv+lMq8cnRsSY2DONnTRe0PNlpRBK/S3zIY/JSV4dhT+WVOWBsf2UGz
    8CG++2O1jMFt7GpzKswlpf2o9kFOAoB+alrfPSHAJBTDrfwvS8vaCs7rITleCXqqXdYARN
    O54IWHSAW1PzQFMvyT0jaB4gvB+esd4PZyjYgiHO/NhTdSdqZKQG0RQa0LUIXm/e4+OP4c
    SmnFk8whFGVH41On0TkGumdtq8BezNvy9MFBBBWqMSuW8CwtU4VBERqoR6aT0dWaCksmgD
    kvBcGpxDovA2jmloNneYaqlUD5kHo1uTezaM7O6BaSD6sovxRPhpSFHdPxNg
X-ME-Proxy: <xmx:hQPPagKtOZ4xrtIyI5mFOh9JAak2jdF-JsUV1FiW1qF6QVaezG9r2Q>
    <xmx:hQPPatQy7J5IG3YoMFzFnlRBSpffeKGSiZ0Y9xlQ1kQjV6s_23wHgQ>
    <xmx:hQPPavt1qJd9Afz5mZXjNr5a7RqkCzKJaXIOcYDuNRfuWYC2YwcXVg>
    <xmx:hQPPauYFV7CBGRRl6qosgqNkz57-rckNtTCnbjon15uQjwb1EOk9Ug>
    <xmx:hgPPat6bsZX18BgzQt00HOS4l2G4UtjU3EG29LPoAgwl5xFbxk4BKX8w>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Oct 2026 00:22:29 -0400 (EDT)
Message-ID: <31c9b298-886e-4bc2-a824-7ab190b7a0ae@sandeen.net>
Date: Tue, 13 Oct 2026 23:22:28 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] xfs: remove redundant stat checks after
 xfs_btree_insert()
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Cc: cem@kernel.org, djwong@kernel.org, hch@lst.de
References: <20261014013505.759089-1-sandeen@redhat.com>
 <20261014013505.759089-2-sandeen@redhat.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20261014013505.759089-2-sandeen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/13/26 8:29 PM, Eric Sandeen wrote:
> xfs_btree_insert() already validates its own status internally; it
> checks the result of xfs_btree_insrec(). If it succeeds, it returns
> error == 0 and status == 1. If that fails, it returns a nonzero error
> and never even updates stat.
> 
> This makes every instance of the 2nd test in this idiom:
> 
> 	if ((error = xfs_btree_insert(cnt_cur, &i)))
> 		return error;
> 	if (XFS_IS_CORRUPT(mp, i != 1)) {
> 		xfs_btree_mark_sick(cnt_cur);
> 		return -EFSCORRUPTED;
> 	}
> 
> duplicate/unreachable code at best, which is good because on an error
> return it would have tested a stale variable.

rereading this, it's not very clear.

I'll tidy up the message somehow on a proper resend.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

