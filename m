Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F452F1FCB
	for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 23:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764114090; cv=none; b=Wvy+nynj+SuA2EYnjjU2rptKMiscpQRQ+QwcAC1JERdv9/YCf4kDKxRTBlIeGxEgMbQvGSpiITHeKiUwAvuohzF4OlGdDoCASOgJJm5D8DBcaljgUmXshQjOruRQo+cHYH7lIAfxjZ8faq2SM8/tpWbYxXp5kV+jY78KzMJXTY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764114090; c=relaxed/simple;
	bh=gWMb0VoUFPvI9dqT/ScM08+SFgSz52WvWw6dKZyzkX4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cuwRX7WmICnv/u91P/WsodFx5YPRQXG5mmcOgvlhIrmC4R/PLHD1kEYt45nvgqcM0VvwW753SNVQKr9zfYfglEEurW2IMkwpbGaclo0piWil+rOuE8dRz6r33+9CSRpX1s0XaTSQparmw1Xwrbob9L1GEcUIiPViCMOogwtjw7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bh2eSTbF; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bh2eSTbF"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-340ba29d518so3850676a91.3
        for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 15:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764114087; x=1764718887; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gWMb0VoUFPvI9dqT/ScM08+SFgSz52WvWw6dKZyzkX4=;
        b=Bh2eSTbF+S2eJFmwCc1VKmsOxCMxgZ0bmxzfMfQ9jvpx/Uuu/exl9YrXv/CpYqrHPA
         MDznPP3EecuhDZxjOAIPcy9aUfePrAG1EUyAmCUiy64KsvYcFDoSKCseaORNt71vJ+Hq
         Xh+BYWayuqLVLedpm3/lQuvzYyqOoQymqd2HoBkBGfuHBmF+xj/ZaaSIhjHp2CcGjNOF
         ACSYynNugZr/MtNQd1ZesmPTUP+SkLkRvXqz0jInKZjs/4Vhj5MRmpQTnvHtd9MVwF7e
         GZZTTMD/yIUzeyFr6CeFH/mqtlwjLxDx7REF+C36qjFfi+Q24Ssk0cM8OSJGS0+ugu1H
         tFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764114087; x=1764718887;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gWMb0VoUFPvI9dqT/ScM08+SFgSz52WvWw6dKZyzkX4=;
        b=jyrPKvhftumnezxClmalAkeHtuZoJRCVc1xpugdG9Orroehwo2hcAdtGgyYmgFGUr9
         BH7ChZcQiEYMr0DzIlp/iQcgMKVd7nXpmox3CgWTlmEmImwJXlYexN55Sqfb9EOs0wkB
         s3CbYIMPZ4q/ZK9+9VTgwtJMLkBuyAxFg7LNmBM57qoBVBoa8OE4xoPVJpG3UF8w4qM/
         nbZOA9kpE26wy4ktSNOa4woeSrkXI3g5QPlBdIqodv1WxN0lNUeQiqPIgdk7IW1ZCAY/
         bo3UsQEbYa5aDW61ydyTOw1/d1KjJg7ELHqqWgGWH1VT7vokZkzf8OZevrlycNMpkjk1
         eOLA==
X-Forwarded-Encrypted: i=1; AJvYcCXYYW3NrHhnfN5G93LzYyYWPrpEvUgTq7MRkl5SdtMSJpgq+9V+l8Fw941ZS1BBlVXuXp4A5ilGqnI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww7QhaP/KSNPR2Kwy4k4dqgz9plfPj3Bws1Zqld3CC2UFnJ2xa
	1ZqBhi6CrGUA/QW3+CGQBajhFinjAF1pK9/wCzNcORDlk2e4WeQzOPDX
X-Gm-Gg: ASbGncu2h5jCjdLeqr5nJAOaa/2mVG6dLu/o+wslT/apYTkDlAHHm+qd0uRN3gR9H/Z
	oC6AmNN2YQ1aFAgAP3se0kjR2nXdfjY3QGP5iO6hU+jqIH8p8Ccj4CZxLNXn2nic32jw1s+qp4D
	dcUJVofrHwDbEsOsPR/xL9iwwB6aJEte+dYl7Fcjj+v+A5h2PUgCTi/Ver1YU9rbkoTsFNUx1MV
	6WvAIUTkYE7SXh0yUqR3oD4FFcdJzDQFSnAm0O/4SCz5OfiHJt2wY7MnZLup4Aip3dKmu2S+pZp
	qe9OwivgtTwV7mbGVmoT7fUVHeQWpRVYaj7j6a83PpLGbYTsN+FM3KdCqiQh7ddT64RaVKp9nPH
	ivY9opIKHTjFbHX9LOqjLZ13vfAmNaiZ/1vOxW7x6EY7AtWPMIiytxz0THEM5Mvy3G/Epmp9kRb
	S6bEJDqo4pUI0eYFQogZfUetdm3oIIwjIk+5Nzag==
X-Google-Smtp-Source: AGHT+IERAr6ZaAk8N2XfP1sLPZ8ltdcZpy2by33AewknK2HCsGdLuO/dThk3nDRSpzRLveBkNTfbCg==
X-Received: by 2002:a17:90b:3b41:b0:33f:f22c:8602 with SMTP id 98e67ed59e1d1-3475ed6ac44mr4636649a91.26.1764114087385;
        Tue, 25 Nov 2025 15:41:27 -0800 (PST)
Received: from [192.168.0.233] ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f0e6c9bcsm19291748b3a.57.2025.11.25.15.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 15:41:26 -0800 (PST)
Message-ID: <2f356d3564524c8c8b314ca759ec9cb07659d42a.camel@gmail.com>
Subject: Re: [PATCH V2 2/5] dm: ignore discard return value
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, axboe@kernel.dk, 
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, kch@nvidia.com,
 jaegeuk@kernel.org, 	chao@kernel.org, cem@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-xfs@vger.kernel.org, bpf@vger.kernel.org
Date: Wed, 26 Nov 2025 09:41:19 +1000
In-Reply-To: <20251124025737.203571-3-ckulkarnilinux@gmail.com>
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
	 <20251124025737.203571-3-ckulkarnilinux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2025-11-23 at 18:57 -0800, Chaitanya Kulkarni wrote:
> __blkdev_issue_discard() always returns 0, making all error checking
> at call sites dead code.
>=20
> For dm-thin change issue_discard() return type to void, in
> passdown_double_checking_shared_status() remove the r assignment from
> return value of the issue_discard(), for end_discard() hardcod value

Hey Chaitanya,

Typo here s/hardcod/hardcode. Otherwise, with the split as other have
suggested:


Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Regards,
Wilfred
