Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C45F1DE3B7
	for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 02:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764384051; cv=none; b=Bl+zXrSK7moTbIUo0lucqbDtytWFQ02tUHALJmrjBGyGAEBi3t8MtZh9g2ucxLPKd9eYqhT57bh6CJnKTCk6f6k3KvVT+flQKE75AdyKagQj3LfrSKxcU0xYR+3uMeaRFGFl+06HTiYepQvGiE7sw3Sd+jHEAR+wVz+i4yOiJGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764384051; c=relaxed/simple;
	bh=zHvwDf5Xq+iEVnjbasw1OMjmqc8Je/9Bg17U+6o9Pt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=djZU61TWAm9p6oZXnkeNsXLz4jdCjI8grxsbBXO0vMcXe8mnoz/SoylJHePgJX4VR5qgg/4CBjquwzSGoDp0ljH+yn3yCA++zqqHVuYm79shJEVcXTDd1UF7/xgrIMH+TrbA9/k9QvKuHR1vgMpS57PaA0tk6l06kBaNm5fpytk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CCo97o/Z; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CCo97o/Z"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4edaf8773c4so28165531cf.1
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 18:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764384048; x=1764988848; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QAPySlCz6W7rFB53xcBPcWM3i1+fAM460YdX4Fw6oEA=;
        b=CCo97o/ZznC1eYG5L1PrHUi7Tb5m2ILT15A2NutRwS9h8rBiavWDBFGlkOfkDQB5oB
         0X/BB1tXUWIMix9N0z0KmsOYBWqEExAsJNAPKKgsu8rFvDf42xCNF2R7K2eZ63CG6ilB
         H1a56ecPjNdSJiE0vHy9bjkS6cp9Z0nSUTfI+r4JpvpQpTherxSC+/tZtOkSaFgiLdjG
         qmE4kl8wxTwO8YvwVJqeZhYSsojWWzZfWS3eyvQqyOptCdxzbMqb9Bo5vQd8W+licGur
         40NtoB/FJslnZyBBtvbSVnwREtWFRl4siYiJlkw03UqA9KdvrNtpJEJyCPOQqVahMHAP
         Itdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764384048; x=1764988848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QAPySlCz6W7rFB53xcBPcWM3i1+fAM460YdX4Fw6oEA=;
        b=YR2g39QdqN+Q6hF8UwnduOf209nw/My5lT5Rhv8Z42Djv8Ju2rPWWYB5nqXmds9oPR
         IuVrSuLRhuuM2oxSpad2Spl3Rvc+mhzjWZHs52DLyt5KaF7hs9BJN1DrH72sOA86UPHd
         Fgsp6brfY4J6ItbCkViS+OjCAyiZeNZ51J+WgqPzFweRC9JvSh5m5bTByRbrB2Haya1g
         GJM4lxBDOkfcTFb4v4yBetI9y9GZGuvb9bOQTed10GKSrvMSPVFgIMYwjWdp5VYnxcIM
         Y+DXbHkAYD4BdsE2b8uiamTgt+l7DWNwipTqwbtSBkYg1Jk1pdx7mZXdrVSENjvu5HX8
         5PgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWin8uZultNKmKcG8iO3JaswCfoGd58d1V9N24nBAcvdw4ySd29uoCw+lEiuNKYg5erx4vqUADJibc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaggPC/Z/SQBIUo2HXwqH/w7a70z3rxDGZDHZWgtex2CDR+5Ve
	ZFdPD7ZTpsg2SGBqWt52crFiJVbKW6f1/heqPueVTqMlRAeSiJBaI/N5TplI8pyZAHg175pInGc
	fov9JK+0uz+kihDjMUITygT5FUmPTNnQ=
X-Gm-Gg: ASbGncuGlpogv8XjIP2mijfWmJ+n5QYzw170LrMBitsh/R/YW1BQAabud18THlaDpB1
	njO/SEyLl+HQL0K8ougckBwaGw+WgIwB1/UTxH9tdQF795DsFbxf7jdfNC8ZDJn7+EZ4/O3AKBc
	3+ybyO3pruS7eIwWr57xQhmt8w4x7TU2O5OhZLRbrqsCpcPXvMLTkC+MGLYuP11HWdDP4ZT2MUh
	YIdIZUKpo+ht3VGHZHIGnVzqp3O+ZmbTFFbHtv/5uSXMqE7jmnyiE1c6S+2YnjjB1u/Dw==
X-Google-Smtp-Source: AGHT+IEc3jQjTSh2wGwA1eyD2xP/eWtKWxB49pbTJ6uDNzgYaFeaO9lvwOhTEy0qjR7rLP4x3OvjjW+3HSCvva4PQqk=
X-Received: by 2002:ac8:5753:0:b0:4ee:1b36:b5c2 with SMTP id
 d75a77b69052e-4ee58af12d0mr418152811cf.68.1764384048425; Fri, 28 Nov 2025
 18:40:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-7-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-7-zhangshida@kylinos.cn>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 29 Nov 2025 10:40:12 +0800
X-Gm-Features: AWmQ_bkvl1bn1ab0FbiQv1s_-KpnO8A0jbXWmROhOJd-0tcEov6J9fzUaa8ydUI
Message-ID: <CANubcdUtncH7OxYg0+4ax0v9OmbuV337AM5DQHOpsBVa-A1cbA@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] gfs2: Replace the repetitive bio chaining code patterns
To: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

zhangshida <starzhangzsd@gmail.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8828=E6=
=97=A5=E5=91=A8=E4=BA=94 16:33=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Replace duplicate bio chaining logic with the common
> bio_chain_and_submit helper function.
>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  fs/gfs2/lops.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
> index 9c8c305a75c..0073fd7c454 100644
> --- a/fs/gfs2/lops.c
> +++ b/fs/gfs2/lops.c
> @@ -487,8 +487,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev, u=
nsigned int nr_iovecs)
>         new =3D bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOI=
O);
>         bio_clone_blkg_association(new, prev);
>         new->bi_iter.bi_sector =3D bio_end_sector(prev);
> -       bio_chain(new, prev);
> -       submit_bio(prev);
> +       bio_chain_and_submit(prev, new);

This one should also be dropped because the 'prev' and 'new' are in
the wrong order.

Thanks,
Shida

>         return new;
>  }
>
> --
> 2.34.1
>
