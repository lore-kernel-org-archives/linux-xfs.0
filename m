Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ACB36AB52
	for <linux-xfs@vger.kernel.org>; Tue, 17 Feb 2026 13:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771334834; cv=pass; b=aZJcP2vig+PBwn9BG4WdFQk+/9XgdIvNz3BLK9kZ+ziOetv8Jht1e8o5V2eHbUZ9+7NzY6pPsLOKsMTiT4Jp2nvQsTnNR2gTKlHxIUxklMVBOc7V97TwdxfjYy4nqF/KjpHPP2P4Hl/5aIPMiWLuI+K32bmkl8KWTDfhb/YSRz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771334834; c=relaxed/simple;
	bh=q5oVq95jqQQoO+Nm/H6qoKVVfjO/F3iq8iJp7dxOY7w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tkmojxwH8pWPY042ulab9I2oWAc1VsiS41uTRsGhDCCH5o4W8ARltyBF8Ha+HOoiQ3VRCWnb/ZZpQifKmHVOL7dU95VhF5vhunVuKzvhvzqQTfOgOA6jMU7lVoD/l3MQKagxDCiMn8lYCgSmeSLyTs2bSBAlYRW4EDz3b8tku/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NESqdyBD; arc=pass smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NESqdyBD"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43591b55727so4772899f8f.3
        for <linux-xfs@vger.kernel.org>; Tue, 17 Feb 2026 05:27:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771334832; cv=none;
        d=google.com; s=arc-20240605;
        b=WLAaljXfsbOAPANhkOPlkh3CuAnFI7/uF1donZMMQg7/WAUls+XQk0ih/025a5H9IE
         5kipRs61PLWbr036RtpJGdP5EefAHEA1EoUOcQ0+oUAmjKYpvUuUTXklYWEgJfJG/r2v
         wMgPn/ky+pVwHigZVZyzCfR/LdPJfE67txLr8Qk6U2qVA3yt2XeiyvqwuC+VDUUFS1Nm
         n9GoIw0+R4IzWow5GdnBnVgJoC6R99aLK36Mflzv15MpSZFMzp0JxUF53Umk3oR2aGIb
         fTXlUU1DVnz1zaj6aG8/8C0IESnw/H1FkmZ+u3MygpHjgf7wVs0WlbjDrjUum7L0S8BJ
         EFVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q5oVq95jqQQoO+Nm/H6qoKVVfjO/F3iq8iJp7dxOY7w=;
        fh=YBdnMdoZ5kWEGvPX/FaOGzzare2Ux8qPovBI7sBRBR4=;
        b=gxMJCVO42vQRwSjU945Lx0H57pWG61Elf94MMM6d8EB0KJaoCcdiJ3TRA1EwOZxjD2
         fjhdnrBX+fcyHTkQvcb5N7wuArAjwfmnhbHO4n5JWN83jzhgtLdOTvffPwuFM4w/Qk53
         pNUxu8ZJBdZBIdhwaB1MqFE+lwNV9rXTt51DxTnxRDr/sYh6uFulXTk+TnCLNMyGwFVa
         y6ojeZmqbEVRH4a+GHAZ0g+4UyFFYmk2slqTnFGhjSRRm10aOh3cF7ISdGaRQVK0W6hU
         F49EW5FsUcj3imnPi933YrZS1DmNHEbpoowh4Ph/ckiF0OJUDdp/fjdBL46ehy0a8tO7
         02zw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771334832; x=1771939632; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q5oVq95jqQQoO+Nm/H6qoKVVfjO/F3iq8iJp7dxOY7w=;
        b=NESqdyBDUBdPzO/qTCuoUo6jqKEfI7dWKzhf7admbKHUKEfVT7l3Y/+4l75auvfuSn
         Po9rOlOXCrb6ujJO2eQLx7mFUdB8V1ZLgFtUhgrpr0o1H8K2uog8fRkRRpt5owyAo7Ct
         NhdF4lVBH2KDsPHy6plc2KC6aSjjeT7ozckKC/obumO5z9/d2eFMy0dECxfQjJPvIR+i
         Cz8VJ+Z9462OqiO+yhhiuO5rLthG7GHKlxe1ZFWM6zVWGVcKI0E42ZLSSdoWj1SnVdtC
         A535K9oHwDb6IGhOFzICsIE32/Gv5USdcYDp9DpoMpCa4InLCRiWN64HChvK6OM9+Anv
         bmeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771334832; x=1771939632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q5oVq95jqQQoO+Nm/H6qoKVVfjO/F3iq8iJp7dxOY7w=;
        b=C2EHVWD+KeYmRoosumUr7YDIVAjQACvhFL8BwmEZyfuP73lsuzHpSXJ8cbSA8p8q/Z
         IX4HYXappMFXCU23N5CRdQSZLBf6tVMUbWl66xWkokBGTtoKCTEL5nRn5EyYwTILDjwA
         tiLBIU/PYByq2uW7m6gWR04PKOMzlvaogo5CYjFNaAUM3ZTFs67fJl7sKOCHS00LRHJf
         N2G3LDVc0yD96htVFEl8TD3KROpUKO3qq/sQBc28Ufr4gNSlXSFB2TAYaKMAA7q4rw7T
         TN7NHzNYgyhaVXGnLaYTeoEnQjnvyiKpSg1g7dF1bXOrgfm8BMBnQIIchSGrElDu2AYL
         q9rw==
X-Forwarded-Encrypted: i=1; AJvYcCVIKzvUU/d/5Q5+69GukuOo/x83XOOXTW/yazEM0Uv7S3sXnHMLZEbFdNvBK2DVJvb60uuBo5sVbDY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtXLdyQN3bbKH9sS9UMs69b5L+zd1xKnSiRk1pZdvrnsoLBWJM
	UeQjsrXHz2aLZaWQ+/+Bc0ffCtOh1Jfrg3WBflV8oQJPu7R8EPs8laqjaIP2gVtcceeq+hs4IgU
	HIcqmDa6Om42Eu8lkd6x1Dn4Ub1NVkSs=
X-Gm-Gg: AZuq6aICjhmxe5+yVM5OvA1ZAPV7RV7nxxqllkMYc3L9K7rgC8IQyyRpyLfiOQxagRr
	RkPBw48DIGHbBrL5ltDOKyQqX3WZqNTaMlMNS47d4HEpdjZ0MR3jIQeHDSyZohWc5fP3/M712aS
	bMV7+bM6rrBv3aKGzOFZRjEdatJjLgqlbZlbUg6MyA7httwvf0YCOH/Kudv9mQ9gMnjneea8mnK
	ls0J+0XQPTWyONPRmFSQym7RxjNMI4s0KDs2K4omtI01R1nJMlW+uO9I8aJhmBFMz2jl6pqfVEx
	gVG+IgBy
X-Received: by 2002:a05:6000:40df:b0:436:8058:452 with SMTP id
 ffacd0b85a97d-4379dba36d1mr20165444f8f.44.1771334831515; Tue, 17 Feb 2026
 05:27:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260114-tonyk-get_disk_uuid-v1-0-e6a319e25d57@igalia.com>
 <22b16e24-d10e-43f6-bc2b-eeaa94310e3a@igalia.com> <CAOQ4uxhbz7=XT=C3R8XqL0K_o7KwLKsoNwgk=qJGuw2375MTJw@mail.gmail.com>
 <0241e2c4-bf11-4372-9eda-cccaba4a6d7d@igalia.com> <CAOQ4uxi988PutUi=Owm5zf6NaCm90PUCJLu7dw8firH8305w-A@mail.gmail.com>
 <33c1ccbd-abbe-4278-8ab1-d7d645c8b6e8@igalia.com> <CAOQ4uxgCM=q29Vs+35y-2K9k7GP2A2NfPkuqCrUiMUHW+KhbWw@mail.gmail.com>
 <75a9247a-12f4-4066-9712-c70ab41c274f@igalia.com> <CAOQ4uxig==FAd=2hO0B_CVBDSuBwdqL-zaXkpf-QXn5iEL364g@mail.gmail.com>
 <CAOQ4uxg6dKr4XB3yAkfGd_ehZkBMcoNHiF5CeB9=3aca44yHRg@mail.gmail.com>
 <ee38734b-c4c3-4b96-8ff2-b4ce5730b57c@igalia.com> <8ab387b1-c4aa-40a5-946f-f4510d8afd02@igalia.com>
 <CAOQ4uxiRpwuyfj_Wy3Zj+HAi+jgQOq8nPQK8wmn6Hgsz-9i1fw@mail.gmail.com>
 <CAOQ4uxhHFvYNAgES9wpM_C-7GvfwXC2xet1ensfeQOyPJRAuNQ@mail.gmail.com>
 <05c37282-715e-4334-82e6-aea3241f15eb@igalia.com> <CAOQ4uxgzK7qYDFWYT62jH_zq8JkLGussD5ro4cKDqSNQqBiVUA@mail.gmail.com>
 <8bec19de-6e6e-418a-a256-5918bd835d98@igalia.com>
In-Reply-To: <8bec19de-6e6e-418a-a256-5918bd835d98@igalia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 17 Feb 2026 14:26:59 +0100
X-Gm-Features: AaiRm50wzuTW2-Y09oQNfhcaN_Xf9kQsFW2GVozychJKf87k4BKo6-ETNYdwiV0
Message-ID: <CAOQ4uxhpB-D+DaCVZ6-uZGM8WnsZ9Bkxdd4+f_EkvYnQ8xpvqQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: Use real disk UUID for origin file handles
To: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: Christoph Hellwig <hch@lst.de>, Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Tom Talpey <tom@talpey.com>, Carlos Maiolino <cem@kernel.org>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	kernel-dev@igalia.com, vivek@collabora.com, 
	Ludovico de Nittis <ludovico.denittis@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 16, 2026 at 4:59=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid@iga=
lia.com> wrote:
>
> Em 06/02/2026 10:12, Amir Goldstein escreveu:
> > On Thu, Feb 5, 2026 at 9:34=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid@=
igalia.com> wrote:
> >>
> >> Anyhow, I see that we are now too close to the merge window, and from =
my
> >> side we can delay this for 7.1 and merge it when it gets 100% clear th=
at
> >> this is the solution that we are looking for.
> >>
> >
> > I pushed this patch to overlayfs-next branch.
> > It is an internal logic change in overlayfs that does not conflict with
> > other code, so there should not be a problem to send a PR on the
> > second half of the 7.0 merge window if this is useful.
> >
> > I think that the change itself makes sense because there was never
> > a justification for the strict rule of both upper/lower on the same fs
> > for uuid=3Doff, but I am still not going to send it without knowing tha=
t
> > someone finds this useful for their workload.
> >
>
> Hi Amir,
>
> I can confirm that this is useful for my workload. After correctly
> setting this flag for every mount, everything is working good and we can
> bypass the random UUID issues. Thank you for your help!

OK, PR sent.

Thanks,
Amir.
