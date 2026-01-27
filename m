Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FDF35C188
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 14:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525756; cv=pass; b=nbBN+moCS5+f/xGbuLVT8qbhKffOhVraRbhjfSommR9IdGW3/yA6HrS3EkUQR8W381L0qLYdMHfqWGiCxonEUoLwzfniaqpSBsF3EUfrv8FzftjIYhDU9hnawpaJ9inppFkZqJkvqFJ81DnfIEPQzN18tNz2O56f2eqVIm8mKtE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525756; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z+dswTdP8jIemaiMeIxdKFCj3PpX4HRtqP0TJ1Bc73i6TZ2glmRiagKDSk9G83EMGcusj0oabww4zqC1VbJJCx6OjmSSGIcuTxnnlateOxCCAL49wC1TEMeuwMtQGCQgRONPkWruKCoUB4NY8dqiMQ5/ug497cY8DVpDLBkBqKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YfDWTu68; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YfDWTu68"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-655af782859so11438733a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 06:55:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525753; cv=none;
        d=google.com; s=arc-20240605;
        b=clJJTuPfk+lVtC+cBZhymw66R2Q09HwJ28r8V05nBi9PUHjXAgQ6jNYfw2RlYZ3jZ7
         UEWo4Wlz0+8kIlDRA1hfg/ujJNkUVXPy/ervJL/xVG8KBmUg2/p61R67Y3i3ZShxxx/Y
         i6jaiLIjt1M3SJfVGCw5m0PassZrqhuijM4/2E4IMf+Kw9J49Y4GPyFzTrSC1AKUeeom
         DgU0KoWADyvhn+IyIluTrGrHScmqNcP986UFqNexP3sUGG7vm2MS2Li33yc17m/zsGHq
         +zulDwTqwFLiignw4WzMYdHjB/9ApyMv3WjnJEvqF/OP1mjYC1/4SGsCf43+9Ao4suv8
         6H6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=JKKo+EUfGb30PvOTIMgIp3QJGGqxOht6xeuoY7Bkjyk=;
        b=BwmZA0K8C7ScIOCICxuskucETY6JQjqGD3IlfJPodX3QKG3SLRR+HZsAUdLsaCpaT0
         BeSmZiU2rS7hyJLbhzPrF3gtBitOBWPn+hlXRzeG4MbT6hSzmuNRDrZfESooLb2RLaRd
         dqjB175yM4WpnOS3VVYUH08mD51dP0geCR5UQWgvk6n6C6bMBTLj4Anszv3LJKeISfj0
         jFZF5vtuhy6KeJHV+KoOoiG5yyj2qmWyZSJhg3afN7L+Py7S5dKo0WRuWgBuVTcIGYcj
         QRrp/6wi+1SRtzeH/itG98RId0wZQ6sMCBsGV5q7tme83yMx7CPKXJXNuFyrW9WANIgw
         TtLA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525753; x=1770130553; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=YfDWTu68rfjJPyRNgFqZvPZYxub+lCjaRdoiP3hCroWvGiqPsSxOw64HsiYAuiz6m1
         Z2EWpIzmQbewlKMvPMz7HCYu1Hmc8UKsWZeJKv096tQTfIw/qRA9FbRk3guXC24sTWL1
         UF84T6rTf3PxYMgUZ4L5GpOsyTs2qqmlbB9Z0pNPyHm088T+oWw7N9PHVUqMKVwCTCJu
         FUvWofElWIR1YWK+VU3MCP+YBPIcEuEaK2OBaRq8D2bqgefWkkKz1xnYfJf9t2nxoeUK
         BrvU5k83P+iePMimd9bAflS7rh9K1neP4UfWe1z6fZVq98pYdPl6mJW1PHdfN4jsxGIf
         OVwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525753; x=1770130553;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=pWfM3FGZXBZdzdC6UlT0/6GQNKzG4ZriwuHoNaVVFOWyNxR+TjuCZhmBJUUTwNm8kF
         js+dy3jDjjz+2CLyQwX0+dcnIFBF/OP9RSGYdjVhiKyURAliOUgu+Mv6D/E0e2ZZIoye
         jkDrd+xY2cWPWduwEWA2brlXM92QzoBYZTuJa671GJYvy76jA/kYyiHTIercWgGy4L9a
         6CArHwKBAWXXjhgHIR2fSascf9ywFzz/dhknwtDX/SOMz2AJU+ewbPO88vaxaa4FQFY4
         G+ARW3609DNA5dyvUiddMiP/HG8wp06MIfckuMU++ZPo6euSZiPcov/XSUc6iEBg+SzF
         6ymQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWWwsLld8fLxOPI5PrNvlkvWoVNhJHv/7aagsg2JRVqniZBbuS9LqtTwfsDaaJsVHnPigC+lJCwjI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwijIRS9vy+fez/rtWYNAzalHwKYTAdOA4scbnj6qssAfI164D+
	20lvJ5V6G2zLTZHO9jkT4vPHbghlU9Ihh9R7w9iVZmhJExHfdCMPaImNRM3o8cDHq+e/lkaUIlt
	SlH5IzBCX/8p6tShyF6WIff/lP7dXxA==
X-Gm-Gg: AZuq6aKxiOHM01jEoZNVy1k1QbhfwBFelrNNSPNnExtiXpbfzCL7Oome2JCsYd9mM28
	PF/aqrytspQ14BoekjCR+WSn2W9j1Fh3gj8OI44J1nTAGrJhIHn5cgSiVjpZsZ/j74dL15i0KLA
	BUDPaFbdN0x/8jz/AGy8xU5WwJw31A2QqZErkaA8oT9bs4Ds2sXCYSCmXHURVSRL/y6Jq6YNz9u
	ABGhmZtXB4BilUx0XzkYS4us8NAGqc//5q8d233Ss5nleVO+ac7qiJFC7rOJgtSnxPl7veT+xSE
	PMZnxxyPK8KJ8cvWsXCsqufP+Mu5hwN+Dvt+8c/O4AQlM355uyMtqXuL4Q==
X-Received: by 2002:a17:906:fe07:b0:b88:4b1f:5b1f with SMTP id
 a640c23a62f3a-b8dab423cfamr153134566b.38.1769525752488; Tue, 27 Jan 2026
 06:55:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-2-hch@lst.de>
In-Reply-To: <20260121064339.206019-2-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:25:14 +0530
X-Gm-Features: AZwV_Qh0N_xMlo-Jek-4Bqvm2KfCqCHKR16PVHuC2EtfsXWdRHcPY9i5RteQhPQ
Message-ID: <CACzX3Av31ZUXb9mVGkEm1=+gbH8SFeCd_k7hG6MD5MHosWKBHA@mail.gmail.com>
Subject: Re: [PATCH 01/15] block: factor out a bio_integrity_action helper
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
