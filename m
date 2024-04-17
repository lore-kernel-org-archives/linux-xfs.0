Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598D88172F
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 22:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713394534; cv=none; b=dRKDfSK2XyGd/tp1fy3/pTTQOi0ZNtqzorFHA43kD61lHGvgeFeXy+oblGArT51DZF3BgP+mU2C8UK1oQiUW33qpIHqYAzHPgTZcwLfVPaGPdv1DgfWv/qB+vHdx/FvPcYzzFU7us322t+OmbyouKK6xteoYpG/p/+WnpFGa63U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713394534; c=relaxed/simple;
	bh=munr0gwDa+J7zdimHafKmi2Y6h+zhQ4Odizyw7y19wo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R8zTHk8d5zGy/fftyYSFcds4Op9oR+EBAcyvGAlqvAcez0r5n5GpIDQHPcuvkKYSU1biZBaSfTVi9STAXX4oF4uCg4lR2DQ6NbkyG4QohIRUqNoeBSBSVFUCpBg7lhRrKzUBxqv2OUTTKBuvx+gNYd3M44W8wDFbmhWD4XptWRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jlj3nmXK; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jlj3nmXK"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-dd10ebcd702so272680276.2
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713394532; x=1713999332; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=munr0gwDa+J7zdimHafKmi2Y6h+zhQ4Odizyw7y19wo=;
        b=jlj3nmXK1BiXDiRR+Po2eWyMHEHquXmY8ZiVZQieH3ptyVLQ7x8weRs192MnA0sJ6b
         Lx+jTnmKmtYqvzJWwfxe01FpHN9FcDij3Zn67mbesj9lcyoH76WcoWR/gA6iuwWpXqe3
         1vnh8akSazYoJR4BMauFRxrqhgMVHfWy6+UgSCSIbHJFpC48qho1vxWjTVqYnY2WLLTh
         kIbNci9oPXXabynpKVy7hUcs+MUq7Znd113XpiG0X2iyAfkhLOgmOo5Y0Kvtrxjq81Qc
         nVyZzFpip3wVVxOguoVwvjkKSmRZOTpLB7cXzxXkyKuPdhvrPy4DG5WlUsyCn8d7/2Vy
         EuRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713394532; x=1713999332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=munr0gwDa+J7zdimHafKmi2Y6h+zhQ4Odizyw7y19wo=;
        b=UByep/fCSF00Wa+P+YvRe2ggU12HYHkodC2GQ8GdwXSFCgkJvhN8hcq5woacveoE4G
         O+RMsvbtJk+4Z3Oh9a7WCC79O+7+7l7NMKHnRJMjp8oM0WKi0Es+vAMiexpxCw1AQ/nx
         IEiDAgR8GoOIUm7A1rG2HKkhwVn4iTHos7LC+fGkxMf7CkuzUgls0PIjNOIbMaEvadFn
         T7BnkCHSI7axb2ILR32XmrmzrxJuX9Z5pkichT/D/yhjZ3UEOj2KI0qLP+tqkdxNLDl5
         uRWqXvqIxuznqEIgquTDk+Vco3rmwipkJGC37TJuXOnW1sjbAxqgwGm8cKqkCpOWwIDg
         DZ2g==
X-Forwarded-Encrypted: i=1; AJvYcCVVmi50NIHIlc290wAM798O598/lV4tfa+19ctD41kvFNbMVF+ZYd482rDas8CqL/DmicEByyuNzv9YSbHifqW22BRRrRXymtYD
X-Gm-Message-State: AOJu0YxAOYlq83edFJX9wQPGGxDmCLFXa/qykBAAIC7UOVUg1eEz/e5i
	uOZrb70UILVbttlGkRxhkCmdFjJM5Q0OANRCXIhTCYqoRY+qETCXBxdIpU1Zpe89zQI5vpIfulL
	hYDw/EqFSxaEr8vC3Y9imOAY4kpE=
X-Google-Smtp-Source: AGHT+IH7p1D/M3srcsbvf4PxLSYNrbjkeBY/fCZPIFeV+n+lkz9SllbixCRkBsm3cgkJcCKAVlR9nH7h4B4gHWdyHr4=
X-Received: by 2002:a5b:a8e:0:b0:dcb:ca7e:7e6f with SMTP id
 h14-20020a5b0a8e000000b00dcbca7e7e6fmr848654ybq.55.1713394532185; Wed, 17 Apr
 2024 15:55:32 -0700 (PDT)
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
 <CAOQ4uxjqdi=ARyGirFqiBQAwmvcotZ=nOV7xdw8ieyfD4_P4bw@mail.gmail.com> <CACzhbgT8aeY9j2mqeoSBZJ_XeREyhYw3+jfXUoVGQ1OB36S7zA@mail.gmail.com>
In-Reply-To: <CACzhbgT8aeY9j2mqeoSBZJ_XeREyhYw3+jfXUoVGQ1OB36S7zA@mail.gmail.com>
From: Leah Rumancik <leah.rumancik@gmail.com>
Date: Wed, 17 Apr 2024 17:55:21 -0500
Message-ID: <CACzhbgRb4hR-3pSz6_z0ytCjp9nNVpaR3Dn0mUN4mv61LRfA5g@mail.gmail.com>
Subject: Re: [PATCH 6.1 0/6] backport xfs fix patches reported by xfs/179/270/557/606
To: Amir Goldstein <amir73il@gmail.com>
Cc: Mahmoud Adam <mngyadam@amazon.com>, "Theodore Ts'o" <tytso@mit.edu>, 
	"Darrick J. Wong" <djwong@kernel.org>, Leah Rumancik <lrumancik@google.com>, 
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Just an update on this, I added these patches to my current set and am
now seeing issues with the logdev config not finishing. Will separate
out into two sets again and try to track down the issue.

- Leah

On Fri, Apr 5, 2024 at 11:53=E2=80=AFAM Leah Rumancik <leah.rumancik@gmail.=
com> wrote:
>
> Hi!
>
> I'm happy to run some tests for this. I have a set currently in
> progress. Can do this set next and probably have out in a week or two
> if that timeline works for you.
>
> - Leah
>
>
> On Fri, Apr 5, 2024 at 7:40=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
> >
> > On Fri, Apr 5, 2024 at 2:12=E2=80=AFPM Mahmoud Adam <mngyadam@amazon.co=
m> wrote:
> > >
> > >
> > > Dropping stable mailing list to avoid spamming the thread
> >
> > Adding Chandan and xfs list.
> >
> > > Amir Goldstein <amir73il@gmail.com> writes:
> > >
> > > > On Fri, Apr 5, 2024 at 12:27=E2=80=AFPM Greg KH <gregkh@linuxfounda=
tion.org> wrote:
> > > >>
> > > >> On Thu, Apr 04, 2024 at 11:15:25AM +0200, Mahmoud Adam wrote:
> > > >> > Amir Goldstein <amir73il@gmail.com> writes:
> > > >> >
> > > >> > > On Wed, Apr 3, 2024 at 9:18=E2=80=AFPM Darrick J. Wong <djwong=
@kernel.org> wrote:
> > > >> > >> To the group: Who's the appropriate person to handle these?
> > > >> > >>
> > > >> > >> Mahmoud: If the answer to the above is "???" or silence, woul=
d you be
> > > >> > >> willing to take on stable testing and maintenance?
> > > >> >
> > > >> > Probably there is an answer now :). But Yes, I'm okay with doing=
 that,
> > > >> > Xfstests is already part for our nightly 6.1 testing.
> > > >
> > > > Let's wait for Leah to chime in and then decide.
> > > > Leah's test coverage is larger than the tests that Mahmoud ran.
> > > >
> > >
> > > For curiosity, What kind of larger coverage used?
> >
> > If you only run 'xfs/quick' that is a small part of the tests.
> > generic/quick are not a bit least important, but generally speaking
> > several rounds of -g auto is the standard for regression testing.
> >
> > kdevops runs these 7 xfs configurations by default:
> > https://github.com/linux-kdevops/kdevops/blob/main/workflows/fstests/xf=
s/Kconfig#L763
> >
> > but every tester can customize the configurations.
> > Leah is running gce-xfstests with some other set of configurations.
> >
> > Thanks,
> > Amir.
> >
