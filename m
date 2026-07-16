Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB65236D4F1
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 20:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784233819; cv=pass; b=WQQc3pWcacZ0lpWbT7/4v+tMBQPtVxOyIkNnUWUOXW+MXLRh5r5sNEx75NQSG1sbnEtv1ZX1v5Sn3NQMcMsrl0RbqSnSc4paF9crXbLvJjRBABy9IzMLcV7cvwPOfoi3D0GCVd93kHqnZniihWilOWTwtnO2069NxJTS2R/3RNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784233819; c=relaxed/simple;
	bh=XkISDm8HbEgqfryndXnbXzSWsmS9bYTgW/QnC3vQd2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aRHArOT9LW5QvHw+K/jD8r+ZQ6KCiNtrqIEEjw7R/H+GbptlmK5/mrKqZGr6/u1M4xZDymijovDH7hYFmw33sxS5SuYUxCdFqTgssNPu8xdkCJgwyxKEWSwbZF/eEJD9BK3eX0xRmc/GiFm8vZ+GDVmxQ+oH/rcsP+7RspPFkmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=reillybrogan.com; spf=pass smtp.mailfrom=reillybrogan.com; dkim=pass (1024-bit key) header.d=reillybrogan.com header.i=@reillybrogan.com header.b=ggUuEe5i; arc=pass smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=reillybrogan.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=reillybrogan.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=reillybrogan.com header.i=@reillybrogan.com header.b="ggUuEe5i"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-495c63c4141so4399777b6e.2
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 13:30:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784233816; cv=none;
        d=google.com; s=arc-20260327;
        b=bARsv51XNEhPrKIIdTQgJOelnPL7xuTGqWXypV32l9sPVIhVNxmrGt4/81UroZkRvV
         qXLuM8wbfeQMuoS7w+h7dCnXh4w87BkFqGYFRYETvcS6BDhffDPSgxGh+1FMbBji86wI
         22NBieznWam5x4Kj8k4UUKZEv/StJEyw5wCS8PgRMGEJHB1JVPJ7cV7yROOMOsrJybvO
         9x1EfEDzCgRDIQjhu45N2m6S+PNYjQVr2lqnQ8Ef7SdhFPhE/TWyaKwMUGg9No7SsVwy
         ZPHEsv9HbbdAPAK/D1r1Q6+VEPcP+bhnYSmEGgwOmRTvBUNPhu6xeSRWCV9OH437S5Za
         WatA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=XkISDm8HbEgqfryndXnbXzSWsmS9bYTgW/QnC3vQd2w=;
        fh=GA3stsVRytTzWfWaacKuwJk6ZsPTIMHzV2XVO20GfB0=;
        b=LnKLkPPMpMrvMFYWqrWcvOv5R6iFAdzgMUoJAKTCk8kxeOxxl8UIzIqCgl7hwvjjax
         7U+vfOQiZxQGB2cKWDPadDYRDAa5nOXGr+6w75WKjEi/0dYylquH9vnshUc7HNnJsCWW
         hn28B737fKH9PHTrAzaNhNbTGFqYXBhqqOuRPApEvgYdKob3HQj5yv6ZY+QuiwaYpEQo
         fa5xDcgh5MA8qixkPOcwEiLNfbPkgzFWPKzLM9PRsO+uywJ8naPko1Wyxf8MGjsXSnMw
         JEpB1im6yP+cXTvNCAqrQcMqPd4a/h6tDpanSEUS/Iur2lvVh9/pvCjUFQDPV9c1s2Ks
         Kcdg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=reillybrogan.com; s=google; t=1784233816; x=1784838616; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XkISDm8HbEgqfryndXnbXzSWsmS9bYTgW/QnC3vQd2w=;
        b=ggUuEe5iEmUVYjZ+kS5Ciw7LPTVbqMhnNpDrGCiIGnAcUNDR81vT65rgM8berw7uni
         BU3DxAI6cdJ3qUPet0ZnkQDRAxV4AVV0pRZgaMe2UiZLOUMJd9OZ4RF1wFXIjUh+Nobk
         u35wN212fLX8CU238pOZh3RvvWB64z7AqNjrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784233816; x=1784838616;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XkISDm8HbEgqfryndXnbXzSWsmS9bYTgW/QnC3vQd2w=;
        b=OTPxpRO7M8N/S6rpQdGtYwGRAD2sMfmbrxTlzjZ1YVA2EUrCtE2ly+IFu+XPzmnPiG
         mLojnKTNF1JtqbiYNuBFFhe6lglF062MahkaRhwMBEygo53jcIR1Yx0mXf50bD6MElP8
         0vBCVy80+tYfx8JCREmH25XN1vb1BH1Ncie/4xMRQpdioSPuxYex4aItHphzTwVELNk1
         w9RFcBHEold5K4KMEvj5ViWzhz/lZDJk04u4rMk59j1qptXQfuQ/1AOM2Nd/uDgEwvjv
         bCUDz81YQ2Y/me7CoVFFPpAtpkEbyArWQgIDdVNLDu/GrOvQm7c6kMPVWSM6E6nth8mR
         3QAg==
X-Gm-Message-State: AOJu0YwDCWu4Nb4cjzVIIKvVKQSfuXyjYLG0AClMNt2CNwm0RPBV+swl
	/28aTz/NHFt/sgjUezKILPyrzMxXpqNN6RvLwIwq26x6nKnGzFWCNp2BrOy1w+E77K7z+6tkLQH
	wds7AtTCJD+BACS/X2gyo0vPH4miBEchXE48UDOF9UA==
X-Gm-Gg: AfdE7clAHJLasjf1OwzhKVYCIcyd55EoZf+lXjCZmQ6Na6wpkBDToheSWoepedZ57Nz
	TLri7cZVzwUzAR4td/5FMWW+YK8gP9U38GsOiV8MbqhYZMZod2i69L5o1jp8T5nPb05y5VRNMqI
	E4c7pGFpTWhkTs7z7j1LKwht1peRXzFiIYsJSXo+sim1fUwF64R7rThbOGD/XwG4UG27jUBPLNt
	C4G5SQpuvNXhBFs5ggmyScKVpiUadl+pv3DLIrqvK7hoFhzK6KTlHCK5ZGbwnaBGPu9mohy
X-Received: by 2002:a05:6808:1786:b0:496:116:105b with SMTP id
 5614622812f47-4a495e9e12emr7064152b6e.14.1784233816547; Thu, 16 Jul 2026
 13:30:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CABqFQkar-sMMyZGw4KfAV51x7F65ddF7d8cszQ8iWiprvnKMFQ@mail.gmail.com>
 <alkzIx0H-cn169RI@pine.grzadka>
In-Reply-To: <alkzIx0H-cn169RI@pine.grzadka>
From: Reilly Brogan <reilly@reillybrogan.com>
Date: Thu, 16 Jul 2026 15:30:05 -0500
X-Gm-Features: AUfX_mzwx2KuiSjFjsxihj46DNROmq0q8RcidS0w0lTSw1DKvUbBWhuXKscGX-s
Message-ID: <CABqFQka2DQocWjj=9d7ebT-LakGKjN5HGBH=-J3Ph3pEvcjzsA@mail.gmail.com>
Subject: Re: xfsprogs: 7.1.0 Build Failure
To: Jan Palus <jpalus@fastmail.com>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Are you 100% positive you're using slibtool? The error above looks very
> much like coming from GNU Libtool (as well as help message...). I did
> test slibtool and it actually works for me in similar case which could
> lead to a conclusion about slibtool incompatibility :).

I am 100% certain we are using slibtool. On AerynOS `/usr/bin/libtool`
is a symlink to `slibtool` and slibtool checks to see what it was
invoked as which perhaps explains why the error message claims to be
libtool.

The only part of GNU libtool we have packaged is libltdl as it's a
dependency of a few other packages in our repo.

Regardless to the xfsprogs developers feel free to use my patch
without giving me any attribution. I unfortunately have too much on my
plate right now to bring it up to the mailing list standards and
submit it properly.
