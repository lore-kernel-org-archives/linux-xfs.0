Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0326C274B55
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 11:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758625918; cv=none; b=lMdlywccrai2bX3qkwGxJwV2FxF8x3FsPXZaI62f2BEC6g7IMGUHgEuQ/DBUeqmcb0UAxMYsVw+VQjbT1PhcsGP0GuHE4XjIP3z2rM7n5uNYzEIGO/7XHhOid8nm4HV1Dqv7Hf0P+tDsVE9YgXKedI/D5E1AaUd1JHXbvp0Cm1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758625918; c=relaxed/simple;
	bh=b5HQzS/IgzWs3gBrRSR/MIrIrjx8DeV5xFqZ5DRELLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BUsQuWO+mHVL1LHlIfHs7368IcFlQ5p7AN4AvRxbtBoFCph9cxDAKmS0YHAqtukA9ap428ZO9ROtgR6tL4AFEPCzv+QG1Zmpng0egdOeEQKz1pT+IHEQ5eR8Ds4rurl4BlY8dIW9FBhg+QP066RcPWPD78nOsTE+flAmzREmylI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=P2hYvcYk; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="P2hYvcYk"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-84a91cfc7f0so195555885a.1
        for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 04:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758625916; x=1759230716; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=flFGmwu4mkO5hSvBsepBDYFlHgAlMxINsB/VP1uSo5I=;
        b=P2hYvcYkjsM9XY7qdZ+2oDWF+2NYKWBMZIeh+Pq5kGhFdBq0N5zpUwKBBsCymlrO1H
         MuTA1puT9KFuvLhQaPwdnxhvyhdJvpZCSSZa/pg9m+IVpfCVu7tNIE//jovjSPKiq658
         CQAcUOfEa0Vy0ONYXfA8envtFVe+3QAb48VrI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758625916; x=1759230716;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=flFGmwu4mkO5hSvBsepBDYFlHgAlMxINsB/VP1uSo5I=;
        b=qx4dERa4W0Ud73/tBnMrqq93LD4MNltFi6bfIEftkQBwYufgLKnvRNO1SoFqaRwAfy
         t+xHRb/zsxfMuFcP6eQSN3nu63KXHpOUjJ1AdQ3ksk/DKtaDNs1rruDS8BfIG5h/hDuC
         cOtYAZN58DbJQTJOyBp+u0EEAIKmb8K3+SoyEfYwZmxu3GzRzoNVGH8LhcQyjeREFw7i
         Iqr93KPW6XRDqBz614qxn/fCRTEZGfpTLEg7uXXL+Qka+CZQex9WcvtxS8sXSvxhok5/
         mcPHj+2MWCFGaL46DdadpaAv7/7r7+z8I1q8huS1d9fl7Ac3iV4aAm82mCDMBDCnJfN/
         bbeA==
X-Forwarded-Encrypted: i=1; AJvYcCXeJ/yCOxe8n4gVn4apxd494fG7zQk5rfim+bDclRFKEzA4INYMyY3mK/9WffgLwyfNyx96dAy/UWI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMefrENfZONy34e5F2wISMuuRbwaaE3lAj1iyCjLOLyv0Ei2kT
	92o1RUSe0GhBtV99If0umwODWvb1vpQB+RqvUp6EAzv7vrIn93OAD4LYcqPQMrnIxEqZ2YrmfU+
	GrUHYlJYTWdK266hsWFnmaR3E31BIsHuxkuYwtOv9DA==
X-Gm-Gg: ASbGncsQyca1l+9J+s0VURz/QAYFxI6aKh47zwfr7OY+nZek+uR29ceI8Fyiva0McET
	BD0VfGUMOghNUEwL6RGLVWwlA67V3TwkcJN2+bgteBPHhx+azIO9OE7YfSEQLODe42N4V9OVNbt
	Iw60fhATORA4OLMAAJWBaUM9Mo6Xf4hmd4nSR+03AYICCp+ZUhez0IqQsednJsKb0qJAWyo6vXe
	OabwaJs6o2H92M5S8Tbn1YQuxPItgTppisL/0dXM3+PQXYawA==
X-Google-Smtp-Source: AGHT+IEWowhMwOrt0EXgg4kdzeYYRV1P1D2GU7iVV+lG8V62/iqczkAt/wdzk3Wlp8WIgnWZa1YX7g2VmSZ7IyBtBXQ=
X-Received: by 2002:a05:620a:458b:b0:82b:4562:ea60 with SMTP id
 af79cd13be357-851af5f4c6dmr207534485a.6.1758625910538; Tue, 23 Sep 2025
 04:11:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798149979.381990.14913079500562122255.stgit@frogsfrogsfrogs> <175798150070.381990.9068347413538134501.stgit@frogsfrogsfrogs>
In-Reply-To: <175798150070.381990.9068347413538134501.stgit@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Sep 2025 13:11:39 +0200
X-Gm-Features: AS18NWCacoGxINt-x16sxcJyeTVSMahKj4WWFLFSM7p6uh7_e3qHhhx8aZVh8js
Message-ID: <CAJfpegtW++UjUioZA3XqU3pXBs29ewoUOVys732jsusMo2GBDA@mail.gmail.com>
Subject: Re: [PATCH 2/8] fuse: flush pending fuse events before aborting the connection
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: bernd@bsbernd.com, linux-xfs@vger.kernel.org, John@groves.net, 
	linux-fsdevel@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Sept 2025 at 02:24, Darrick J. Wong <djwong@kernel.org> wrote:

> +       /*
> +        * Wait for all the events to complete or abort.  Touch the watchdog
> +        * once per second so that we don't trip the hangcheck timer while
> +        * waiting for the fuse server.
> +        */
> +       smp_mb();
> +       while (wait_event_timeout(fc->blocked_waitq,
> +                       !fc->connected || atomic_read(&fc->num_waiting) == 0,
> +                       HZ) == 0)

I applied this patch, but then realized that I don't understand what's
going on here.

Why is this site special?  Should the other waits for server response
be treated like this?

Thanks,
Miklos
