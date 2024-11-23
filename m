Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966DAEADC;
	Sat, 23 Nov 2024 18:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732387986; cv=none; b=VE0hF0PE73ut4vICPp9UOW/CzTamkyfhAX1MeJx2ZL1y7c6g7Ay+92ZgN0RZZgSd4cm02/hY//LJyfgSZSmAmaxXu1+C26XH2jYVuP6EuUw57l6TB+Vy/qaRHTEtRumJzr7OLFsMaAPB1a7qWdu+TY+PbJqU0liNL+tVx9iRGSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732387986; c=relaxed/simple;
	bh=N/kdCp8Cukl2JF1zdvwDE0yC1vDgRr5jd/C661u4hmo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KawXJ1yZgrWAIyMZfsY/gy5lfZcYmBn6IATl5JA5ZZgG/AR5G5beUX8soyBd5LuCWClX8tNQxvsSvVF2zQhJdmbcnEfr25/Be2VSgU4x/N+BaK7AWNhtZP0DM+WvwiX3320740OHyvLst/+uZjt3PQHVarPnZa68QDMJ2CKuD3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IRIREZZL; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IRIREZZL"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5cfcd99846fso4154250a12.1;
        Sat, 23 Nov 2024 10:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732387983; x=1732992783; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G+P8IuRNOPnYl68Wr1phF57tcI/VLlzApQAJOR/FrHk=;
        b=IRIREZZL9EWDvBvqtBqESz/knI0wBSLgK9mNwQRjxs2tzcaEZSyAzUXnQVC5kyXu3w
         8hoNeCTyd876vZzHO5rmQwzXgAd/C9fu0potU6zXjzDgvNQxIjcDvhOZ4NtBYekEakvO
         lpoStAK3i44x+Dzaw62kBp6Mrsbfgh4cnvJa+gEEu1F/67cBeMpUy3NTprcFxZZHRnKb
         DJZYMT7GUnLe9neRgobRzCA1qrav+yAx0UTslQ4Rex84E4gBQYR3kBtturUowiTjaqVT
         6XWw0R4LKBfrla52wV/WYwDPCDygYbtfT1GL3drKTnrZTKmF56jwt4Fx+eWHcMnPe8vX
         Cugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732387983; x=1732992783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G+P8IuRNOPnYl68Wr1phF57tcI/VLlzApQAJOR/FrHk=;
        b=eW+TW0ERmAuQKSQMmUkdygkILd5shtHUzW3tFVL9vU6e21fPjGAHY5jl1iomQ6Zsj0
         Whi+KnKmw+KD4jB7XXpAhbxAR8bUQcISFfpFx4h2BqqoWhN9VHzmbwCiUobIHFJj7Ma8
         mRfTGBvaoV0JTGXeoQ0+V+aJYt4d7YTtyOJAHYlp2KKqxyUTpc1v8KMJ6Tz0+7U77pV4
         7M2bbA6LshJCRcwB5gfUrljgsYa4T/m01Ik8FwB87/F2ydVKoesqaywLMVmDyi8mANd7
         Gdtg5H+KCNdctAWMD9VbghPZ7fMm53rZd6N5ESw8y3nDDahbgrWzPisXKSUTo9FlFSBV
         J+9A==
X-Forwarded-Encrypted: i=1; AJvYcCV6fFFqGtjGVk7Nw/s8315BNV7Y3C6HnRyf1EGUuZTgftXmobKyalC+BhCXS2XcZ/lq/HMTbME1WOSS@vger.kernel.org, AJvYcCVrKQU1bIelImErZz7hpVk5qmF+71wXtv9JF+zXqWq/RoaJBlgK39cFMg/uKgJyWbO6/iFfCUqaeQP3M9Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YycstgkCw0FUtCJJcTUvUSXrXpPiQp8hwrVq/eFAAWVUIOwMrfp
	mpYReINAAqo45VPZhZE4tqg0YU0eO4aBhTQtuIFhhD2mBF20fTFLZLtUjl4DXa4HgJ4Xc725Hsg
	RwnA58zKDggXOlD0Ohm3h6I0mAg/WDQ==
X-Gm-Gg: ASbGncuiIsqHmsAbmk5zZq0K+0rEPJiBtBGTOWO9hf/bDGTaK9fv5m4ro/74Uyfq/Gb
	oFUu7Ht8RCxngOHDqYB82eYr+DKUmJT0=
X-Google-Smtp-Source: AGHT+IFV/1j7SFZZrVDwqT9kxWcHOutCC0ZE5Vf5FSesY1wixS8qSP57oJOeNWwZ4gfC/GimnirqXvzTBk7G+EqLPXk=
X-Received: by 2002:a17:906:cc1:b0:aa5:2817:cd34 with SMTP id
 a640c23a62f3a-aa52817cff6mr413960166b.57.1732387982610; Sat, 23 Nov 2024
 10:53:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241123075105.1082661-1-mjguzik@gmail.com> <20241123161955.GO1926309@frogsfrogsfrogs>
In-Reply-To: <20241123161955.GO1926309@frogsfrogsfrogs>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sat, 23 Nov 2024 19:52:50 +0100
Message-ID: <CAGudoHEHSoFzadeNW3dhStCVy03G61X+Rd50SQKYt=aDRv6BYw@mail.gmail.com>
Subject: Re: [PATCH] xfs: use inode_set_cached_link()
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: dchinner@redhat.com, cem@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2024 at 5:19=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Sat, Nov 23, 2024 at 08:51:05AM +0100, Mateusz Guzik wrote:
> > For cases where caching is applicable this dodges inode locking, memory
> > allocation and memcpy + strlen.
> >
> > Throughput of readlink on Saphire Rappids (ops/s):
> > before:       3641273
> > after:        4009524 (+10%)
> >
> > Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> > ---
> >
> > First a minor note that in the stock case strlen is called on the buffe=
r
> > and I verified that i_disk_size is the value which is computed.
> >
> > The important note is that I'm assuming the pointed to area is stable
> > for the duration of the inode's lifetime -- that is if the read off
> > symlink is fine *or* it was just created and is eligible caching, it
> > wont get invalidated as long as the inode is in memory. If this does no=
t
> > hold then this submission is wrong and it would be nice(tm) to remedy
> > it.
>
> It is not stable for the lifetime of the inode.  See commit
> 7b7820b83f2300 ("xfs: don't expose internal symlink metadata buffers to
> the vfs").  With parent pointers' ability to expand the symlink xattr
> fork area sufficiently to bump the symlink target into a remote block
> and online repair's ability to mess with the inode, direct vfs access of
> if_data has only become more difficult.
>

That's a bummer.

Thanks for the review.
--=20
Mateusz Guzik <mjguzik gmail.com>
