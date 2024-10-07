Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB0618B49C;
	Mon,  7 Oct 2024 20:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728334414; cv=none; b=sUQYQPdSVQYbdClCvUKFimdSVTLBwhcSYFtuCgH1OFHcIobLiglrAHb+o7Y9bfJ2xb+dyQXgdyO0CQ9O8mfau9I9HOKfi4Uv+QNzwSOfY3SPGl9Ey+F21H8U8J1tc0yGeUllXjDJcuacw/eVa5yOI44fxZmRAjHVHuI3SvjQ0Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728334414; c=relaxed/simple;
	bh=7hNGPA1gxfGLdlHovU/Cg7O9sFF6Mnxa2MXLc3lAbLQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UGPbqdCEbsrgZ8XrzoU9MADpmIA+GBVE6UZBG6ghT8jhiOZsDNOK8EWST/iwxs+lapm4+O4yFX+0i61Xzjlf+6jS1v+PYbMQ8/1VaxRvHlnWNGHqQHQcYuBATwJFZtpeUhHk4WErNmQOr3AoNmPcF5ImBg6LQLVgFaYg0AfBcG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ff6ED5ry; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ff6ED5ry"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6e2e3e4f65dso19152667b3.3;
        Mon, 07 Oct 2024 13:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728334412; x=1728939212; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/P6Z8MoLBTNyNgoQYiG3xAVkdrjMw+AhtLOoflITm3g=;
        b=ff6ED5ryAtkIwIN9xtXtfu5HZEuvrXXxXjVUI6tG50/suEUSMnvD4mS4ZqpM+o+68I
         6kYtUmyBXJaRCz4pbgRcpE8PUyqPa3ycqbv+2SUsn0kN58yilEw7SEDRUy056yrvazRw
         RagnAmf35pABOiOXPm8Lpd8Il+VZRMjws5fqRCOEPYaE9GGoAqLacHNwo665MP9Omm4S
         toOMUGbB8jMu0iel+JWDA1v12DiP6bzu/RqvlggShwwYKWOf4xSUf6e50Kj6oUVT7vt7
         /DgPv8/qt5f9hX8Q/zulPJquERlEBwIuRaHjnuXFXk33nMaL0qQmSYN2MLssp0T9ltT1
         Y4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728334412; x=1728939212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/P6Z8MoLBTNyNgoQYiG3xAVkdrjMw+AhtLOoflITm3g=;
        b=p1K0GoH656suzDeE46lBIEupDcvJrkcOM/RcFXTTQwQ32W7HZ9rFwtrbZDPu9kQcAb
         3g68/b7lo8oPSORJAVOJcejQTM1VqzYIt4fNpkbD3/ig45NcloB0TvKsfXMINU5LYtHZ
         hSRxI4Ys9yPMwEUBA0SMYr0W1NyLdZA3nGYAMPOTyXa0qeFSeflNT0fwCz3L69J5yF4N
         8w233kswjmhivw83o0j/PV3uV8exEGkGQ+I9vkLbpXQhZVcrsMfNvKA/V7vSLcVybzPn
         0YMQkspEoETM0aKUbXOyQEN+/USC/R28SmpRdx/SvloQkX8BjEwKeXcm6m3kWHt+3WJ6
         MtJA==
X-Forwarded-Encrypted: i=1; AJvYcCV9PJ+5+0QPZy9/MSFWRZDn7v76+P3xwWl2yUpSz4Qg+V9SFdEBeIguaDAVo2pGEXBS9nhkeBkzM1LI@vger.kernel.org, AJvYcCWEOMy43BeJump8t77XE6DFfJyqnZjkhi2d6ofnX+KdWVxfrOrPcghVKW5kpx9frTgQ7QsK8auq4YfSVLI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfvT1jcNKIiFWDzvDBShECsd+ddkwj/3ZrKqO+ao4MvVouRK3f
	vxaZFOkEjB1XU+FPDEnn3FcOmeirYMzLCz3O55xzJHQMOLAEPQLCF5Nb42E46IvKEttWKmGr141
	e9fpThgyD3ngvwonbc+t3lfq93Ig=
X-Google-Smtp-Source: AGHT+IHCaS4xyO3kI9QCcDlz7//R99ll7vpl/XU4EeFOdVQn6RVYcGzpJcByVFIvXaVe08/yEAllkhGFyD+XZcJfQ+8=
X-Received: by 2002:a05:690c:f91:b0:6e2:12e5:358b with SMTP id
 00721157ae682-6e2c6fdd3bemr94365737b3.4.1728334407146; Mon, 07 Oct 2024
 13:53:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240924223958.347475-1-kuntal.nayak@broadcom.com>
 <2024092725-chamber-compel-10b5@gregkh> <CAA4K+2aGYuRZW6prUi53vcEYhuCf4WvGEj384E-Ut-OJEm6wkA@mail.gmail.com>
In-Reply-To: <CAA4K+2aGYuRZW6prUi53vcEYhuCf4WvGEj384E-Ut-OJEm6wkA@mail.gmail.com>
From: Leah Rumancik <leah.rumancik@gmail.com>
Date: Mon, 7 Oct 2024 13:53:15 -0700
Message-ID: <CACzhbgR+EZ-zaRxwUZRLkQ_+9kxy_nttNyu9m9EKa12-XcOogA@mail.gmail.com>
Subject: Re: [PATCH v5.10] xfs: add bounds checking to xlog_recover_process_data
To: Kuntal Nayak <kuntal.nayak@broadcom.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ajay.kaher@broadcom.com, 
	alexey.makhalov@broadcom.com, vasavi.sirnapalli@broadcom.com, 
	lei lu <llfamsec@gmail.com>, Dave Chinner <dchinner@redhat.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, Chandan Babu R <chandanbabu@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuntal!

Thanks for proposing these patches. The current process for
backporting to xfs requires that patches are tested for any
regressions via xfstests. I believe Amir was last in charge of 5.10.y.
I think he is still on vacation, but even once he returns, I'm not
sure if he will be maintaining this branch any longer so it seems
5.10.y might be left unsupported when it comes to XFS. If you'd like
to take over for 5.10.y to keep backports flowing, we'd be happy to
have you join our efforts :)

- leah

On Mon, Oct 7, 2024 at 12:48=E2=80=AFPM Kuntal Nayak <kuntal.nayak@broadcom=
.com> wrote:
>
> Thank you, Greg, for getting back to me. Following is the order for patch=
es,
>
> 1. xfs: No need for inode number error injection in __xfs_dir3_data_check
> 2. xfs: don't walk off the end of a directory data block
> 3. xfs: add bounds checking to xlog_recover_process_data
>
>
> Hello xfs-team, could you kindly assist me in reviewing the 3 patches
> listed above for LTS v5.10?
>
> ------
> Sincerely,
> Kuntal
>
> On Fri, Sep 27, 2024 at 1:00=E2=80=AFAM Greg KH <gregkh@linuxfoundation.o=
rg> wrote:
> >
> > On Tue, Sep 24, 2024 at 03:39:56PM -0700, Kuntal Nayak wrote:
> > > From: lei lu <llfamsec@gmail.com>
> > >
> > > [ Upstream commit fb63435b7c7dc112b1ae1baea5486e0a6e27b196 ]
> >
> > Also, what is the ordering here?  Should I just guess?
