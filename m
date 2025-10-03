Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FAE26E16F
	for <linux-xfs@vger.kernel.org>; Fri,  3 Oct 2025 11:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759491153; cv=none; b=aAjkGKDqUYt6tx0VHZwvQvxMoqp6+G96vSPY9zVgJeasuv+rir5GrV507EydzIiVUi8sOlHCbH1EHSnaWEkCRKH7UDF8uM7DKtQe3sMYfS+RklKC6Y75p9qcCZxJrBQ5FE5a+mnXIpb+uOdo2G94gXlYVC132HRC+tomlDuoSIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759491153; c=relaxed/simple;
	bh=hN/3/jSULnqO480CV9R4hgGh6pedSfW6Pifioqw5/JQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QgFiwYn4cW+3dtE0uldgvfQE2kErQc9HUcuQYIgNkUMCu2iud94rJCVN1JIJZ4NsVqF+4TxbB3yp8qw0lTc0aTN9oCyXw6LRMVAzj0ksKbk3/P6pfJZmYUnLfhsa09/npbfj6tGTWXCObG3GbYo3slQUOU8l6pPfnjZyUxhje9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RM1h5aBq; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RM1h5aBq"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-62fc2d92d34so4418047a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 03 Oct 2025 04:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759491150; x=1760095950; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=arofDSGA6K93/EH7pboiThZMRbZzahaUwyfBQ3athN4=;
        b=RM1h5aBq9uQgnkBVpRXkip5ZIs+58YWXX52Zpp5d3CykxKhqMguMlDXq4FJQ9OQPvl
         WnZHfqU2XhX/+MR7mS/DjU6hfkHZgLFUzIAtbd5H90KTw7oImbW+t68HwsUdOwSGFaAQ
         Qfm28IOVY4/cuxS60vp2f7jejZW4yFb5AEFmrpBK5PC+iM1CZmJ6cgJOJDBnIf4xInzr
         T+piyVe34vhEz2Zfd3zNVETx1WQKO0ADVrMSmDJa4mBPICctK3oONUeiTc147y9xkB7C
         /LAPOtbaFLIS+Z1EtrVwDyX1aGRPKB/j6wT2p7iq8ghNBFdeptFaKIcyv5a3lh7hDkUJ
         dIWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759491150; x=1760095950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=arofDSGA6K93/EH7pboiThZMRbZzahaUwyfBQ3athN4=;
        b=BwAsd29QoW+BESH9m6OZJnAZsXbda+XZN/oCOnv9VoKMSWlD7l6Uz2YNvpWcj2DQbP
         XlsUZkGjbme1MRXypXbleSHoua02+6Ml+WwlTV7mscZOzA5omXFyhPLA186DzBZz6yvX
         m0ZonlLk6cFmg7riGHfbLJa/P3QH11jXSNXYoCtTNWa3iFv6+wLNYFAxF5r1a5aIp36l
         xlDWgTSfCE3r5ULA9NsfwMicDX29BCdz/fdfytkLhWARrfNPmEd4PLkW39d5UfzPVR2q
         jlyyCyEytAsjudB8MMLDGGPTmd8XX89g6hjRNR9Z5Z6uDIGziUe58ErIbhJOlz2AL5kg
         InUg==
X-Gm-Message-State: AOJu0YyGIEl2V/Gksg7E8UhDGrY5SBvxPkHWvjRZnXLCVMI4YTflzc/F
	KdGqLtzS+VZc40CmwoTdl8AMH/AYl++981KeRvuPTN9zOZxVDPv6+mOGmJiDlDXeiSZ1u83Y8RH
	vlANpHgVWVutIqJKtaMsXhv1ArlUk6p0=
X-Gm-Gg: ASbGncsxLpPm9OIoVP0mbTcSXIVLGjUPfdQ18ZeT6JN14tKv24/qKxEt1Xgr55gzPCX
	6L0QCK5+i1IefnpZBVEu08Ds3hIqw2cIvNzPb270X/NR4heKKXww9mL4Jnrqr6Y2EF/or35fNw/
	54mGjtCV0NRPSnXvdP2eb1GXZBokeq18ZvoCa6KxGaIsaLMYuKlQp16J6rPoxDs8jZtPz6On9aV
	gbVABT6IpVxxT8x2Qm8uI4oxmRh9g33aAN1uDuAeN4muBh5KSc2DOWdg9FH3PBQCg==
X-Google-Smtp-Source: AGHT+IG4NfeNnd85rxYjjlAEqw9eiy/cIgM0hpZS6uyDDW5NPv1/Lc+AvktvMAEoHzPDBeMxqP9mxINNb6C+RzFr6xQ=
X-Received: by 2002:a05:6402:274b:b0:634:a8fb:b91d with SMTP id
 4fb4d7f45d1cf-639279e40cdmr2951155a12.0.1759491149615; Fri, 03 Oct 2025
 04:32:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251003011441.GS8117@frogsfrogsfrogs>
In-Reply-To: <20251003011441.GS8117@frogsfrogsfrogs>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 3 Oct 2025 13:32:18 +0200
X-Gm-Features: AS18NWCnPQN6egt5ux-iBnCQot67AfQ0aMD2-rGHEu5-cfibIEa8kBAn9lGuaqg
Message-ID: <CAOQ4uxjXQ4yZUOZ8ny57F-4yA8Fpj1xW4eY72j_ZBTe3h5hVWg@mail.gmail.com>
Subject: Re: 2025 LTS maintenance for XFS?
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Leah Rumancik <leah.rumancik@gmail.com>, 
	Chandan Babu R <chandanbabu@kernel.org>, Catherine Hoang <catherine.hoang@oracle.com>, 
	"Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 3, 2025 at 3:14=E2=80=AFAM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> Hi everyone,
>
> Just out of curiosity, is anyone interested in picking up LTS
> maintenance for XFS 6.18?  I don't think $employer is going to go with
> it since they just picked up 6.12 for their latest kernel.
>

Sorry, still no time/budget for me either.

> Also: Is anyone actually working on anything older than 6.6?
>

Depends on the definition of "working". $employer is still on 5.15
and I do have to maintain that in house but it's only "very odd fixes".

I was considering upgrading to either 6.1, 6.6 or 6.12, but now that
6.1 maintainer has left the building, that narrows down the options.

We should probably update the stable MAINTAINERS entries
for 6.1, 5.10, 5.4 at some point...

Thanks,
Amir.
