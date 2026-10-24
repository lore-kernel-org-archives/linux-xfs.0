Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.156
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792866559;
	b=3/IMZ9Tu57CGZ4xYRuhXNaOhM/OOPxFUcYxsgTIP/Sa57Yu/IvNC8HafcunVyR1jW1+Q
	 GIC+o/UTTgfA6sRi1EyfiR7B976l8h02+7BLHDgM9Nj7P+Foz4LIjZxRWk5FJWnNKppen
	 1QZjV/gT43wApimA3jdXnCPtFZ8nEbOwCnUI9yqD3sDNFm6ta++yxeCUamMzPMA+ZW9LM
	 nz5fiWNS1uEYrbi3Q7rYnHZoq4rsjvD9nMeGUm8vZwgpK5ITi2myUn+Ori1jV1fZ7fBOR
	 E0gz0mmwQyhpE+bxKjVuAayBW/p+UgSPcPtOgMyXiS0JkCbGASEzn+2FG18Quqz5v7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792866559;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=S9E26CFj+s4USbIGkQ6WnMrVieCZ2Jg1/+kbhENovXU=;
	b=bp78EMZ6F2fycHthY1GU9yB7LUPxooiqeTLRQ5+KH4DM8qOPdw8tUbfOJKPUYUb/4cCg
	 ZgcOMQf2xeUY/xEyAW82kavc7sFsFVDRgeWa0dR5Ja8Sjw2EUaVIed+9fiCWmqrxxDs82
	 wNKJcqk40+Sx1XUHJ7cvqPTW25TxF9jM1lfOD94HYZKHpmukT6guMNVRDmHymPewO3FJ1
	 SsrNk14+dt91GSXrlpxfiPIjyDHNrVUQdSlTZy9F3kT7a4nLpugL7hqD4F3q+moVimW6g
	 uVigqacU1oRKh7dcHlkmpJgcGcq2+mEASr6kUTc58YwWQG4wZB6RHulgnkr8cR+OZRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=sandeen.net;
	spf=pass smtp.mailfrom=sandeen.net;
	dkim=pass header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm2 header.b=ypI4qrVH;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=Ewd7tGn2;
	arc=none smtp.remote-ip=202.12.124.156
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9B3606A31B
	for <linux-xfs@vger.kernel.org>; Sat, 24 Oct 2026 18:29:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC9B3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm2 header.b=ypI4qrVH;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=Ewd7tGn2
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id E840D7A00CE
	for <linux-xfs@vger.kernel.org>; Sat, 24 Oct 2026 14:29:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sat, 24 Oct 2026 14:29:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1792866557;
	 x=1792952957; bh=S9E26CFj+s4USbIGkQ6WnMrVieCZ2Jg1/+kbhENovXU=; b=
	ypI4qrVHrqgQOK48JqKCNob1QDHQ5Qu0ggNPK7XR3c5VuzPFXAoODtfGtEcLP5IK
	8AhzcGMfjvW9FP82M44QnguJ1F7BJD+Fdu8YtIjX7BmPnuG9wpQo+jXaWEX7/UvE
	PzQRYFAlnqMSB1oLOShtB61VH9CDNB+xhnCoA2pQsznDLr19esu4PbX7jQw70mdN
	iNl0Jkr2l4XVIZ150MAYP8LDVXyPxWijq3+XdaODGMFSUOKeLa2nvKISFtmYqWIQ
	EY64kW56EjtqxPZ6k2y+K/Apre3wSf6uGSPDxSc0KU5IJPI9nDqgajcBTNgY9gCO
	hFnYHTks55ItYT54fkJqcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1792866557; x=1792952957; bh=S
	9E26CFj+s4USbIGkQ6WnMrVieCZ2Jg1/+kbhENovXU=; b=Ewd7tGn2Py2rcrKan
	pRszXek+6DAdoXpZFwOx1wv3Hwm6dhzMnEs8q+S3nQqo6uYWXeE/jljMudfphJy5
	jSiibQasNBesawMiPUV9aePG7/OADchQ6KZ2HEXJrhXXxz711QCKSiIVN9D21DBA
	lI92vUy//YogAI5TLkeY/GphdwA/3ieQn7A9ncESwd8+IR81228CpRRLLFBYr+95
	wf7sHITHAC05enaHiaOUUAR+lrj1uL/ayEl7YpZ2VAubiJw0o3l8WYl0Sat7gDnZ
	T2Fg44SfFKQZbvIAFtq00EKzZOzzSPzcwLDBEesm+zcg2nWsylQ1Bayd3g0bCVNO
	j3kVA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792866557; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:oaL+0zP1wC1fB7aPpcFclzv0olVCPRqJ3YXEZKvLfrq9Opw
	QTRzH41d7YxgxNevRi2Nyk3rZjo9owOmbQhXX3Fr6YScLRUEpF9yfBiEEvdepWS5
	xUV4eu1VxCUwIhV7Pd8Uafzkfjs3dDZKHuc1ienYc6qXs2F07hgqbwo3ktkY8W8y
	GoYyg1qyuIiaEhZgd++m2nvqunvUeMr62Sk7tjLzifxZbHaOcu0L7rpDDYtinISX
	s7jG9zzBIZNNE1ggmbOwcKAUaMQ7y2qJM+hHucDrk5tMYyWzz7wL2OsXDW06pLGD
	j7nwR7w6SoXjR9lRaikAFvBDTbR2m6V+qAcGYbg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=content-language,content-transfer-encoding,content-type,date,
	feedback-id,from,in-reply-to,message-id,mime-version,references,
	subject,to,user-agent;
Message-Instance: m=1; h=sha256:CyxWdSD5NI1QFvmhJrbdCmUeHFLxIbVzf2H+pUR1gok=:S9E26CFj+s4USbIGkQ6WnMrVieCZ2Jg1/+kbhENovXU=;
X-ME-Sender: <xms:_fjcarKWtTTG91trJjxoNbUDrdmTF02mIdxjhmZc2xuUQklot-2jiw>
    <xme:_fjcamEqbYWs1l_Hxgpu58BdVxvbmhp564EAAIAPRobINDg0O7IqF-6BGitjembE9
    wTxtlCjVGkZYbjVTDROyh294PhLIMMiV7mFZvzsnlIJ1yRrq2V0x8dy>
X-ME-Received: <xmr:_fjcapWcHI8uuU99z8nUvfWW7VoKfxOWhxOX0NEP37rl_ok8Avo_rn-L0tB-3eydl4wno9dZiSipbfsices9ja3rAkqv6g>
X-ME-Proxy-Cause: dmFkZTGALDkRbkNjVlGtyqMNINQNY4o+FjPFKEYXkzSkZ7P8WzQQJ54eGFnk2mN23IBaqX
    JQb5HeZKCNHG+K9uTCCXH57N5zsiJMQ71HwOj8srB9Mc5ujTUcbU091pJVLYM+ocVIO3J+
    MJeOzlrXpMYT6wB+aODG8NnyHF8jJfFAriof4i9osPTJtHC6uAw1UtXrvEZRde1jXaCD7K
    F/R1XXEGgaZdgHIleeaSYcKttavomQrw7syMv562spcZRJvp8u1aMkxRq4wenfqKovIQy8
    OydxM/6Y2RKJdQh5iVxaXWvUnaQDqR1/QItWkOU27nSBHyQVj/wawuCmMJPHzNfj5EaQt2
    YYyVIL9cHN5+iz9vDSR1iHM08dcImqpzLpCHLIFw1P8tushwxcNw52OLbQnf+H/Sv1l9ZZ
    1rim7NPLCCksGAr196hxm1NNkhPp1hxo02WDNTiP4T2iSpkK+yoWoFGIygdXzaGjn/JPN1
    gRaf4NI8KDB5tcR9YNMPjll/mKoolIsLydBUMRwDJr7nN+bp/++Q/0S3cDwHovIwMXdLpO
    vsw61tEuer+jqf9KEnCTWbi0g4lB2sOj3TSEQmiPgg+FtULgGgTPlVGHCY2ILtJ0IbuwWc
    bbHnZ905+JpAbHDUGv8jk1fruVjuEXyvjjBIigcdWZh4gm1BOBoL1AYTKyvA
X-ME-Proxy: <xmx:_fjcapgKrpvhzwJKSb4Tz7hjqUr42xvL97SU3gsXgQa3yeUMeghbbg>
    <xmx:_fjcaiQI5NsVi9yA8ehXvoajXevtV-IZ1rt0aOgP9h57_W8bWUAz0Q>
    <xmx:_fjcakG8QvoivM-VoezKS5qKTUd6GzH0Pj3TvkawHDzzuXIUPOkzzQ>
    <xmx:_fjcaimXd3yTw_IAaKahTp2CotzZmN1lXumKXBpx0z11hbLstDEtOw>
    <xmx:_fjcagowGhLAVjsDyFzukEPeYYB5uVi712og9LXlnhOn8qpNsX3kq-bk>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-xfs@vger.kernel.org>; Sat, 24 Oct 2026 14:29:17 -0400 (EDT)
Message-ID: <c612bdc5-3330-4674-8987-69935e8c6159@sandeen.net>
Date: Sat, 24 Oct 2026 13:29:17 -0500
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: validate btree block level on read
To: linux-xfs@vger.kernel.org
References: <20260731120344.558808-1-david.lee@trailofbits.com>
 <am0voArOlA31WBC3@dread>
 <CAC_etQGTnVV-Jd0waUMfT=8-JtSHxnrQq9jJRDQBisX+1EHWWg@mail.gmail.com>
 <an-LhCZLN06ajjI5@dread>
 <179278367083.68413.17147250369624243185.xfs-lists-plaintext-resend@trailofbits.com>
 <2d24d2dd-b8e7-4da3-867a-a62b0dfc95f0@sandeen.net>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <2d24d2dd-b8e7-4da3-867a-a62b0dfc95f0@sandeen.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/26 10:37 AM, Eric Sandeen wrote:
> If this looks like the right direction, I'll send v2 with the corrected
> tags.

Sorry, I missed this part.
