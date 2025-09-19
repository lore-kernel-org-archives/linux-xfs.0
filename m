Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730C52BF012
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 07:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758266047; cv=none; b=YOHq4mtl3g7JEBbcYYv4Lb0ydtcrsMpS8Kg9h6Fy3M1y2iDJ0ZuJUK/Mrr57PXQouQQpKGJhFvdMCh+ibbucJbTG8A3k1MtEP8/EEDp9EteIAD4uNrScQWYxWOV0+k0GU4P6fAsmXuifnC5NTjQRks9PfUfjUl9nxp7Y8B5v67Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758266047; c=relaxed/simple;
	bh=HWdLkZOt1eo65Hw9C2VJLQGvyauAaqfW7dH7XTRry48=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=loEtQfkivmPFAZBxDfHtoxgngIvLwjoOAk8ZMAjz+ryCQvVd+QCbuqzk3WyYbVVCs0WfxmmUdJthBjvz2IxrbyEt65L1RJwLI9bOYV+DmqEtaDrBnHd+r9LE2pffAoGMh5OHTAE+kn7MuRVKEqGwdcqgjSr9rJaYZjVTpjXwU0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=JVQrOxNB; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="JVQrOxNB"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b5e88d9994so20514861cf.1
        for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 00:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758266044; x=1758870844; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5FwZbH6t8CGqEFqmrm0ZFV29P2Rt2NmMLrFnZUIngW4=;
        b=JVQrOxNB9aklAqUCsbrzaBhSVhLRu1ViPAdrmaaCv+00+KH7K8IDB2fqaT0xPhCk/F
         GwhtwHi2DsiJO4ar4JKuAOymywdrOGeH8AHCnoiiD3jn/WceRCJIRe9mxJM3WtTmQxkV
         sVz5y7Z5KjFHcuUXUkcDHOj2mO/QidX/CrOPo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758266044; x=1758870844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5FwZbH6t8CGqEFqmrm0ZFV29P2Rt2NmMLrFnZUIngW4=;
        b=ChFvNzrKP/4E1gZ+d4ynPngS5RoJ7GmZc5u4O4m165+dZn1/TxJq+6F2II2xj4uwel
         la7OLYk9UAtes/6PiXwpE4Fa1iVXxzy6S9AF6lxO3qzMPDu/ainKde6khdK8+S1hUrhr
         nRUDzdnvDePovVRr6H2V+mJV8p167rTCX9LIV7axfs8mUDJGruEE9E5LaFQmticuzMIk
         6vb3BI4FykrBG2B6wVP+YVvlghmMhB0kq+VYgEnxBhHvmm1umTAfcM40qH4FzDfbZCrc
         cTmfP4CxRqO3FR9lat61OzttEx/JzwDRCROPY224P5ULPxaNm2sc/Y/zgrS5I6/wvL41
         tNrw==
X-Forwarded-Encrypted: i=1; AJvYcCXt38DPye6lxguDs71Wz4IGq3U3dwD6um2Fc1rOMFehZoauPMXtPQ5/2dwC+8+Vg01tV44VxPXElbg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuRAVtQekRHZeDH71+dh5AJnBerlKCy4RclT3OIZ5U6UUTNND/
	zCLSTPImjIH/5XMf7Fb5JbmaeIS0RSp8crAn2v0ytslNDurHQ+OLtQ7AQnejf5LZ18xUDdB3LWj
	ZTL/f6PW+zwaiX5oXLlTWJu7Rn+S7qxnlG42dFfGVPg==
X-Gm-Gg: ASbGncsRLczRNat6ZsMCwEjoQRT34F1WJBlWbGy8YudAr5eh0BM8iPw789zLckC3zGc
	Xaa5iMyc7PCzvodyahJ1XBaYJOGoBaZaiUwObzW6LNuPv+s0I3Wn4xpjoB/F7gHx6UUn2dMXjCG
	fu1SCK8tm3Fhrzki+QTrdbZz84513PskOyUQtyIGsmqoyKBpq7DWhTpOlMFErNtfQpRayykGTvn
	TBvT4ELr3KEkU4+alRslSObghsRkzxV+J71K92IhyqWeFpjow==
X-Google-Smtp-Source: AGHT+IHgJSRV8ByiNY7ouVWHU1k4CdL9EQdnatTgwryNMr4/Omqqdm3U+SYbq5QYyRAZT3wSH4j4TBKjh1SPN/pjHcw=
X-Received: by 2002:ac8:5754:0:b0:4b7:a885:9659 with SMTP id
 d75a77b69052e-4c0720ad96fmr24093771cf.41.1758266044383; Fri, 19 Sep 2025
 00:14:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798151087.382724.2707973706304359333.stgit@frogsfrogsfrogs>
 <175798151352.382724.799745519035147130.stgit@frogsfrogsfrogs>
 <CAOQ4uxibHLq7YVpjtXdrHk74rXrOLSc7sAW7s=RADc7OYN2ndA@mail.gmail.com>
 <20250918181703.GR1587915@frogsfrogsfrogs> <CAOQ4uxiH1d3fV0kgiO3-JjqGH4DKboXdtEpe=Z=gKooPgz7B8g@mail.gmail.com>
In-Reply-To: <CAOQ4uxiH1d3fV0kgiO3-JjqGH4DKboXdtEpe=Z=gKooPgz7B8g@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 19 Sep 2025 09:13:53 +0200
X-Gm-Features: AS18NWD11PNB3svk5L_DyA4P7FLTVC_7xWPTnVo1mAtDh-XBIofxbbIK0S55ieo
Message-ID: <CAJfpegsrBN9uSmKzYbrbdbP2mKxFTGkMS_0Hx4094e4PtiAXHg@mail.gmail.com>
Subject: Re: [PATCH 04/28] fuse: adapt FUSE_DEV_IOC_BACKING_{OPEN,CLOSE} to
 add new iomap devices
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, bernd@bsbernd.com, linux-xfs@vger.kernel.org, 
	John@groves.net, linux-fsdevel@vger.kernel.org, neal@gompa.dev, 
	joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Sept 2025 at 20:42, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Sep 18, 2025 at 8:17=E2=80=AFPM Darrick J. Wong <djwong@kernel.or=
g> wrote:

> > How about restricting the backing ids to RLIMIT_NOFILE?  The @end param
> > to idr_alloc_cyclic constrains them in exactly that way.
>
> IDK. My impression was that Miklos didn't like having a large number
> of unaccounted files, but it's up to him.

There's no 1:1 mapping between a fuse instance and a "fuse server
process", so the question is whose RLIMIT_NOFILE?  Accounting to the
process that registered the fd would be good, but implementing it
looks exceedingly complex.  Just taking RLIMIT_NOFILE value from the
process that is doing the fd registering should work, I guess.

There's still the question of unhiding these files.  Latest discussion
ended with lets create a proper directory tree for open files in proc.
I.e. /proc/PID/fdtree/FD/hidden/...

Thanks,
Miklos
