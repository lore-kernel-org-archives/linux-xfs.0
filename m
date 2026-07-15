Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885C446B5
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 00:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784075799; cv=pass; b=BzvIqtKb2rNKqKUL11x0dGYxTkSdvM5hnm+F4jTIbfEHmBIAGtV+yyG64U9LgWn22O5Z0RuC0TMHWREjlpcHD/YcTcAg93Fh7A3Pkb+Z0vIhSFMh5OOtLPKQufrcXjn3Io3X87sPv1WHTdhcX/8+pMezxAu4gXuvlYG3UIOmPH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784075799; c=relaxed/simple;
	bh=IhgagwPLcErYXsbFBMm1CziaZKavTfhArRfY6nQ1Jhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nSfxR/SOa4nbTPBsX8HLgIkcF0m7IkwX7wqGpFGzWVN5IDqJ2s0rWLSLY6YBAnvbySnciYhN4Co8miKNP5/Ea1pmRyW9oziHrTY85kLrizuMV5H1mQeoRPJH0/X9oG7r3f3KBYa1+uPEfNW37K2rdfjCfejqKnm2d+vOL19Y3pg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=O2SdXwRp; arc=pass smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="O2SdXwRp"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso1893993a91.1
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 17:36:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784075794; cv=none;
        d=google.com; s=arc-20260327;
        b=EMKLIsGxj6iHl81KdHkSHHeoXjQ3255DixOxHl2Q6Q5+aiAC1EAq++apnW29aNme7n
         LpVEbY2N3olnGqnl/qvGV4ksBJwjGKkrxIA9iF8SwWUK+kUTKY/MpoxUegQUXAX/Chs1
         NQ4Q6NCxyJAR3q1wLl97f62xXF/D3ki1bf6Jv3C4kUpQaRqDyxMFcU9MCR6b+FHdC2RP
         QqJmTtm5WmgzwgNc0GNOFaHpcvInAQtq1q1MFkWDBJ7ldoVF1hWnLgxWcrpGW7qpySdS
         S7N5uXIYs0nmKK1XihwaXPNQTvD4NcaxjUoodTMgupJ9kloz8ZWdgOD4hgGASMUt5OYg
         idsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DBldHdbR59xzOwiGY7csdK2px0Gbv1LqenTuLfbw2nY=;
        fh=dBPruU6GzHg4SQIDOiFL7ZXQO1P9xpX2rVCEShptJ3g=;
        b=awATmpAvHG5XajRZf3NINsDJzcjC0txGQ+PCBKqndvucATyjHXTn5WX71WssQH31o1
         omqKOKng2ZNugum8Hb18Km3LjyVXr0YmeIsx108Y+PLaGuNUkW79d8TDL8fB/mdisB0m
         8dOaK1uDZcHWydDBboTtLa9jATQXgNRBqy6OTKoWjI2VP0BMpbwHiulxbYzGgr94/09V
         WDz/j/ALj8g6VLyWGW+ifP2Ljg91V8OxIK083l/md+tkI0f5OU7aO3KDS7GX/cZA2A1w
         uY7KdSX78OV2I0ARC8WIQ+JdYoKw1nkI1jcNr8/DN47dl8Y+bxU/sAKbk4SvOotIReOf
         4Heg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1784075794; x=1784680594; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DBldHdbR59xzOwiGY7csdK2px0Gbv1LqenTuLfbw2nY=;
        b=O2SdXwRp7ow2SHwf8WbnH69/ji+Q5s+R/c+ghhZiH6Yl2vl7dLs8hLWZkRr7V3tHyp
         TwcYt7xGKmk3OZDn612p/K0uqBlkQHPMX0mNIwGp430wfC1LlkHorr2UpkY5BncgPmgx
         oyeIASCRJ4/sp4+gWrtjJFQSs02J5bNzO4LUKPWIpT3OYXea3pGsyk7Rn8Xzq3A6Z4P3
         Bxx3zz90OImwHsKzCBiA59MGdRwOw+bK9p35tYZadpyV+MhsKwDGXejEZzPuhPAbJdox
         0vUq9Gtng9F1M5IluFPmLVszqNak6h+Hd15Vw1aUk54wzb0g8/mNCPwkx80krIc0WpOf
         9Zig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784075794; x=1784680594;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DBldHdbR59xzOwiGY7csdK2px0Gbv1LqenTuLfbw2nY=;
        b=IAfp334WisLDqGkqxSBDXvSlKpSSP3vgboHnZ7MZ9m/4zxcGNE7la2eqf6gROVNIhQ
         GTRyY0AYmsxMPRoxrgwJrC/y/xlnTqYPLiOuv0oPQJVv/k9x97V+wQzdcFvDfo4q8E9K
         JMH8hJsSEZBCaJgXwCvqDdhMPkAUVdCaIQTMk/OKXTmddG3F11ZCAkMCHqzNQRiVLJms
         OtqC1cXoYv1ijW2wWiz3L7x7cMLHFeN36yppBqDB3fRXWbr7ivMXaiHISNovlSMbsj8W
         rgNSXAnT7NOmoToJwbrZACy+7/lamuBeyNM8HaFpsuEQdPRZsZu0Fm5tZrthKIersSy0
         rDeA==
X-Forwarded-Encrypted: i=1; AHgh+RqZhw/0o5Ez/2GQ8xP/5V5lRa/CFIeXUsCjPfk6NJE6wjVoee6WX9lUoIdAizxZtH/m0vhgYE37Dik=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqvXIDcEFl5F1+uTXEBM51g9nfnvgUKTtPXQFwlzgNs18XN79Q
	nayWC0F+/5EJp2JgL2y1FIJCZKfKHgK5psFYUWPBzyOZNvOTN/mgG8f7EOFIDK/1N9s4UgGyYmN
	FwPd9VUxvaVJ79XJ6aEZ2EJRO2lPhxW5egYFNgqSi
X-Gm-Gg: AfdE7ckWy4RPx+pgUFtB1Q+Sii+Wr61TZcdaYsMYHOg6TDS/wFuA9XpmM4/GMNlcdtG
	84v0ZJeBlkvTImLfWzR7kqZTFwhdjrRPxBwZ7PGa2qgIZb5ngX2w/VfvcthmRmMBvSeQ2cLnVk8
	/FcjVXC8S0Ha1YChqcP/HVlBdnBkQdVitGnbrwTSaWdnGTBnNpvY88DwEIx2GO8CiohjvVRWQc5
	+LuZCjr8HN8T8cf+IbQUGI82ZirVQ5TFU3utHh1zvreMGTZMB73QzGNPUAvVTFK6CJFq9atvi7W
	oMGYu3ekEt4fH7IB+bn4J6oO1jXbPSLe8sKQJ+k=
X-Received: by 2002:a17:90b:264b:b0:38e:79f:76c6 with SMTP id
 98e67ed59e1d1-38e079f7788mr7757014a91.24.1784075793850; Tue, 14 Jul 2026
 17:36:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712220854.3131445-1-xmei5@asu.edu> <20260713225721.GM7195@frogsfrogsfrogs>
In-Reply-To: <20260713225721.GM7195@frogsfrogsfrogs>
From: Xiang Mei <xmei5@asu.edu>
Date: Tue, 14 Jul 2026 17:36:22 -0700
X-Gm-Features: AUfX_mz0KzewxGrV4iSsWihDxa5m_UbpLckWgQr4KlMKsAhOyJCNkWHSUe8C0ew
Message-ID: <CAPpSM+RtwKTJTwm-pRLqs5+E6DqaPgJobGdxo649NNLmsYFZ4Q@mail.gmail.com>
Subject: Re: [PATCH] xfs: reject log continuation for a header-only item in recovery
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bestswngs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2026 at 3:57=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Sun, Jul 12, 2026 at 03:08:54PM -0700, Xiang Mei wrote:
> > On an XLOG_WAS_CONT_TRANS op, xlog_recover_add_to_cont_trans() extends =
the
> > tail item's last region via item->ri_buf[item->ri_cnt-1] without checki=
ng
> > that the item has one. A header-only item, created by
> > xlog_recover_add_to_trans() when a transaction's first op is a bare
> > sizeof(struct xfs_trans_header) op carrying XFS_TRANS_HEADER_MAGIC, sit=
s on
> > r_itemq with ri_cnt =3D=3D 0 and ri_buf =3D=3D NULL. A crafted log whos=
e ops are
> > XLOG_START_TRANS, that header op, then XLOG_WAS_CONT_TRANS thus
> > dereferences ((struct kvec *)NULL)[-1] and faults during mount(2) log
> > recovery of an untrusted XFS image.
> >
> > A valid XLOG_WAS_CONT_TRANS only follows a region written with
> > XLOG_CONTINUE_TRANS, so ri_cnt >=3D 1 always holds for a real log. Reje=
ct the
> > ri_cnt =3D=3D 0 case as corruption with -EFSCORRUPTED, which the caller=
 already
> > propagates to abort recovery.
> >
> >   BUG: unable to handle page fault for address: fffffffffffffff0
> >   #PF: supervisor read access in kernel mode
> >   Oops: 0000 [#1] SMP KASAN NOPTI
> >   RIP: 0010:xlog_recover_add_to_cont_trans (fs/xfs/xfs_log_recover.c:21=
35)
> >   Call Trace:
> >    xlog_recovery_process_trans (fs/xfs/xfs_log_recover.c:2306)
> >    xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2500)
> >    xlog_do_recovery_pass (fs/xfs/xfs_log_recover.c:3243)
> >    xlog_do_log_recovery (fs/xfs/xfs_log_recover.c:3331)
> >    xlog_do_recover (fs/xfs/xfs_log_recover.c:3368)
> >    xlog_recover (fs/xfs/xfs_log_recover.c:3493)
> >    xfs_log_mount (fs/xfs/xfs_log.c:617)
> >    xfs_mountfs (fs/xfs/xfs_mount.c:1031)
> >    xfs_fs_fill_super (fs/xfs/xfs_super.c:1940)
> >    get_tree_bdev_flags (fs/super.c:1634)
> >    vfs_get_tree (fs/super.c:1694)
> >    fc_mount (fs/namespace.c:1198)
> >    path_mount (fs/namespace.c:4161)
> >    __x64_sys_mount (fs/namespace.c:4367)
> >    do_syscall_64 (arch/x86/entry/syscall_64.c:94)
> >    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
> >   Kernel panic - not syncing: Fatal exception
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Xiang Mei <xmei5@asu.edu>
> > ---
> >  fs/xfs/xfs_log_recover.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 5f984bf5698a..fa8e04bf1aac 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2131,6 +2131,9 @@ xlog_recover_add_to_cont_trans(
> >       item =3D list_entry(trans->r_itemq.prev, struct xlog_recover_item=
,
> >                         ri_list);
> >
> > +     if (item->ri_cnt =3D=3D 0)
> > +             return -EFSCORRUPTED;
>
> Didn't Weiming Shi already post a similar patch?  Is this a duplicate,
> or a complement?
>
> --D
>

Thanks for the reminder. Weiming and I both pulled one crash from the
to-report dataset: The crashes are different, but they could share the
same root cause.

After investigation, I found it's a complement. Same root cause: a
header-only item left on r_itemq with ri_cnt =3D=3D 0 and ri_buf =3D=3D NUL=
L.
Proved by crashing the kernel with:

https://lore.kernel.org/linux-xfs/178342425117.389943.13021791343607135682.=
b4-ty@b4/

Weiming's v3 3/3 guards xlog_recover_reorder_trans(), which only runs
from xlog_recover_commit_trans() on an XLOG_COMMIT_TRANS op. This
patch guards xlog_recover_add_to_cont_trans(), reached from the
separate XLOG_WAS_CONT_TRANS case in xlog_recovery_process_trans().
Please let me know if you want us to merge them into one series.

Xiang
> > +
> >       old_ptr =3D item->ri_buf[item->ri_cnt-1].iov_base;
> >       old_len =3D item->ri_buf[item->ri_cnt-1].iov_len;
> >
> > --
> > 2.43.0
> >
> >
