Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5EE2206BE
	for <linux-xfs@vger.kernel.org>; Sat, 12 Jul 2025 07:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752306574; cv=none; b=MVKKpTk9yysDvHkE7rEaj0J4pIz2WayIYzcg0910pDeCgs5xjWuIAEIo4r5cII7fe3GXfa/OynnaFIScjN51SxjqgJHT5+1iOODWxcUQ/W7+blGZDqWXvZzzFj6mbipwhXCY3K+6JDadlQq0Xhyr0B6UOiq+5C2XdCCF1XhnnWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752306574; c=relaxed/simple;
	bh=JzT+K20QFJN8B64Ey0pJluvv+Wh40ug9tqnaKsf+UT0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=hwF6oVYO2SLqmjcgIvvMuT4D10vmU2TS2jYWRJ4fzJ5KJQ6V6YqMzLTC5IBB/4sAr0bvngmaVUI77diUMSPBRJBiJ3bWRPTqFjYXnkrK+/6ePg+7CowaRZXBVCqRIXqb3b67mpyArvQAjUgW0Rwg5X7JnInRV9wrvVSYpX3ooiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OHEPyUxs; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OHEPyUxs"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-32f2947ab0bso19827641fa.3
        for <linux-xfs@vger.kernel.org>; Sat, 12 Jul 2025 00:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752306571; x=1752911371; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JzT+K20QFJN8B64Ey0pJluvv+Wh40ug9tqnaKsf+UT0=;
        b=OHEPyUxsKWHihhNZOrCHntMz0stZ1mY0vVdma35Sn5ILuK5zHvUt/xb3fJZGw26l8J
         xcAfZRav4InpxHnC9cVNFQCHVfio/ubv7H9NFNR/EXlOvlCk+cBdsEPVMlZDiv8H7OKO
         Ryi9c/IYxmi5AWmnE6uJSEt0ijVwuJw9n8OedzMpg5e6y1pa/Mh6stUmQrlv4khEQk4o
         56DTAyRyB+P/RlgZ2nvk0zHqo26aJ7P6zkDZdoahnNfhHMXTa0ERf1m8zT2JhOgSBBwo
         FIHfhliiUyMzksmLNRn+kS3xkGqhCAx73GjEZaaAOHq9MCyvUmTCHJm5bnDPt1HRt3z/
         jX1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752306571; x=1752911371;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JzT+K20QFJN8B64Ey0pJluvv+Wh40ug9tqnaKsf+UT0=;
        b=O93eJ+SZ2qF1gGQVfU473P0Px13m6Ns/BRBl2o6LRrrCuGiA+fJreAr7WFbSzH38Oq
         EN+CaPeSUKZX5f0dqM2OohtWLbmy9+y+MOqZMp6XI5BKvrJFgMdq09j8pW/WEgGoba4o
         lNTtqUXWu6QhOJAOHZk7cv0bWMswV2YQEngUqc5/ILh5nelAgXyS28uwW4Ud/qFPjfqp
         dD/u1SArFcFiMX+edz2//6rvx4hOjYJVyk3ZftxLFCuQi1daNqmWvtvzCWwh53wmjBj7
         rT0/XzsXvmRNnjrzPWIAxdLaXwobLTb8wLA3EeBusNhCj2EeXG5rDhq2GUnT6+SnEK8V
         dCug==
X-Gm-Message-State: AOJu0Yz924bZXPE57C7wToz3XnRXPkg0D6arhsKmciSjdp1bHzNE1FQO
	ZedRJIVKRTapeGWKCRIktOJ4pkLyKCfPhdYfdAlFCD3FKZSTBMlJll/jr1UIUEk1OeNR5k2UjXE
	Neiwmdn7Y4WB7OoxFkAsrHZHgwGWWOqnWVOXf
X-Gm-Gg: ASbGncsrgDTGGf3zT6NijE+7gyIBKo8v9wB11Lpia9dr7ThTyEcY+ulvvyRK9aQgVGR
	DSubW1shq173svRlcJWty0k/nDqUfwYkjPE7v97tV5qoIyUnpBIsHvAt0qQ5daVHSkCqs8c5Uqj
	uL+SOuS5JHgYJ0SewV9i9ZvqHxVD24uY9riJssXLC5/IgvEQCZcJYZHI2IekAX1FqBeoPfgonBV
	PnA/HqJ
X-Google-Smtp-Source: AGHT+IHwxHP23Gj2TlwAxEHCfHWkQfqWd+TsFj2PJqBvqOYosAfwAY4y2OyidutC6bTpR7q17WA5fZVqctUMoM7HliM=
X-Received: by 2002:a05:651c:b08:b0:32b:a85f:c0b8 with SMTP id
 38308e7fff4ca-330532cb882mr21820501fa.9.1752306570650; Sat, 12 Jul 2025
 00:49:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Priya PM <pmpriya@gmail.com>
Date: Sat, 12 Jul 2025 13:19:19 +0530
X-Gm-Features: Ac12FXxUdc0jFAzhNxAejH_IiK5732zo5-KavZXyHaeDap11oFR1I2mq_IecmeU
Message-ID: <CAP=9937nv-k1dTbHHRZF3=jizvRKcQNAa9_nM_Z1RA8VMYhKSg@mail.gmail.com>
Subject: Query: XFS reflink unique block measurement / snapshot accounting
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I was using reflinks to create snapshots of an XFS filesystem;
however, I=E2=80=99m looking for ways to determine the unique snapshot usag=
e
or perform snapshot accounting.

We tried using filefrag, but it doesn=E2=80=99t help when editing files wit=
h
vi, as vi changes the block numbers with every write operation. This
causes the snapshot accounting to show unique blocks even though there
are shared blocks with the original file.

Can anyone suggest a better method for snapshot accounting on XFS?
Thanks in advance for your help!

Thanks!
