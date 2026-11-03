Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793715191;
	b=WFIyxFpPfE3cWSGh2l+sRTMSTfN75wna51llzAxSLt94MZww9kLMYDXfskgW5drIE6wt
	 gCL5kEHso4K+B1gdVUKJMyJYq0WgtD9euipQzcgpve7MGmtN6mbUGDA1Wo8YAvasbuHZM
	 e91XHLhrhglWma9ZVC7Y/E2ldRLHnk+ZGzKG/WOqalk3W0xZ3yFc4TqZ0fjg3j41ZKwKH
	 prsHPNvkBJKd37Oj7cI4omVW2zHzFwGr4QELXputQ3ik92Fb06Vq4yI5f0awXPWrPNLuj
	 awJc7BcyRGNVnO5VZqTElc5X598YSY/DLVquAV5oBajSaOTsFOr9//F4Vw89DBwlxaA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715191;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=HL04h1yc9M4hwxY/BxNlJ65GkcTfjvC+va5ivgCWeBs=;
	b=H/uJkepUE65Y2zIz9ues1CjwYMq0+ria8Hh/k13oInCzWpVmoT0GvdXPoPGyc4/CiiKX
	 65BM0gkSaZkbTdQXCs3D6usy5x9AKxpHYUNFvRGAe/7iRrUeuou71WRuYCv1Nh5UWTXMf
	 89Z/qPVA14KiKu85qUlAFqw9N93dVeB9L76MWKdDq0L7iOr96aP8ExGEk9o5NAnEHKHWt
	 Nuo6EWpZPPY47WLSYDCovBiwjX9zUDMGwu8BQz/g/SSS/KPZvK9PENOmhc/GpAzgAt7zE
	 Q/mSbIedQapxRYAUoLcUHG1F7I8J6wfZ90OkFcCtnl6oYFwyj5fGhWR2Xe25V3OPqxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=APtZSFjT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.68
Received: from mail-lr2-f4.google.com (mail-lr2-f4.google.com [74.125.230.68])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3DE606A324
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 14:13:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A3DE606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=APtZSFjT
Received: by mail-lr2-f4.google.com with SMTP id 38308e7fff4ca-3ac4f373d3bso29405341fa.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2026 06:13:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793715189; cv=none;
        d=google.com; s=arc-20260327;
        b=IjBKU+Qhrddcmnek9FYki8FhtKVZ2HaGvibcR2O6CljilMtDaJRhdDhoK0FcHN3g2a
         bip/5FBsAeRb0gWV0lyaj71hs0ctAgNNg2surANYANx0ya34tlneG+geXVprTVLxwJoB
         LbIkbKErSBUdJrONweTd2o0/nX5LnXTsFtGM2dDTZ/9dUBmKymNoWeSzYUPylKUnoy4f
         jgeI2wmoYHmVclr8YIBh7kcYPFocNbI+Vg369/I0hNMSlGFssZjq4oagtxK9WQJtjwdj
         RgtETEH+Ze/lt3lZZouBCtSORuEJ8yr3aeHK7eBqhDmJJpjqRTvqu8Dc5YjjFe6x8+xP
         eJsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HL04h1yc9M4hwxY/BxNlJ65GkcTfjvC+va5ivgCWeBs=;
        fh=rUrsY8Ihpxam5+rUXOs5WhZipcKpFjRsGV4PZDu48DY=;
        b=KXOyhlwY6XPFiMA5yCTsGYjY0ZBtyi0GeGSc9VPqQZO37eVEhKGrzsDpjKe40QjWBy
         UhN9KsmaRPINE9Gf5FKmNeNssaA/HdtUGOeS5vLQZeyQB4WOFrVEuW+4+Q7iJpdPqukf
         wY0RY3oZJDqj3JF0yNQyHIIZCCFvIbg9MLo/s8aqvnMyKI/N9L1InUr41el5aiD51i3k
         uTgCYPmiNX+ZhcehXq4uJ/CUJVbhr+lkXMU47UpgLQeW6wa//On6jftHKQn4A/vLfyPc
         +rHZRFfgtDVihDUN717mvR56aQTQFFd2T+PVdwkSvUQy2nuTi4Veqq5EnW3sq57JzLK/
         er1Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793715189; x=1794319989; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HL04h1yc9M4hwxY/BxNlJ65GkcTfjvC+va5ivgCWeBs=;
        b=APtZSFjTMWO8qjF7GxxiWwzto/kwZF7nZ7TuzyxegZ3QQg47qjf7Q9FEsZ/gsaIbZS
         CvVufX3TCvXgBGLnjkWvSfbo9FIhWjdpSmA0z+Tn1/LcjXcVhyu/s1fj7xEcyb7xxCjf
         ZZ4MsVpybYhKKOjPTf/Wn/RJPmwBBuJOEqq8JR07cUEwnJKfYYbl7qiKVOxrRDOLXCUn
         QDsfnO1A9Nt4oBz7gr322PjtesSZ7D/GkMuq5GqWlDS6O7ZEbQ/jawnq7zgZ8sxtmbnh
         MJfcsSKqWsR1bBzqZvo3vWNrIMWFO222i/3C8XRE1Rit9rybjTP6Th61UvW4DNUHvq+Q
         ntwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793715189; x=1794319989;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HL04h1yc9M4hwxY/BxNlJ65GkcTfjvC+va5ivgCWeBs=;
        b=h7A3dWWqWzCp4LZbGH4QfikO2+sm5G+/9PQKASy+1tPgoD5Lsmq/ZGiDgetE7aIIBJ
         /sqVbMtp/G74pDQ2OVvDSCKN+RgdiIiXkx4Q/z7AN3jUnvM5P60dzJX9rXH5dWErtiWi
         hTZTsD6CpgjS+ebqzecobibbFIrgal9rc0LaescDSkinldmgWS+LUp2HYx8x1yKZg9Q5
         ruQ89Rg6EO980vK4aUiSu+/CcmBThN96Kjywj2WygkGQtOyhy4lXhTPoLmcGuUFG1/y0
         H62Bu7G17Yv/khw4VVY1wrhT+DdVwxloMKoqlTOQFMebLbeBQTLfxv5BuCCMpdj9NzzF
         JekA==
X-Gm-Message-State: APuU4Z/dcf0119qfuFcvJiV+l/MDE5HSY10Qr2Kx+FInTBPlLksu3QXm
	w1nK5O12VnLrEjaUfdY44YQz26gZ4gPwapHLX088XXEXt0VGiiMUgeo3olLBmF0TP9PQBMgDttp
	FzFXpvWE18ajXP+Iz1cxIhWj+3SG9Brs=
X-Gm-Gg: AYBFou38/8rIFTW3IJ8axkckIuc9ID66PxJ5NDDKkFJazBjqxHmJDiElYqvR7wjrO2U
	GOyV6TpdPGScr5AyFL8qL02O1nVARWYN9jG36IeFuAH9NvDkvbrnYF/AfBnkMaHQM4hmQVqY5Cs
	6ex3vE4vCn7hEbwe2e2STiS5wHNjXGQsRJEV/u92N6jMzMRXPdjX63QYo0qNOmdt7cCyqKF9SSz
	tgMnNQxIFhuDNkcPFnWr12/hwaiBcz2PVqSdI9cW7fZByDTDKR0tO6PI5TBIwyIQur7Mnmb1yOu
	XUXJcFF7HcXyMQC21VzRJxu8eBUfHMJi57JVst+AmQDZXIYCMIhSwekKlqnocXB0pvmAnaLypcm
	V1eCctBnsmwjrJAuKo/POiGKOJfBbLqBTyNw1gELxdcZL+O5f45Rc9QSWJXom/KG5DCT3oVZmz+
	aa3xayK+RaPzK+mcxwiw==
X-Received: by 2002:ac2:4c52:0:b0:5bf:ce41:7a8f with SMTP id
 2adb3069b0e04-5bfd957d192mr4098858e87.53.1793715188505; Tue, 03 Nov 2026
 06:13:08 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102150146.19777-1-jianyungao89@gmail.com> <717984c9-a0c2-43d8-a801-d36c18c7040d@web.de>
In-Reply-To: <717984c9-a0c2-43d8-a801-d36c18c7040d@web.de>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Tue, 3 Nov 2026 22:12:41 +0800
X-Gm-Features: AclHuK-MfLQMs5fQ5T8G-7KqHA8RnCDfPbXHT1W5k5aa0ReYsJ56PCXds9stJu4
Message-ID: <CAHP3+4BfTma1tQLbGLzy3aAzx05eR0QKOfmL0V-X5vEeOWtAEg@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix temporary cursor leak in btree shift corruption paths
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, stable@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	"Bill O'Donnell" <billodo@sgi.com>, "Darrick J. Wong" <djwong@kernel.org>, David Chinner <david@fromorbit.com>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Lachlan McIlroy <lachlan@sgi.com>, 
	Viktor Malik <vmalik@redhat.com>, Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Markus,
Thanks for the review and the suggestion. I agree that centralizing
the error handling paths in these functions would improve readability.
However, to keep this patch focused strictly on the cursor leak fix
(as per the 'one patch, one thing' principle), I would prefer to
submit the code clean-up as a separate follow-up patch if that's
acceptable. I will review the affected functions and see if there are
any obvious style issues worth addressing.
Best regards,
Jianyun

On Tue, Nov 3, 2026 at 6:43=E2=80=AFPM Markus Elfring <Markus.Elfring@web.d=
e> wrote:
>
> =E2=80=A6
> > held by the duplicated cursor.  Jump to error1 instead, which calls
> > xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR) to properly release all
> > resources.
>
> Can further source code clean-up become helpful for affected function imp=
lementations?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/process/coding-style.rst?h=3Dv7.4-rc1#n526
>
> Regards,
> Markus
