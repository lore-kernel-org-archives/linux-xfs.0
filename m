Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.72
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793147976;
	b=Yqq64DFfq/7mpgO/ntqDuMaiffDG+efAJojM1Ydrb0e4ZX9ioaDuqWBPkq823yBvpIOZ
	 2XU6oRDl2p2fYktcGXP0C8AhBUj3s1pZMYu/PmB9yG0jXzW2ykww90+j3uXVVpigfLUx/
	 gaGG0NbXxQWz/1ofExZmTR9dVIkLQ9GpEsK6FdjrusFe0Cw0moX2t3u5UlVCjyO5i/4Qv
	 bb8dt9237T+Cm09tnybWEwq6Ko+YiRKcs5Jv+Xxha/Eg13fYN7pnzysmy1A4+cxCN+CGM
	 qNdOUkHaVAWewhPblM1rW83yuR26EOZVGD12QPHpdOzcNy10E0f3ozlBWc2OcdH22FQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793147976;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=8OqtLfhC5NDfUpetxWQFi4TMteqAlcr0nsRIqZjX4g4=;
	b=YCnt7LvicqA27VAfeY1rp+2FeAv67WBgPpQJNNn2NkSBBD0gv2OxbWUShbHeMzQfwGYJ
	 tNcFYFyAikUPZecezIRXZZs2LgAfGnB0Njii3pLps/15NYgtNT5fhuqKnNLHd/X5gLypl
	 0spWjQOiEPtUHHudBFjdmWoAVeXJgF1mcEhh5kR477yOjHioQo/g9knDx9CVwaM7sOt2y
	 5Q3i5i2fsf8GJxGziXMkpS0H9UFJY7oR+NFmqG2wGkTFoU4+ovo/XlXbeB7hjTSd1UZI8
	 ZuW1aVQENc8A3vxl0XZUydOwmxj7BUi6fcrQ21nPIZF6vC8EvSHQCFP48Bo76ACvnlw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RFO3a1Ao;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.72
Received: from mail-lr2-f8.google.com (mail-lr2-f8.google.com [74.125.230.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA4B606A31A
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 00:39:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AA4B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RFO3a1Ao
Received: by mail-lr2-f8.google.com with SMTP id 38308e7fff4ca-3ab28382b92so2608591fa.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 17:39:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793147974; cv=none;
        d=google.com; s=arc-20260327;
        b=nbDsVvEpH8dD6NB1+8ZkmGx1ssuuadQ17psH1b9r7QGibusoahTQ4Hi2JzkR+Y1/7d
         y0BKfZpppJ7odtTve+0wYRWBeyUKTxEiYLJ3YD+wEx/qwmqXdwIcR7IPh9t+G8kX83La
         LXTGpGs2Bl2gZze+k3lvatcCkCVmld3Ol/P9EDPG3iuGm8fR/KhjACk7dxmpuwexfdgA
         O+L4X9foc6jl2tdLaINPHK1Q6uydkSOL6B31le/gl6Wk0pEUCrJTgG4CnSEUFIJi78Ib
         RC2g/asurOew0GSRpYl8YsDuO8v4sZ59QPWMgBQFOztfOMTM1RRS3NAaMM5Ra6T83Xmz
         Wucw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8OqtLfhC5NDfUpetxWQFi4TMteqAlcr0nsRIqZjX4g4=;
        fh=LBe4I6ByNAFhDq89DY3Pm2E3HMxvh014qqKC+ck/yAs=;
        b=HwyOpXZglqIUeEPc52aNQHE2jaKqdBveGxb6Oane/izE0a2iVg7EMqcQYAHkgujbwO
         VMAAnyzAHox4kHobCGX4ukdvs4rMDL/5+yyy4Vxd/DO8P9dUHHkP+7QbRHqh76MwLN01
         hIIePwzyPTi1cwnDVuQMHjvvDPyDu8DTpRG7sOrw5DhZc2D5UZK6Q8Vfa7tVjBWH6kUm
         1wDZbkNrAZrvyZqzX7Mv88D4T5V6A5Lv91A/clvwzdOPsmlhcO0D95gy0ittGGMLiu9Q
         E0c8w/4y5D3Qfv9j4wRhmQZso0ThrZWbSnQSTjzUYbTFp/OBD7huxjdZD4QTzULVEewS
         z0zA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793147974; x=1793752774; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8OqtLfhC5NDfUpetxWQFi4TMteqAlcr0nsRIqZjX4g4=;
        b=RFO3a1AoMwSAMGUn0ipnKS245KWkzrFi7JccukXkZSKbCV2FJZdfELUGjqu2ntW5pv
         7UfFwxBvRm/99P6njkfACglFNdbskR9/uOQoKvEz3mXe80tLgtT3XsuqEM8GsF/t4uuY
         mtBWIGByGhILMpphL/h/sVekBP1oYGMJkZN9l4UhPpEjRDVWaRmrp/tNchE9Mxd5BRAp
         PnPb3XlyKBke9YqSz7khBIYeSD4I//qv/RoBn5vs6sRuKCkd7H9rBeKYMd4H5yGq2B+E
         c8fa1LKYR3GDOA8OWFT2ePSqW/JXjrkMYQqhzUfThSatnDzWd2b2qzA5TVPDYtKp5Bad
         7Yew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793147974; x=1793752774;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8OqtLfhC5NDfUpetxWQFi4TMteqAlcr0nsRIqZjX4g4=;
        b=bMcMjSEpuehanC3CQ7LQ0tiw8detrw0ly/oixaIablyfZ8nF6mL4rDRKAMZfMS5C33
         VcceiOrsXs2hwUVoHxXgWLxQ8wPfiGQioClgYh5BoSk88o1oKNTuMqu9MBwvvakT/FrK
         z44iVuRfUe+lxMD2awew988ivZ9H/yGodcCkyftwUQ2W/fIYdHJKimpS4PKAX1JuIwSJ
         cIyg9c30te+r3cxhgsCSxdUoVbnRgsmcZpr1mttreV7Pk/VLsNKQnqcbjYL3WZPLRe/Y
         X/iLFLUEkN+6jY3Wjsucv2TcNQhWLH07uPDzSlnXCF6DAKsaWSYpKpuskSPC/W327E8K
         Lusw==
X-Gm-Message-State: AFq9FYJGebn4/464ZWtx3CwmQNf1Oi5sDHvEgh8/Jm4QTOLOZP60rSah
	kdjWkNkI57ZrP2lk5+K6nKZVxhtCDWaz5H1ziQv53zr7ZnZ5fpcL6zjBT7FlYtv40b2WfSN1v3x
	9ve7RI9h1/ihw+P9Qu2GSo5vEeFrhuSo=
X-Gm-Gg: AYBFou1pExLlzaZDI05RQDZYhA6OQfTfqErxgng09NlkC4QwHlaALC9cji9/or2nx15
	mmDlqYFpha+YxEKW2eYldY5krr0/xn2Ao+nSFTdziYtGTW9EOEF+BpDsW9b1UJoQRHHjuJc+pNd
	fMYM5YpQiouKpWO3LUnwqm3/E/6cfZNBFM9ounpQaO9OMg0OsfJLhv3pXGzoTkT+VFfzKXVGA2r
	B7DU8tybcPdUpgzuZ8S44y6kBhvFZfBPF2/FPTIz6F0cHSz6mgb532ZYcsCo5Jup33bKJ6jms+b
	pLYLt/xhB2EfLztPhzrQEYnPgdkrhgdKXIATzRvBcYrG79PCMNGcEffxOejuryYmsp/FsK8jclg
	Mi9R6mZlw0tmEKAV4XlzNz7TGyqAQo5O6rsM=
X-Received: by 2002:a05:651c:b13:b0:3a9:c1de:852a with SMTP id
 38308e7fff4ca-3ac9ce3b95emr1270841fa.3.1793147974231; Tue, 27 Oct 2026
 17:39:34 -0700 (PDT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAO-4RZ25PZ5BM+83Vk8t5NUY3ksLGz5nzONrncipu2_MZhFSsg@mail.gmail.com>
 <auDbrRoBQaxWnsE9@cronus.toxiclabs.cc>
In-Reply-To: <auDbrRoBQaxWnsE9@cronus.toxiclabs.cc>
From: =?UTF-8?B?6ZOu?= <fengaojigui88@gmail.com>
Date: Wed, 28 Oct 2026 08:39:21 +0800
X-Gm-Features: AclHuK8n1C-HN8_ZSqYd3c-5v_SbdRi2BLHY-p8qUXbEBdTX9Lw1BbEHIxvDUvw
Message-ID: <CAO-4RZ1TTQRRS-LfJHogu5Sgjw7brWbjJUza8dv-At-OLW_mKw@mail.gmail.com>
Subject: Re: [BUG] xfs: undersized log triggers assertion in xfs_log_mount()
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Carlos,

Thanks for the clarification. I am running syzkaller in isolated QEMU
guests for kernel testing, rather than using this configuration on a
production system.

I understand now that the fatal assertion is expected with
CONFIG_XFS_ASSERT_FATAL enabled. My intention was to check whether
this particular assertion on malformed filesystem input indicated
an issue worth investigating.

Your explanation answers my question. Thanks for your time.

Best regards,
Zheng Zheng

On Wed, Oct 28, 2026 at 1:32=E2=80=AFAM Carlos Maiolino <cem@kernel.org> wr=
ote:
>
> On Wed, Oct 28, 2026 at 01:00:54AM +0800, =E9=93=AE wrote:
> > Hi Carlos,
> >
> > Executing the stored syzkaller testcases on Linux 7.3.0 ultimately trig=
gers
> > an assertion in xfs_log_mount():
> >
> >   XFS (loop0): AAIEEE! Log failed size checks. Abort!
> >   XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 597
> >   kernel BUG at fs/xfs/xfs_message.c:102!
> >   ...
> >   xfs_log_mount+0x4e3/0x590
> >   xfs_mountfs+0x10b9/0x2270
> >   xfs_fs_fill_super+0x15cc/0x20b0
> >   ...
> >   Kernel panic - not syncing: Fatal exception
> >
> > The log size check reports 516 blocks, below the required minimum of
> > 636 blocks.
> >
> > Is this an expected assertion with my XFS debug configuration, or shoul=
d
> > this malformed image be rejected without triggering a kernel BUG?
>
> You have bug_on_assert set on your system, so yes, this is intended. If
> you don't want to panic() the machine there, you need to disable it on
> sysfs, but...
>
> > Questions
> > ---------
> > - Is triggering a fatal assertion for an undersized V5 log intentional
> >   with CONFIG_XFS_DEBUG=3Dy and CONFIG_XFS_ASSERT_FATAL=3Dy, or should =
this
> >   case return -EINVAL without triggering a BUG?
>
> The config you have enable explicitly says asserts are fatal. I'm not
> sure if I misunderstood you or you misunderstood the configuration
> option.
>
>
> > - If a diagnostic dump would help, what state should be printed before =
the
> >   assertion so the malformed image/log geometry can be identified?
>
> You are running a kernel configured with debug configuration that are
> meant to crash the system when some issue is found. Those are
> configuration settings used for development and debug purposes, not to
> use on a production or semi-production system.
>
> Cheers,
> Carlos
