Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0AA3EBF19
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 18:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192735; cv=pass; b=PBCngRJ8E0KNGK/E0MxS7WTjOJxrP1Bq0G61lAmTivKJQfSdX1dkbJv/3at33lFOqw1sJ/J3JWpknxo0bklcAzredY8V4TEOoFol/4aBkzdOKLyAF7aQdr0eU/HDYo5YTAMA6bBOX0xOfrt60Z3etZklNnj1E9gDgTH/FW/HGyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192735; c=relaxed/simple;
	bh=LLlr6qFPhQrpLskHiNTpWVP7M5Yl+G9ssNDzD/bnoX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GLiR/PiXSnHbjGshsqCxWaqsOegBFS21EWF33CCfrmsI/ZZguecnKFT1gCJ7wKMrXTE4ntLe/eueWOzBJFpHuS951Sj3DA3rId6z2twwdukfL+ZFULV34/EdTEsQAXgcbjwzZehLB6/gkj0SDYHvBXOLBE+JviZP8c7vWWFOITU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TfSaWHo2; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TfSaWHo2"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b872f1c31f1so350387266b.0
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 10:25:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769192732; cv=none;
        d=google.com; s=arc-20240605;
        b=GRn3+d/h6TQLuZG1axFr3RrbtOcXTBHGn1g2kgxHeLgBEJ430+P9Y8u0giclC3ZoGP
         rv5kilLHS64uwUIu5yYI5LZLW8CFsBMxac4+bLzD024DBRwnOoIZybrvDiwanIu7D8Xv
         llZSHMau6AXAWVfZ5JNZwlaEvBbBvyS94Dj1AkcKE7CGUMlfiHNse5h5Ah20Wr+9F+dh
         wOIGTjRHEO9fai/VMZiij9C4/VwMmugDIx9Z5ErdGKPaoPsSB2NBDbTBKj88mcVztfJs
         +36yrp5HZnWBE7blTVqdUmsPLE/t+Iwm6HHZ2erVqxkbChfbjz2ZbggC4Bbiw2Snn1lR
         8rZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=U46WO/6V9JCyZE4jICWmEWW2GU9FvLsO66woYhkM8CQ=;
        fh=7qrMq2euYSj10U8tEs8348oKZvP46WeCA7tGYEzsUB4=;
        b=GXB/C82Zci6fX6RjpOrsnxdvPa76Th9Bw0sq1DPGSDM6waMBoWdtcFIN2J9+Azz9T4
         C9S7Msou49eaTAcnTdsW342f/qJM0jz0cqFEVM/b7pg+TRcXPhc7OHrCKd25GdSYTyRr
         OAYh/nzeC264Oi5SglOsO+Ulr/SVU+oKk/gmL1EJoARFblscRs2BT0FXBVQsIfIbsEgg
         g3UuaJO+ESQ9poXkdSgPGfBUjUwQmDgmae8EyvtpnZRepWfJrPeEkDh0Wq/hHTfOUszv
         RTf6Hjpqu2sq+mPJo+NsEI2FfIh88V5ykcHepDBN5H6Hn4JaI3PKIS8xwYZODM9DNelV
         tufw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769192732; x=1769797532; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U46WO/6V9JCyZE4jICWmEWW2GU9FvLsO66woYhkM8CQ=;
        b=TfSaWHo2OH+VcCe2IYxm87sLGWS3/T49+l445pVclWfSQjW1n1Fuj49TVQk2coRcIg
         5OEgLXo0vRBFOkS3wG57oMlD55IkKiPlPI9IdBN7valwzIlq2ijjPTrr1A5np1vvg+KQ
         rtjgDYDdfE79d55B7GpXo2uGjmz/PqllkcrKnSg/mnMCDAAUFOZOOaS9gspRobcHoa/t
         6v5odz8kpbjbo07uik+1g6cTTPmpsmaG6eZLl8t5cnk4BRJOjoFms4tYnBNk+jNjC0Cf
         EoeCa0skQTnhULxFW/hu5+IhHcSl6v0J4H2wVyvIJsx97ajYzU92AITDdw7vF0xyA7PY
         S27g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769192732; x=1769797532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U46WO/6V9JCyZE4jICWmEWW2GU9FvLsO66woYhkM8CQ=;
        b=P6zC2QUnbG2kxf7QSU/BW2i9GTrya+aJt9RlW9AtPJa20sHlZtKW1lGc0kjrzdcdJh
         zY0cL6rzmSB/WfcD+5nZhyxmut6+3XiQ5y4Ir6D3vowwJD9BvXXMjqAePNnopALnxvNI
         +2f+C6x9PaoZQNz2F4GiO75gf54wrOz75eBtcTX7itMDzLtxUB/mZIQDbmdCNn1IPnMw
         pkXQ1LcuPLH74ablw+tWKjBjEzH60x1kluor3rUvwQV+q4+svwlEXWf/81SyySI3VsY9
         2Zpx2tTwvWAWnyL7gVe4HMwSjZatMHG5V0CgTvZTVigREc1rIEu90yPmB1zl8HSAoE/s
         RLQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBuKImvfsP2K5WmT2xoF5fF+TaY4PO+esZxorAIFJN37GxPiNkV6HGGWfgQljXq3HWgXddUOHTV64=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTM9zcijuZaWsle1SbBAxaOvqxuxMh2CTTLqIhszX+YifdMEjF
	aPrJ6z6FxykfMB0hr3z52fzjwoffbMMDqeMEFS1SU+q73Z681IDpVSgU1AOkuFFazyiq0sp+WRP
	j+nHB3XlbgTUrN8Swf7mN9C9jsWxzWnU=
X-Gm-Gg: AZuq6aKQdxALhLlTFMRlzBOTyLpD7SavBfrN6u/rv9inwynoab5pAXilWPMERNkHWJ4
	fww+4FHjlk9XjgVXrTWLiDmXjBI7/5X8RHMZ0PFQXeSmtDPCGUj2B3GaIpGfZm568UC14j7EZBw
	tjJp8AxMmtaFtd6L6YJGcUUojWJJ7UDYTw6x1FH7lsi0kQABPgZ6LCAlNNi5aSbTemjXbmKxImH
	hDXn54g9F5rqf377FsrI+WWMayx2hdZXjCgKpmD5w5B0C6mfnqBYhZLgPEA8vTYwILQgl8egSli
	Sx3IkFXNej1Or24dvvKsEP5qPaYCyQ==
X-Received: by 2002:a17:907:7f8c:b0:b87:322d:a8bc with SMTP id
 a640c23a62f3a-b885ae332e3mr271805566b.31.1769192731569; Fri, 23 Jan 2026
 10:25:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs> <176915153782.1677852.511726226065469460.stgit@frogsfrogsfrogs>
In-Reply-To: <176915153782.1677852.511726226065469460.stgit@frogsfrogsfrogs>
From: Jiaming Zhang <r772577952@gmail.com>
Date: Sat, 24 Jan 2026 02:24:53 +0800
X-Gm-Features: AZwV_Qgr0Zs4bqzv5ANNnDbFK2WKMm696RJGslpy5VAD19tTvor6GaE9fd4dcyU
Message-ID: <CANypQFbNw52qkirN9cKma2Xw-CLjLumq8gqF=Utn47fCcr6Lgg@mail.gmail.com>
Subject: Re: [PATCH 4/5] xfs: fix UAF in xchk_btree_check_block_owner
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Darrick J. Wong <djwong@kernel.org> =E4=BA=8E2026=E5=B9=B41=E6=9C=8823=E6=
=97=A5=E5=91=A8=E4=BA=94 15:04=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> We cannot dereference bs->cur when trying to determine if bs->cur
> aliases bs->sc->sa.{bno,rmap}_cur after the latter has been freed.
> Fix this by sampling before type before any freeing could happen.
> The correct temporal ordering was broken when we removed xfs_btnum_t.
>
> Cc: r772577952@gmail.com
> Cc: <stable@vger.kernel.org> # v6.9
> Fixes: ec793e690f801d ("xfs: remove xfs_btnum_t")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/btree.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
>
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index c440f2eb4d1a44..b497f6a474c778 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -372,12 +372,15 @@ xchk_btree_check_block_owner(
>  {
>         xfs_agnumber_t          agno;
>         xfs_agblock_t           agbno;
> +       bool                    is_bnobt, is_rmapbt;
>         bool                    init_sa;
>         int                     error =3D 0;
>
>         if (!bs->cur)
>                 return 0;
>
> +       is_bnobt =3D xfs_btree_is_bno(bs->cur->bc_ops);
> +       is_rmapbt =3D xfs_btree_is_rmap(bs->cur->bc_ops);
>         agno =3D xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
>         agbno =3D xfs_daddr_to_agbno(bs->cur->bc_mp, daddr);
>
> @@ -400,11 +403,11 @@ xchk_btree_check_block_owner(
>          * have to nullify it (to shut down further block owner checks) i=
f
>          * self-xref encounters problems.
>          */
> -       if (!bs->sc->sa.bno_cur && xfs_btree_is_bno(bs->cur->bc_ops))
> +       if (!bs->sc->sa.bno_cur && is_bnobt)
>                 bs->cur =3D NULL;
>
>         xchk_xref_is_only_owned_by(bs->sc, agbno, 1, bs->oinfo);
> -       if (!bs->sc->sa.rmap_cur && xfs_btree_is_rmap(bs->cur->bc_ops))
> +       if (!bs->sc->sa.rmap_cur && is_rmapbt)
>                 bs->cur =3D NULL;
>
>  out_free:
>

After applying patches and running the reproducer for ~10 minutes, no
issues were triggered.

Tested-by: Jiaming Zhang <r772577952@gmail.com>
