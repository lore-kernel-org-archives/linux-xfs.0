Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BFE4C6D;
	Mon, 10 Aug 2026 18:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786387209; cv=none; b=oGiz/ADpgSi6LOQabExtG6CBOm/hLLJIUiaQ7PNT2HT1IO6M309h0/JlzhPwjJ6ynRHm4xKE7TD8TMorILMFD++RF7fiocKZisHkq5jRjeJ5SH/Uf3uVrzg3zYtZA3ZmPd93QZSpAKMVZLX/RfuOK1FgLOiOVLHtJ6/yjCqSmf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786387209; c=relaxed/simple;
	bh=VZDF07HQmdOnN2sN/Uo6KVRNEevvdKEeriZACRb7608=;
	h=Content-Type:MIME-Version:From:To:Date:Subject:Cc:In-Reply-To:
	 References:Message-Id; b=TC7kQFBXUgYjZiWcSNbIpCaWhYGsbjHbTuTZuPMOa4rFycaDSUfC4RBIoLYuBPGiSbIDqr3ksJQxFOLdMCm6yg+dSD3NwVEKLiT0IiLZEfHDJPD09gA5xRFuOWnfGS2FFuBQtTrxfPtRjLwdcjM1bQGjlCEA31nKgP42UkzEJf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jetm.me; spf=pass smtp.mailfrom=jetm.me; dkim=pass (2048-bit key) header.d=jetm.me header.i=@jetm.me header.b=FEid5WYM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=FQb2LIp+; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jetm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jetm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jetm.me header.i=@jetm.me header.b="FEid5WYM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="FQb2LIp+"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 9B2907A01C7;
	Mon, 10 Aug 2026 14:40:06 -0400 (EDT)
Received: from phl-imap-07 ([10.202.2.97])
  by phl-compute-02.internal (MEProxy); Mon, 10 Aug 2026 14:40:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jetm.me; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1786387206;
	 x=1786473606; bh=z6j8fSlpBqFv997t8bdY31W3KC1LzvCB35QfDHMbQVY=; b=
	FEid5WYM6QnC9/rUQsiAXn/bkiD1hTUG6r0vIxgnrP1SGla6MK3viE2NgA0BfGMx
	JClPb8O6C9eHIlCdgqEmJrE82jDsQ/g/RSAYIwBiZ5uf2n6DmE8WCMlgbPx6jpQI
	ZM+1C6MJBjoWc0az5h/ViO+1KCXnIVhA73JVCg0KJQs6sum9DLjrCHd2/Q9bu8gy
	i0nae3I/b4jQKvdljfZLXPi9sq2pVeH23+IY/RLHamrCtL+0stMEtGIdMU256Kr/
	CS5tRhhF7BlubeXjPU+D1wGjL4MaNGGO4+/4QbHtWv2j0MdfY062ygoNWxiWbJ8w
	20xvLueei5US2GlNiaj2+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786387206; x=
	1786473606; bh=z6j8fSlpBqFv997t8bdY31W3KC1LzvCB35QfDHMbQVY=; b=F
	Qb2LIp+FZ+PhXgockmZib48IOVRdzXnCBGKhs8o3kNYRhnTFPFxaRbeq1kQ0tdUr
	eoGOU9xtj6YV6oGcGJCTVAVIlpH5cZwXaivOXA0Ovxfqt2lIC5dUZuHwwtry3K3B
	6eM9fW5jkg6uw52pQjo8gez3BBk8gp/qhdP/ukvtmBzKshBO8obkFO1vgEA68ZL1
	n6YFuMpt5x0klqvnaTsO5iu3ms8Lhs6eV4zMiod3Zgg4ic0H3bvjxF64oQB/JzK1
	DJ7P0rp/OYWfvMsKuRGHpPdBpFMCMT6sy9JUIXDNoBdWHjhrEbbyc64WorJUZLgP
	ywqS2CtVzAvuoq9zNcN8g==
X-ME-Sender: <xms:BRt6ao0Yu589EfMC8_HixG6PMqA_cX1FmoO9EDbxNwxHZZFlz5J8sw>
    <xme:BRt6at71Qt5gus12T2UMXd1jS1wOZFioUhacHB3tw6J_6oUjQlI75C81XT6xn4v2s
    C_gMYXd9VS1a-1Gnht0QzmC90istEM_38busNcdXyvBVRrz04iwWSY>
X-ME-Proxy-Cause: dmFkZTEel5OAEW+4DC4HCnj/5M+qZWD/NXQT/wKYcNblI1KtJy+0SWtT5wvVtpyBsRThLv
    kkaCKw1ewT6bko/t/U9zK18vaizw+mlCD9xbCqOagphYvDqzzUXv2m6dKcnbivSDQiYFy8
    Pal1yuw6zpfRgLTPhrSaCOBF+3TC/nr0IEBAdDne3hCDPF4uLsEyKMM5JpAuqvRx+Jg6JO
    wm8bijzvUL/t2YzavCZ6IUiO11m1oluDgSJ8wkoGmZMl7WOfL2AIPrLKXCWjtjNs73QPjM
    6Io7tIo/1ri3L3+WaRv8Lc40ft6EHRRgu0S+oey82dwPEv3dJnqBCAFExyM6JT2J6kinql
    YDgiASt29cOOVQwLwrpfW4LtIMwobsnu05mWiXVhtdEsRrgpvz+383ji1wMSLo81XgSgyZ
    CvF5ynHMWDPzxqH4mDnbVbAtnfLvYEX0yolSHL+jG5Y7rmffMiMXrDO2SoWUKSRd4AYaOx
    dM5aGYyDpcSWx6Mt0B1typgSW3UHnDLYO6ZOhUpkAg5msYD9aehuPx5iexFTqhE2KwM80B
    iDu6sdce7nEESPFljnIvqep6hln9tvhUPMPHaHG5Y8t1YRwHacjdkUcFvmJ19VYtp71wte
    QpgaXEVBAYZrcdbAi4LoDRPQ2NlOmSfL1cjbqykMMAe5JaDlKwqJS/p5TQuA
X-ME-Proxy: <xmx:BRt6av2U-u14r5rf7yZ9FIl2o_Fti0kdhnvD_i5UqyHb4H_WUhbuYA>
    <xmx:BRt6aqqklKwbdNkh56d5VwlTIva8sdWoEOnRXY_to4ptaEZF-kHTCw>
    <xmx:BRt6akURmbMYLrPcTrsSC7nDsO1hUC-XL-BVIwC0bOng1ooiC3msZQ>
    <xmx:BRt6arpZwe_Z0mpA1OkcVMrZLcjddfZsvn3_SdSk0ZMvrT-amFVAAA>
    <xmx:Bht6ardP6hiKQweCLbVR4feDgiuuH9yS_5KWPki_MDsJ3G6DXDsiJxk4>
Feedback-ID: i9dde48b3:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D5E4D1EA006B; Mon, 10 Aug 2026 14:40:05 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From: Javier Tia <floss@jetm.me>
To: "Darrick J. Wong" <djwong@kernel.org>
Date: Mon, 10 Aug 2026 12:39:48 -0600
Subject: Re: [PATCH v2 5/6] xfs: initialise args->total for parent pointer updates
Cc: Javier Tia <javier@peridio.com>, Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>, Allison Henderson <allison.henderson@oracle.com>, Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20260810180802.GS3556460@frogsfrogsfrogs>
References: <20260808234016.246054-7-floss@jetm.me> <20260810164312.960721-8-floss@jetm.me> <20260810164312.960721-13-floss@jetm.me> <20260810180802.GS3556460@frogsfrogsfrogs>
Message-Id: <20260810184005.D5E4D1EA006B@mailuser.phl.internal>

Hi Darrick,

Thanks for the reviews on 5/6 and 6/6, and for catching the args->total
placement in v1.

Noted on sending revisions as their own thread - I'll do that from the
next one.

Patch 3 ("report the error that made deferred work shut down the fs") is
the only one in the series without your Reviewed-by. Would you mind
taking a look? It only moves the tracepoint ahead of the shutdown and
logs the errno plus t_blk_res, so nothing invasive, but I'd rather not
land it without a second pair of eyes.

-- 
Javier Tia
