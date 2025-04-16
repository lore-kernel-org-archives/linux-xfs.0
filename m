Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD4A1C27
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 16:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744820234; cv=none; b=JkN0ITAo5nd8v5bgPjNC+axTLSeU6owdID51GkcDBSsO3NTaJZjZx/t8sASJOsGsLG1qUc1C0FFalifj90Yi5OzOAyfzJud8vym7xJRGV+fCuO20304sw0xIggfwUlWfvynAytIZhyA8V4fOhzl2BjE2+q8jjmngvnvpwqb6UsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744820234; c=relaxed/simple;
	bh=/NjkID9FHg7dLf/5Ofw+jTgfpsm3WQTHdTh55tm6TfM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M+r35XF3kqKEqnDJV7ncf5gKWRGq7Sr8EHh9cAF7ktqpUuw5hfRm5uisHoO//yIrdBiode7fLplAOifw7AjdkxMjg55Zbp52kNBZbMEKPYEtzBWVUFBr3uo4wiem4KG7HA16ejo9kPzd+frCwPvxbZTZx68jP8pbUXn266pE8tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UhWLmtTz; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UhWLmtTz"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5e5cded3e2eso11087228a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 09:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744820231; x=1745425031; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DI74N0a4+q3ZpTRBR0CwHmP3bDL45JvCMSjBK1wF7p4=;
        b=UhWLmtTzJS8iA7+40HlM0AIgS+BwbWoCHohA2lUYYW792VdXb7Z+zXv3eiLeZnNiz2
         n1f2UPIIVXmUgtykyUvTPovHd99a8eYGNhBqiM6qsq+ATI4MtTm1R5Q+Yp1Ze6QzXndP
         jFY634i/XF6lfEg8KvrrZwMQt4pDYKbAIKw18kQ4P5UgMnA9yMbip7eW+0lzBlqY+dlZ
         DB1XIAzPJu9zAZKMMSxIkmUICUt6f7jlflVFcQuVCMSNs/+I5UITrtWlOTSC/OZaNlqA
         Ig5akuqUsYbR+VvQZrc3pHame5/gCKlYOZ3adFwRf8Mp4rM/tKTEARSDzCO7yGLCw5ag
         Nhlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744820231; x=1745425031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DI74N0a4+q3ZpTRBR0CwHmP3bDL45JvCMSjBK1wF7p4=;
        b=sfnavOPw5MbJ1GHsuruZtphczePF240AwC/H1NCsxEYRt1wGpMgs1CTKajc+Pkk8Ng
         jd1TFfDtEXqAAs1di2GgH+WukoAnEMa3BfA5tZEKRWPeBT7k/JPtFehdlCOotKZcmwUJ
         kmFjww6y84qnU0ISlhp95WRH1mHPoeEkdp4UZISofSEBj+JDlUPGlXHOqWqEx4hEaDjD
         dkXfOadFKhxqowOgv7c6+6Cyj+NTmczyJUKSm58Ot5Z/9VlZy6ySTy1Rwo5f+Iv1ln8a
         h3ukifsy8NofPtg0Kv19s1p3/LVAkpB4Ghu/6F4gslgEF7usW7uvlZQwA7d2vQNIB5Jz
         z2uA==
X-Gm-Message-State: AOJu0YyaA4fRCTIpuK6vz+Jlxcghy1Ym+26VKzWhl9IP/+UdcqhKOZl8
	gtuA7o0MD5jqH2H27Yc2voNcxDvsZbSYt9HTMh/fTxwG9QrkkAOM/Wy4T22t1IIVFJekTvswtQ+
	wZvJiI3xICcwpQRMpGoV8YxOVc5Gd683j
X-Gm-Gg: ASbGncteoLK8vzCGYm2VUO9SgcHO0h+kIRp/K2uPC78mFTdBAE6OekadIDtQUdEMgt6
	FefM0Qs1pNzuTlspeKOug7STNw/sqxbzZvcov35PaayCOK3970dwHCs0AmYQbvztSjALD7ncZWr
	t8IjR7v/qoxcmLihk4eYlfX1VGPiBkdi5nhINqR2UarhCnQ+SxsHJllk4=
X-Google-Smtp-Source: AGHT+IGtMMYcvb2EdWs5VNvQG4xCdfPwcDhOQ8cyy6szrXW1nhwVvatgJqAVymNUFWw3GTSOBVWfksMnfdtAlxrGnXo=
X-Received: by 2002:a17:906:f5a3:b0:ac2:c1e:dff0 with SMTP id
 a640c23a62f3a-acb428fd690mr268654166b.19.1744820230931; Wed, 16 Apr 2025
 09:17:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250416123508.900340-1-luca.dimaio1@gmail.com> <20250416154013.GF25675@frogsfrogsfrogs>
In-Reply-To: <20250416154013.GF25675@frogsfrogsfrogs>
From: Luca Di Maio <luca.dimaio1@gmail.com>
Date: Wed, 16 Apr 2025 18:16:52 +0200
X-Gm-Features: ATxdqUG55zlPOwiyCHV4hH6biY2ax-LOk6tT8eDzX7UjsCGE15cKTFvA_3Zimpo
Message-ID: <CANSUjYYA-UaBCn5jYUCgWGkos2DKpUE-xRqQngeG3ocuXWVG3w@mail.gmail.com>
Subject: Re: [PATCH] xfs_profile: fix permission octet when suid/guid is set
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2025 at 5:40=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
> Hmm.  The mode parser only pays attention to positions 3-5 in the mode
> string:
>
>         val =3D 0;
>         for (i =3D 3; i < 6; i++) {
>                 if (mstr[i] < '0' || mstr[i] > '7') {
>                         fprintf(stderr, _("%s: bad format string %s\n"),
>                                 progname, mstr);
>                         exit(1);
>                 }
>                 val =3D val * 8 + mstr[i] - '0';
>         }
>         mode |=3D val;
>
> so I think xfs_protofile should be masking more:
>
>         perms =3D stat.S_IMODE(statbuf.st_mode) & 0o777
>
> because otherwise we leak the sticky bit (S_ISVTX) into the protofile.
>
> --D
>
> >       return '%s%s%s%03o %d %d' % (type, suid, sgid, perms, statbuf.st_=
uid, \
> >                       statbuf.st_gid)
> > 2.49.0
> >

Thanks Darrik,
I've sent a v2 Patch implementing this, co-authoring you
let me know if this is ok

Thanks
L.
