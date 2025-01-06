Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450AC70830
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 19:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736191283; cv=none; b=VqEQ1YUKY6V/m6KhS/68jZCzttpmwBoydqMWqUDU2vidru5SB1/yeSvwOw0p8CYZH6ef/xDbO0/+25h1cITIGtG0eA0iLqAMQLpeuhC8D074fOIpKWKsC5HC6POUnK0aZr46ef+hORF4H6aP3ZIB+8Kz/9pcgIvMUKKp98F6ipA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736191283; c=relaxed/simple;
	bh=HFgdR4L/DhPOYtoofHe46i6/7trSDZVS+pEUm5fp3aI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o1RUNFMF+JFoj0/n3j5sj4yztMbqxZEpBbN2ilMqq+Ji77JrYmjL6Cb9LYmegtqHYMvBO4Z0ODgj9spyLk1aanGZCM/ORCIG0nhc9k6bRnDA6hz8iytxPZ3E9Eb5fLmt46BpjRtY8X6hV9aE3TdsBx6e4PCXH5Q/ThOLFi7ePH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JsrE7cwE; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JsrE7cwE"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e549a71dd3dso4706024276.0
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jan 2025 11:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736191281; x=1736796081; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBPxLo3rfgysCtCfKNPRW2I+1MJGdeJ9Jvo1A4mDkR4=;
        b=JsrE7cwEXZVppVEA0+0ljAqLq6OpYpE7XovMAFuDALziVpk08zdvxH3rN1KJulnI1U
         HjBTYf2hqNdUBmnzCTZGqTEBaTEv4TmE673RK1daBFX8pibS6RQjmfM+eE9qVb8zz6jz
         FtIwdTJKDhirvmcsyHxPmMoUL+Pbu200mua3cyHoIcowBRTUfMGnVAneAAmpQNGG7IoZ
         TFWBWg+WrtOdc2+5MYJM7GmHPcAfIwpXwFe0wVegw4sQuTMcSYF+IxX3AD4mzQRpZAqh
         sfud1ugBMo29tkINj2vGaG6zMitKlQWuOoYrKxz262/3w2Ly8WbZT4RCW1Tc7ZoVNAD4
         x0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736191281; x=1736796081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hBPxLo3rfgysCtCfKNPRW2I+1MJGdeJ9Jvo1A4mDkR4=;
        b=l+om4BwfiSksrueBp262yRvh8Q7IXxfvrmWOHU0REr39ypWQKiNjpFOSTmScxbtAzj
         MJgqjjTIa/BiWRn6p1L6qmKtD4180J/qrNnCKrj+M5WvPgr1Ns0DsA/UuvwLfF+M66lc
         04kiEe6Eu877FUQf3xY1IgaYGSJ0gEyA9RHE68TF/HW18zm78Ntd4KzshtcPiutT60ZB
         e40utMkZM1hEv2YeYzKLNpdHVcOESDy2cqNQSge/WHZj1xlO5oI/oGuezR6Cwthu8KmM
         qTPxJ5Q0SFRWOhdJ4rr/G0eUMTX3MM1PrQm236yhKCtgL91/cIUgeqxHYGL8k/ml+NEA
         oXWw==
X-Forwarded-Encrypted: i=1; AJvYcCVSYDurmQnBxR8N5iXCj0vPBGlBbqXNDM2Meh5tRX6NOEAYI2Wwi/AFHI5FdPOV5KSDpbb35HfkZ8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0VAZu6jUjO9g8ynjfBcwW43GxEPmAM2kcnBJOZPrVGNrRLXqD
	17Wfu0T5Xc1386MtCYhTYmrWntg2mH5dQZRcEi1fRj36ABRr1I2GCa2Cq0+d68fQCVl/G9sx8+N
	i0Zm2M3GLq70hNm64Ut3KriAUzlQ=
X-Gm-Gg: ASbGncvJvXiOvweH34QGrnzJxSdKIm55K3qaUM0c0w376c+NIVIVqdiDqJgCfddD9Sy
	zueoRTMTUgZNZuLyWpbbKecSs0MEyrPmL7LekI9spgxyuUmqKHKj/fHc61yUyVnynN/A=
X-Google-Smtp-Source: AGHT+IG9I3giwswrJ3ZeK7yJgj1E2V1Nb2KkSGetLGW5jJ5CzMC7EHRZAz8MwBcHi6TNuI1PREpEBjh0M4AUgsIQPfg=
X-Received: by 2002:a05:6902:1108:b0:e38:1b17:8980 with SMTP id
 3f1490d57ef6-e538c202572mr32559967276.4.1736191281277; Mon, 06 Jan 2025
 11:21:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241219183237.GF6197@frogsfrogsfrogs> <vbcin7yhf7ymbt5o35clxzym3qh2irxrabkd72bnksiu2kzu7g@jzo22uocpzvv>
In-Reply-To: <vbcin7yhf7ymbt5o35clxzym3qh2irxrabkd72bnksiu2kzu7g@jzo22uocpzvv>
From: Leah Rumancik <leah.rumancik@gmail.com>
Date: Mon, 6 Jan 2025 11:21:10 -0800
X-Gm-Features: AbW1kva-efyKBV1leV7acGvEU8wuDrIglWiVL1QwGMMN1Kbt07Oqqqx4Hk1sotA
Message-ID: <CACzhbgS9wrsxr=F9yE62hcPmNj_61fFr3u61GLCZnFD4ai5HjQ@mail.gmail.com>
Subject: Re: Create xfs-stable@lists.linux.dev
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, helpdesk@kernel.org, "Theodore Ts'o" <tytso@mit.edu>, 
	xfs <linux-xfs@vger.kernel.org>, Catherine Hoang <catherine.hoang@oracle.com>, 
	Leah Rumancik <lrumancik@google.com>, Chandan Babu R <chandanbabu@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 20, 2024 at 10:37=E2=80=AFAM Konstantin Ryabitsev
<konstantin@linuxfoundation.org> wrote:
>
> On Thu, Dec 19, 2024 at 10:32:37AM -0800, Darrick J. Wong wrote:
> > Hi there,
> >
> > Could we create a separate mailing list to coordinate XFS LTS
> > stable backporting work?  There's enough traffic on the main XFS list
> > that the LTS backports get lost in the noise, and in the future we'd
> > like to have a place for our LTS testing robots to send automated email=
.
> >
> > A large portion of the upstream xfs community do not participate in LTS
> > work so there's no reason to blast them with all that traffic.  What do
> > the rest of you think about this?
>
> Can this work be done on stable@vger.kernel.org?

As the xfs stable maintenance process is still evolving quite a bit,
there will be a decent amount more traffic for xfs than for other
subsystems. I believe the actual stable patches will still go through
the normal stable list and the xfs-stable will mainly serve for
discussions on xfs-specific testing requirements/patch
selection/process questions/etc prior to actually submitting the
patches via stable. So I think it makes sense to split this out into a
separate list.

(did the list get created already?)

- leah

>
> -K
>
