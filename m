Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B0B1AA1EC
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 14:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744815023; cv=none; b=X3vvykCb9Hd6picpnwpNGTi1L0asNg9vcaxW49pU0Rb5YUaBZHfgyylR1k1VBDLADw8QP18fcj9+EwEjYi6Yj3qrpBuikw2jia5s6BfzlFKp8b7PrNq4kMWx8zRyJr5ogoFBCPAowWk85I4akn2sQCfjH1coHAClwRNlX+JbR9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744815023; c=relaxed/simple;
	bh=msdXUkkGJyrqGsq+eFaHmsguIQuGLRdsOU8emiomoLg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JjwI1HdSinNBvP25xp+IxLYYInf2BvLxGKzHgkofP7WNDKvlLcIY38CPypOs8mohV6aaJEzqBqQuI6yKxnawzKcEpYExtXITa/3R/cdQUBhALYL1GPhzSzKF54gErMNxQyviCY9I3Oo9RCjkdONYsRu+RXBobZUlLssyIKcJZLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chainguard.dev; spf=pass smtp.mailfrom=chainguard.dev; dkim=pass (2048-bit key) header.d=chainguard.dev header.i=@chainguard.dev header.b=Q+nluY7a; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chainguard.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chainguard.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chainguard.dev header.i=@chainguard.dev header.b="Q+nluY7a"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-525b44ec88aso3104345e0c.3
        for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 07:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chainguard.dev; s=google; t=1744815020; x=1745419820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACFsfXXb9kwJXNCgs0M9rIwuCTlE6oVSOYIhp0WeyXo=;
        b=Q+nluY7aUO+Q+uTQzGXAYSIin0DYzW1LaDOozoHgKcL1AgGE/23wQ52uCRJ30P1t6d
         2CHvQ90V1qF8pQWcdsBCFV4wXJ0aBehSt2fB4wY7YAX5aWpKz/M91gEziIZE6dgw3Kcz
         2oPvj061fxgJHugvESOZ4g6KiZwLy9pFyW/Prb6Y9SUEJ3uql0KMSxLjbwEkS6g9QNQc
         67Tz37x7mQlNrn+GZAGu0wofeA7vJoeImW6wF7G2CFFHSsojTugsOcFmGRGkIgvJGMnJ
         VwJH/NyOb0IKWS0z5lijXC2kbFQcQpXd4Xt7LR+1tXH4Ewr5j0Ht4m/TSYMAnRBwQeua
         gSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744815020; x=1745419820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ACFsfXXb9kwJXNCgs0M9rIwuCTlE6oVSOYIhp0WeyXo=;
        b=PYoTJFF0fuS82Gv56luR5+yrE5Edw+gCpo7d8+F9wN+rbXQRh/L+MtX9gVE/48ASqa
         UJgyiFdsehGnU6x4tdvprtwMuyF4024BK4As9BM+eVIEsjL8ndkI32MSz98Qsp4XC2ir
         8VmHTJbT2qRGe1VtjRWx/zTIkvgXlLyF4kqsSjEfNUzK+MY9xDNuhX3QmcdN/DmE4jNF
         EYnMmasAyHHGVnIlVUniT/yJ2MU2smEeaZO6UBbsU41ghtZnAY3fozoAZ7kaQRxGhaGF
         VjRubCtZDiDl16WhK2bnbKeOLyGlJzhp1Tp+iAq5hrC5EHFedH2V4deXoMvt/gz1hmqZ
         Nkpw==
X-Forwarded-Encrypted: i=1; AJvYcCWlF5FPl+hI0RaqBfDCgIyAb4Qdwv/SE7mIcgSb3Ula9TVhhx9f5YTmvh6cubZwMSGKI0Ih7rPRc/M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCwhqedFh21oqpJSKBHEgp6UqE8USZSZLaiZyooJP/XruV4rfd
	4EyvKgUHw3xWK9EU+5MMbMAVyRy2NZ3sig+UdTICI7uMCUClRgUhDl0V4Z/YnzJR3NcrTlh6Ehd
	VUxtTyf0UJvRYU2zFFwjkxkecqjMRNqmpxfmDlg==
X-Gm-Gg: ASbGnct/3v8NoWB3b2sKFza3UORfnHDzgJIezeZ1VfKHrPhvVNctr+dW3t7focWiQFH
	ZcdNnvgwdVBabM7Dzrv06AdjXjiKfODHK28SwWoFnn9Vhagk3rnEhoe0JFzb4BHLS70LY8lFFmH
	q561mJF8DU2pwo8dVBm5Mriwz6ImyxTZo3+MoGWhuK47i7esI+4uOGxGw=
X-Google-Smtp-Source: AGHT+IEyMmX46DjWF2PKJ/X84SHC42Po2/xqtO4tQ8dJ2nMI0KRh7nqFO33O/p3OP7xzpU72BJD3aLJeBmsKfvZgqgw=
X-Received: by 2002:a05:6102:299b:b0:4c3:6393:83f4 with SMTP id
 ada2fe7eead31-4cb591bbdcbmr1133400137.2.1744815020110; Wed, 16 Apr 2025
 07:50:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKBQhKVi6FWNWJH2PWUA4Ue=aSrvVcR_r2aJOUh45Nd0YdnxVA@mail.gmail.com>
 <Z_yffXTi0iU6S_st@infradead.org> <CAKBQhKWr_pxBT+jXpaitY3gz6wd1WLqyU4JwQoaRhzKWye8UgQ@mail.gmail.com>
 <Z_9Bas9rRB4cMibh@infradead.org> <20250416055516.GE25675@frogsfrogsfrogs>
In-Reply-To: <20250416055516.GE25675@frogsfrogsfrogs>
From: Luca DiMaio <luca.dimaio@chainguard.dev>
Date: Wed, 16 Apr 2025 16:50:07 +0200
X-Gm-Features: ATxdqUGzDRTqcA2aSDNtr0AJLeZT4GapU7cYsiuxnKDsA6vOUvzf0FLIdlBh-RU
Message-ID: <CAKBQhKW-MhGBLfnMmtz-MXXx1ZsNY0Ro1iHAhut99iXm6ngf4A@mail.gmail.com>
Subject: Re: Reproducible XFS Filesystems Builds for VMs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Scott Moser <smoser@chainguard.dev>, Dimitri Ledkov <dimitri.ledkov@chainguard.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2025 at 7:55=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
> xattrs mostly work as of mkfs.xfs in 6.13.  If you have more than 64k
> worth of attr names (aka enough to break listxattr) then there will be
> problems.
>
> --D

Thanks Darrick, I saw that this was recently fixed
I've sent a patch to fix a little bug in the python generator here:
https://lore.kernel.org/linux-xfs/20250416123508.900340-1-luca.dimaio1@gmai=
l.com/T/#t

Together with this, I've prepared an RFC to carry over timestamps when
we create XFS filesystems
this will greatly improve the ability to create reproducible XFS disks:
https://lore.kernel.org/linux-xfs/20250416123508.900340-1-luca.dimaio1@gmai=
l.com/T/#t

Eager to know everyone's thoughts on this
L.
