Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01EC28642E
	for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 14:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758809495; cv=none; b=A1kym4VwPv2veKO08nF3d3gG3o0OLryENWpH75JjbQTM0GrPRrbpH6QCE+T4AEhB0PkZUWZm3YXXOCVaI9PYTzENVTdBI+bDm2ZlMWVZo1HxaI8zD5NUsJFqP5RYRurMMUBRYKsz5f8lVi7JhuJzOPQkIEroqYyz6JipBA3R3uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758809495; c=relaxed/simple;
	bh=UWpobgG7AYD6hqiWmnB0mqamozgaQ8uj3AzemTe7asc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FNkX8bOLPRNmVnwCzdatYYo1L+hmRRrW4Z1PJYVNHFviJGs2Qmmrua5qslgvDVpfXpeFbwqSVBwmSTPPtkjs+7uOVFdsK2XbrLKfDCYeRQSLnoe80AfIInps4zCOuQnysuZv6DiVEKaIHJhltq5kBfS1PDtEUUV5TFLCJIhjen0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Fpcco5+F; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Fpcco5+F"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4cf068ffe4dso8045241cf.1
        for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 07:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758809491; x=1759414291; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I/427OD6W7pLU9IsyNgBLHy3+mHgHSmXy3JA0vIM0rw=;
        b=Fpcco5+FgBeRXCE+FP1vA3EcLguU66YWq2sA+3Sjwwzhgf4hr4WUd2H/FhkZZeOZ+X
         naXU4k8EEiE9eHdBiN+0O9/0k4tydH30C7+g5+QZ5WYV+yltls5a5yhOWk2jpww25plU
         Vi4Ji1jll2dw5D1y2IBuZFjKLp1IywMSzPSH0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758809491; x=1759414291;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I/427OD6W7pLU9IsyNgBLHy3+mHgHSmXy3JA0vIM0rw=;
        b=ZFXR71ZhBIUMMpgPE0utPsN1d+2O8Yrei0k2RW9Ix6+nInVkWF9WanCOq/GUwQkmLn
         GH01FaUKXYGdsdm4Qn2/hnuIwaNBjJThE0D+9i8XlGNBI5SXVqrlq4rrO0XTPPDN1k6o
         R6cy+qnIhSmFC6B/RpisDN1yyayIafNbpy4E1id45v4W05FEuyQP/n9/yeweIt5YyTPE
         Z4+RPIWpYj+/szfuBY5iJzzwv77Cvnx2ZLiyhrYDzVpG/m9HxBSRom6EF2a+W6OVlX/g
         kz8P4bMJD6YKCBwzHvKetddTZ60fLSNhyTOVXTzT12yI0Bi8QL76b5BCSHp7EFUxx6Cu
         GbpA==
X-Forwarded-Encrypted: i=1; AJvYcCX03zds53+f0DDKPAvhiBNoN8b5G4zyrPMVucEg/hUPJOxJVLGqxX2C196mvKy2RIICHM0lcgV63Ls=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGtURpLWdxgI5/itUEAx1G8LozRALNrs4m+58nK74Li9RO1GVo
	pIYJbGa01Ojo21jamkY0R8lv75UphQalOjuwE8y0pmOtSWGcjKvxuwpLT3+6o/ODwCKv5uSGqlS
	5A71K+BnSUja9wcQrbp1lrKwPPme9E9GkkOpZzuzpcA==
X-Gm-Gg: ASbGncvthMCfSt78oj6S/4hlcm8ONsj///9+xf/WomPZCixgqXds9iUrFFaDraGGHjo
	VWUJFvmi38/xYKoZVvv9ssh3LEVfjXz5JUtFb1o4e24RJmYaH2NuM0nnNFAKwH2Ww8Chg6zSOjO
	IwTVlLEtwzphpVQvPDb+G8Do7EiAWGyle+q2ALx/IGl+nFKa8XZGpTlwalJgS5QOdLgN0tCtjRc
	JgH0gDQeZMYChEh2wjMJIUZxLVJun+uO/KMj8Y=
X-Google-Smtp-Source: AGHT+IFhfosi5V3Lpsu7k3dFcUbA4i0T5Z6jiPcQqhRUf6vnqPoz0t+a4rROD+26tZnIGA1reTjuZXid96Lf4t28HXw=
X-Received: by 2002:ac8:5802:0:b0:4b7:983b:b70c with SMTP id
 d75a77b69052e-4da4d503cfdmr38924161cf.67.1758809491232; Thu, 25 Sep 2025
 07:11:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <175798150680.382479.9087542564560468560.stgit@frogsfrogsfrogs> <175798150753.382479.16281159359397027377.stgit@frogsfrogsfrogs>
In-Reply-To: <175798150753.382479.16281159359397027377.stgit@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 25 Sep 2025 16:11:19 +0200
X-Gm-Features: AS18NWCGKknJWI0OJGH_hfKtcByhpGdDRX_5eBsqXozD3JQr_kkA_sCThsBDjJU
Message-ID: <CAJfpegsr5rOu9n=smii33E4KugyTSqSmQzcSzi2A+5Qi-es0TA@mail.gmail.com>
Subject: Re: [PATCH 2/5] fuse: move the backing file idr and code into a new
 source file
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: amir73il@gmail.com, bernd@bsbernd.com, linux-xfs@vger.kernel.org, 
	John@groves.net, linux-fsdevel@vger.kernel.org, neal@gompa.dev, 
	joannelkoong@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Sept 2025 at 02:27, Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> iomap support for fuse is also going to want the ability to attach
> backing files to a fuse filesystem.  Move the fuse_backing code into a
> separate file so that both can use it.
>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Applied, thanks.

Miklos
