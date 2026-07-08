Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A223C3DA7C5
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 20:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783543764; cv=pass; b=juAa8wDdeVAu0cIloLp6+BHBHb12k+ew3dKNaJ51BKVqXG6qyy3hh+BlJMWAv3fsecYmLsj6LP1huLQQbbt1MNVOndvZln1z/v1XqRNuX9hqka5Xu5AkI55mWox+FGNgY8oF6VxMlzi68XbJyaaHERC4gsx32gL68Zp2eokDgD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783543764; c=relaxed/simple;
	bh=Q9VW6dWLsKZN9qsm4oRde88bufG6z6b2KVMtuc1sieo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NksQCUohw6TIvlj47Ut69HNPdt+6aQAko3jdlM8cVgx81djVzoXvGCVIudsU8Bcq8Npx/l7WRTev7ua32l4bgrJIeJrOWnO+mn3Meg2diP//hoR53rE3T8UCk65nnDtMoPBbDv9Hlh6onjWeOvEmagERASyxjubnwCjwhumhgrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J6YI35d4; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J6YI35d4"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4720d22c94aso1057044f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jul 2026 13:49:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783543761; cv=none;
        d=google.com; s=arc-20260327;
        b=C7V04BhqHK2fpnORX9De13AQL6puzpMoOc+n89yHzbTHvJVIFK/1LYKVZ9jWxXGhew
         ayb0GjOgGM/ZG07eHQ/kx8KqVdnIAk6RSCdXXdLf4eeOsqtQ/53+youQY760mrJqc44n
         qeph7C77yBS2h7BWAL0u5g2mBr4dwxsQ+pNGKEw55tnKPxPq6rocssozLBoAtij/dFyp
         f3ZJRHyORpHiKDPqMO5LxDp22CPUqfO6EeyYvme2eUhI4lsIln/jDSot+0FcZ+ncgK2D
         +tfZsHn1iYvt5Tw9ePjLLHfD6qUyTlVPHswsGa2dbp3nAdAqZ/QkonB5PeYMhDJziU1r
         EPSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q9VW6dWLsKZN9qsm4oRde88bufG6z6b2KVMtuc1sieo=;
        fh=MQSrGJkyZ6Rd8HqIzl4dYC7yU+6R9NIPMYmo7YOA5jM=;
        b=HIkpW8xh6sTRxy0Hu7zv7/06n5/azdmIBX3v2VClcxma/y9kflfMS2/0tf+XeLBe8y
         HgRvrukdhfQF6JBd4VAVTq3RKabiElcv753LViwMjRST0taZvMo8F1JvHe5BE9F5+nC8
         vDY81z9b7se/5ZQbuqNPuAJeGGAIoujmwDM/+vBhoWej8Coc0puX0L3ZsLFUpoZgbg+m
         8pRGMYRWt/fR+dfdRG5I+gHTLaruYMl0TFTmchFnEhOQxq14qmTueQy/BxG2R3HgFFb7
         Y5bcY9BWkZJqGvQmU/w9VzBYd869paJjiTQi/UmMlnL4yJBBDVThY6+7pTWMMP+FQyv0
         Bo3A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783543761; x=1784148561; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q9VW6dWLsKZN9qsm4oRde88bufG6z6b2KVMtuc1sieo=;
        b=J6YI35d4A591y/l9NV+Z0NQvnoPUQbpRN8Whh9nwKsuE5uIsFRhwicE5lsSaX9SW+E
         Di+WL2TwrbqJ/0H7Nr5HJnC/3YMrSeXN/ygtovw2u7gMqtdOCmkfpLvrYv/ROXE8w4cE
         QpkTY6N5Xi4BScXm6jseBFnoOZMDjOW5nCqANjxyyrPi3V3fRHUp6Puso7TfhsIwe9vO
         MOR6wrS3qy0zcvJ3yxZ0DJG2NgX40A1doEjW60MlFFLm728bTAwC5MuTROKaxYGHP0Lf
         3lDH3c9jWHE+fWaYLIttP0mHGLmT0UV72dftoUNPsN0759LG/3yRdb/5C4g9XjDJUWZV
         SAfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783543761; x=1784148561;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q9VW6dWLsKZN9qsm4oRde88bufG6z6b2KVMtuc1sieo=;
        b=eDnd0LTA91ljc8GdlbOfu2b7/fmn7/peBnM5IwmoCKr2VOQUxGXLs/egalIAEa5p0y
         lVJU+bLrM1ctxsogHV8rNa0m4yBI+Oh0nPmnL0K4XOIvWQFdLHqnFI83y+DkioOsdPNi
         9hPbGop6a6Hurw/YURlgTx+HG9w7XiuoFz4coVrSdoQLPdPORmCrl3XaH1SRrWoy1MFg
         QTWilxTzFUKlPxN+dAWe01u7CbguWB/Kya9a31VClv2btyTr1TEfYsCO0Tlc5YYEqEDm
         bw9mBo3PTJy5owBt4j3DPexvi18a3mGYW1JX7nVsDXt/ysKHpDbh+uUEm0lqZVxoQsvU
         qSZg==
X-Forwarded-Encrypted: i=1; AHgh+RoChwhey6dnDyhN9m5cLB1gkEJT5arX4XhGw+KSeuERArF0AAqw3q0zjb51t5FM2Ag8/I+ehZvHzdk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb7t+gZFzz6qgZrntlJzI3EdoADBgSN7tYAhw2Mv6CWIAU0GyP
	ky/qY0NUxo/tZkeBfoVdYlAx9jtxWfRaGzGrSGnlxudoYeF5IxAHsjvEwv/JS8TP+I/589WKN2g
	ARV671udadfU7Hv3iB/ff04bQSSq3dqc=
X-Gm-Gg: AfdE7ckszVtXoUq7pllJ+SuBsFyaQbjfAP9fAaf61HyuMiJoScQwZr+YrsuDakZwkZy
	mceNyWSB/Ds+mkUZspHX80en3F6j327rT8ABjthyeBgEK06tNIrpfi4/LHImpIYavffCn+hK09J
	llQBg5sG82CjZavCMoxuCl/8i5LrdAhC+Gl3k7fMSBBbVaT6w0z/fCpcJySf2+7xth/Cf6kaKjt
	0g/Cnv75wXzXFbIJ1pejyKXTsm/vKyrzFbiZtOpeoF1ETV7DsVRilriH44SjbdvM0TMlhlJnHPe
	WSZ3clq/gpkk46sGFmowkvR32ZOvOLtrIl2/Tb2rZaijsUajXMLqYwAoVsOKsXQ=
X-Received: by 2002:a5d:5f46:0:b0:45e:f439:9def with SMTP id
 ffacd0b85a97d-47df0748abcmr4605746f8f.15.1783543761001; Wed, 08 Jul 2026
 13:49:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520030357.679687-1-yi.zhang@huaweicloud.com> <20260520030357.679687-6-yi.zhang@huaweicloud.com>
In-Reply-To: <20260520030357.679687-6-yi.zhang@huaweicloud.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 8 Jul 2026 13:49:09 -0700
X-Gm-Features: AUfX_mznUJrD1oBo5FB4GQ9nk03mR1fYO3mPw7ij3a7Di9C6mAcrn22LiWqCwR4
Message-ID: <CAJnrk1Ykp94kZr5tfXrb0j6O=-gLM3vAL0V7ziAxm39oKOmv_g@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] iomap: add comments for ifs_clear/set_range_dirty()
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org, 
	hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 8:15=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> From: Zhang Yi <yi.zhang@huawei.com>
>
> The range alignment strategy differs between ifs_clear_range_dirty() and
> ifs_set_range_dirty(). The former rounds inwards to clear only
> fully-covered blocks, while the latter rounds outwards to mark any
> partially-touched block as dirty. Add comments to document this
> asymmetry in block range calculation.
>
> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
