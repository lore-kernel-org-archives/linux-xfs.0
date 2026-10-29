Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793304533;
	b=zCYXU9cIClk1sxDy1B8BlsnIw88AsKG8RlM+cQqj7aL/f/JUcxhloVe4Fwsl3D4dcyWq
	 ee/rqqYd0IpJkXGQCCE6DlR3TCv/JwBh28wo6F9dFpc+vYYmvncY7EjhIvWHn7FLKoLFY
	 g1R6TlUhjrQ/Oi1KLZTjMKIXYWC4SlcpaoMlFGqI35Sn9oqWssFBa0iU3bjCfe141MYAB
	 /oCRbry1+RDg8wvb+4wY1z3MHoo1kYJFW/Qh1RowUc27dTO7oSQXBNTjEVoRbiIYmbAv9
	 BAiktY/sWlmvFAkN7czDh7W4tL0KwfBOa09qvXaMWs4ceEGieepRZwKl1XKFX6ENyWg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793304533;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=a7zkNlVrzlPSpxoUpXt3vRmcwmTKMbpAgzHY1qs7+DM=;
	b=Y12i+1dzLfAfP0KGOD4MrsSwiI5xa99PFscmWMNX7s33Vyk38mAUADbjtlI2Lb+rfit3
	 fX8UZD+Sy5PckL9O6JblB+SgHrKtEDPccYf1kvsoad2JrBOTxdheibXG363o3nIyts+EH
	 4RDPSzZGXjZ1qcmGKCvpry8qoe56BsWwWPg2ni8LdD6NehJVEf0llT0QnO6cxaSPYoqfq
	 yxBXPqTAsgi2L3p6nnnsB8DljThCccy7qZueeBBcvsVFEa2k+/g7JnG8cA91cG4kxcGBh
	 0EMvUI7/2rfWmL3N/aQthyBsCxLKgKw0AjojP/K8Pdev+Zl40CCzbm/drgctKyfrwoA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cF5c8VtD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D2D606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 20:08:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36D2D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cF5c8VtD
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48bbb06e746so6215f8f.3
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 13:08:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793304530; cv=none;
        d=google.com; s=arc-20260327;
        b=rCve06O6QtSykq11hxkwn+A1yPYD2qd3jR1S4wCDEOrrtgHJUD5g9iHlHuavVJlZbP
         6iCt6OCCwF7i9m5nXYkHzqzkyzwcRX8r5seR/U5c7gSKx38cZurq3RzRvMmUH4v0Wmru
         kReelnbLHHGTANN3UP79vaSqipGBfnnJvZSf60KQkweog6PVBdQ9aTHDpHh+UFScMHhL
         mbUOqFQvh+UcEPLJpl+87xlJuBRM/qNtm0XfXbPQWYFeakRhoW85SdIgCsvZvEJwKyFn
         2oVatDnqxRJcmdIKSgk5PgCpwbzLqrRc4CTTx4XDpctd7DXmMC/7DbcceU8F7Z/Wd5WF
         6hnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a7zkNlVrzlPSpxoUpXt3vRmcwmTKMbpAgzHY1qs7+DM=;
        fh=pyLIjINTUTUAzt1nc+gcx6BL7h42v3meDmP1iL/vdho=;
        b=c2YYcw4g5wIyjxnVlb4Xgzv1pzunMV2M1mUKhTu4/r/qqyfYDwC03e+Y4yhvfiYN5o
         LjNQ/KhFOzpLiEl25tU/UTU/2fjdF6MbL0kHX3UZl4N4u7nDMNzBaZtbbSEj5Lkn7YMw
         UZSTkJI2yJYx4IMn5DW7bTSo0K1LERom2FQT21RS9RlZawnCsp8tzc7x+AWKAxPBrPU9
         AzNFNL4X2xv2lel6jYZ51A1RhukaZDqS1qS8cAfbsQ13gAk8e0NkTI7mFigDdnWIGcj6
         L+OZCs7hki742DuwCdMur/t2EXUi2VYb62vU8OL3u1c1ZFA6I1YNEOmoP/8lZ/myHp8U
         yo/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793304530; x=1793909330; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a7zkNlVrzlPSpxoUpXt3vRmcwmTKMbpAgzHY1qs7+DM=;
        b=cF5c8VtDD9mtXXMfx73tPPZP6ZGyc7Iyom5qIfSSirBoVjl+k1aJU9TlqtCNPsvv6t
         YUj/b2XjUvWOJEgA+rmpLJCfK19zhHTB1E2NO6z0KZh+kricy7kJQ9VZbjQpkW4sHs2H
         GNH8iRpemMGf5zAL7uGgGkMT+qaLFijGwdUVsaYuCiPasfiKk96yNECS37KfKjR41wvN
         zZRT7TKNKbHpIe1WqHXSoQbXF9sNULGInMaoyeU9alUXbydvm6CBahzyFHaCUh+Rfvjl
         KIIq9oRgvQUrNMFu9mgicexxTpmFPnBWaby0bq75EL6n9D5+kcYsM2Ye5O9qfRLcDhDk
         D9Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793304530; x=1793909330;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a7zkNlVrzlPSpxoUpXt3vRmcwmTKMbpAgzHY1qs7+DM=;
        b=OoLB3q+IQO2vuwU82rEBfSNazeZaZjZZTBW8tq2rBwcxyYwjXi9cL7zg8TU2MecnRt
         yX+yFJBJIaZqz1yhxtZxUaUtFDl5/KBrwRXS8vYLWmncpohggD5Hgqqm1iZi6x1aUZyT
         8XMpMTRaJhWMPCAi/RKXrHaSo7morIf+p/PTq6Fqw30g8Bk375c8kfh0PUZV8DOOE2K8
         1QCXi0yjcmlaMUe6HBMo9MX3jq5UYwYe00s+lbI3fv683SfUOTryrnzEmA1nqhk6jI9p
         lIKIORiTlZrMrcDmV3Ok1cBtELHKP28+uWCDlgdl/NGl4IAWNeC6henKaST0VacgSvdG
         eOMg==
X-Forwarded-Encrypted: i=1; AKwUvBwjG1Q6vWabFdRXz3w+FKPyyT92DeVadDpMt3b09HYt2ZoeHRBDY+uhYhbiQWmC9cHmOX6b1kMU4pc=@vger.kernel.org
X-Gm-Message-State: AFq9FYJM6Wj/ol+Pr5GbSEfmEFJlret8czpwS+2nv+oruVGH+8F7nUJU
	u61zsDDqZRK432R2TionnkYYQ2grzqSRxtTIOFDgpH7dg+fcd7JfMH3Ek9WmklRl15MUCM63FSa
	hol2V0hHj5UOn74g9k/7yZDHquq8HfoU=
X-Gm-Gg: AYBFou1jiMpBm3OzGcqdRVhNuIOdoYbEP2QcDP1cTK4ZBl3QHfj5iNy1/WgJYHkIalH
	/4ucWZuuk5lQy24vDRCVJBr7aX4u+SYoqQX8YksdkhkEO1leSQvtQLsWtVZECBthm0Uh9Z5T7XE
	T6cm/ZSPu61qsX7wa8w97SU+Xk+5wQYrLp9f2Ar1wiaQYxqBpGsFpxrz8GCop6T+63F0gJiVAKA
	AFZC8yJI0KIvAfdtC4QAMU2NYwMWK3cvsxbje0Cj+GTqr4c9AsMC+dtW0i+4Nd74mX4Zp/Sxf+T
	rk/jhqfiqpbGQpOpMz+asMmkCcOTwu/bbkoGUN+2tLe1anOeJRBx8lwdypDnMNyyuHtki8SWVtO
	4Zyew3c9pylgbnPjs645xe3tI3i6MJPTvwrdy3oAxPB1XXbEwUUFMcHIk8ebtZImEjEVJ2xn2Vu
	XNBDeGWOqlOFWoCQ0fVQ==
X-Received: by 2002:a05:6000:1ac5:b0:48b:116d:56fb with SMTP id
 ffacd0b85a97d-48e6e2bbfe0mr1122858f8f.1.1793304530377; Thu, 29 Oct 2026
 13:08:50 -0700 (PDT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029-work-iomap-ai-fixes-v1-0-7eda63bc1b13@kernel.org> <20261029-work-iomap-ai-fixes-v1-1-7eda63bc1b13@kernel.org>
In-Reply-To: <20261029-work-iomap-ai-fixes-v1-1-7eda63bc1b13@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 29 Oct 2026 13:08:36 -0700
X-Gm-Features: AclHuK_mxORIH-qEHKr1ZEzSnp2s6A1zchn0cpynNg9TXiYPbvV1ECJaStfOffg
Message-ID: <CAJnrk1YiF=OEYQzwFpkzmBY_78+fNKgg5CafaWOa7KwGR+XN-w@mail.gmail.com>
Subject: Re: [PATCH 1/2] iomap: don't mark unwritten parts of a folio uptodate
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Chris Mason <clm@meta.com>, 
	Josef Bacik <josef@toxicpanda.com>, Matthew Wilcox <willy@infradead.org>, 
	Zhang Yi <yi.zhang@huaweicloud.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 3:35=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 907873073b03..d6e2f1ded5ca 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -920,6 +920,7 @@ static int __iomap_write_begin(const struct iomap_ite=
r *iter,
>                 if (iomap_block_needs_zeroing(iter, block_start)) {
>                         if (WARN_ON_ONCE(iter->flags & IOMAP_UNSHARE))
>                                 return -EIO;
> +                       /* uptodate once copied, see __iomap_write_end() =
*/
>                         folio_zero_segments(folio, poff, from, to, poff +=
 plen);
>                 } else {
>                         const struct iomap *iomap =3D iomap_iter_srcmap(i=
ter);
> @@ -943,8 +944,8 @@ static int __iomap_write_begin(const struct iomap_ite=
r *iter,
>
>                         if (iomap->flags & IOMAP_F_ZERO_TAIL)
>                                 folio_zero_segment(folio, to, poff + plen=
);
> +                       iomap_set_range_uptodate(folio, poff, plen);
>                 }
> -               iomap_set_range_uptodate(folio, poff, plen);
>         } while ((block_start +=3D plen) < block_end);
>
>         return 0;
>

The fix looks good to me.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
