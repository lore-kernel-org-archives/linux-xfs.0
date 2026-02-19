Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BC829E11B
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 09:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771493719; cv=pass; b=kG9Guk5+1xRbLzJr8UMKlVvLAA1+y8G+xO/SRVkb6oBhCVc6+jbyOXWW4ILcfEJrPPpZAUBMkFIaDyDJbVnuaEn0WW/iZj5QKtnhziXK8dboBtA3xGsEcZ2aGsMuIKkfea4+UgJ5idfT9qRq65sAOQfO0IvwB70B2j4GmYcVvks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771493719; c=relaxed/simple;
	bh=gCWDiQm+EHHTUf3msypTuKiY8ST30SKMWU2VhVV9PuQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SqTTs9tdbFeiSFsb1CJlRbOMLAzkLznQpVeUSlDgTQIRN4foV+9e8VaraJW34BwzEKfsPi3W1UMr1zXA02D3lTd04vrO8miay1aeyUuCGkpuX3QKjmRlbZiV5gTdJBtvIY1YZE7IgHlrcNs8W+UtuISoPpPQHBLLfICvN0hC19Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O+79GAjr; arc=pass smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O+79GAjr"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-59de8155501so756546e87.3
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 01:35:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771493717; cv=none;
        d=google.com; s=arc-20240605;
        b=e1z/kV3F0O6ljH8IAPZRdEjCPNBm3eOuxFmk3Dy6pobFk+4+1OqD7847nvjFrIo+Qd
         1ZdGgM2JrrUj/wMXrnE6NXHyNMn9B/mnmgzOBLTzydERJqK442bcEkuPbRtlMHHzo3Uh
         /B4LqFEn5Rn+acPGa7uNAAE4kDKV8NNUiOGGZMrbVETNGIOw4bqdecE2eXIlxlNJF0zE
         B4rkDhIx8UzC8mmZTmawlOAE/+Un7ZcE3OPuYn1/QZXNk2vBSncdgakKx1FmLrCAqVkg
         gNUAguDZwoTLIzyqS2Qz5lkmKam6IWJFJHJyX/ogzrYNWuu44CpHnJpsCoNOdpnVADx7
         vxlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qwP73GPLt6/49YtKqBvxtty3Y7ZnoSWI6pg6OHhH1MU=;
        fh=Dn1gbGPw3WGS3L77TDwcG49BoAeZPjD5NhHoWJvw7q4=;
        b=TQifI87OTGnCAEknV/Oh1HcUyFLpbpZ/VsceramrnCa4hGBCnwZ1yqoemEv/o8Zx8N
         2/0/9/5A2qcjpewDKTjPJsw8w9SOltciq6uYMV1gdL8jvtVt6JS8N0OT/LZy+sClJ+jz
         plJzVSUsOQxpwV2bY2mIgBGtSsDAM//H7Gmu9VsLJ/PRa1BFji74o01rH29EPdd42UFd
         5s37zloG+BVgqMAfeeeMFBJPx7czEa07M4qh+2K8pfyE4FdTvUJrFNclQZ2XBd/XmMet
         3tQGe+Q1hcRnpFPaZdsGPWA3mpkx5mZVe5/smAI1DTpdEwV/D/tDacdTf+H9t+q5KxCn
         mQEQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771493717; x=1772098517; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qwP73GPLt6/49YtKqBvxtty3Y7ZnoSWI6pg6OHhH1MU=;
        b=O+79GAjrfutAqPW9UdOjtEZwRahYbUWG0djjo2jTHqHnkzVBxfiSAkCgAKkGjRISMX
         L2ELXRTY3jOpb/w1s8fDSB3h28lvquHHCHMpFZ24YZE3u4riZAxZjPH5U9bXTEkOEk0P
         v0jM4Qg2MYdn9d1NZgCnaSsb5IgNb0tOf2xo8P3iSu9coz8ZGcM99BcGHAMsLQN7hlzG
         NLHzOWDLhLhuYFew8PqbQFBbSNcMVDfQnymR/e+7flp9SAtICvP03WtqfvJzIDelME5C
         rumcaQnHHbb6r/etdDgUdAR29rrRWfAhAc5uq18qBjiLcw3PpnJCWJPbTOtnfFCZKHE1
         4zNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771493717; x=1772098517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qwP73GPLt6/49YtKqBvxtty3Y7ZnoSWI6pg6OHhH1MU=;
        b=F89tfuN+scKoS2fALhYsLpIpE+Wb5fIQyAnnOWtUS/iLqYfuR22m5HFMP/8axCox02
         ovujBfxXuKMb+ebuAFiKPuwzWfNoxYE1d+xf4jj11LQPhJmeoeuF3LzsejFCjESoH1pj
         Ff2NrSHB6A2kFzUbns5K9Vp1vwwlN3yNeHx3abhzEaPiybqnStNdDhJJx9Wm+cXYurdi
         sg73zScEIGb9hBshEQziv2pIYcHvkbwj8fjxiHJz4670d6zspBxfYDEMfOBve8Uj7kGi
         SX1nSD2WmnSVrJEzKpGuubehfm0uLEB/lgA2rTqVMsXk/h305cgYrQj2ofubV76LOMBa
         z1oQ==
X-Forwarded-Encrypted: i=1; AJvYcCULUr8M194uCpDcsj1tN8aBl4//5vx8ieJySlrqO0DtZe132ZrTlh0+5rYIE46MMiilHU48iFA+m3E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7tF0XQ1AF3Kr3fLiQwreM4fQzcMLEVadWnzKPIlQzUI53o1Z0
	ssQMh0tEZjf1Mt9oDaBQG6pCc8e5JCeZaEcUJq5wDPFdn2Hbds4AlXi7rDKA2Ip4yX/9I+YnlNn
	Qk9F9hDTuuZRbc0Pjv3MvZGSrHLTd/i7eZDERWUSwMw==
X-Gm-Gg: AZuq6aJtlNOwiDZwjNZsqwU/Svv9RSb25D4F86riY3JSR/PNc+F+WB86Jtld3Fmvr5n
	uPhXK+ZN3ULgiE8waaayYWjn/xVIeKJtgmgUDB/jvgr4TfJXB+cpBIRWur8PaJel0WOk/Bw8Zdz
	SV+7NWdIYdV44MHlNXMNR+aThlR8RS7dyIEqDyEE37AO/MaZ6DLsoBo2ug6+HBxDdzQmiuNmUPY
	HjWpb9wrtfHudHJ30cxpP6EL4DRIq2RdqySmj45Iocj6985rjiudDYGuRWEd45e/6Qts0hXg8uD
	Lupydn46bzT384fXFtZBCrGUc0FzVqGsZqd73Tpg
X-Received: by 2002:ac2:4f06:0:b0:59e:144:64b6 with SMTP id
 2adb3069b0e04-59f89751253mr639377e87.21.1771493716463; Thu, 19 Feb 2026
 01:35:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260218165609.378983-1-marco.crivellari@suse.com> <aZZmVuY6C8PJMh_F@dread>
In-Reply-To: <aZZmVuY6C8PJMh_F@dread>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Thu, 19 Feb 2026 10:35:05 +0100
X-Gm-Features: AaiRm50uFsB4Wl3syTOS_67PY-dPVy0dI9VHOt1139FVH3f6WTgGaNZ7sO9ygl0
Message-ID: <CAAofZF6Osnih1Atg5dzSqCH3pAK5U5jMfRX+pCu2HPwmpRmBOg@mail.gmail.com>
Subject: Re: [PATCH] xfs: convert alloc_workqueue users to WQ_UNBOUND
To: Dave Chinner <dgc@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, Anthony Iliopoulos <ailiopoulos@suse.com>, Carlos Maiolino <cem@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 19, 2026 at 2:24=E2=80=AFAM Dave Chinner <dgc@kernel.org> wrote=
:
>
> On Wed, Feb 18, 2026 at 05:56:09PM +0100, Marco Crivellari wrote:
> > Recently, as part of a workqueue refactor, WQ_PERCPU has been added to
> > alloc_workqueue() users that didn't specify WQ_UNBOUND.
> > The change has been introduced by:
> >
> >   69635d7f4b344 ("fs: WQ_PERCPU added to alloc_workqueue users")
> >
> > These specific workqueues don't use per-cpu data, so change the behavio=
r
> > removing WQ_PERCPU and adding WQ_UNBOUND.
>
> Your definition for "doesn't need per-cpu workqueues" is sadly
> deficient.

I should have added a "request for comments" for this patch, maybe.
Anyhow I meant they are not operating on per-cpu data, so it wasn't
"strictly" necessary because of this, sorry.

Thanks for all the information you shared. I will read carefully.

--

Marco Crivellari

L3 Support Engineer
