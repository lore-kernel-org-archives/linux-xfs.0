Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F6378F2E
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 09:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773308731; cv=none; b=hUl8fb384jfJQig+CgrvvFGUyYDnDsSVQooh4ZFoK9O14ytOXOUkbu4dunHdBqobL8cV646qOYeODmgmlG5PaXcpvvwFZP5xv8FkS6h+xpQgSaH261Ou5xi6naaWt5OATU04FPigtpZ23EMh0l27wvwJCRPnXCMbc/TjeCLbHzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773308731; c=relaxed/simple;
	bh=0ZRANUN7UlCukwYQM29Md9MnE0nYb2RsCEQmYpZxDpE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=LtCaIrzqrFLYyytU3oYa6bD0zXSG3K9Q0d6BTtC5EG4KFrTemL/zF+V6qzHX4zGeq7Md9TeqpOZPW/+rmNrybAVYr92WPs0kwQsCaYKUlVryr9OoySKzT4f/rRXmn2JLpn00+6txjK3VZi0QHiu96r9QH4w60wv0c/q/8jD8fX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b=nCpB1pfZ; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b="nCpB1pfZ"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2adbfab4501so4303135ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 02:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20230601.gappssmtp.com; s=20230601; t=1773308730; x=1773913530; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3x0eeu7MjizOqKGGJm4T2xmjny18E14L15w/38jmSwg=;
        b=nCpB1pfZElk8JOvn9zteby2BBnel8E9UT1BeI0QqqExRlKKRt/+MaPYSQd5DbVTm1b
         5X3XMQcxh4vts+7qvf8R2CufaVkGr4ZhiObAZEz4bwFHgefMiu8P/8qFRP9tX6SZczi6
         T5tU+xQ5MW+G+2LPl47ubqkb9dF86RiMKZGlYU0NwaXWXG3Y5PJHP4Fe7u0/s1tiOTaJ
         4Aj9U2qunFnV1SZVJpJpUQUcBtapFS0y7o2JY0CRmACdLkiwD+1tpzLR0g9zEdvONJiQ
         ucvzilDnh3Zxw/OGBGK6aDpwiNz2WSAao5+FVvK2kvHy2HrISg33fbcKPexAB1F7D3a4
         6Xrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773308730; x=1773913530;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3x0eeu7MjizOqKGGJm4T2xmjny18E14L15w/38jmSwg=;
        b=Vd+lzhLAd3HDqG1+fh9Yk/W8aiSVwzSoSeeixDGLIxaJVXPfnKUluSMA7AoCV17OWw
         hvK5Zxdg00OLoUaT4J5K2qziQ7+qHF8qePxgUDusBX7WIMDwyg5vQMZHfiJWbx/pEQJK
         7EQkkFo/nAQ/hwwKc7+SChrcakYZ/bAQGc8s/GuFqEkjsa2akm/lkFdSXEc+iFoEGiyz
         bOyFzJ4Le2b8E7gpKBKtNZNWJOAB+ywfO5jAy5BsMWD8M8F8a/JKJvNoHNawgqEdlWJl
         nWMO95rNPE7UuFo6MoI7EOTzMFOn47zZWMA7gaoO3pcRuquryoGUURaXbbJrTiUhB2qh
         PDkw==
X-Gm-Message-State: AOJu0YyVHbBNW/xfFDkp0Zt7CCqDecAYcHjvF2CYpiLayVnvwT7kF5N1
	TBpWb+M0N9dvw9Thv/SPhVG4kOBuSiJAdccjcqg9XzL7+OKDbPw0ndiAVKYVOhswy3o=
X-Gm-Gg: ATEYQzwYWDngPpRLbUFQCmyzGzzt7Du+FvdHYJ8FW1LIRcR/dX2R9uZQ6p+WDVMD4FC
	f7T1EiLrVMfYgfHdPcklQ27xVRZUSHPlGpxT8O2mwRCP33q4LU/z0krCKeI61DXzj2rNYV3Fo0R
	ZyLkd404L1u+++yNkNRv4u05fsoi2RKaZo+f29TyPZm8OondAQ/aUyMfsVP4sl25Q40h1wuHfnh
	a2ICW4IB19tn0EgeJDSW2bIDZxUiTe1PErLA1ppcIvKGUr/mRqWktJzyYpidYqH3RZcVWBVMo8x
	D5ICwiuQqnLCpxO/A5crN0NMXqxrYK3pPHqtQW79q3rGS//G26RbtCAMWTWtJLJsMYVTr6MmS1o
	UKkKjEXEBxn5cesmfXbgSMMVM2bb5XIzEOHMcWHEvIaYLQGtfSs07K4okNoah/abtlhn82/hQaD
	N8/ryv2JgwSfjv9a+bjE9xTNWI/SFAzn0OXhoREM14UD1V7gFuA+yATdWWBNRSEAVzNYp+YkIk9
	VAVEQ==
X-Received: by 2002:a17:902:f550:b0:2ae:3e4a:3cb8 with SMTP id d9443c01a7336-2aeae95301bmr56859165ad.53.1773308729647;
        Thu, 12 Mar 2026 02:45:29 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae258e26sm49293315ad.37.2026.03.12.02.45.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Mar 2026 02:45:29 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [RFC PATCH] quota: allow unprivileged users to query ID 0 default
 limits
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260312090810.1145908-1-ravising@redhat.com>
Date: Thu, 12 Mar 2026 03:45:17 -0600
Cc: linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 jack@suse.com,
 cem@kernel.org,
 dgc@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F061AB76-E500-4F78-A6E3-E71A32B04077@dilger.ca>
References: <20260312090810.1145908-1-ravising@redhat.com>
To: Ravi Singh <ravising@redhat.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Mar 12, 2026, at 03:08, Ravi Singh <ravising@redhat.com> wrote:
>=20
> Default quota limits are stored on the ID 0 dquot record and are
> applied by the kernel to all users who have no explicit limits set.
> However, check_quotactl_permission() only allows unprivileged users to
> query their own user or group quota via Q_GETQUOTA/Q_XGETQUOTA.  This
> means unprivileged users cannot discover what default limits apply to
> them.
>=20
> Allow any user to query ID 0's quota via Q_GETQUOTA/Q_XGETQUOTA.
> Note that this does expose ID 0's usage counters and timers in
> addition to the default limits. This enables userspace tools like
> xfs_quota to fetch default limits and display them to unprivileged
> users.

Showing the root user's quota usage may be confusing for the regular
user.  It seems better to filter out the quota usage in this case and
only expose the limits?

Alternately, should users without an explicit quota limit have the
default limits merged into their returned values, rather than them
needing to query id=3D0 separately for the limits?

Cheers, Andreas
>=20
> This change does not affect Q_XGETNEXTQUOTA, Q_SETQLIM, or any other
> quota command -- those still require CAP_SYS_ADMIN.
>=20
> Signed-off-by: Ravi Singh <ravising@redhat.com>
> ---
> fs/quota/quota.c | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 33bacd707..8b21f3c1b 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -42,6 +42,9 @@ static int check_quotactl_permission(struct =
super_block *sb, int type, int cmd,
> if ((type =3D=3D USRQUOTA && uid_eq(current_euid(), =
make_kuid(current_user_ns(), id))) ||
>    (type =3D=3D GRPQUOTA && in_egroup_p(make_kgid(current_user_ns(), =
id))))
> break;
> + /* Allow unprivileged read of ID 0 (default quota limits) */
> + if (id =3D=3D 0)
> + break;
> fallthrough;
> default:
> if (!capable(CAP_SYS_ADMIN))
> --=20
> 2.49.0
>=20
>=20

