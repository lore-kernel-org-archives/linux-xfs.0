Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A904839FFD
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 14:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s3kuor0o"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-67ee17ab697so5540366d6.0
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 06:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702651350; x=1703256150; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGMYxeknzC7gjgFIn010QvpivnBYXCaeK7U8Zp8Dqns=;
        b=s3kuor0ortf4gI9VX9IlGJh5gT8HeElsb18TwHJRc2oQQ4mHRepVR2n+ODPkBAY+Nx
         H8JFyVglnsbqlNlkZsHPn+T3gSB2oA10HGvQkkq7UPmA4udR75x5zVoblvovqUtE5S/2
         pwxdn92vpW0faVF2dBJrCr6e7hPn3r3Q913YKforl0UlctOLHPb6zHKPqQOyHkNfp5/N
         OWOKTiRpBIrYJzmGN4LZMi5OOZuBmoYWR7W8FN5kfU/PGYoeiA/Ha2o6IhgcuSE7RlWx
         4XPdVQQfa7mMG9Cwr/syXEJMsYD40Ttp35nXtMrBJ0qZSIRZAgobTeARkd0JtFwPCPOJ
         aMGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702651350; x=1703256150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aGMYxeknzC7gjgFIn010QvpivnBYXCaeK7U8Zp8Dqns=;
        b=aM3FCJ2eLfHVhBqk+CArSSR/gi5SJE3NuKq75gw3SNs5CCqR5C0KBL+cEues0hsezw
         9UgSqo8rz4MgtrEoMnYl3DF70Wvh8Pkd5wGgV5jHk2ugNqUlRybtrwQCbEjvFy0L7S6J
         kP0UPfTBU9f3dh93wx0f+NmtRX1s3ob84ZCZ1fkcJgAePAFJUodUrgOt2lUCshB2bx9W
         WD5yKEoi+cpjwPPRsYf8bR3Efs3lrT7Myov85/vUowYSBQ6alnbGRp5Vnyh8Csx0q9co
         z3OuCIa2a7cC1V6ktqpq5r1DJ2HJ6ZMtGF16QPKbSaO+1IqdKZa+YRLzIS9iaZYmUDFh
         C7Ow==
X-Gm-Message-State: AOJu0YxvBUV92wK/xvyG5925Doy01+xNUe9B5F/rngKuF8E/okBL+CAO
	goYaWDWj1Iu/vN/fQTyRK2wBNF9uNKAGmiwu7FXfwQ==
X-Google-Smtp-Source: AGHT+IFEP4GTH7PwOKt2GmIEi320wj42DmjXITQoebReQVa4qOl1P4PdTy3zrAT0HyjDjZcIXiRIU+gdyZRM37a8Siw=
X-Received: by 2002:a05:6214:226d:b0:67f:f0d:1bda with SMTP id
 gs13-20020a056214226d00b0067f0f0d1bdamr2911619qvb.110.1702651350277; Fri, 15
 Dec 2023 06:42:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000f66a3005fa578223@google.com> <20231213104950.1587730-1-glider@google.com>
 <ZXofF2lXuIUvKi/c@rh> <ZXopGGh/YqNIdtMJ@dread.disaster.area>
 <CAG_fn=UukAf5sPrwqQtmL7-_dyUs3neBpa75JAaeACUzXsHwOA@mail.gmail.com> <ZXt2BklghFSmDbhg@dread.disaster.area>
In-Reply-To: <ZXt2BklghFSmDbhg@dread.disaster.area>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 15 Dec 2023 15:41:49 +0100
Message-ID: <CAG_fn=VqSEyt+vwZ7viviiJtipPPYyzEhkuDjdnmRcW-UXZkYg@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in __crc32c_le_base (3)
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, 
	syzbot+a6d6b8fffa294705dbd8@syzkaller.appspotmail.com, hch@lst.de, 
	davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 14, 2023 at 10:39=E2=80=AFPM 'Dave Chinner' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> On Thu, Dec 14, 2023 at 03:55:00PM +0100, Alexander Potapenko wrote:
> > On Wed, Dec 13, 2023 at 10:58=E2=80=AFPM 'Dave Chinner' via syzkaller-b=
ugs
> > <syzkaller-bugs@googlegroups.com> wrote:
> > >
> > > On Thu, Dec 14, 2023 at 08:16:07AM +1100, Dave Chinner wrote:
> > > > [cc linux-xfs@vger.kernel.org because that's where all questions
> > > > about XFS stuff should be directed, not to random individual
> > > > developers. ]
> > > >
> > > > On Wed, Dec 13, 2023 at 11:49:50AM +0100, Alexander Potapenko wrote=
:
> > > > > Hi Christoph, Dave,
> > > > >
> > > > > The repro provided by Xingwei indeed works.
> > >
> > > Can you please test the patch below?
> >
> > It fixed the problem for me, feel free to add:
> >
> > Tested-by: Alexander Potapenko <glider@google.com>
>
> Thanks.
>
> > As for the time needed to detect the bug, note that kmemcheck was
> > never used together with syzkaller, so it couldn't have the chance to
> > find it.
> >
> > KMSAN found this bug in April
> > (https://syzkaller.appspot.com/bug?extid=3Da6d6b8fffa294705dbd8),
>
> KMSAN has been used for quite a long time with syzbot, however,
> and it's supposed to find these problems, too. Yet it's only been
> finding this for 6 months?
>
> > only
> > half a year after we started mounting XFS images on syzbot.
>
> Really? Where did you get that from?  syzbot has been exercising XFS
> filesystems since 2017 - the bug reports to the XFS list go back at
> least that far.

You are right, syzbot used to mount XFS way before 2022.
On the other hand, last fall there were some major changes to the way
syz_mount_image() works, so I am attributing the newly detected bugs
to those changes.
Unfortunately we don't have much insight into reasons behind syzkaller
being able to trigger one bug or another: once a bug is found for the
first time, the likelihood to trigger it again increases, but finding
it initially might be tricky.

I don't understand much how trivial is the repro at
https://gist.github.com/xrivendell7/c7bb6ddde87a892818ed1ce206a429c4,
but overall we are not drilling deep enough into XFS.
https://storage.googleapis.com/syzbot-assets/8547e3dd1cca/ci-upstream-kmsan=
-gce-c7402612.html
(ouch, 230Mb!) shows very limited coverage.
