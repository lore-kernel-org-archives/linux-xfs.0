Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8885042049
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 06:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752734580; cv=none; b=ZvuGIAz4/QM2eYlc0hO1KNumS0XYfSHPeLW67OatqWyEUhVPViy3tDERhTNrXcu/6KJIaf2uD3nDs8BayrPMXHB731YrdEcPsoTmdlM7UXTc2AnLJZwnY+xyyFXxk0Wh+eneO82dhUUGnB+gPs38+C+BLZX1WNEqiw5NcUqUGn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752734580; c=relaxed/simple;
	bh=Kuc4TAqvrnUn+q3qyWlV+xuG2GHLI6CswDkKWksHg88=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=jq0SicI43/4ztPSwBv00RBSr+/gJAkLIwY2UuII6gqlsP3RBt1FWkZpQBcJ5VceaWqnBGfbWOblJAb+G5InQpAfwgXWbzAHsReWr2jAEpSxmujtpYab0Rp1mOAe2dQX3pnYwww4JLb0TixMcm1fp4e+WWZyFF5He2JC4yc6twAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hKBmuwbF; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hKBmuwbF"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3121aed2435so666149a91.2
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 23:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752734577; x=1753339377; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kuc4TAqvrnUn+q3qyWlV+xuG2GHLI6CswDkKWksHg88=;
        b=hKBmuwbF9ehj4/1Q6LNiycjEJMPK3R38t+Sn4vcLMCOTv+go0T9uifsIe4tqyFk4rL
         bE8E/EHMUNwhWHn/VUXonOLcc1c8V2rIcIms9+Ep2hs1U9XBEhBs96cc3ftj5o+tyYYw
         xPBQaLYIZmlaygDcIqhd9LGzB2L5Ii3VoT2p+izd/h4vJkMmYtCLyRsn3r9leOF8Dwk+
         jg/qy3SfLhIArgnUSw/HmmrS0ERR9QPhJDSyagS6DTIJDrOzU83NMB3Svhsm8oDPMEVP
         tnNpvlbUjoE0GwbBBq0jtB0211IiM8+1O5lr2LzqZRqFnZSM9VrvMGlBgbteuhR7OMgG
         Wr/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752734577; x=1753339377;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kuc4TAqvrnUn+q3qyWlV+xuG2GHLI6CswDkKWksHg88=;
        b=e0tyDDYDvTGLo7TH5fVLZsUD3knk8kjpB3Dd9MStUOLkO36pJIVQu6CwTYeCmdc18K
         MXl7+4422nuqW+G2BioEnDEXEDPP0TEuWD3PwrubAWuNiOaACA6+Emutz4wlVq2txY41
         VoMeVKMs8pAshxt/iRb07VZcmZDcwKoouwyo5spTGVs5xg7R6g373h2hFLZKPWwwjyBR
         /koyYMWFJSNd2VOklAc2kLqPIPIDAtfOhIGoCytZSY/PTa9UVTCEc/ohybWbRNOk6Uxo
         co9EB1pf3XkZZXRZdWeadpCK3qYOMcR+Sc3GT6YS3b5Dif+WSM/ODf+xlTWLMIvs/h21
         l5GQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJvn4eZkWJLXRJancT5slTP6VPNNpTkxt/U4GqskMPineRHFaNQQxhr/ov80wwILYjLNgetUhEQE0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/vTqq7yJ2dqYUJlbJITTcM7IUcMKLgLXF8FK7Lsg7n4y5UZvS
	4eUAXuVIuf3hi0oONQjKun9xnvWRO0THhgF0QRjDiitV1TaIuvDzG37Z
X-Gm-Gg: ASbGncu0DS4aYKnWU4G7tmEdMT9BZDCMGVE9OLRt2Z65zbI/QQBVrPcbczc0y2OJmSM
	pkiR4HbhGzM5GjFeqMW/3mulc3PRxrXUFwEAOYkjcMXaCaDGXQbA9o5cX+W42eT7uDKAhEpg9K1
	A8wG7Uys3Jnq8IdIWyVyEiBb1oGKqzu3DSei9O2fhIlNsttyjLZoDKxdrV+r23ikWijYVBCVuBA
	TSbt6MlDBV36lzLVJRYNEZu8pGWFWdBCv/qDKHnTePZTbnBsmFh54aCyCobUOI43SpsbH1sNeP5
	+urlZ9WoY8bvMoq8XOIMvZVyEJnn5aTSxDkfmVM894dthVfzVclYA/E7LtQhkKdqGh2Sico+DN/
	3l3M4iw==
X-Google-Smtp-Source: AGHT+IGRqOCbmLxXaB2LM+qKdVVyj2wSuDiO9rR4YXGSBoM9o3aC2aA1CEodfvfWlT4uP83FXSRteg==
X-Received: by 2002:a17:90b:1348:b0:311:fde5:e224 with SMTP id 98e67ed59e1d1-31caf821876mr2780219a91.6.1752734576708;
        Wed, 16 Jul 2025 23:42:56 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3bbe52e983sm14400080a12.15.2025.07.16.23.42.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jul 2025 23:42:56 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH 5/7] xfs: replace min & max with clamp() in
 xfs_max_open_zones()
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <20250717051619.GC27362@lst.de>
Date: Thu, 17 Jul 2025 14:42:40 +0800
Cc: "Darrick J. Wong" <djwong@kernel.org>,
 Carlos Maiolino <cem@kernel.org>,
 Hans Holmberg <hans.holmberg@wdc.com>,
 linux-xfs@vger.kernel.org,
 George Hu <integral@archlinux.org>,
 John Garry <john.g.garry@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <31A43F49-9AF4-47F2-97CC-D885051AD986@gmail.com>
References: <20250716125413.2148420-1-hch@lst.de>
 <20250716125413.2148420-6-hch@lst.de>
 <20250716160206.GL2672049@frogsfrogsfrogs>
 <3B511F05-E1FB-4396-B91F-769678B8E776@gmail.com>
 <20250717051619.GC27362@lst.de>
To: Christoph Hellwig <hch@lst.de>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Jul 17, 2025, at 13:16, Christoph Hellwig <hch@lst.de> wrote:
>=20
> On Thu, Jul 17, 2025 at 12:52:14AM +0800, Alan Huang wrote:
>>> Does clamp() handle the case where @max < @min properly?
>>=20
>> No, it only has BUILD_BUG_ON_MSG(statically_true(ulo > uhi), =E2=80=9Cx=
xx")
>=20
> Well, I guess we'll just need to drop this patch then, right?
>=20

Yeah, I think so.=
