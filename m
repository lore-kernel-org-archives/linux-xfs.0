Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24922EEE99
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 13:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783516773; cv=pass; b=RjU8tZYcgd6KxDSTHm2DQSXzgCwNh9ZTnjStAllmTz72gXs3TubnwMHxJEfoaS3MwxjNqEhPp7zGH51dd8sKWIYyWjlMztZQVEQnuj7MABVj+xFzj9m4OL50VFWTZO2tg9iVJzswIj1PkUZa86HAponb7LdfKystnu1omzintGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783516773; c=relaxed/simple;
	bh=2U/Lcg2dxTOb86C192kJMJnDHfUfQyKFRI1uJS/LXXU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iHH4guEIKKt0Iol5E0nsa1ByXf2RLrKUstVebMczcjfh8VpVvHPQTToMA8QVMR1K0NAXmzhUIMCDI/T4UZNUqsHVXQBiSaBNjx6kMtcdzHteqT3/fhchjeKKHn7KyBCgHy34UPTJKXnyXslXj+7wBOCVa6GXu2Q2KRACDb52RzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fCRXws/b; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fCRXws/b"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c127ec4447cso79581766b.2
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jul 2026 06:19:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783516770; cv=none;
        d=google.com; s=arc-20260327;
        b=Q6GRFobNLp+9patojT5GXwezot/qWk3rECn+QbqMv0wvWBmGNn+hnxwo9bF+vrp/xJ
         aNvQ6LltEl55LuGcgwtBIiB5jv0bPVIsA7alPGoKBSz25Atzp21fDneCt2iqgArVdOsY
         MfQtOewr1ENIMpaYe57x+TLV5/CBfjBumm/B7m/03hqBifz2hOuJUMP8B2KIiwCzDHFx
         8zeUG+E/vOep/bAHkjuOXWmsxhd9T8nL9IJdWZfgt49axtSQdszVYDrUGNtSc3Kzz65r
         5gZ1lxUisvTCYYAW3HzrVBlf6LYiOuHOzgPY4Cv0H+8MC44uJaE+JILCVwjydUErinaR
         ab2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2U/Lcg2dxTOb86C192kJMJnDHfUfQyKFRI1uJS/LXXU=;
        fh=Hp68dsGepfO3fTIXHGhz+iWQFz8xDCIpPCymA+LNOss=;
        b=BpJvWq2SL41xC+aAI3PDan2Kgd8HkowSPTV+evHG5+Psf/obb2Xw/lM4MUbpLfHVy4
         sY9AU3mSHEHIvlf0P8CB2yD+aSXUaoPENhFYOzoN8h1Gh+fKCvA86Yc21/TOKHm5zcno
         03ZNn5H74opQ6Tmoa6ufgXZhSoCxe3eLTOBPlfia8MlnhWtk86SrO/d3DdaAPmypiOGj
         rnoHvvblJDsOjnprkePYQNjOtT+Zjkq+96oQYPX4I8+tk7UNdtRq+Xovn+qPZKcEqGrE
         C7R0XHHuYyqsbO9TOHFDubyYK+fMOxm+UvrnEkexW/LlHtieVZrptFRZHdoZF2Geyzp+
         EozA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783516770; x=1784121570; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2U/Lcg2dxTOb86C192kJMJnDHfUfQyKFRI1uJS/LXXU=;
        b=fCRXws/bZKjYsG+AHIG1yU0ddPdQhBWS0BMeJ2c9jzTv7Op64cedWTNxzUwCSlKNcU
         PBEABm8qmYGxzQH5MlQkRPNAEyokvpk17z6qRxSRbecIpW0pMVFPWXyVKxSIgFiY6Cm/
         yi27YQGprnh+taYeH8XZScemKbFaoWla/ouZZCv7Cx5qRo2ht/hlii04v72GSRfwh2rA
         1pjYwmLTr2J/ulBdudpbCEugAzx0/XJqtKUDWIujKJserpQ2T1FhhqyhX72DMg6gGAte
         VH4f39WshcPzqBdI3d7pwbVrcRpU1v798LUHKopIX06sE9FGZYhuq+6qQpGjaeLzEv4F
         Cg+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783516770; x=1784121570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2U/Lcg2dxTOb86C192kJMJnDHfUfQyKFRI1uJS/LXXU=;
        b=RrdhIZpPLalMr0/o14JZYmD/coDE4dQVLc0/85BdBt0j2/Lg9JppycZQ9QomSwpt64
         2lY+iEZ966sfsnOEcsfZKu1PpqMoIXJk8ALfqiZmbBwOTJTJ7yKCzI2WRXFZiIXoiMJZ
         udbIb9plxZp3CduFOCceIHR6jf2LkdqdZArXGSCxf0qIkvPf1VIoDIiCEF1UybRMcVU9
         ilVO8ICvS6oUKf39pfIASU3qrvCUjTf6E0R0yxHY88+4dsLw1F4L4THvQ5JW2RNNAQtB
         7Ni1lewB3XPtnmZ4w8Rd32CWdn6yosj22ETvKJxO/RyoKCbpd6IfmS9jR0QiLKU15Rir
         8oHQ==
X-Forwarded-Encrypted: i=1; AHgh+RpHWu0s22uyqpJmjCLVi3y6KgJOe+151U5J92fQahKChEaogQqzAhmO44x/CTaU5UHSsx8v4SYykoY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfQ2zWV1zRgr5lGBJV5mhbTGbvt4wzUkWe+e6ceIkWf5R/mxdn
	0Mopmw2gzmYOu7Q/jit1Y6D2p4ES1VmMJDGHD5Ixa2Kkac586xqbr+IIf6zFFqEI2eJzWfzvmDQ
	iJorwZHGMH62n3kfaBkpC11gTrBrbiHc=
X-Gm-Gg: AfdE7cn00T+8cT74rj5uJ/dLXF7hQSXBotqTYCUD9/j+HaO9OvrzkzwUl5Qrd2cp+fO
	nJv3XotgFSUv0KbKIry04q055T+xfoNsk3l4+aUNp69dUIFZCMM4Pfeg2HW+05sPcCr75k/kl8c
	T9D0lrgUEnzciRtAYlfsjRWiOBN7apqcGEPk0Tp8C8W8DeaKch5hbH6w2vFjcDkcs0jZcry6iqB
	D+4XmF4eVGnzOrgBDkHzWKJzJ2ixSvHhx3fj5GUuLPuDtu1wuRGy0iyjnc15vkzH8vKUM6udpHE
	jHOOJSrgEMBmr7CVvT2OfA854p+9p78=
X-Received: by 2002:a17:907:782:b0:c15:ce72:9352 with SMTP id
 a640c23a62f3a-c15ce729443mr116874666b.33.1783516769572; Wed, 08 Jul 2026
 06:19:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260616053850.2188-1-aditya.ansh182@gmail.com>
 <20260616053850.2188-3-aditya.ansh182@gmail.com> <20260624173531.GQ6078@frogsfrogsfrogs>
 <CAK5ssPP6FL+6i8z+0QdE-9DSp0rC_U2S20qdxY7Kmdp7RS0xRw@mail.gmail.com>
In-Reply-To: <CAK5ssPP6FL+6i8z+0QdE-9DSp0rC_U2S20qdxY7Kmdp7RS0xRw@mail.gmail.com>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Wed, 8 Jul 2026 18:49:18 +0530
X-Gm-Features: AVVi8CfxbJpkhMN59amAOcQ3RgxiEc-CDT8U2RPSGw2MHXBqhX__elybbMIpGmA
Message-ID: <CAK5ssPMyJhvnEQSRoAwVNnZS-A837OOMewEAvp+ZiuWKD=vUdg@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] xfs: prevent close() from hanging on frozen filesystems
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2026 at 11:58=E2=80=AFPM Aditya Prakash Srivastava
<aditya.ansh182@gmail.com> wrote:
>
> Hi Darrick,
>
> Thanks for the feedback and review! I hope you had a great
> vacation.
>
> I looked closely at wrapping the block inside xfs_file_release()
> with sb_start_write_trylock(), but I believe sticking with the
> transaction flag approach is much more robust for a few reasons:
>
> Lock Ordering Safety & Lockdep:
> In XFS, the canonical locking hierarchy is:
>
> sb_start_write (freeze lock) -> IOLOCK -> ILOCK ->
> xfs_trans_alloc
>
> xfs_file_release() already holds XFS_IOLOCK_EXCL (acquired via
> xfs_ilock_nowait()). Attempting to acquire
> sb_start_write_trylock() inside that block would mean acquiring
> the freeze lock while holding the IOLOCK. Even though a trylock
> itself does not block, this is a direct inversion of the
> canonical locking hierarchy and is highly likely to trigger
> lockdep dependency warnings.
>
> Keeping the check inside xfs_trans_alloc() relies on
> well-defined, centralized write-count evaluation, avoiding any
> lockdep headaches.
>
> Encapsulation and Readability:
> Open-coding the freeze trylock at the VFS release boundary makes
> xfs_file_release() quite fragile and harder to reason about
> over time. The resulting nested conditional block is prone to
> subtle bugs during future refactoring of the file release and
> blockgc paths.
>
> Architectural Consistency:
> xfs_trans_alloc() is the canonical, centralized place in XFS to
> manage write-count blocking semantics. The
> XFS_TRANS_WRITECOUNT_TRYLOCK flag provides an explicit, clean
> interface to tell the transaction layer exactly how to handle a
> freeze, rather than bypassing it at a higher layer.
>
> Given that this keeps the VFS/XFS interface clean and Christoph has
> already reviewed/endorsed this version, I'd prefer to move forward
> with the current iteration unless there is a strict functional
> downside you see to the flag approach.
>
> Thanks again for the review and guidance!
>
> Best regards,
> Aditya
>

Hi,

Just a gentle ping on this patch.

I replied to Darrick's suggestion regarding the
sb_start_write_trylock() approach, but I haven't seen any
further feedback since then.

Are there any remaining concerns with the current approach,
or is the patch suitable for merging as-is?

Thanks!

Regards,
Aditya
