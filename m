Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2F713E41A
	for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 17:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763745164; cv=none; b=XHxINHB+sNAT+1+26zawiae4IpTotU//cG3daVVBlCWYcDuz7tr472iNPv4LFRmgfgpRWCy45YRRgQx1ag9vM/UnBRJz1iACn089+h0F6RHgTHqd6B0mY07ISkgGJDqwJ/Q96Yb6Eu9CbC/BFOMjmlpRLYxowBPqyrReOlm2AR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763745164; c=relaxed/simple;
	bh=4knX7UdpV5PqcFPGudPF/uxcuJbYSUmyGMDEJIBJ6aQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M47End10PyHYeZgOgCiScszUXOpe9rbxWnRQ6xNmGPIxa5fYvS5p5sj4PeEU2gE1+qczfFNsNClNf+5f/+FgoYLiX6LgpoNoqLhZbtJsyJTpdkTMkNPhVRpDuU7oBZwvVGHp0RRVKpWrQo4LDNgbc/jUYVStB/LT4jJ4Zow9JPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a/NuQklc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=K8GIaqpj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a/NuQklc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="K8GIaqpj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763745162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FRU2qLfbf/wNhvSHqqWH92nPqYewb6NVEbhZtNPwvUI=;
	b=a/NuQklcDbES/wSrBnpqQ4Qx5GQyGhAT7FZMtZV3Qac35+KBCJYy+BQkvj5BJcHOWKyJ8A
	sByHyZEWJBvFWYEuPZyYOC1o1slbiKRMpLVBEgKmsqexY1wUuUgnXadAOmZgGxQkSKClBt
	CqV1q7dQI3vbBowSupvjs8A/IQcXZgQ=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-ruMBE6nsNd29-kQvSWRs1g-1; Fri, 21 Nov 2025 12:12:40 -0500
X-MC-Unique: ruMBE6nsNd29-kQvSWRs1g-1
X-Mimecast-MFC-AGG-ID: ruMBE6nsNd29-kQvSWRs1g_1763745160
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-787e3b03cc2so33528287b3.1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 09:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763745160; x=1764349960; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FRU2qLfbf/wNhvSHqqWH92nPqYewb6NVEbhZtNPwvUI=;
        b=K8GIaqpjeDrEiOedlgcj7Uqvf3/t8g8cTMrGb1tkUTxOiDnEDiu3eRXNs5tbYsf83v
         getj3IFliZKAb3QYO3a6xmsXLJkiQgmSq4nxrM3nr+e67x7p90bfaMojk/L5twjeJABH
         DVfvgvc0YiPm7jH329MX5kRDzLtMmrg1Df8JmJFgEu8ZCozAVh2IFAova/fEK4hod9pc
         dt1TG3jIV/RpaWxLVVI6uXAqw2gc9P3CUJr1D81KhMqNny5953/5QNzPbPiIMh695k0i
         D5SR5Ujin56/fDstB8b086wLqWKciz5EqEZhA4ARo8P/7wLvzaVcVeHSboskLBVMRphH
         txww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763745160; x=1764349960;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FRU2qLfbf/wNhvSHqqWH92nPqYewb6NVEbhZtNPwvUI=;
        b=WgQASJcPq9znH+RNeXpJVnKDWaFCG1YMveP8ytwax997UBB2WWYvmYKrAyIQgt8v5U
         pFNQ0T9Pfh/OdMSRvmttXoiUT1vqFG72L3q9H7FLZ9DzwGzHgm28yJHm6QtYmutF7pWd
         63LlQ2x0E1vj6p7aO3sUeL6vd+jOgzUgomRHc+KvwHUMPrbpHOYDu8wIb389++GzVvhV
         rZeYEWVEdB9/hZ7Qj7b0Z8+fQdFd7oxHYxhk2dZDEdk1Dx3ae54U/XIkoTfof4OzR0Vt
         u2FCy7FJ53T8RKZBie0mL4uI4KS0rYx/R1XzDQN1zrKPprbzRnVs+YBu6Ztq6YNqZeBJ
         6XIA==
X-Forwarded-Encrypted: i=1; AJvYcCULt4PkBngIPfoxY0tkAnDqE+ljfJpSSbmX43HpQdoCyEPHfBhmv6NlF/PZm0Ru4oWZH1Tmn3N3ME8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYmuVT5xirMfWq6rssxPjqe+fVWWDxf1/5WtSAQcg+o8TDK7r8
	zAmhpGOg6wAIrykx6q8Arp3NrRIkKCwiflJiZIh57pHZYd2HAQCvFLoG+7dWVZ5yJ54ND5cxaJF
	1YVPPooEbRrhjsKZusqw0P0w6setrBtYR5Om1CsOl0nNPCX5t1pGqXZRhXLqwIe36/6U3zKp+gh
	6Ym1UnTwaWo5s0homun+ZlVj2veJO1YGec8EZM
X-Gm-Gg: ASbGnctUJjiafYSKQM1dP1rAZrlLx/Vwf73L055qYSrPkaiO/r+/QWzhAana29O3MXz
	78qbBjSGl8bbALYa0I3aVzO4uDyXjzzFybw3xlWA6Yfi+yFIrK17Cl1779hHUvVtMgJrvGzh/+z
	PRJ9ZXaH6gbJTvtPQ8PE1GQHqLFH8GQF39w+XTtVjmJmh/0jEUxipA/d1FjIGK5ubH
X-Received: by 2002:a05:690c:4c09:b0:787:bf16:d489 with SMTP id 00721157ae682-78a8b5681a0mr24167097b3.62.1763745160080;
        Fri, 21 Nov 2025 09:12:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFJMtLvkeHiv5tBcVk8Zunn6fcLBfbMFj2OlEQ7sDWssH1e01yWoO2IMY4KicgI4AI0qMGjQLfshccde2mHq/o=
X-Received: by 2002:a05:690c:4c09:b0:787:bf16:d489 with SMTP id
 00721157ae682-78a8b5681a0mr24166847b3.62.1763745159764; Fri, 21 Nov 2025
 09:12:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn> <20251121081748.1443507-3-zhangshida@kylinos.cn>
In-Reply-To: <20251121081748.1443507-3-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 21 Nov 2025 18:12:28 +0100
X-Gm-Features: AWmQ_bnhlFe4bz2evbPrSI0Jb0EHnrWDpAVAemzJqi8jgCPnPPGI5CuseKDcbLY
Message-ID: <CAHc6FU7eL6Xuoc5dYjm9pYLr=akDH6ETow_yNPR0JpLGcz8QWw@mail.gmail.com>
Subject: Re: [PATCH 2/9] block: export bio_chain_and_submit
To: zhangshida <starzhangzsd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025 at 9:27=E2=80=AFAM zhangshida <starzhangzsd@gmail.com>=
 wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/block/bio.c b/block/bio.c
> index 55c2c1a0020..a6912aa8d69 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -363,6 +363,7 @@ struct bio *bio_chain_and_submit(struct bio *prev, st=
ruct bio *new)
>         }
>         return new;
>  }
> +EXPORT_SYMBOL_GPL(bio_chain_and_submit);
>
>  struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
>                 unsigned int nr_pages, blk_opf_t opf, gfp_t gfp)
> --
> 2.34.1

Can this and the following patches please go in a separate patch
queue? It's got nothing to do with the bug.

Thanks,
Andreas

