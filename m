Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C464118562F;
	Mon,  4 Nov 2024 06:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730703361; cv=none; b=ZEUKe2Xrq7nbw49sDnVXB7DUTDKm1zvJxTEEpc962SmiUTP1tIDr/guxKeOvKKDLELVVFkJCmtkoXbH6ChiYgYxY2Ij/rDp7tYgvfrATCj1sA271kq+6qPU+fwENuozyZrKuOcRIIOIpdBhwGjtZS67KcNT9slB04L5sghSdAoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730703361; c=relaxed/simple;
	bh=KnTOP1y0mwLLmktmDUuLS9+1x78AkvSs2dKxz3+1fZc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uiUELYOVrUdLpAgwIhrthG4F2bmTNWqQYE/iUh5l/Ij9uBmRS9DexTMm7VBnHZ6IGM01eYAF5aAt5jFDsVcqVHvwJKrai5k5CHe0i0ItA5NOXs8VoJEpXbBOdGeyfNuiRUS3sjk70prk5oceHOXRLKZ7aK97PPWiMsqLtkjwU6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F+uqmhDn; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F+uqmhDn"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-460b2e4c50fso28992141cf.0;
        Sun, 03 Nov 2024 22:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730703358; x=1731308158; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KnTOP1y0mwLLmktmDUuLS9+1x78AkvSs2dKxz3+1fZc=;
        b=F+uqmhDnnzHJqYG3EC2NuDpgEae0OLAbyYy0291mlMeHowC54EV5W8a7mKxYQSMBIW
         LpZ+dsQrdHqnpOWdo2pIgxLdcEBxls1SPTDX56OamnPYMEMU1r6I0uhKrGgwHA3LPY/9
         s96QF6Y/lBxaFnp/LR8zt7x59ncHDFFkGgr44uN0aRj4Ai3dtHV3vVA/ciBLe4J21kxG
         wRhOTEBbF2pxEJRX5M/ea5V/+/D4Z62N9FGHYCIvO2/GapSixOu7tHtRDtC9jxZANaFI
         U1Cug83OxqBYPx8Q46rvDS+thLuPQaAlQhrE0h5aHgOg6MBi/ibUpTAvvCMu0XUEJz4P
         yaSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730703358; x=1731308158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KnTOP1y0mwLLmktmDUuLS9+1x78AkvSs2dKxz3+1fZc=;
        b=LpqjUg18JG7XNNhtwnvtBR2qLqIuu5CMUph7Qxtzm9vhUW44r7m1JQeAhF8ngh4p8H
         crYE4z6ZDHfFLfSXBqhr+aJ85loVwrl6DM53jgSb3jHH3kvG3GwsmiUOzv0gy+Bi6Wzf
         dSV1jQAhShU5eZsSKjRiU3cctXWnO4vB0LapkGCbtBfI3VLyVEUPy+AxvZe+AsHZfb9z
         3n6uVgetgKRAPMsHAE77bC7j+AZ/nThFYeXTReRKqFlOni9eBJjKgTpdy1BjXdj9rQ3c
         4fVRAjS+ksv29L2ekdqXzjdE8MyfQJd2yi3i5xhnBRS/tx5df3IHf1cpB7Wp3WT9r60+
         dUGg==
X-Forwarded-Encrypted: i=1; AJvYcCUADFFLcdwxGYE+mElXLSz4qPz8WEo07V9Cede3CtP/byAfa/oEO+Gc/mvYwLTxQc6yiXcEbQ0us1uD@vger.kernel.org, AJvYcCVWN5r8fzZV9JBmh2IKDi4LV+mtQYM86wjL16D8+wKIIUAE5f79PUiVgpXT0911h1li9mohJFSUgHVgTIQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkqFJ+DkPludxu3ksKc6wEBX9goT9+uAOgZHOU4NN+0rXhdnbg
	Ft1k6Hb25ucEJ/oXTk00XVeD+R6rQu1Q/KW2J6+vR8nmk5h1b/Y3Jyh87nqygP5/sQ1VF5kZWrm
	PGO/sj7bHo2AdY96H2Lntml+y7F8=
X-Google-Smtp-Source: AGHT+IF97gXJ5LGCjJTks8AH4z0TUnSkkLJFAHat/Lf228B3dkZvcLaj9nfLYuwamNsr5k6g30A15LrUWlBnUOv+79c=
X-Received: by 2002:a05:622a:609:b0:462:a7b3:985b with SMTP id
 d75a77b69052e-462a7b3a2d7mr277828281cf.59.1730703358632; Sun, 03 Nov 2024
 22:55:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241104014439.3786609-1-zhangshida@kylinos.cn>
 <CANubcdWwg3OB_YV4CteC7ZZBaQXOuvFG1oS7uN+TpabS=Z=Z2Q@mail.gmail.com> <ZyhAyrateNQPz3Hw@dread.disaster.area>
In-Reply-To: <ZyhAyrateNQPz3Hw@dread.disaster.area>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Mon, 4 Nov 2024 14:55:22 +0800
Message-ID: <CANubcdWdk+STqOYPO=24f4MSXe1sBvLmk5hJZS_KX+qk1bTpgg@mail.gmail.com>
Subject: Re: [PATCH 0/5] *** Introduce new space allocation algorithm ***
To: Dave Chinner <david@fromorbit.com>
Cc: djwong@kernel.org, dchinner@redhat.com, leo.lilong@huawei.com, 
	wozizhi@huawei.com, osandov@fb.com, xiang@kernel.org, 
	zhangjiachen.jaycee@bytedance.com, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dave Chinner <david@fromorbit.com> =E4=BA=8E2024=E5=B9=B411=E6=9C=884=E6=97=
=A5=E5=91=A8=E4=B8=80 11:34=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Nov 04, 2024 at 09:49:32AM +0800, Stephen Zhang wrote:
> > Hi all,
> >
> > I just send the scripts to test these series here.
>

Okay, I've resend them in these series.

Cheers,
Shida

> Please include the scripts as in line text like is done for patches
> - base64 encoded attachments are not quotable nor readable in
> archives.
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
