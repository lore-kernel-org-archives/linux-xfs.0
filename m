Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AB8770E2
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2024 20:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721938309; cv=none; b=W2c+O7/i2CclUhBjilrfhb9qTEpK0Tll9e8BYx4nfDj/J2pxlt0Hk9WEPetfGE8PU3CpYrbUGY4oPv1/03ngEFgQ4YLeazSrk6pcTGyM5RVBbRjmynZnJnNrJS4CIP7tmUAc+wwAR/euoJRktArvVGjSOFd3Qu5H8icjf4kXOXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721938309; c=relaxed/simple;
	bh=IvdqZvTacjy6MAQ5qDRh4fw3aGKlpJ5TgBBkoXVfd24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ah0q5X74ivT80Je0iU+hG0U+pHzDfFkGSX10GZXWPc/PsRDdZEw6bJv1yvKlhCUl+49WPgKynDjafzydMQ5wrUDvlX1DZ+bncFI1dkRSa4u38242qOKm/ex4Mlsh8C8INJZREkLpu0zjLDlQoFPwP43gJhX4OaIQq9pRaXieH6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VGGJpc9z; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VGGJpc9z"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5a2ffc3447fso1625065a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2024 13:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1721938306; x=1722543106; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HYXza095pMOoHpnczk24pBNsoS9nyihsTN3J/3umgZw=;
        b=VGGJpc9zDN+mkjvHijUbdgW3//dooXZcuMo645a1xri5k48VE1AQuIbTGr9azz1xnQ
         mUhlZMOj1qSMYJYlVdttSq/JTONsicPW1ho5S1GHxC2nPVMvXLJxTKH64P+X/1BtC5ks
         ZNNTyxSR3pCAijP16sHF2EwMekMt33xW8Nmu8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721938306; x=1722543106;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HYXza095pMOoHpnczk24pBNsoS9nyihsTN3J/3umgZw=;
        b=fbFbOanLUGVAQ5F1S9SLuuLZILYbfPcESaqDrkCkKZVrSQmVB7m+fOx8jgcUMaeHMv
         oS4PdjBYNcvOqWngn6xlccO1gie43+wV4JAWltvMl2Oc6OY9Hxtaf1RoqJ96pWVksXKF
         Q3SU2XjbjMvPYb5DkzhWTq4mj7DY2z5aw6lHqOK8gxQ1kOB48Xzf4XRQE0AZ+Uhlk4yt
         uDgFMc+Xil3Dq2H/B5ov6Q8+MJm+wOqH3XpbNLfCDo8C5qbIPu617msEvsDVjjhK5SZv
         vOpyzasMGCr2Je5G9V9NslE0KRuzDJo7NqrvvJMLiMr9Ejwz5qkKtSZNe2yzQN7Wup8y
         ei2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXSHVi2kovAYpKvLN7gs12o6qm1ydhc3Y3VBqxApV61dWETDwmEX3sNJWXpoUMd2YFN36k7FyUWxxsxNzlmWRF7Y7KQApzLZPYX
X-Gm-Message-State: AOJu0YxYJKXe6Ed/YwpPDsVo570Prf8FnPOr/7k0iEhWEsgSpS0uJMYF
	8Jjl03lDkB+MuIxlFZrA+g+GlctEhthXqxaVUSLFKl2Z1utmdG+ICXC25DOY3a8DxX6Qi/FkpkL
	grZg=
X-Google-Smtp-Source: AGHT+IG0+HT/ky4wKRPLKVqlhpC59+Ol1DRfwUo76cEfHcUnWzOcfzqah12Fv3CNhsBJjLtevsFASg==
X-Received: by 2002:a17:907:3faa:b0:a77:deb2:8b01 with SMTP id a640c23a62f3a-a7acb38f1damr266746866b.1.1721938306522;
        Thu, 25 Jul 2024 13:11:46 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acac60cb4sm105264766b.92.2024.07.25.13.11.44
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 13:11:45 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5a2ffc3447fso1625012a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2024 13:11:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUCku02xh6dDP+OLWZaDKFU+R4l7+J/ihAqpdaSlsIOwQPYfJa7E0wiSAWGx+FRo2j3vS9eTTR2J1FxhLSqQVTM1DQZ6KyhIXAb
X-Received: by 2002:a50:a686:0:b0:5a1:1:27a9 with SMTP id 4fb4d7f45d1cf-5ac63b59c17mr2468749a12.18.1721938304541;
 Thu, 25 Jul 2024 13:11:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240724210020eucas1p2db4a3e71e4b9696804ac8f1bad6e1c61@eucas1p2.samsung.com>
 <20240724210014.mc6nima6cekgiukx@joelS2.panther.com>
In-Reply-To: <20240724210014.mc6nima6cekgiukx@joelS2.panther.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Jul 2024 13:11:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiHHDGQ03qJc+yZKmUpmKOgbz26Tq=XBrYcmNww8L_V0A@mail.gmail.com>
Message-ID: <CAHk-=wiHHDGQ03qJc+yZKmUpmKOgbz26Tq=XBrYcmNww8L_V0A@mail.gmail.com>
Subject: Re: [GIT PULL] sysctl constification changes for v6.11-rc1
To: Joel Granados <j.granados@samsung.com>
Cc: =?UTF-8?B?VGhvbWFzIFdlae+/vXNjaHVo?= <linux@weissschuh.net>, 
	Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <kees@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-security-module@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, bpf@vger.kernel.org, kexec@lists.infradead.org, 
	linux-hardening@vger.kernel.org, bridge@lists.linux.dev, 
	mptcp@lists.linux.dev, lvs-devel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-sctp@vger.kernel.org, 
	linux-nfs@vger.kernel.org, apparmor@lists.ubuntu.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 24 Jul 2024 at 14:00, Joel Granados <j.granados@samsung.com> wrote:
>
> This is my first time sending out a semantic patch, so get back to me if
> you have issues or prefer some other way of receiving it.

Looks fine to me.

Sometimes if it's just a pure scripting change, people send me the
script itself and just ask me to run it as a final thing before the
rc1 release or something like that.

But since in practice there's almost always some additional manual
cleanup, doing it this way with the script documented in the commit is
typically the right way to go.

This time it was details like whitespace alignment, sometimes it's
"the script did 95%, but there was another call site that also needed
updating", or just a documentation update to go in together with the
change or whatever.

Anyway, pulled and just going through my build tests now.

              Linus
