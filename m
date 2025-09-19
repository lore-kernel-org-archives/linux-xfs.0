Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7363F23ABBF
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 13:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758287372; cv=none; b=O2bJBV7MMG1DWrXOehbALlXEF0OM15FrgApgqp8zwhC9Fv/zUPYAm0U/u7n98bTPrn6BeEvc1to9/nnN7CMyjIbcA11wcRcLRmtdywZODLDWBfRpK1ZJ+RlL5Si39ICrmKWvtFHVYSFFlfWszCkk5qmL3QEIFzS1FnCpTOQEHrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758287372; c=relaxed/simple;
	bh=H2nghK4bl/H+DNUfQhtZLwYHG07QNLlFwkEd9mrXbhQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q+m3G31YQTckIkNrMaD3O6FFEFlzy4ewvk74BPUHj3CZKWX/JOcM5nQer3cCvuEKUWh1/usBnhG1/KwMQZw9Khh+/cUbOhsZPdlZmq1bkDlPtu/T9CyHUZsHSzCey8/DkZNZn/o1pePFewSZ4zgQVoMikMNblj/Fv6msurV2c70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BQIPISGy; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BQIPISGy"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6228de280a4so3290743a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 06:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758287369; x=1758892169; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H2nghK4bl/H+DNUfQhtZLwYHG07QNLlFwkEd9mrXbhQ=;
        b=BQIPISGyaL9K2DiFORwYXbLp0t2u4Qq7Wi9F4RNLMuSVpyK66tSAoNsyEIYswqWV26
         iNyNMFsvPDMLcyCx5Brope1KQRqcyBHMz4yssiys1snjyeR3l1GIcRFDsIjglAi9HvWj
         IlBVLk4wEYQGTNNyUT7TeWjslzh1k5HuAp+0Qpsn5AsZ2NW8Y5UyHSzN70Zer329AMnZ
         n996bHOKl75/nauI8STW5nkufGGR6s1xIt3boi1DFvvYhV32fAvcCtgJqEW1NhPtORuX
         wm9IS6roqrijLmO1HE8RXHPiymNGhW+W2wOGR4/VZPeKOGA6ByVNxAJRMbvc1aw+r+Xm
         q8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758287369; x=1758892169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H2nghK4bl/H+DNUfQhtZLwYHG07QNLlFwkEd9mrXbhQ=;
        b=e0I24SgrtmwIqMDQH2OzE/t7KSLiaOAomQC7D4rUbNugqvg+wEnVm5uF3kHRzbMWI3
         EVfns6pd2jIr9k4kjZ4N4FeUHM33TW/veML6WXRC4orUZqNf1ZpbSYfzQGpgF79bbutI
         DeimaWnqEhSMsVQj7rxsnzUp3c2j0GzM/d6i6SoiO2LQSsRGuM+1vTZ34lqi99zrXEQp
         IToVplVlZFph+RHmOvYy6LesE5Q7rbO+LU0HCchPU/FOADtfd5mhL8LjRN0xRw6EWfcx
         KHuErkOwTXNfVAxbezIvqnQ7b5SgulTTVHD8yVW5zhBza4B84r+vcB0HtwlTXVffWzDS
         LUww==
X-Forwarded-Encrypted: i=1; AJvYcCWs+Q3geZlQmevOpiei6JqnZhO2vLYH4ORLpkslAe0uzC5foR/jR9ezRXKdH7iaQ3wzfU6nOdF+re0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLFbmAAj0/BigL9TA5uO0djgm8k6DXn1S84PFVGQESAJcfFbIa
	z+6mJc8GAwx03Lq97TBTQEpVx6r45Ty4BFXxVlswKK5xTBLiMQiBRBOjOWnMvlqBLaKiuffsPht
	n/oxTXFylntLTps/OiCjSbcF2Qhg+AJ8=
X-Gm-Gg: ASbGncvXBLrPkfFnTxqcKxYOib0tkJnBPDK6nF4uUMRzoG9CMgxECEHYSK9jtSBivmK
	zNJuTUJqx/Hm+qtlRFIL7kDR0/gjGSolIUega6YAGoYKey+MDD67Ghe5IlDKBiZuD888cSKDgHv
	2TCu6ijt8QH48BFCvqjqecwQ7TR+x4P5czLt30p0R4fB3U0h03I3q0HQvU0pIW34Opt4IQrSfcq
	nG7Dghn3ov722Z/akhpn9GTfnU1qewKRWv9AUI=
X-Google-Smtp-Source: AGHT+IFApfhAHEjMUI5U299k57YwKnPsMN/Ik0b5HX6lVlpdtHbeIxsd1Q0r+GQz5I22vbwNy4Ut9U4zuDgZ7sOE0qo=
X-Received: by 2002:a05:6402:5343:10b0:62b:2899:5b31 with SMTP id
 4fb4d7f45d1cf-62fc08d40ecmr2418056a12.5.1758287368510; Fri, 19 Sep 2025
 06:09:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250916135900.2170346-1-mjguzik@gmail.com> <20250919-unmotiviert-dankt-40775a34d7a7@brauner>
In-Reply-To: <20250919-unmotiviert-dankt-40775a34d7a7@brauner>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 19 Sep 2025 15:09:16 +0200
X-Gm-Features: AS18NWD5Om8yGekTULVtEvApOLHSTiZijG74rmoXqBK7CgJeOnhoxL1KEl8c09g
Message-ID: <CAGudoHFgf3pCAOfp7cXc4Y6pmrVRjG9R79Ak16kcMUq+uQyUfw@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] hide ->i_state behind accessors
To: Christian Brauner <brauner@kernel.org>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, josef@toxicpanda.com, kernel-team@fb.com, 
	amir73il@gmail.com, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 2:19=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Tue, Sep 16, 2025 at 03:58:48PM +0200, Mateusz Guzik wrote:
> > This is generated against:
> > https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?h=
=3Dvfs-6.18.inode.refcount.preliminaries
>
> Given how late in the cycle it is I'm going to push this into the v6.19
> merge window. You don't need to resend. We might get by with applying
> and rebasing given that it's fairly mechanincal overall. Objections
> Mateusz?

First a nit: if the prelim branch is going in, you may want to adjust
the dump_inode commit to use icount_read instead of
atomic_read(&inode->i_count));

Getting this in *now* is indeed not worth it, so I support the idea.
