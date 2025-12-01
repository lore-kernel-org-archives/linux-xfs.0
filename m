Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D0F1DB13A
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 02:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764556907; cv=none; b=XxM81WnuwFr+rd7u5Bss+xuOpQZCWw8jN3jE5PoIV7rmBy2AMvwp8TodYL9F5Bwd4DgEF2MVwRnsUBJab4COXvPKOTnrbUbV0r66+591DYKYuLzjEafAkMtsIIASAvyLl6+hO0WP1obNVxobSs6Iz2Bk/9NKMTEVq6Of3pF552g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764556907; c=relaxed/simple;
	bh=bVTMBZipQSey4Fgvkem7K+oGHQCM1N5D+geGZc1LQG4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uPsXoDvjj3UM8d8NdOaPblVv/ggC/8P1kwu4BmHISj6wgcvpeUi87vzStsrgItJFfELXvEWoc06KeW+aXgHq0OlJ54iPjy/3aV5sv2XaE4Bfx/yWFMDNJYfYSQ0Gby0NRCscpXA5xqzoCqBX/bI1Kb0ypPwxmHYmbgi0XhT0aCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HMU8ccvF; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HMU8ccvF"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ed7a7ddc27so31558241cf.2
        for <linux-xfs@vger.kernel.org>; Sun, 30 Nov 2025 18:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764556904; x=1765161704; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z4ueRZDGEmZN3pKdDV+VUbfm/GEWq1+GkEBdKVjZOtc=;
        b=HMU8ccvFVJ+OWkPxTVDXXZ6/nVErhPiyzCUNotBWsByIDtbO/TuA0uGn6ReZxP4REe
         v9GHH6zsGJFhNIYb/mVB8VRkwIZi6ZVfu4pjyBZMER8ccKdNOtAxHHlIQdfF6odjWErl
         hWwbr++SWpIOCVcI3tNEhwYqICh8V26iezv8dshZBjwp26C2WXWK1udu1hTwYwbg5fNQ
         KJJE16qROMWMY7Krr0zgBXe3RX2VKnOlY5mhYFfq4XOh702JA7ZuPawaQx1Gd98yCvNv
         nF5vuUVPNA7SzGvpKDNbvta2gMfbkVI7e/dSXDHnRL0/4LCUI1Mv7TCccGj1Puu72hMw
         sYSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764556904; x=1765161704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z4ueRZDGEmZN3pKdDV+VUbfm/GEWq1+GkEBdKVjZOtc=;
        b=bD04QS5cLpAiwTL2XiEsAv8YG44YRBzADVL3tVQWQK5F3NAA1KRksU5NOPzfNFg4C7
         URwteFKRV5C+3M4q/FvX0ixFK06H+T/sjEz2N3PegJQFes1rgdA0RjpQ0NkP75EVnaS/
         /2ZR5kRjmT03iX7kzGwRgd3g7/xmDyEU1UhuniESIVakbat6ihkAuyGO4NL0gbxs8B8l
         mmRN2dazdc4MusxkDaYqPdeuzMY20eD5DsuYLG9s7+QdompKSWTdu9ZjN27IcF2XXxyL
         8Eqj8xcnKPHseitTHp6v8rJbOFScR72QTvCQWK24wsNc872lY98n+DxreT1KPZatt5d6
         M+WQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQC4GN0KEw0P759aimTsPAKxVu2Y5F8shoQp8DQimQsKe9BX82BLNsuHPlH62QEA4sOvO1l7q1caE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGPVYT46GK9iitSCMWDAi23LFOTIHx0bXfeWMV0bHdwsSIMDNl
	9DJXOnTsnp0TfCjLdJ5Yzjzb/U1ZI29tyXCnyj9JAQ9z1kqpUzMrXS2JMji9yiqEZpnAsrZUcNJ
	NVajXuWkzLxeEuVVBCn4a+D9FfRkD2Tc=
X-Gm-Gg: ASbGncu7olQr15eTjzjvXreKnyEEUWq/714zi2UkRWTXrAOusk25pFjJ6G2J+I52m+O
	TsCxd+UzKsJHDOeFMk0cUhhTFc4XdxDlcnoH130DT7EyBeGpmmlJdL4Kvs5T9cP9diL9OoPtiUj
	hs11bVimqbffyzC6nVGKpHMU0C5onMOMMXmSu4c8QDvSFszMRAwBoPgx6P1vKl2pN2iGUYvofm3
	HQwZp6P/XX0VbMWvnZo4+RFc0acKOYaicVCo2rDYZpRRKRDHhBsDtYSotSdm5Yl9jjLHJI=
X-Google-Smtp-Source: AGHT+IEmvBJytrUYv3PRff54NTqLEiIVWOTOdu8c+jgIKKnb+TW+2xLZqLXPCQhWGcR80rf7EC5pZtRoolK6Jl03Lrg=
X-Received: by 2002:a05:622a:14ce:b0:4ee:ce1:ed8a with SMTP id
 d75a77b69052e-4efbd91573emr353928791cf.16.1764556903722; Sun, 30 Nov 2025
 18:41:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-13-zhangshida@kylinos.cn> <b33b3587-edb0-4f30-a8ee-baaa2b631ed9@grimberg.me>
In-Reply-To: <b33b3587-edb0-4f30-a8ee-baaa2b631ed9@grimberg.me>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Mon, 1 Dec 2025 10:41:06 +0800
X-Gm-Features: AWmQ_blj_C1mdvu7tNb0hVlGGZGM9DWXbWPpg6J4BwD_02XuZ0ipoM_caXqdy_E
Message-ID: <CANubcdWAk2Mh5b9stjTh8N84jq+XAgaR3n2-VYRinU9ERtJLUw@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] nvmet: use bio_chain_and_submit to simplify bio chaining
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhangshida@kylinos.cn, Andreas Gruenbacher <agruenba@redhat.com>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sagi Grimberg <sagi@grimberg.me> =E4=BA=8E2025=E5=B9=B412=E6=9C=881=E6=97=
=A5=E5=91=A8=E4=B8=80 07:03=E5=86=99=E9=81=93=EF=BC=9A
>
> Acked-by: Sagi Grimberg <sagi@grimberg.me>

Hello,

I already dropped this patch in v3:
https://lore.kernel.org/all/20251129090122.2457896-1-zhangshida@kylinos.cn/
The reason is that the order of operations is critical. In the original cod=
e::
----------------
...
bio->bi_end_io =3D nvmet_bio_done;

for_each_sg(req->sg, sg, req->sg_cnt, i) {
...
          struct bio *prev =3D bio;
....
          bio_chain(bio, prev);
          submit_bio(prev);
}
----------------

the oldest bio (i.e., prev) retains the real bi_end_io function:

bio -> bio -> ... -> prev
However, using bio_chain_and_submit(prev, bio) would create the reverse cha=
in:

prev -> prev -> ... -> bio

where the newest bio would hold the real bi_end_io function, which does not
match the required behavior in this context.

Thanks,
Shida
