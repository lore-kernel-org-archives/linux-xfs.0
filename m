Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C711C188A18
	for <linux-xfs@vger.kernel.org>; Fri, 18 Oct 2024 10:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729246430; cv=none; b=KIOLtjh3MohfTMLc5j2KyIIE6KeGiytOAbEwPVc+47NkZ8bMsUqS34aeHuaZBZR1tZSYVmDjz3OyV0wa5ptiW9oKDUDTx3X50uxcgm/XIR+Wo+h1/siYrZy14Ar4fWQ+B88SiSD4ECi/PvzqdkXsfP7SUhLS2v2XMHa94tUsWNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729246430; c=relaxed/simple;
	bh=hhdtRVVX7WzrR9ZDyQXljE21HGN2zqUu2fWkbYV8wsM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qj0Gb9SiAnde5utDvJRwGiXxU/ETdFBakbB5VFWfztkQAatdQDB2SWvfAjW1hu1Kvxs0KZtYMKvGnKLTFtrf8WwIPc9Mlcsrs07Vbi6bjDVx4DZuSomMVB2EXJbMqGD9urtTiII/oCnmw/07WK495lHKBK/p7lni/aWYKJ67PsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ggNlh+dx; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ggNlh+dx"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7ea6a4f287bso1348378a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 18 Oct 2024 03:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729246428; x=1729851228; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VNCexdy11NWtnd0DyBaI0rvoFNWq3YyoC1hC5FTN3Js=;
        b=ggNlh+dxHggm5OlGq0c6o8TcywSRdN8wLCdfYeAGc5H8sw34Io4f8PJlfvK3uQx6hE
         zGJjR6J6zfhDjaMAzraeBtuRWRXo6nq3Gv0RoG/vMgA+Qlz2HjsGW+2M8CQRM8ggsyId
         Uq+NUm7BmnMsQ2+Xkl98wx0fNYtbmD89k8M4WwVrUku/Sz504gKt6qXQDOQ2RkhRQvFt
         FaR/O1hX/q1lhIEUtpbTVkoMrLq2Nx32Fd8cr9yTWMFMaU5gffKse5mP8lC7MUpRNtgC
         rRrHdOBOUA7p3zzSfMNtu2JGjaqr2VF+28rMT2uK2OuBGsyX7AN4JOaNzPF+LCbFe0ul
         pwQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729246428; x=1729851228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VNCexdy11NWtnd0DyBaI0rvoFNWq3YyoC1hC5FTN3Js=;
        b=AQFuKeW55Zci8swhrsymtU6xLA2D4AUs3k9sYgWi8Oe5+dh3oZJLU/wnkJ2t3piJSg
         zNHIie4yebvIXFisNEWx/F9x7J8lJIgugcjMlHTFP6fJtm1BS2hbD01xb6EJ+lOXl5g2
         L6WlZtkh6PlQWng+M0DcInOs4wgcQ4p+z/l2rBIq39wdg5Sd8oo4mhDHUsDlwyITAIoR
         UR4DSoip9AQ2AlNFSL3CYC1cVe6v8iCS1nLx1OK5p8rWNZWsdmMmpNMyxv5OZFp3nvww
         SLHZSXZEmyulAaJ962s5BDbZSQCZf2/TAeIQDOHArtqz6DIrzjIxaYHQGzoHFYpeM09L
         II6g==
X-Forwarded-Encrypted: i=1; AJvYcCUQRE4SslZ/lQ/BKIF1iayZPPWAmgXh/4gVbueBrg4RmubfBNfgmeD8F5impVmwMefUjeYNHvTmro0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxdhwt7uaRQig1H/DByJzm8n2EXUbpJzmA/JMMelX0pAiIi9X+
	tCZIm9adA2MzjiaedjX7G1JN7KOzeL8AvI78IG0uD6OnbMXbrlC7zYsc/hzwhD9vZqJy5Svwc4+
	let9hBrFIvpQJ4vVyBmWLHz95xZXxzRojYIZ9
X-Google-Smtp-Source: AGHT+IGbfPAJIHa3zZ63TkKChq/v4MAkfsSPa0fAPK8u0ovX8VYnqJGHOcmDx4rGpG95XEuybm33qBWneRcfSb1uXSU=
X-Received: by 2002:a05:6a21:330b:b0:1d9:1e36:8f97 with SMTP id
 adf61e73a8af0-1d92c4dfef5mr2324042637.19.1729246427780; Fri, 18 Oct 2024
 03:13:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67104ab3.050a0220.d9b66.0175.GAE@google.com> <ZxBgAU7aasIzcBfj@dread.disaster.area>
In-Reply-To: <ZxBgAU7aasIzcBfj@dread.disaster.area>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 18 Oct 2024 12:13:33 +0200
Message-ID: <CANp29Y6Rv2vUg463F3SYTsSNDr=Hmnarbz377tS=Hash7pT4xw@mail.gmail.com>
Subject: Re: [syzbot] [xfs?] INFO: task hung in xfs_ail_push_all_sync (2)
To: Dave Chinner <david@fromorbit.com>
Cc: syzbot <syzbot+611be8174be36ca5dbc9@syzkaller.appspotmail.com>, cem@kernel.org, 
	chandan.babu@oracle.com, djwong@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Thu, Oct 17, 2024 at 2:53=E2=80=AFAM 'Dave Chinner' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> On Wed, Oct 16, 2024 at 04:22:27PM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    09f6b0c8904b Merge tag 'linux_kselftest-fixes-6.12-rc3'=
 of..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D14af3fd0580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D7cd9e7e4a8a=
0a15b
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D611be8174be36=
ca5dbc9
> > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for D=
ebian) 2.40
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D16c7705f9=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D14d2fb27980=
000
>

It's better to just leave the issue open until syzbot actually stops
triggering it. Otherwise, after every "#syz invalid", the crash will
be eventually seen again and re-sent to the mailing lists.

In the other email you mentioned
"/sys/fs/xfs/<dev>/error/metadata/EIO/max_retries" as the only way to
prevent this hang. Must max_retries be set every time after xfs is
mounted? Or is it possible to somehow preconfigure it once at VM boot
and then no longer worry about it during fuzzing?

> I explained this last time syzbot triggered this: this is a syzbot
> configuration problem, not a filesystem bug.
>
> [   96.418071][ T5112] XFS (loop0): Mounting V5 Filesystem c496e05e-540d-=
4c72-b591-04d79d8b4eeb
> [   96.593743][ T5112] XFS (loop0): Ending clean mount
> [   96.791357][ T5112] loop0: detected capacity change from 32768 to 0
> [   96.814808][ T5127] xfsaild/loop0: attempt to access beyond end of dev=
ice
> [   96.814808][ T5127] loop0: rw=3D4097, sector=3D2, nr_sectors =3D 1 lim=
it=3D0
> [   96.851235][ T5127] xfsaild/loop0: attempt to access beyond end of dev=
ice
> [   96.851235][ T5127] loop0: rw=3D4097, sector=3D24, nr_sectors =3D 8 li=
mit=3D0
> [   96.860284][    T9] XFS (loop0): metadata I/O error in "xfs_buf_ioerro=
r_alert_ratelimited+0x7b/0x1e0" at daddr 0x2 len 1 error 5
> [   96.886045][    T9] kworker/0:1: attempt to access beyond end of devic=
e
> [   96.886045][    T9] loop0: rw=3D4097, sector=3D2, nr_sectors =3D 1 lim=
it=3D0
> [   96.900489][ T5127] xfsaild/loop0: attempt to access beyond end of dev=
ice
> [   96.900489][ T5127] loop0: rw=3D4097, sector=3D32, nr_sectors =3D 8 li=
mit=3D0
> [   96.932892][    T9] kworker/0:1: attempt to access beyond end of devic=
e
> [   96.932892][    T9] loop0: rw=3D4097, sector=3D24, nr_sectors =3D 8 li=
mit=3D0
> [   96.940364][ T5127] xfsaild/loop0: attempt to access beyond end of dev=
ice
> [   96.940364][ T5127] loop0: rw=3D4097, sector=3D8832, nr_sectors =3D 64=
 limit=3D0
> .....
>
> And so it goes until something tries to freeze the filesystem and
> gets stuck waiting for writeback of metadata that is not making
> progress because XFS defaults to -retry metadata write errors
> forever- until the filesystem is shut down.
>
> If the user expects an XFS filesystem to fail fast when they
> accidentally shrink the block device under a mounted filesytem, then
> they need to configure XFS to fail metadata IO fast. Otherwise
> metadata will remain dirty and be retried until the filesystem is
> shut down or the error behaviour is reconfigured.
>
> Please fix your syzbot configurations and/or tests that screw with
> the block device under filesystems to configure XFS filesystems to
> fail fast so that these tests no longer generate unwanted noise.
>
> #syz invalid
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--=20
Aleksandr
