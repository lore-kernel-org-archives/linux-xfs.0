Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E7B9443
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 02:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774838428; cv=pass; b=SoXspRooK+SE/yORQLt+GRCVwldxNi1HI5huneiJkw80RomFeJowAP2bgsf9a7YSxZ3A3lZOe9H6yPL9HZFVNHR65ttvk+l/77s3WPKhYqDf+jq6QhH3ObUWudt85ZTj0jiHbascjDeQhEGPjwbLXl8BJaq0vCQqGnKe3BKn+3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774838428; c=relaxed/simple;
	bh=SzTDA9I/K/GkhCvZvzroi0PXC7Wi4U9poSRwY/I4MYA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iC7gFMO+1fGPuovL7k+uGciB4rEBAaTH87f0cnmRLs9mUcjj3ZfBsuTZS93CHadvmz1Y8Q1dYkHb5ZRRTCeQ8q9SuF7Kpz4gaxHLSWyO6O/JlZdUXxu1eB3AKUNUtb7cz2dm6GGIR14N8gbAnW2KToUTNQKIA6robFlacVMme5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cR2PnCXk; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cR2PnCXk"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-66abe08cdf5so6084863a12.0
        for <linux-xfs@vger.kernel.org>; Sun, 29 Mar 2026 19:40:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774838425; cv=none;
        d=google.com; s=arc-20240605;
        b=FHmwopXupYKQadd+BtA2GKPnsy1WPR7cdVrMVHEEuGUY1O7rJTh+feMal6EWg9lwoS
         qwDk1bdWYsS+icIlLxqQu98DrIfGIVL1MMLe/6Lr+OBkIPGAbdT2JVHtM3D1MJu8MFyl
         4H3ivYHM5ebaa5BgSpvg+hdN+myx831W46k5A40GmNsGEj8SC2EC4LU+OwkhKXtYVq6a
         1/fzjoIAjXvl4P7rdcdmQcyI++xBTdei0Bbrtnobj/Lwt0peicDk+ea9LLAg0eqL64fb
         1De2araxL20DV8+9OLAtwIV0pZh5lra9YLGpV1VMksUqG3+0J5UQiB/gYX6vNwl5z28j
         Ib3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SzTDA9I/K/GkhCvZvzroi0PXC7Wi4U9poSRwY/I4MYA=;
        fh=cUWcsPmT9qf84cb6yPVlmgkQJuEkyzy9dRRhGEpXhN0=;
        b=LDY8IGJD54q4FS4Ce6ucUAJw0j3P/rrkHC9Z6GU89SpIobEu/WCmW4e6J3s0td4kSl
         VqFnPRjGiQr5tPHT+E98SMQyH1UG/tz5ZuKAOw0zV2Owq9Tn5nym9oEJtl3edevIdP0y
         VHpo/HfTAUlRLiCh75Bu/YuM6DehkenNrK3O92o6X2L9zV0nR1IfxsFXkl+DhbTRmxLa
         +QZbXMCBk1VNI/f7evUkS64G1NQLisWxKSwOKILEel8krqUco9jM4dFBxdfzrAGh7Jjt
         SLYjwDhQpPn5Hz2rPlfNbDd81vvAnH1HSubyZdD/Bq7XWMNPiWW2CmwWtsbZiJq/Jx3O
         Nyyw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774838425; x=1775443225; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SzTDA9I/K/GkhCvZvzroi0PXC7Wi4U9poSRwY/I4MYA=;
        b=cR2PnCXk4UajrlBTmZLD/Ty5Xyjf5nLeB7XZgEAuOiTL+iGjwD7/etDVwlpMZ9rfIM
         0olptKNXIKRdNNa/itnVgl9lEvR+C4jZlYz4tKvuBXaIEHPlcTNH9rHDdpwtS+CR4Qtz
         7QDKXI3EzL3JZVqAhHWjzHr0TdqXVHj4muKhJI41jLiQfEJYCvVvemVueK6hjBX+qX+W
         QfO4nz0dPJdIi2AJ1ZIOh3WGn7HUbOQXOUtSZAtDUWNM/5T65ni3VnMiIyCSDVQmRuG4
         0xAgNaFnxUHSFTMUO37BQTyQD5vlkKq+4UtwRrtfUANc5Joe9Fu644BABvn3VTdmROa+
         1meg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774838425; x=1775443225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SzTDA9I/K/GkhCvZvzroi0PXC7Wi4U9poSRwY/I4MYA=;
        b=dqLV2jclWd29h8wH2ZuYGBP8EKzg1+mHiNQCkN9emZm45tW6rFPUsh9QrPPFshTDt1
         4CQoFe6ttZBRefn69j6f059mxmDkqmrFSiqO6YfG6/KiWqkld/tPdjZNnuooJXfTkgSG
         Rg0hgpS0UPGJ8TkNZK2zp0i0VAzya2+5yasHQm95kqM2J1R+C1dUU4tePNvuY8G0VJfc
         LxejzTwS98+RhnvqXMyGnQ0x1pu8pVWkbg3FWGKqKcLkivnG8K61jaBgALzQbbo4StNj
         dugCNL03szPHqyoPamvtmwt6EtMU0/beeAiFpupLEt1uhRGY2uzzvQxK2vbZt4LSffJF
         LXng==
X-Forwarded-Encrypted: i=1; AJvYcCUTEc1H/rkf9mbbAB60M7d2vyAqjvcPzZkTDEULpj3P3pqW66aztZP0CQbCE2hZsuAN7S9EmjaLz+Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5x6FxgwFzwx+s0LLzc33GcAhaVi4kYZQb62q/eT4TOQnNtaVj
	7TPVMPc1i5sp+MmYQPK37Q1hnIrCMH8hT8E7a6fIEgydm3m681D3w30JBSDNHVMNjXCSMFFtGmZ
	br44SNJYtDBHzv89QAs+pTnSy+hTuA6E=
X-Gm-Gg: ATEYQzwAyvGlZPAbWV/gp9knfjv6VJv+qCXQM/BZgYmmXzu1AvHN/ZREQ+ptPxhvC/2
	7JKbznvTVbiJGg8UrsCja+nQQ9WWSy2yUUi5SxUdDzobji1rFIEZqmgM1GTsRPc/XiCM/lu1qT/
	F/bnE6Hj/yTaLwYXffoWt3m6plWWgE6ZodiVG26By7N220u0Uzv1XSzvVL9klRGnZsBm/fRIGzT
	R906msPljWxmx/P6PSI4P3xAW9FyqRfwOMleHgicUZgqJj64U2z6mFfhaA0Kgv33+U0W2h4IMmT
	fMafjlKo1rInhev6YuUFX7XLaxYXD1rTfcHenhu3xzYym5lPwsP01ck=
X-Received: by 2002:a17:907:1b1f:b0:b93:5e04:a74b with SMTP id
 a640c23a62f3a-b9b507a56e2mr632415266b.31.1774838424618; Sun, 29 Mar 2026
 19:40:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260328071252.3936506-1-gality369@gmail.com> <acnUybgMAsBA9IEc@dread>
In-Reply-To: <acnUybgMAsBA9IEc@dread>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Mon, 30 Mar 2026 10:40:13 +0800
X-Gm-Features: AQROBzBOO541Q4lXr0qA9kzP7jbtfC29vT7kQKSbgedCDhi-XHPASMGlHuQFd_8
Message-ID: <CAOmEq9Vx_sJf1PbD_SFdRyKb+u+kRR8_BPJ_+Ms4tdD895-cVg@mail.gmail.com>
Subject: Re: [PATCH] xfs: avoid inodegc worker flush deadlock
To: Dave Chinner <dgc@kernel.org>
Cc: cem@kernel.org, dchinner@redhat.com, djwong@kernel.org, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 30, 2026 at 9:41=E2=80=AFAM Dave Chinner <dgc@kernel.org> wrote=
:
> How did the filesystem get to ENOSPC when freeing an inode?
> That should not happen, so can you please describe what the system
> was doing to trip over this issue?
>
> i.e. the problem that needs to be understood and fixed here is
> "freeing an inode should never see ENOSPC", not "inodegc should not
> recurse"...

Thanks for the reply.

This issue was found by our fuzzing tool, and we are still working on
a reliable reproducer.

From the logs we have so far, it appears that the filesystem may
already be falling back to m_finobt_nores during mount, before the
later inodegc/ifree path is reached. In particular, we observe
repeated per-AG reservation failures during mount, followed by:

ENOSPC reserving per-AG metadata pool, log recovery may fail.

Based on the current code, my understanding is that when
xfs_fs_reserve_ag_blocks fails, XFS can continue mounting in the
degraded m_finobt_nores mode. In this state, xfs_inactive_ifree may
later take the explicit reservation path, which seems like a plausible
way for ifree to encounter ENOSPC.
