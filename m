Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E096F274B30;
	Wed, 16 Jul 2025 17:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752688029; cv=none; b=LY7kMgBeCOiE13HkS2r188l2XqMWrMAov7vn5iga4KZXtTphRUAMn3sNM6UahcU8W/6RRwTP9Tq+pgBHbXZc2g8GtvundPLw85RTj6Nt2fy2coLIjf+EAcFbCKmuXFIvOBpDKiggMe3BW637y9YaZB8uczIE0XWwZKwlYc7b+5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752688029; c=relaxed/simple;
	bh=gJyf3eYBOXnI0JY3ZVl94DEBjeBBRtOgiOq4S+Z6bSU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dNDZfPTlSzaKqPCn5VinduuGnLrdUSLEYduVmzUHDfBbrAvDgz4tm8H6YRWXg/A/Ylvf/ZJDMuSvHXyDrSZgJT/BGgfgoNQUIT/0KzrLSgPto2cUkoZjSiRzJ3qFBosovVNuy2Z67uZqMJ4L/N5GPQqC8M7xHaUlMSryd5FXxjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PigDw0S0; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PigDw0S0"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-2efa219b5bbso76824fac.0;
        Wed, 16 Jul 2025 10:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752688027; x=1753292827; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gJyf3eYBOXnI0JY3ZVl94DEBjeBBRtOgiOq4S+Z6bSU=;
        b=PigDw0S0W2CX6sk+aOMLnUTzhbuB0L9EUuaqVFmn/rD+t5gGB7So+I2Qn5FuUQDEcm
         MvxUuMBstvErInSTEThOWh7l50OxT8Awsrn/0Q2GKjZRv2GkMGzefOynyQJZrnmEizMh
         Bdxau8ZWkYDEVkrnRPSnqB5ierzYgGRWpoeQTz454dQD6lQveqWEbOGcK1DSwb4qVCGa
         ykDnVOmbZBpxIv+JV1CCxzDuMBsMZGtAGVNGnwAJltFYkJpE4kHR2bse72n6YryD9W7j
         2DGgHhu3eAYW4K40mUpHTtg1w5YayC4aPe7+TisFwILIVYsHUpBV7Jy/cfTBtYoBuNzA
         vV3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752688027; x=1753292827;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gJyf3eYBOXnI0JY3ZVl94DEBjeBBRtOgiOq4S+Z6bSU=;
        b=ELWbLLBWMK2q+Dh/VB91SYiF4UvNyPxfe31BowD6HnXzqAa85O9C9+1nxkV9nPBc5p
         gPFKc1KPd6WgG4yOwOamGJYmNbVOi7ZYsmO2rGgtzWwf5ZYO9k9UKiJB5z3PGQJNeb+S
         4oP4hofGcQe3RdV9RJBR9cgEN4EemBQnTY2+FyoXLFojPqohECrQKrS+N+he0EhJpPce
         RnanD0YQAjm6NWT71urbJyxcbYK+BKdg3ST0UpTtMErzeMRqBLCbCIcw8mUElF/Iw/xD
         AdEQrAPaJwehYsC3c3yPPy3sGFc7vyTjtasDivBkF8srPpZ/s023lhMpSObcG4YmnNO5
         tEkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUY+81P8BWIZ1f9PyDfiyC+CgNu/6z0sFpDHiqgT47vyYpQ5+2T6C/q57TSZQ4W00ijIVdoDWXmT0U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlzzaMCw9/Sojpedmik4kRxD6IdR2/V+/nFbwiNcUjki7n4lJp
	rjwwIZ3LzJwnE1RAUVhDmwnGQuEpNLWulvmxk1HaYwP+v0ZE/7yB8F4i3JG82jmq2fNnBevBq+n
	Vu5WaqJZoImf2464LZBclL1GlF2dwA3qQYByK
X-Gm-Gg: ASbGncvIZg0vpNj3vbEjVHZYsl6C5Q6T1TdTqmOgaJHefG+Rx0AG2tE9W+9nakS+oc/
	yYyYe4B/CAVz+0oVjsgrYMEImVgzVnKGt0ImweFQTmmaYveRwDguZAiUrFt5hZNfXrEsr2XRjcj
	vbBE8FyIjBliD8e003txaJhizCVpXKl87al+MEg3jTUCRqdf+Ujv7VOt0zqpRsbERKHpin7Vzmf
	cjLhMw=
X-Google-Smtp-Source: AGHT+IF6kBbOAlEBp+jLgXG7nXB3N3v2Dh/1kfCy203MIrzOwxNKfJjinMMNUNoqfIasZ6UWLs2SfFo3rJ6835G/eEo=
X-Received: by 2002:a05:6870:b025:b0:2c2:4e19:1cdf with SMTP id
 586e51a60fabf-2ffb24434femr2778311fac.25.1752688026831; Wed, 16 Jul 2025
 10:47:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAN5hRiUQ7vN0dqP_dNgbM9rY3PaNVPLDiWPRv9mXWfLXrHS0tQ@mail.gmail.com>
 <20250716221003.0cda19e3@nvm>
In-Reply-To: <20250716221003.0cda19e3@nvm>
From: Filipe Maia <filipe.c.maia@gmail.com>
Date: Wed, 16 Jul 2025 18:46:29 +0100
X-Gm-Features: Ac12FXz43e5oFai12962wHSGeIlukTKh4CTciH6WVQbHlL1T9oeBJr9rpbX0-Pk
Message-ID: <CAN5hRiVBJe3geH4C96xDkopOb=jEj2wi4FGA9yAPUB07Kh60Yw@mail.gmail.com>
Subject: Re: Sector size changes creating filesystem problems
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> If you dd the XFS image from an old 512b disk onto a newly bought large
> 4K-sector HDD, would it also stop mounting on the new disk in the same way?
Yes, it causes exactly the same problem.
>
> Perhaps something to be improved on the XFS side?
Indeed!

Cheers,
Filipe
