Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DE02848A0
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 18:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192770; cv=pass; b=tCXlSLJ28630yv5OGXk7Sro9pIvpDUhS+D8pjJfrCWHyBwIGXI2nRcVey/d3sQepFv3Jt+klbgaGeOJV4zTU++8K3jsPbNPmpqij8sV+AT5NJbgRpd6RqNNQsor1m0youmPPPAN9BvNWeUTI5i8ibMu1GgTfmxDy4jcJzSRZDFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192770; c=relaxed/simple;
	bh=lw7xRpFw2x/KE4Twuxal1PcgEtMfTSjH8L5ZPbFVCDA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mNlTbaqtH6ZL1JYSOjIEJOkmk5hVDyuKIyKO+PdYPO5NxcVaWKoOT4gA1v/5Fl71BbPHNBI2EmRibmeUl2/ttzKBk/Rqv4Xp09sNTPthEo4l0XT4oEZK7RKBrrYsf2gTWqgLQwjuWYOkxb6kjin4xAX74UOb0pfTP8uTPWTfFwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KagMOtgB; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KagMOtgB"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64b9dfc146fso4451491a12.0
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 10:26:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769192767; cv=none;
        d=google.com; s=arc-20240605;
        b=NTTH6LJ8Tt3n2OmD2tC5RdvYX580JhvnjOE21Cx1j3CFk+0Kjm2kn9WiaJnOjcQxvt
         fhPVw8dt0kLgI0vZNX/ha6g2CexdMUpTNVHWHy2Wk/deAAZJbDJMhGKwwutyJLBZjjDl
         Xe26uyBNHLTEx2zCjJ01DYNy+u2tIcsuqY9BmTVIwmBFyRdItGD3XsgCR9T3pdSorwTI
         +WREpARnHA/dALc0tFFDaQASF3TZrMOz3R2ZVMec0tju+RmPZproOwYbI2/45uTxX798
         27jzdbidjFDfV4p7GJvnteaPr8ZqS0v0NFp7cHq9Tplf4lbrDDyx1e5zMUNa90zZRGw6
         g3ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=plAFLPhHQxvfWQb9q1LZY3VXdudAWiQZEI4FNJSvCFk=;
        fh=Li/bl5/bepfBC1z5vwDlBs6IpDEnRyAF/rnuJkufEsI=;
        b=iDDSJq9aDsx2vjI/kB1cL86/jx1ChB6Xorbn++kmEV/yL2sxfHUkdYxOnMyhuPO0J2
         0Cfv/4ykk5ArU8YO+Itk3fdqzkeNcnjrdhrR9tpdlYngd0EBsYy0IHt3FVlx5q8S7uhn
         Zz8SFccTQLmHNNhrPnBsWtB21mqps9r+ilJyBE5PoZdarHPQfkax1US0EGgPsul9KDoy
         TIbTZFYhvh3g113NTtzDa8HdpvQBqHmpWfHEl/FDGpscFcCBBHjBHKSrX5eSqaJsOxlx
         O6/CdiQyflALr6qOwMDUKjMZ6raz/foBV/5E9y/YVTd5CwUP2Xu6Du6c+0Kv8xYnZuwx
         EZvQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769192767; x=1769797567; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=plAFLPhHQxvfWQb9q1LZY3VXdudAWiQZEI4FNJSvCFk=;
        b=KagMOtgBIzNT19/IwggUARHTCuAFoMwuZUw+R9oQt4HQh98o25YIDuGjqrY3G1lsoK
         D8ERwZRhXa0VHkVajyQ5rxeYKThHJcQKtHB3an4wYOZ4XmEVdCACA4nLTMxQq6OSzvbB
         fX77tdtkN2x47NxCuinyNzh+tZQglwuv7Q/7Rrl9SvLX5L7bgmihy+IDlNrR6rginXnC
         pTIiXIcNZ8Ag5fvNpIxdPkhnXnX2JL/0PQYODNwLWkLtT8rrEh0WWRaPu414ZG60BYAP
         GAaR5TmX8tQaV/Qb2YxK5+6Tgk/pZbFrfoKO61vM+9ecZA72YcVRz51rgCnQ7Mo1peeH
         Qu5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769192767; x=1769797567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=plAFLPhHQxvfWQb9q1LZY3VXdudAWiQZEI4FNJSvCFk=;
        b=O5k7S00W0IkA/r9p0LBLkqdDyx403gz6phwm772HEqe9w/hWbGzpTM6G9aeFhwfB5g
         6Cggrn7CWF/QuTmDRpysrwLc+41t1RJfQNo1DJRORFGeSrn2GlJrNn87gP+53EX0P8MK
         4t5L1GCwiYRTFFQ9TPVP3eUXrG+CklRlkynHwXaPf/PRBeuiItp5y0mT2kcFj6mxSAtr
         bHQ+mW5oLA6Nr88MEHud4ZPywQ1WHV0eCFwtGyPy0xhdauz/wiuPPEZbSZtkC8ySsaHn
         BbpM78C8Wvsy2rHy/E66djAZ1HtLnPV4SNePeefS5KOJi8CyJdlXd0y66hFNTAc2Mm92
         Upjg==
X-Forwarded-Encrypted: i=1; AJvYcCVZNCPG6skd/7gkusFN0PNou6CoWV/SFWhCrZpXicHMJU0AhNVmIgxNwwyMqFGqU88kdPgHqdb1MRM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWrh7XG89qvMFdddbpFKuMLJDh8JToXV6NgDdjhrobCouhQTAK
	+wAxi6XtOT00CW5BQJ8t2hjCEdn8ccTWX46P9CSSTmsVUL1A49AHZJDMiIXYV4jamQU0R1M0ot2
	1Oip/E6dLbnBM4jcHfbRMxypkMFGiZ84=
X-Gm-Gg: AZuq6aIxQWa1O6PQKDzao/zQIq6aFpkdzkRtf3WmDtWdX6IMe+L7Zqkgn4qTlIoEdHj
	iJ3P3TL0oZHW5Dd0xEbwrd5EPfHqDPhHe4LDd3bbMIrOjWGESqOQRrA2FznvsyKgtZxTqaRCLfE
	t/WR8qLGywkAq95JMNp+PxdRkVoBWOzHUPEXpuVdOcYrMK1hD/XM/gQQ14UE7jAg9ptzVz26Su9
	cjasp8QcHMxJmspXfBQpjB/hMkwSwnwJAuBHZbXcHs4WOCWrbXoWLWLSGDoquPKg54qSKXy4kSv
	Et71hPJbzKNTydIh/QdcIUNBhSRz3w==
X-Received: by 2002:a17:907:6e92:b0:b87:19ae:eb36 with SMTP id
 a640c23a62f3a-b8831afe0b1mr459407666b.7.1769192766467; Fri, 23 Jan 2026
 10:26:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs> <176915153803.1677852.3768821466518761768.stgit@frogsfrogsfrogs>
In-Reply-To: <176915153803.1677852.3768821466518761768.stgit@frogsfrogsfrogs>
From: Jiaming Zhang <r772577952@gmail.com>
Date: Sat, 24 Jan 2026 02:25:28 +0800
X-Gm-Features: AZwV_QhbBhNCqFRaVEpuVLVGT8TSdILJLLQjzRGbrx3OvtrdQbvkTuWAsYL6jVU
Message-ID: <CANypQFa-_VsQjs7Ep4USA_YHC6cD0kH8K_eBV2SjKm1yPH2J7A@mail.gmail.com>
Subject: Re: [PATCH 5/5] xfs: check for deleted cursors when revalidating two btrees
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org, 
	hch@lst.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Darrick J. Wong <djwong@kernel.org> =E4=BA=8E2026=E5=B9=B41=E6=9C=8823=E6=
=97=A5=E5=91=A8=E4=BA=94 15:04=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> The free space and inode btree repair functions will rebuild both btrees
> at the same time, after which it needs to evaluate both btrees to
> confirm that the corruptions are gone.
>
> However, Jiaming Zhang ran syzbot and produced a crash in the second
> xchk_allocbt call.  His root-cause analysis is as follows (with minor
> corrections):
>
>  In xrep_revalidate_allocbt(), xchk_allocbt() is called twice (first
>  for BNOBT, second for CNTBT). The cause of this issue is that the
>  first call nullified the cursor required by the second call.
>
>  Let's first enter xrep_revalidate_allocbt() via following call chain:
>
>  xfs_file_ioctl() ->
>  xfs_ioc_scrubv_metadata() ->
>  xfs_scrub_metadata() ->
>  `sc->ops->repair_eval(sc)` ->
>  xrep_revalidate_allocbt()
>
>  xchk_allocbt() is called twice in this function. In the first call:
>
>  /* Note that sc->sm->sm_type is XFS_SCRUB_TYPE_BNOPT now */
>  xchk_allocbt() ->
>  xchk_btree() ->
>  `bs->scrub_rec(bs, recp)` ->
>  xchk_allocbt_rec() ->
>  xchk_allocbt_xref() ->
>  xchk_allocbt_xref_other()
>
>  since sm_type is XFS_SCRUB_TYPE_BNOBT, pur is set to &sc->sa.cnt_cur.
>  Kernel called xfs_alloc_get_rec() and returned -EFSCORRUPTED. Call
>  chain:
>
>  xfs_alloc_get_rec() ->
>  xfs_btree_get_rec() ->
>  xfs_btree_check_block() ->
>  (XFS_IS_CORRUPT || XFS_TEST_ERROR), the former is false and the latter
>  is true, return -EFSCORRUPTED. This should be caused by
>  ioctl$XFS_IOC_ERROR_INJECTION I guess.
>
>  Back to xchk_allocbt_xref_other(), after receiving -EFSCORRUPTED from
>  xfs_alloc_get_rec(), kernel called xchk_should_check_xref(). In this
>  function, *curpp (points to sc->sa.cnt_cur) is nullified.
>
>  Back to xrep_revalidate_allocbt(), since sc->sa.cnt_cur has been
>  nullified, it then triggered null-ptr-deref via xchk_allocbt() (second
>  call) -> xchk_btree().
>
> So.  The bnobt revalidation failed on a cross-reference attempt, so we
> deleted the cntbt cursor, and then crashed when we tried to revalidate
> the cntbt.  Therefore, check for a null cntbt cursor before that
> revalidation, and mark the repair incomplete.  Also we can ignore the
> second tree entirely if the first tree was rebuilt but is already
> corrupt.
>
> Apply the same fix to xrep_revalidate_iallocbt because it has the same
> problem.
>
> Cc: r772577952@gmail.com
> Link: https://lore.kernel.org/linux-xfs/CANypQFYU5rRPkTy=3DiG5m1Lp4RWasSg=
rHXAh3p8YJojxV0X15dQ@mail.gmail.com/T/#m520c7835fad637eccf843c7936c20058942=
7cc7e
> Cc: <stable@vger.kernel.org> # v6.8
> Fixes: dbfbf3bdf639a2 ("xfs: repair inode btrees")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/scrub/alloc_repair.c  |   15 +++++++++++++++
>  fs/xfs/scrub/ialloc_repair.c |   20 +++++++++++++++++---
>  2 files changed, 32 insertions(+), 3 deletions(-)
>
>
> diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
> index b6fe1f23819eb2..35035d02a23163 100644
> --- a/fs/xfs/scrub/alloc_repair.c
> +++ b/fs/xfs/scrub/alloc_repair.c
> @@ -923,7 +923,22 @@ xrep_revalidate_allocbt(
>         if (error)
>                 goto out;
>
> +       /*
> +        * If the bnobt is still corrupt, we've failed to repair the file=
system
> +        * and should just bail out.
> +        *
> +        * If the bnobt fails cross-examination with the cntbt, the scan =
will
> +        * free the cntbt cursor, so we need to mark the repair incomplet=
e
> +        * and avoid walking off the end of the NULL cntbt cursor.
> +        */
> +       if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> +               goto out;
> +
>         sc->sm->sm_type =3D XFS_SCRUB_TYPE_CNTBT;
> +       if (!sc->sa.cnt_cur) {
> +               xchk_set_incomplete(sc);
> +               goto out;
> +       }
>         error =3D xchk_allocbt(sc);
>  out:
>         sc->sm->sm_type =3D old_type;
> diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
> index b1d00167d263f4..f28459f58832f4 100644
> --- a/fs/xfs/scrub/ialloc_repair.c
> +++ b/fs/xfs/scrub/ialloc_repair.c
> @@ -863,10 +863,24 @@ xrep_revalidate_iallocbt(
>         if (error)
>                 goto out;
>
> -       if (xfs_has_finobt(sc->mp)) {
> -               sc->sm->sm_type =3D XFS_SCRUB_TYPE_FINOBT;
> -               error =3D xchk_iallocbt(sc);
> +       /*
> +        * If the inobt is still corrupt, we've failed to repair the file=
system
> +        * and should just bail out.
> +        *
> +        * If the inobt fails cross-examination with the finobt, the scan=
 will
> +        * free the finobt cursor, so we need to mark the repair incomple=
te
> +        * and avoid walking off the end of the NULL finobt cursor.
> +        */
> +       if (!xfs_has_finobt(sc->mp) ||
> +           (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> +               goto out;
> +
> +       sc->sm->sm_type =3D XFS_SCRUB_TYPE_FINOBT;
> +       if (!sc->sa.fino_cur) {
> +               xchk_set_incomplete(sc);
> +               goto out;
>         }
> +       error =3D xchk_iallocbt(sc);
>
>  out:
>         sc->sm->sm_type =3D old_type;
>

After applying patches and running the reproducer for ~10 minutes, no
issues were triggered.

Tested-by: Jiaming Zhang <r772577952@gmail.com>
