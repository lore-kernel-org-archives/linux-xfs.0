Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897B918B493
	for <linux-xfs@vger.kernel.org>; Thu,  1 Aug 2024 11:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722512053; cv=none; b=feH5xo3FrK0XfTQ9TZn85YsoPlbrLAUmjoNDQk/KHDUnwh8WyQGUKzZNFbCrjOi8NNOO69vT9mQG3dBhQu9V/pZUko71x4Tn5dHjyPKBF7ZenAxp8WavU/06ZyJuQc44mVZN3lm04y70vbBu7zgqE5g+HZ25U11UFNgyinnfSZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722512053; c=relaxed/simple;
	bh=l22ocJHxM4V22SaUrB1nt0oB5aytUQU1Ow8g09DUO6w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aOY53fHjTiyEt/07dWHhz5a3nCqAD4FPT7pN3JKAwrk1NPjXxydDqWH35DFapyBzYZB3Rddw7Aty24jNj+6Jy1fz2bHUydlNE49vin9R0Z82AzGItQQ+zjlpjM/SiZ6dNmC9ZrJJUsLdX96dZTPnTWbXz8yd0U/vxGW5SQSa0/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xrp5ASOW; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xrp5ASOW"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52efe4c7c16so10034881e87.0
        for <linux-xfs@vger.kernel.org>; Thu, 01 Aug 2024 04:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722512049; x=1723116849; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OPgr8EubW3CnuenAcVIOCcKa9WvrgV869SfvLT+QQCc=;
        b=Xrp5ASOWbXoryIC7Oo0x2bOAHJwZdHz4ISS2dVY6U01DYT0LHp6YrI7lieSUMa9huZ
         sLuveSDw9faPCgwC4Tavkj8NDaoWBXSw6boy2GYAgRK7lcdTtkOprjXURtS0k+AhRjMi
         RRenI+df3jO9UuiUsi2JFHx0L42dBkPAXY7K5cdJZPHitgUtmeQnjN56MZ0JN6ywmpov
         Lt4PEPIRGIzCeA4dhH31yErbZTpLBgFT5EJ9c8+x1S28Krp61OPCV5ZuJXbB57zheojr
         8e+g5Za0jmasUedQDDZiroLhe7uQ1LBvwl5ihCV0QHufAtqRZItKjx3t/UW/KCabH4AZ
         NLsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722512049; x=1723116849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OPgr8EubW3CnuenAcVIOCcKa9WvrgV869SfvLT+QQCc=;
        b=bHY1WxP34UyQctsljkiyxy759SkKkJRX+vlzwaZJxD/DalRFz0EFalwl1G0AM4L44b
         TUambOXTrDDrrJN6Ejgaz1wOfQbi4q94MNbLCH9Kna3fqXu4cp4JPJ4HoCwZzqb0nJZ1
         qe4/JmGj8UgNwyKyqU0Z9IAGCt4YvDu8a0GWgkIXDu/RZGPHf0m1G9Pbwxl/dmeHKe2e
         4ZdQ8raO3UmNBEZPS6/6fAaX8SKXfJEOVVacmVdfKCPYN9TZL1OfJXNKYYwOSTrqzTtq
         D/ErF1R6E+VnW6PzLgXVUNcrhHu8MAdndbZ5pLDnB1Qr5LqAuewTpw1aNOI0OsQwh0HY
         YncA==
X-Gm-Message-State: AOJu0YxkWHO30on5Dw5JasMFJl2izF3XE00gy+VZn0Wo5QKtILfUhMHE
	VIbBg0PxGISVRGcmlMRalg8Y+Z7necWx4JJFE3Fl4fnpKBJ24Ig9g4ACqvirqguHveJef1Oh6Il
	bZjUG85fW8/sVRFDGA6qgSRLzd2kfs4h1
X-Google-Smtp-Source: AGHT+IHjLC3lzhkHZYY0Eu9xqFu2t/hhvB+xeVfQWwL4doTXky3ft56QWRUw8MX7dHyjW6xTNu887OV00ivVE4fJsow=
X-Received: by 2002:a05:6512:2145:b0:52f:c27b:d572 with SMTP id
 2adb3069b0e04-530b61fd2c1mr1274499e87.59.1722512048815; Thu, 01 Aug 2024
 04:34:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240724024015.167894-1-sunjunchao2870@gmail.com>
In-Reply-To: <20240724024015.167894-1-sunjunchao2870@gmail.com>
From: Julian Sun <sunjunchao2870@gmail.com>
Date: Thu, 1 Aug 2024 19:33:57 +0800
Message-ID: <CAHB1NajXOm9rOtQ1ZzAZB+9bdL6deBuK-69MzB_=T+khQ_coeg@mail.gmail.com>
Subject: Re: [PATCH 1/2] xfs: remove duplicated include header
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, chandan.babu@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Kindly ping..

Julian Sun <sunjunchao2870@gmail.com> =E4=BA=8E2024=E5=B9=B47=E6=9C=8824=E6=
=97=A5=E5=91=A8=E4=B8=89 10:40=E5=86=99=E9=81=93=EF=BC=9A
>
> Using make includecheck, we can see the message
>         ./fs/xfs/libxfs/xfs_defer.c:
>         xfs_trans_priv.h is included more than once.
> So, remove one of them.
>
> Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 40021849b42f..8a73458f5acf 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -12,7 +12,6 @@
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
>  #include "xfs_trans.h"
> -#include "xfs_trans_priv.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_inode.h"
>  #include "xfs_inode_item.h"
> --
> 2.39.2
>


--=20
Julian Sun <sunjunchao2870@gmail.com>
