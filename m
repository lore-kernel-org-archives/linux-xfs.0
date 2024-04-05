Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F98979E3
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 16:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712336044; cv=none; b=utuwD2pQmMAyYFdBqnrEzSF+ULixX9Dc64g0ll+3NUsLDRCBfMcwJ2tkGZMoVN6ddUXUAV1X1ngb45ebz6CPFCXQ3dS/uZIZS9SYqvoXvpd4cNT++Mlrb++hwvIRQPKBoh1wqGK0PDu+zxwNHplFfLAu3JnbkADK7+aUt6lweRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712336044; c=relaxed/simple;
	bh=8hiILCWWT0foGk9QLb/WKs9j1WuDz5G044mYIjzBrOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Poc5vyxBEQBe2NpqKRj/01vColnvy4QR6/Z0I7z9DxNTywwDcsXfiroqKEserj+5WS94WgSeGtM1gEC9bd5zbGoLrccSWWqNCh/qbRsXjoF+GzQjnE0CUsGB04Z5ED+2n0GjexhIu68IqvS4K7HqlwkttN3nL2A4pZRMgGP44c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EvAAJqxc; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EvAAJqxc"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-615019cd427so22370707b3.3
        for <linux-xfs@vger.kernel.org>; Fri, 05 Apr 2024 09:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712336041; x=1712940841; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8hiILCWWT0foGk9QLb/WKs9j1WuDz5G044mYIjzBrOw=;
        b=EvAAJqxcvo5UyCFUeeAUWKvEcYztonFqDDOK+qV98I0itXgMdb1qTPeO++nwBC8PSQ
         7SW/LzsmVpnJLJvcGJeNsXT4quX0xY8JqlDNso/XXowCcXe+RcEWB9pqdMcm/tPNpvYF
         DG4+uq5L2b1zxeA+nZVNcYpKwSfcsLyRjyBCDG4XXmHW6WVVR+fBiN6ZeNZcb+iI9864
         PJCz29aVyq38q+r/nYlU4bL+izZGv9t/kYtqMe2Qf0uYvVpM9lV3EEBBEXv/TNv5S4VS
         Dd6iw6Wt7vGAO3JLRHT2Y8UDBlkM1uRsu4c1UTERQb8lZXjF+jCigM3OyYoAuarqd0LE
         fdgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712336041; x=1712940841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8hiILCWWT0foGk9QLb/WKs9j1WuDz5G044mYIjzBrOw=;
        b=jw6hVvyELJ9MRLie7mo86oAHl5BHbezUPCVrJDcyPQm6/FeQS8yw8qDs0p8NakvU+0
         MWi5q6ECBJYKHywpsMsytjKmdE0IDEZiiGQoH20UwOy0npb4eeoJ1TTqvSpgtBLqw6Ls
         gs+SZ3bpEpJV9Vux1YuD5vC7RGoCY1DsJkr3EBRaN361NCxZPgq/R5ehn2lvxun2MTVe
         +UxzOj/TaaLKQjtGkNuLGBBUWRq1FaRkv4FbG3U+2UQ14kQeJQco+vdBQvDnMQuKqE3m
         XOGFyCeYDfOkiQKAV5hkNrUPYEFahEoLpoLmee9f/OBljOjA5vXKop1uzXLX+NpuxD01
         D/Tw==
X-Forwarded-Encrypted: i=1; AJvYcCW+zBe6Np6NciDNRt6RRILSEisf1UemU4PtR5A5jR78pTGs7oisWi9znPYfc7cnbFOLTBOtJhnmRcWILRCKbapjTVFJvHzA+39W
X-Gm-Message-State: AOJu0YyzLURqt4JZaALsJkYsBSWwXNnVLhfya33M6WkgFoKlv20WmeNY
	HA81YaKryRFrL+IkicWQLCz0VSxtnF37kCHZtdT+gk8K6qgngCN+JoYAeDVKHiGYWjsRWGKF3j5
	I3rS1eFAddnlaS/j2OJcrkXZBaa8=
X-Google-Smtp-Source: AGHT+IH3eUjmH2cM4NDicY+PhLqazYFJe/viewiunY5Mmttwwk3xpL2oV/2u1Tr7WDWa/gEkRxENM8+QWi+oFZ/w5EE=
X-Received: by 2002:a25:6b4c:0:b0:dcc:ec02:38b0 with SMTP id
 o12-20020a256b4c000000b00dccec0238b0mr1585495ybm.64.1712336041553; Fri, 05
 Apr 2024 09:54:01 -0700 (PDT)
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
 <lrkyq5xwwcbcm.fsf@dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com> <CAOQ4uxjqdi=ARyGirFqiBQAwmvcotZ=nOV7xdw8ieyfD4_P4bw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjqdi=ARyGirFqiBQAwmvcotZ=nOV7xdw8ieyfD4_P4bw@mail.gmail.com>
From: Leah Rumancik <leah.rumancik@gmail.com>
Date: Fri, 5 Apr 2024 09:53:50 -0700
Message-ID: <CACzhbgT8aeY9j2mqeoSBZJ_XeREyhYw3+jfXUoVGQ1OB36S7zA@mail.gmail.com>
Subject: Re: [PATCH 6.1 0/6] backport xfs fix patches reported by xfs/179/270/557/606
To: Amir Goldstein <amir73il@gmail.com>
Cc: Mahmoud Adam <mngyadam@amazon.com>, "Theodore Ts'o" <tytso@mit.edu>, 
	"Darrick J. Wong" <djwong@kernel.org>, Leah Rumancik <lrumancik@google.com>, 
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi!

I'm happy to run some tests for this. I have a set currently in
progress. Can do this set next and probably have out in a week or two
if that timeline works for you.

- Leah


On Fri, Apr 5, 2024 at 7:40=E2=80=AFAM Amir Goldstein <amir73il@gmail.com> =
wrote:
>
> On Fri, Apr 5, 2024 at 2:12=E2=80=AFPM Mahmoud Adam <mngyadam@amazon.com>=
 wrote:
> >
> >
> > Dropping stable mailing list to avoid spamming the thread
>
> Adding Chandan and xfs list.
>
> > Amir Goldstein <amir73il@gmail.com> writes:
> >
> > > On Fri, Apr 5, 2024 at 12:27=E2=80=AFPM Greg KH <gregkh@linuxfoundati=
on.org> wrote:
> > >>
> > >> On Thu, Apr 04, 2024 at 11:15:25AM +0200, Mahmoud Adam wrote:
> > >> > Amir Goldstein <amir73il@gmail.com> writes:
> > >> >
> > >> > > On Wed, Apr 3, 2024 at 9:18=E2=80=AFPM Darrick J. Wong <djwong@k=
ernel.org> wrote:
> > >> > >> To the group: Who's the appropriate person to handle these?
> > >> > >>
> > >> > >> Mahmoud: If the answer to the above is "???" or silence, would =
you be
> > >> > >> willing to take on stable testing and maintenance?
> > >> >
> > >> > Probably there is an answer now :). But Yes, I'm okay with doing t=
hat,
> > >> > Xfstests is already part for our nightly 6.1 testing.
> > >
> > > Let's wait for Leah to chime in and then decide.
> > > Leah's test coverage is larger than the tests that Mahmoud ran.
> > >
> >
> > For curiosity, What kind of larger coverage used?
>
> If you only run 'xfs/quick' that is a small part of the tests.
> generic/quick are not a bit least important, but generally speaking
> several rounds of -g auto is the standard for regression testing.
>
> kdevops runs these 7 xfs configurations by default:
> https://github.com/linux-kdevops/kdevops/blob/main/workflows/fstests/xfs/=
Kconfig#L763
>
> but every tester can customize the configurations.
> Leah is running gce-xfstests with some other set of configurations.
>
> Thanks,
> Amir.
>
