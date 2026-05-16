Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF2D2DC762
	for <linux-xfs@vger.kernel.org>; Sat, 16 May 2026 06:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778913821; cv=pass; b=TuUrfLe+T0sjgVj/7gxEMPteP9Q+IAOrF8VG3Tse0ebI1hMemYXdMvpk8b8qzZwse+yXYE48CCYSiQcz9+PFxFlHuqfWCUDglnXh0TUbgyi16Re98CNg5CM3NeUVUdvSsiP1cewkKekrgSvMSZdIk0e8tHGE+6V4g9dIbfp6dc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778913821; c=relaxed/simple;
	bh=BOu7AkGfzBlU/bzal5lpBXqw/o4zx+y8OCCvr0FI1sY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z1arXFUwPUjb9kRyZYFqhLrYJcTkWqOjfPVXwVuJCHl/+dNSaVEzZ2EhinddvbJCt1QaFUbF9pjORyniIoC8sB3ZKNXeIffO+RmDQ2YaAavSSAbggS9nVyAuUUDDaCqOMvpP0tybf39tZK1XDXGmqNr6vPnqrXDEyLQRwKIQYIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lte6xRJp; arc=pass smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lte6xRJp"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-47c6f914617so307763b6e.1
        for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 23:43:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778913819; cv=none;
        d=google.com; s=arc-20240605;
        b=Pc66b4j9KVS5J0m4dZXF4aDaD9+FLrPOJuF/Enw2tBcYgvH4ei+o0IVH9t1iU/4SLR
         iAitrcK5JDW+CXpMgJg0scGKmhv8obWPmR1VXckqxQgfiGc+cOsydW2xf4O7XH/d0D+X
         YmorZm5+qTDRCbKWOjAkpW3hbBfoYzMFevRcLSlfe47mbA74+reg5kVnY3xupkW5/DI6
         0VkKnSPZVQnQcDoM61TntrwQ1ShQZkM+dUOe2h/tHr19Y46onIbsCmeiYt/fUk4u0BF5
         8B5BzGYjno6OctWaLVYOSpj9/v11xVCXk13HgKppnyXvIJRHqPMROEuGf30DVLjkY/YF
         v4mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9mxy2GpAHGinIR1PnXVMvug0ztGXvMspUp7huk1TMZs=;
        fh=f2QoJ3AGWBFt0OxVX5hZss/oW1ziY2iCidO9DJsxjQo=;
        b=ljCsVmdvxCX5aV3MrtqcOu1EFvBE44ItZ7OUoUok5CgdySNbSUJKwix7v1ggIRK2D7
         P5J0LlslrEv8bBqFgDJ6aSoG1JLVubwauO/Pf+n+FkLTrqByawO+GCFuSatptN/+p50u
         e7Micg+J6thtgmwk3Rxm/LDTgDyQMBK3HfvX7SRayz48b2TngFHR63WOewU+1VPDMTRg
         jrGtTTaQ96ZdAFezA8OBirCGPOEt9DK+xI8VhBQ+zouBHS9z4Bb3g3pkFqgC9lJTJRlX
         WeCDCJ/D9KMsDmL0dphE1/rthjmpqb+brwNIMepdyYISNSM/r2+gSMnr+afxj1YMI2JR
         gluA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778913819; x=1779518619; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9mxy2GpAHGinIR1PnXVMvug0ztGXvMspUp7huk1TMZs=;
        b=lte6xRJplRGmp/PSskcPRMRcmRHxp/3AN6A1XynLI6uXZlluhAn8u2h7mZQg7APZLK
         oAbu6jVFzk3P9a62b4PsoqoTNSJkE7FzjLFpOPv5Z+lsxgwuhtlVTrcbfv9MbnmVX5Py
         k/kzYjGMlhm8+gRGJfuzaDpFjgrS5WI83cFpH15WHsjn/iy/5C/Ve0iDz9Octg/QEDrA
         DhdqK6z9WrgQK213b5HL2plz3FNcI+orhuzLw1gTevyVgHFRj7CbGxDhPlje1LF0RZp7
         KU79gd97VCPt1LjtMq72jZt/AsJhd9asWIZ2PtbrgPLo+/sBoYkMDD8j7+KHYkro1zzO
         kN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778913819; x=1779518619;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9mxy2GpAHGinIR1PnXVMvug0ztGXvMspUp7huk1TMZs=;
        b=BVMIHIaZNZOZeH5GayrhoaNOxRkV3bE/ticsiG1+SNrEhGMfZvM94mFJENghrzOWD6
         4xvWfZhhHgddG/7s1dnVroycdqKckRxeA7U8f8bsMOzAq76UbJejV1u8+wAq1TdwU+R5
         oxDsGF65ZPwoFKYM2j364MSxoCciGfnKuPRt3PZXgbjGyMI3bFhTr0HXPMsKBhYJN8FI
         Z/ob1uk6lTYeb5ky76OFjPpxCqFRp7paKfYCrciESKs996dfUx5OQtC/nq3/8Xja9l9G
         SoNS1pgHMX8/MkhaeS06eaScakuAm2rrbsc4aaCsAye6gLKjPE64ehHEa/u1EFlnp54Y
         gdEg==
X-Forwarded-Encrypted: i=1; AFNElJ99WqaOTuzwTzp5HA/Zkh7uHaKrue0zWjnkSzvicpHbXSN0NGEjHsuEcnm1mkQQZYYQaqse1UaeHmA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHibwMqxGnBbc9+kLSTVy1wmZ56DVGm9JEfjV1iEPY62Dupu5j
	rEdKG6rdPv4k4y+APqRehgYV83k7wp06r+z4L5e2dq5JyI9fdcFZ7Qi9fq80Kd+V5pST5NzqeEB
	PJDZbuz4Zvz4eEqNRZ2bODACa7Mtc0JQ=
X-Gm-Gg: Acq92OFOep4I7IpwR+qf4dJ8OraTwuIydnh7zZsILyJjsddWdpvzxo9kq3uVhGoheOH
	yLqEyQ05Mnb+U56oFtng1dSHIVx5CBMEzkKVAwDWJJY3Q5hXfaJ355UrokUXUh3QtMOZBkEL7/W
	U4/Kc2pifWt0ZJ+H4JysIn2og2xEAIeVSytOVLi+ro9zW4+IOvS7wUHd8uwkI/1lDwOc/4dVzzf
	ZgOfDFCJtBUEY3wjJdF/TAwTbFH4SuahHPMyR/c+LR5VKZK0JFQJt810ucWsEXoKWqf7h09OiCL
	HRlgtjbOqAlkv8AgyQ==
X-Received: by 2002:a54:4e88:0:b0:46c:e542:cc3e with SMTP id
 5614622812f47-482e55e65a9mr3386045b6e.6.1778913818672; Fri, 15 May 2026
 23:43:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260507-case-sensitivity-v14-0-e62cc8200435@oracle.com> <20260511-wertverlust-vorbringen-070f016f3bd4@brauner>
In-Reply-To: <20260511-wertverlust-vorbringen-070f016f3bd4@brauner>
From: Cedric Blancher <cedric.blancher@gmail.com>
Date: Sat, 16 May 2026 08:43:00 +0200
X-Gm-Features: AVHnY4LulXSgBXmlt-XknhPT4FGQR5_lEWwUy9GN7jO6BYSv7kvOdT0vcpcWCyI
Message-ID: <CALXu0UdsurG-ayuYViqs0HXOfgyDw8gpNC+f=5y59cuuSPUbBA@mail.gmail.com>
Subject: Re: [PATCH v14 00/15] Exposing case folding behavior
To: Christian Brauner <brauner@kernel.org>, Chuck Lever <cel@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	hirofumi@mail.parknet.co.jp, linkinjeon@kernel.org, sj1557.seo@samsung.com, 
	yuezhang.mo@sony.com, almaz.alexandrovich@paragon-software.com, 
	slava@dubeyko.com, glaubitz@physik.fu-berlin.de, frank.li@vivo.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	trondmy@kernel.org, anna@kernel.org, jaegeuk@kernel.org, chao@kernel.org, 
	hansg@kernel.org, senozhatsky@chromium.org, 
	"Darrick J. Wong" <djwong@kernel.org>, Roland Mainz <roland.mainz@nrubsig.org>, 
	Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 11 May 2026 at 16:11, Christian Brauner <brauner@kernel.org> wrote:
>
> On Thu, 07 May 2026 04:52:53 -0400, Chuck Lever wrote:
> > Christian, let's lock this one in. I will post subsequent changes
> > as delta patches.
> >
> > Following on from:
> >
> > https://lore.kernel.org/linux-nfs/20251021-zypressen-bazillus-545a44af57fd@brauner/T/#m0ba197d75b7921d994cf284f3cef3a62abb11aaa
> >
> > [...]
>
> Applied to the vfs-7.2.exportfs branch of the vfs/vfs.git tree.
> Patches in the vfs-7.2.exportfs branch should appear in linux-next soon.

@Chuck Lever Thank you!

Does that mean the support for case-insensitive filesystems will work
with Linux 7.2?

Ced
-- 
Cedric Blancher <cedric.blancher@gmail.com>
[https://plus.google.com/u/0/+CedricBlancher/]
Institute Pasteur
