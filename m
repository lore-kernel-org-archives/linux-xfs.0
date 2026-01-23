Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330FC23E350
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 18:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192689; cv=pass; b=kYWRejJ4HSbBO+aUunCd0CeXMH1+CqQhdXtBcUcQrlWsNNGh6MCHslqxfgYF63YyWuJkKrFcpJxBf5dX7IUPhFcVcehUlwzv4RlX/rdkPXu10etIXKKQVHv/38nouEq6FbdfeaH4LLbyqToqVkPv+pzb2w80vPpTDA5nmjLJisU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192689; c=relaxed/simple;
	bh=ISxbKohTgkQkJLGb46Dr9mlK6gEmzyea73J5Js/irTg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h/2ojTmcnovZhPjrIIi7qaEKhTIpikOvvSP34PnU4TsI1J55Xxz1jG/cuecKF/0NWphFT4zL5Kee4FCraaRvAlyWjktWhMxcSVtZlfpcF0d7eMl4kMz315OMjj6pW+PPu1hqLhv2e352dNKOsWFbB1WIuTfowGeXa2Sy5e+Us+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hPJJtKDy; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hPJJtKDy"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b8838339fc6so449505166b.0
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 10:24:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769192686; cv=none;
        d=google.com; s=arc-20240605;
        b=YAcR+CX4xZ32BCY0o5i9ckJ/6qAsbs4Yxzff1xdCU6nYaxqoFkeFEQ91v47hxoKKmn
         tIqudF0ShmNh2Ng6RapnYIg+uYM5dWNI5AhC/OIrLyt/rpz2WEGSuVYRAEx5FiN+oZ9e
         7aFWg9hT5NfSG8Q4goN/vP0rhyEG1wybIGZ/Ny+TBvta0yOyV8/QDxDkPTqF6O/yoGhh
         clsumbXnSos2fnB2QXIWgs4AlAkyycZwhCtMr6xtE66CoQzSCbDmSWiPpJ8nMLzItBGx
         qfLIffwi6VmKv1ysM6KhA8uZiE21MPvdCN2nwUmTI+VLobmTa34X2YBGwaKH/+0jL9T/
         D0bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5cVJF4hn7iik9B/ULbOnGHj/zoVgYkKufI/4cDYwvTM=;
        fh=xmTAR+VjCVhw+Pzg3i84TQJnuA6o+DNkh+jZ5TRkbYg=;
        b=lKAXN/RDteGKYMx6mVWpQg5tibW8d6nas511PzF8cLZwiDcQOg8D1d2Y5mCA620yPQ
         vrRzKP3dQ7+kySVv9Fu8CQLipfZzFFm6I+dDGTR9YHbeUp7Qk8Y4blyqQiBoVSQJKY7j
         y8Gnzt/quQaQzYDpmbQo8HPspagdnPEBnsztU+lzS9ie+pctlPChB2ZQSOGYBVgww2Wg
         rnBJ4PwWlF6Zh9FURUDPph/p3xJi5IZm32FSPIjNyhYvNSV8fcXZ0qwQnyMA5ZdqFEvU
         tCH13sCi8yOBJ+Rddjqi0jlOLkeMs3BUm7tsmJX8BE6H0JgemplRzqKnrUxQlJWCxJq1
         fnAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769192686; x=1769797486; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cVJF4hn7iik9B/ULbOnGHj/zoVgYkKufI/4cDYwvTM=;
        b=hPJJtKDytPV6QLZ1HGEvgh84Szjf32pCdrMq/znLTVweXyZVHZgv6sQrwkAT90+5Cv
         cBGt7qP9n3KTdtJQfQU+I/NFeMv91QImHI20YR/aO9LmHyX4cyIiprtt22ZePVQcnI8m
         3z0Yb/Is5Z4bZ8JTJWbH+FI2NcSbE/q9r9Dq8ZxYGC2TUfp4mILGg+nI9CcETCJry5iV
         gsv9BrUxtGki53bWt6RCceNPv/9Rbs3w6a7hrkim8o/EDPD/RrVl1K0sAbZWzDzhvPap
         +NQyKskhp2htrvyKcLG/wib4X+hDetKg52ANbNAd/q1aatjxNUGnBig/TDANmgvHKmEM
         /ipQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769192686; x=1769797486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5cVJF4hn7iik9B/ULbOnGHj/zoVgYkKufI/4cDYwvTM=;
        b=cpHGfXzuRxNOAC4KqtJXDtvzunfV4rriU+IJgXxCnsyEU2pfSRCK7V1CvIZCCSDsUI
         m5emo8+dfAqG3EeWISHrRs5otL0nTDBbGaU6yKReVajTlDJeiZgdP9VT6PyH/qtVz+To
         zQlUI+avFgIHq6YF5kZzRsDsmPWmmGNCgovpZ/z8mCpMRGxZhgVxBD34jXG/NN5mEV/9
         wfUR/RL8UNE8LkKhv9mWjn/pUqBTH2xSZa7YRa0o9e4Vkp4QmSOZb6fwxbDsrToqeEXh
         NMIv4jv4eeH3VvULl7+CwDdub6u+Pv8XySBaSMbpXb2U0zuVB7ob+XAaxOItW6Z597Xh
         Cc3A==
X-Forwarded-Encrypted: i=1; AJvYcCXTt9sNr7NPszog1AMMbuz15h5KmmZgtYl6Yy50khT9704MliV0FmU9LsIJjwFdkT+hArZIDMhG2uo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA6uGa86ypL6G9JKfq8EAHHScmEI7WQYm3gDFjZRJdwH7Y3kLA
	H4cfMJ1Gktac7Ezg/ndWs7efvCe6perTM5b8wAWMSR3eoMrqnw9h2pan9PWdl6rNVVMUz4XSg7C
	mssAYncNjNRz/UQs3rCu6vdkbwov0m2g=
X-Gm-Gg: AZuq6aLcEcpaY9huPnkPuXwPW6l3/XkOJP3gQCJZ3q78YE65ktwUyvs9PKzX5XJVxCe
	Bc1FERQoph52NGCYRzLoucHkNAhmuQ1+S4gAlb9rk4TzpjLwVM2qpEhgh/BLa8o3tZ92Wfi07aM
	ynAmgQPjZnM+a/gog95L3d7nhXMimz2NhG9MniFL+TO3Har19MUvzKI3JdKQTlgTZ47ER/KzBRd
	xSuaadcFVEGyXy+xHaMf0wTkKNXY32OVIn0GkDVF74o8jJgR+PRvCdbFT/yFRcnrMSLABOf68p4
	GTfQ/cuGP/NrxCUlsvoC2c/PXM8+2Q==
X-Received: by 2002:a17:907:60d1:b0:b80:456d:bd99 with SMTP id
 a640c23a62f3a-b885a3b601emr295926766b.19.1769192684867; Fri, 23 Jan 2026
 10:24:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs> <176915153761.1677852.10364914654449283291.stgit@frogsfrogsfrogs>
In-Reply-To: <176915153761.1677852.10364914654449283291.stgit@frogsfrogsfrogs>
From: Jiaming Zhang <r772577952@gmail.com>
Date: Sat, 24 Jan 2026 02:24:08 +0800
X-Gm-Features: AZwV_Qhc7HQIx8Jldfe4gIdkQ3j2HOjmrFi9KHHJ6KCvEFTKTji6ltCzHRYXhV8
Message-ID: <CANypQFbhbXeM=WXqcSvR4n2=LY7a_6+HuTL8X2Vs5yK3sy17kw@mail.gmail.com>
Subject: Re: [PATCH 3/5] xfs: check return value of xchk_scrub_create_subord
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Darrick J. Wong <djwong@kernel.org> =E4=BA=8E2026=E5=B9=B41=E6=9C=8823=E6=
=97=A5=E5=91=A8=E4=BA=94 15:03=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Fix this function to return NULL instead of a mangled ENOMEM, then fix
> the callers to actually check for a null pointer and return ENOMEM.
> Most of the corrections here are for code merged between 6.2 and 6.10.
>
> Cc: r772577952@gmail.com
> Cc: <stable@vger.kernel.org> # v6.12
> Fixes: 1a5f6e08d4e379 ("xfs: create subordinate scrub contexts for xchk_m=
etadata_inode_subtype")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/common.c |    3 +++
>  fs/xfs/scrub/repair.c |    3 +++
>  fs/xfs/scrub/scrub.c  |    2 +-
>  3 files changed, 7 insertions(+), 1 deletion(-)
>
>
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 5f9be4151d722e..ebabf3b620a2cf 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -1399,6 +1399,9 @@ xchk_metadata_inode_subtype(
>         int                     error;
>
>         sub =3D xchk_scrub_create_subord(sc, scrub_type);
> +       if (!sub)
> +               return -ENOMEM;
> +
>         error =3D sub->sc.ops->scrub(&sub->sc);
>         xchk_scrub_free_subord(sub);
>         return error;
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index efd5a7ccdf624a..4d45d39e67f11e 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -1136,6 +1136,9 @@ xrep_metadata_inode_subtype(
>          * setup/teardown routines.
>          */
>         sub =3D xchk_scrub_create_subord(sc, scrub_type);
> +       if (!sub)
> +               return -ENOMEM;
> +
>         error =3D sub->sc.ops->scrub(&sub->sc);
>         if (error)
>                 goto out;
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 3c3b0d25006ff4..c312f0a672e65f 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -634,7 +634,7 @@ xchk_scrub_create_subord(
>
>         sub =3D kzalloc(sizeof(*sub), XCHK_GFP_FLAGS);
>         if (!sub)
> -               return ERR_PTR(-ENOMEM);
> +               return NULL;
>
>         sub->old_smtype =3D sc->sm->sm_type;
>         sub->old_smflags =3D sc->sm->sm_flags;
>

After applying patches and running the reproducer for ~10 minutes, no
issues were triggered.

Tested-by: Jiaming Zhang <r772577952@gmail.com>
