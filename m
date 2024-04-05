Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5B915FA95
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 14:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712328047; cv=none; b=Ge67gizQ+Jwv1u9U0+4bXRHSLBCTA7l14lOkqaFRvqA97ogSzh+Jx/A+IoRPtKPxBDj3rXaa19ygbPSoVvAxYcSZsqre91sb+x0PLwNt3mInakPhXSYQ7kClVD25wfKtNvfJs6NrcYsatV7O64WfX6nHlw/1YMXX+xQmQSgxtm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712328047; c=relaxed/simple;
	bh=Mf2Oj2zamR0wldXfb2pOrk/VpTr9Xi8Hm2aTtc6Yy2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ATRD17BEurRq19tHknHzZSTxbQizZO1S4xFGHVmoZZCc4OlZWmP+FPrcKML2dHF0vK21S7bi0OQcEcC2px48gadMDL+9V2FtQCkAeup6zQhC9N6xFLW3ICTJ0VR6XfkwmCO3WCdj4yydtMyQWcQE9xPlgu5jT3E2qZAjsufq81k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A4cR4kcS; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A4cR4kcS"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6962a97752eso14840906d6.2
        for <linux-xfs@vger.kernel.org>; Fri, 05 Apr 2024 07:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712328045; x=1712932845; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mf2Oj2zamR0wldXfb2pOrk/VpTr9Xi8Hm2aTtc6Yy2w=;
        b=A4cR4kcSsmq6lN2S6rGcUJRUJqg9oKdkwVKzm0dJOPJyIiYiiQn5IHNZ/SaRVMH42r
         ePm4bgod6uCAZ66WKowGK+02QQZk8Vi7XQDU5gPCmI5ymJFJAaC4danbG54I0tiMflo1
         2XZCHFCx08EV9ozpaPIAg4JMurtDVDnz+ib6Y4ohw0+UzTVlIRwynwQF622DvuLJk1hO
         T7qlGzaiAdMaTRVDTPAc4mjcb2Tm+HN87VQAY7ljUSpfWTnRlODfzJu6gCgQEkj8tXEU
         OuvD9bANco+BM9TZoPYeLQ3mZkNbmRoduFgRgzT33Uz7BA69loc098tAOzRXI6jO38P3
         hJlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712328045; x=1712932845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mf2Oj2zamR0wldXfb2pOrk/VpTr9Xi8Hm2aTtc6Yy2w=;
        b=keefYhl+Tw905RGHbI3ePR/uPBm0qGErqPPyFX1m/JdVnQh9T6UsmG5vSlbxisB++2
         31RAQzzHYaUYpVJUCDnrESccgtKW7Z98y7T6rBVfXUWoHnXXeMdr6Afw2xi/3BcZt+Qk
         B1L8YfZkoTXSc7xEhrhOflHyOOgUF6UMFWW7zjSMMT7oNnVIyP6rHdKhOU+6PmgaD1Kr
         xvP6s6bpqMFDcrIqYlGW/uhbcIJ2DxyCz5LngV9RSKB3B+qpKkFLay5YKBRH6Vi+1Y8M
         Leg8ktRgiG7sebKbVvRqQe4gcHnJzGNOMYWhacc4hRwvE2TR/47xJ62kpYxPq5QLyhJ/
         URyg==
X-Forwarded-Encrypted: i=1; AJvYcCW/j45CcTeMOp3793TK9VZdMC01aqW4zAXubWXhrxOCwMEU/YH/TgazsFre13J1CyY1oQP8dLu0RGbo7RmMtMKDrxAgrBuY+b3t
X-Gm-Message-State: AOJu0YySbJ+GgqpX/GeKsEq+QHIbIPzKamqAAOkPv7s08nQxsZ0M8XVv
	tp1ANg+g4GkhUqq15jgInhf8RCjzOKjWxABU0PLJMB8ijWhuHzkGJhuHAglvjGOvj4GHlruGybT
	/64z37s5zrbIB643odZqeRkSodtI=
X-Google-Smtp-Source: AGHT+IHx0iZM80oKmRUq3Uy9AIxyCU4ow5ZnZGr/RMcKCMFAGevYW/ZDgs9U1JxdtplzjeCquJMpR+0iOsKmhtn8gNs=
X-Received: by 2002:a05:6214:1d0c:b0:699:1dee:c1e3 with SMTP id
 e12-20020a0562141d0c00b006991deec1e3mr1402458qvd.63.1712328044963; Fri, 05
 Apr 2024 07:40:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403125949.33676-1-mngyadam@amazon.com> <20240403181834.GA6414@frogsfrogsfrogs>
 <CAOQ4uxjFxVXga5tmJ0YvQ-rQdRhoG89r5yzwh7NAjLQTNKDQFw@mail.gmail.com>
 <lrkyqh6ghcwuq.fsf@dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com>
 <2024040512-selected-prognosis-88a0@gregkh> <CAOQ4uxg32LW0mmH=j9f6yoFOPOAVDaeJ2bLqz=yQ-LJOxWRiBg@mail.gmail.com>
 <lrkyq5xwwcbcm.fsf@dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com>
In-Reply-To: <lrkyq5xwwcbcm.fsf@dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 5 Apr 2024 17:40:33 +0300
Message-ID: <CAOQ4uxjqdi=ARyGirFqiBQAwmvcotZ=nOV7xdw8ieyfD4_P4bw@mail.gmail.com>
Subject: Re: [PATCH 6.1 0/6] backport xfs fix patches reported by xfs/179/270/557/606
To: Mahmoud Adam <mngyadam@amazon.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>, 
	Leah Rumancik <lrumancik@google.com>, Chandan Babu R <chandan.babu@oracle.com>, 
	linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 5, 2024 at 2:12=E2=80=AFPM Mahmoud Adam <mngyadam@amazon.com> w=
rote:
>
>
> Dropping stable mailing list to avoid spamming the thread

Adding Chandan and xfs list.

> Amir Goldstein <amir73il@gmail.com> writes:
>
> > On Fri, Apr 5, 2024 at 12:27=E2=80=AFPM Greg KH <gregkh@linuxfoundation=
.org> wrote:
> >>
> >> On Thu, Apr 04, 2024 at 11:15:25AM +0200, Mahmoud Adam wrote:
> >> > Amir Goldstein <amir73il@gmail.com> writes:
> >> >
> >> > > On Wed, Apr 3, 2024 at 9:18=E2=80=AFPM Darrick J. Wong <djwong@ker=
nel.org> wrote:
> >> > >> To the group: Who's the appropriate person to handle these?
> >> > >>
> >> > >> Mahmoud: If the answer to the above is "???" or silence, would yo=
u be
> >> > >> willing to take on stable testing and maintenance?
> >> >
> >> > Probably there is an answer now :). But Yes, I'm okay with doing tha=
t,
> >> > Xfstests is already part for our nightly 6.1 testing.
> >
> > Let's wait for Leah to chime in and then decide.
> > Leah's test coverage is larger than the tests that Mahmoud ran.
> >
>
> For curiosity, What kind of larger coverage used?

If you only run 'xfs/quick' that is a small part of the tests.
generic/quick are not a bit least important, but generally speaking
several rounds of -g auto is the standard for regression testing.

kdevops runs these 7 xfs configurations by default:
https://github.com/linux-kdevops/kdevops/blob/main/workflows/fstests/xfs/Kc=
onfig#L763

but every tester can customize the configurations.
Leah is running gce-xfstests with some other set of configurations.

Thanks,
Amir.
