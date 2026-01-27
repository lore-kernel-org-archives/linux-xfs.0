Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597743559F0
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 14:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525820; cv=pass; b=C9uNBil+yf+Xcea+4RESWa1ipKwxX1I900cUzZBN2/UTOnXyOK+V8u1Lg5KYlWkynWyvwHNF67F2m6BrMfCc3ZPYmxbadWaiFUm9Ue6jQ+Kv0AAQEgbcsf2SiYyVcJTbs8YXDGQx1XNkCIndhTi2uwYvyyy6cG8eGfXfu/KsjF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525820; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ULszpCLD6XfvOyYN0T6IyiKAsxwGiOXjoTpWT3ZwfTzkpuVQCi2cCJX/hiHVA9r340qdZAIU4cQKVFS9FMuZ0b7fz8nwM6uoRShmqM0Cd9nz0Oa0isWNCo3isqI6FmZZXDsnm7NrcMd5SVgQEqwt+QOFgy7pGK/zsCDRfQtPo1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MGVcs7J6; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MGVcs7J6"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-652fdd043f9so9840344a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 06:56:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525817; cv=none;
        d=google.com; s=arc-20240605;
        b=AkWurOQndGNIfQZ0oqiHsfQcFMxfAaSsRcoT9BXYC4aO9DuUTWb3EZo08a2ZjItkwu
         fwJPBdLtTlJCqLf/aGudEcAgLz6+ANHBY1s9a5RtjL4VR8Jj+9wRwxUTGlawVF7/3/Dl
         xetwpycJfkJ9Yo8Auk1AxvazAxLcJtwASYWz/bWpdZWxpOitOnoaX5jOe+PLMyUX56TK
         PMfDlnqNgYggEmRznJ1l2fEAx8MtQ1PTGPuFGc5KGAjanhRFFoTgZIdlX3djWe87l4VC
         p11aiXa5Li5auUnAbuwCPNaFYEjSJhfU1K2Lz4Q98uu9qCslWMANBVYX4IXVRmB6xQoM
         Rd4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=7tS/dwUOazeFXGiAtai00E6Qp3e7nuM+HTYB6n9VFZw=;
        b=j38f2vXjRnEPm20eTV1VoMPk0bZ+mIPGpVAZ0mdbj7zPWAMczSQcheY0ZHFRceJIJw
         iM4n7E0M4TQoQ+qBfrCNm/eB0LB+vcep3BvMDLeRno/biomx9mAIhmK1rdxXvtQpcaaq
         Fz2Vx5xnEBBNQuHHL1hgRwF0RSubXJnMqEiPpuCb/rMAyKiyOe6tQpSgC1eKr7yzcd6n
         f+vnsw2RJM58YZA4RfGo8/QTqaiP0DyXP9TpJox9Ub2kxhK6uyx/nQB96IESpKongiM1
         f7I9qbJ6MhjqLXAwx47Jf6I/YrBkgjPLiR59B4qzn6iAFiNnY4T96Wbx+08Vc/rFGJGS
         p48A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525817; x=1770130617; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=MGVcs7J68ktxy9ICcsWR2V6AWM/FCmhb+JcVHOsy8/1lUYI5u3hh64Txijg22Mj8yl
         hA1dS/XvhOQRCr5Xyc7CFdlRyAmbSDTR/11H1W0wDhAlx7dEfQeW/xFkm35QSc9eHkMd
         b2bGDbcKeUCEOmOE1afLn+OgAJtmAHyRX0Tx8vLkOSvf9uJM7NPbi59Z8LKoYER1Nilj
         t6mswqQSR/B8gnzXgSLSPYcSpJZHfclekhaAiS4ejVnXEJ+MVaDYz7df0tKLfETq6q8K
         /X43u2T21VhlqAWxcEhbfo248SQzs9o18+fLsRThiKULs92JUMU5Mc8cYcm32+sUFEts
         Ha9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525817; x=1770130617;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=lsZ56wFiVP+H+P8gTyrGW2ODp17vfsaYCq7vjmCjlZvBeSg4zu9aLdiOgb6mFggntk
         KbCeqqUwMyleq3syBP/wKxultUDd4hF95sqKqWAxzF0uEXhTClaNJWFYgijKDnkfCf6V
         ElR376LmCDVxdaWwJ9R/GKee/Is7DEXIgv3n1L2WzMaOIptLZeQodUFLB1TjJmBjicrW
         fexchJqGi07QXPWg+LcBTBjzmuxXAe8uL/oQrQ+vZZlW/OU6X7UmatxHJjUAJHSoeaNV
         W4LDrHj1dy2qeqI5o53Twu74S7BPpYWes6/h0gIOrK+FCWNXTGE30vqhDE0SQzCa+Zzn
         z2QA==
X-Forwarded-Encrypted: i=1; AJvYcCU8tD+9flWp2jlXEdLDbEgJ16ZL3hA6GAsnZacI0wn3vztipyZ5cPVwxuEFMawFy+ga+nshJoggPhs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1o4BjEpGpyZVTysjpHkyxOpQ5OwZ1JuJoruPfYarozyEeKAJS
	0ynFFs2PfuXQwaaAtl9Z2LfIpJC74Qn5MZMzZQa3b6BuqxRC3dom2MKHJKhUlv2uZDndKJnfps+
	oBWchzSI7Aht6z4CpV/yIrcsn5plg2Q==
X-Gm-Gg: AZuq6aJcirztaPro8gW6tleQj6muM30n58dLyE2mHsCCJlVbRQM8zsORQ+NFeSpv4j5
	NZGWC3ySXMH6hu3+fY0d6FY7sPup3VmpL1RH2JcL/liCWNf6/5JC2ovwei8LHXVGXO7Ltkn8BCG
	WVR75DAa6Yg743jXXjPo4dE6VFZeSP1WFTdG51NqmpqkI3HVnlLXrSkbRg9j1xlL/ajUKGGPqyF
	6znRQQdp6JSBBqzbKcaXj/IqcFrO517MD6NLLmYWBDW7krFwBKRKLjSabDqwYWNDQvwXcoD5Qrn
	k//Q5SXS7uilvMbYdZ1Lkr8QZsATajHcIlsAvKaZumQP0n2yQEdrpLhD2g==
X-Received: by 2002:a05:6402:13d1:b0:64d:23ac:6ca7 with SMTP id
 4fb4d7f45d1cf-658a6083d59mr1404674a12.20.1769525817398; Tue, 27 Jan 2026
 06:56:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-5-hch@lst.de>
In-Reply-To: <20260121064339.206019-5-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:26:18 +0530
X-Gm-Features: AZwV_QiDlPiwSdA1exwb_wyngdPHkJQcFo3xsAtPq8Ggx0ZleakNb4Ga8U4ZEd8
Message-ID: <CACzX3As2YHwiBXwHBTh-QHTc9g08V_tkBXqUsKCin8UfrgeLuQ@mail.gmail.com>
Subject: Re: [PATCH 04/15] block: prepare generation / verification helpers
 for fs usage
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
