Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9636947D46A
	for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 16:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787848908; cv=pass; b=EunPQ+BNWt+MPTSnPKX8gchiSQY73CaPoX/DmD89VqqqFeGY6mg9oMuAzc/lp0oelHvXEeYU9q61cbAe+ExYgYvQvU0Wy0t/T/ZYphN8zCypA40TSb4jwfs6OJXAhV+sN8Hd34brhTB/GnX5s3MjUN9Wev4yJGQj+kxrZIJcC7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787848908; c=relaxed/simple;
	bh=Ehfw/8EaZ7s6/AwnwbX/B1Uh4zRXI+Dz+q7FN1nwnm0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bQZcKCZX6Q0ZGb2Pl/GBqF9Tyrq9uULJYw46O4vnXVA16Umd1g7yh7cbI2aTQ8l/6z65ByJPndfSDHt6aY4oOkoFG+1DdxBktOOnL5Q54c13tpUMIlGAevDlyLiNIxGpLKyJ1GiOiFN9JzmD44GYUFLzEA95mgnfwAdaqx7mwNg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sVDiuE0s; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sVDiuE0s"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a051b737d8so2990574a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 09:41:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787848905; cv=none;
        d=google.com; s=arc-20260327;
        b=LFe3db+LVp93fH0nWsUiyYBb5MmlXeDXOMbCwD7sdeb3vjdatc6t7FuEoeazTEFFSP
         Q2YcE80DuP+rotqc/yogE3WrSo/R8v5emcKJgzZJx+taoGDwKEVwzk/InjhdyoY6hQXH
         5AFJ99iwOLTQLcR3qO2wCZ1P9JzZdqPlkyceCDOprbEDRFI3afqbIhH/nvNZYTgZT0ge
         Vm9NX26K+sCSkNQc7lGLGxQC9Gz7q4iOZp3J795spX6636LIzQinLb7XgVzS1uFqJWVX
         bt56hX/lJx+GybsPGe2+/uqfrssQ5+oW8PnIOx+HlE6gJgZMyovrC716K/fBy6gcPBPJ
         xQBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Ehfw/8EaZ7s6/AwnwbX/B1Uh4zRXI+Dz+q7FN1nwnm0=;
        fh=PtvdJoQqddrrxtNhnwnP8/XBulUm+PUUp0MAR78WJHU=;
        b=Ta88hoO75HZRUtoyY09EVIWhWkC3hiox2GS0dzrSTEa5vyoLTwUzEagDExvUjs9S6T
         /Bg2JZmz5D702fEVgFB+JsET5P/G49WC6+K6Q4D3HtG5GZoFRldKVI55PSVgoiAngEFJ
         Sl08761ToSTKD3Y3Rk6/pwIghoghgDo6BdetKu+apTBplDkgOkksnndHYtQwq8Ua0rv0
         3cl71lKct+vCd+3/OZ8Fhd5ubV7NdrSoHExReSCAGCbx8NjfbolYqeglwXKl0eRefQ6c
         K4WBM38SS0dxSwjP0cZ/w8dQ0hmyMSvMmkz6RYgcRM/cvQXeqG7o9x3iGNgrLmGdQj9g
         LVBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787848905; x=1788453705; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ehfw/8EaZ7s6/AwnwbX/B1Uh4zRXI+Dz+q7FN1nwnm0=;
        b=sVDiuE0s8UYxCIx3OeI8AKt5f5EHUtzWdqGw3RwYadbRbVwYx3g1JMG3Ydbl6grKR/
         EqViN8+/RfknlwmYdisEYOArMBCZtsWFF5vlNHYT3O7ykroDdWfmCo8OXDoDniux88P4
         t7orEckD92v08bsJMh8U6LsmBiJ+dsnC6MyHLJfsDhTvElB5XZbU5JMMbMDxts4VbYT3
         dFZNFYfZwN+YbYK/43sU4f/QQvqkTbPrtbL+a148E/mN2wVfjG+ZWvYkqH7NkvieNtr1
         sjKRfDJEJQSd8hsJmk2VqBPz+RjVNG6bus+EZV9kJtY2ikdJAVFGxQZevmyUafwLzAvU
         xMzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787848905; x=1788453705;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ehfw/8EaZ7s6/AwnwbX/B1Uh4zRXI+Dz+q7FN1nwnm0=;
        b=n983kcl3s+tJ579chcpDvFnlwhSMUtPngeZxX2aPe1q0OHPrwZPPHPX5l/qpZM5dHe
         z2zJgtzA1IFRl7y1xdO9mZ+wlJ6Tz9qP7jlfWhthOQ3ZplkbVnGH4YSUfdJTPyKYuWGO
         P4qLP+8W3YwcuES5ksrVoI85FLJvYraErjyNI494/ZF1Vah2l+s26tuLJGIADA7N3vLx
         sb89o2dgWdjf4k/jxRzprjsTyKBnHqtrW53NwBrMdbrKF6EGBHfiIllOhi2Zr2XncKZv
         DsL/V6ygFpxrfH8QP0MG6vpmut9e0WqGIlRF7AsdKGVZNkzQbsMTA5Moo38CobXM5s2z
         H6RA==
X-Forwarded-Encrypted: i=1; AHgh+Ro/dAiYXQaOCJJQGHPArIJgG1jCMOqvKAiBA3X9n+UNxaiI+uH2r2DwESw4cdzhDd3n3ZiV48IRPQ8=@vger.kernel.org
X-Gm-Message-State: AFuF++m1WXcHBRCRCCNNiO707O/eoRuPT9ynOvRQAfcvmv31dvqVF5M1
	OQXm3BWge6kNkQu0kqjvktYk6863FvhniPFv9W61d7HfFUPNca9oFZ9/Wz+U6clsqQfolWIzME5
	NMDxCkmAEbLzXFGL+h6cZ0sWK9G4ONw==
X-Gm-Gg: AR+sD10gOQEhek3vrjRVC/xGp67tOdy4vHra5DaBwZmqwNSuZ4A7BrKuZ0voQjb+JiI
	Ch2LzLIQI1Z7YXUXfojg6yrFwtvP9GihdJmsqkwe9rF5f/tO0lRn4XhfJSfaGlRDNOussQgKvti
	WJJaHdyDDWqrSLRAarSVVoNys2DEHAMLpHH5RJOtK23HDcn+6yK8neYC54pY/Lr83MOUWTZ41Bx
	1PfJnh8Bdnn6m+2UQpsquuL5rDitA4LeECiIQNwvN6FOsKk2QMHymH2ASvXdQW0df/Wxp5khrgB
	VVyxSqtbCpY4WDbVFCIJ/uYEMoAIFFbgcpHImiZQOgv0itCx0fip0nGzpt3k3M+UPXg+P3hLcGp
	yEkDh5dzLeDCGkqf2p7CkiyWTnzoC6BYK
X-Received: by 2002:a05:6402:548a:b0:69f:fa13:ed3 with SMTP id
 4fb4d7f45d1cf-6a5df6722e6mr17436353a12.16.1787848904549; Thu, 27 Aug 2026
 09:41:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
 <178780640282.3528187.11511654116002480699.stgit@frogsfrogsfrogs>
 <ux7q7mg7mp32uekxtei4vrunv53opqwthv2er7gk5l2z3ztnok@mp76pxytxzmt> <20260827144631.GB6072@frogsfrogsfrogs>
In-Reply-To: <20260827144631.GB6072@frogsfrogsfrogs>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 27 Aug 2026 22:11:07 +0530
X-Gm-Features: AcwNN1XYQtI4Q_3dA-wKAwi9elvI12yzboiGgnOvUcLRfcN3iktJnCDxLHcLakU
Message-ID: <CACzX3At7DvbfAOGM_Cj=GwFY17TLw=aUshTw+Gqk8aSVsHTtVQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] xfs: handle reconnecting metadir subdirectories
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> > should we update dp's mtime/ctime after creating the dirent using
> > xfs_trans_ichgtime()?
>
> Metadata directory trees aren't exposed to userspace, why would we care
> about timestamps?

Right that makes sense - the timestamp update isn't needed for the internal
metadata trees
