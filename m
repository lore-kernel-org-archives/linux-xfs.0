Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D5B32ABEC
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 12:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764334695; cv=none; b=GdB4oZ9KKDaSCs3xgOmP4kP1jBXytEx3ruEXzdUgR4bV+NPrxakknlgvDIgS92TsJy/l8EvAOTJ4ecZsE2gFgboj87XLduIsOAYaoI9Q9kgOlnPYcK3bLbZbPTaFzKOyqS1DKfdmCTDDZPoZHsbNnmG5zB8WB8/ww70u7WZj+GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764334695; c=relaxed/simple;
	bh=MuFoqSXPuLC7mZdpb7+pS1mI6Pzog4fHqbrI6/r2Fik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F9LZwtNWik87LvB2kRW+EKK8yasB4naytRQgL7JdCbCd5Suj6yPJmXKK4/YbUWvkqcKYCAMRPaeEVFIgsEOloXv4oKCfaCeLqf+gSxCxU8Z27ezRuwkz/uy3ywKkVtH8rdt4k6/v47sl8eVXwTZZ9HUf7xBGKw6hX9yH3QqQ6KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mj2g24tI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WPWcoa9K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mj2g24tI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WPWcoa9K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764334692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nNammxq+ggHJRHkPcyBw0qZgJjTAIfnPB/5V2CCXd5w=;
	b=Mj2g24tI+acOxQu35v+EYQpsSVFkCUr9xya5eWbGTnEq5Ptt0iXbuMKNI5sARly7lT6beO
	85i5tEDjgAZtWQ6SNhizFaZTlSLOgA98dMFOtM8c9bNsRxT5D83ekPgfAndofj4bcT8Ths
	m2uHI539a6BiWSMEt3fucZZiGB8bneQ=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-6XaB7A0MOrauzb38rVY8og-1; Fri, 28 Nov 2025 07:58:11 -0500
X-MC-Unique: 6XaB7A0MOrauzb38rVY8og-1
X-Mimecast-MFC-AGG-ID: 6XaB7A0MOrauzb38rVY8og_1764334691
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-787c609417aso14464717b3.2
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 04:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764334691; x=1764939491; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nNammxq+ggHJRHkPcyBw0qZgJjTAIfnPB/5V2CCXd5w=;
        b=WPWcoa9K2JrOd9FDfgVkzocSG7sIh/Sb3C9vxn/L1H6MGGrIBNlnWd/ZCJ0pHJL1K2
         Evidr0CTr+HE8pVUeTKfSXLZuQpDrERIbsMyI3sxa+pcP/2M5IulrB1iBVr1uKfEFQ9J
         u9m7Q+NUZkJXnkQwDgWe1CzoD9ZNnQSCVW9UlhQBdeww3TckJu00QyjYwemY8O/dIOre
         gVRG2NC95/0Fx+4M1fKiWpOKaWlSSPRpSXTw25Y75Kab/VTH2P5H/pnhcOwcaRhTRwHM
         jFIC/IySLQO86vdb/ma9VqciHHcNwo55Si+W6YOgi+DZfOxt6HMmwRwnC+4jmTRAYEQI
         UdhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764334691; x=1764939491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nNammxq+ggHJRHkPcyBw0qZgJjTAIfnPB/5V2CCXd5w=;
        b=u/PxsPI4LvZOBBU4Zcvg691ZEa9n3O4D2Zl0Cfvdq3S4rsd3N37Kf057j+CxI73OUZ
         9LRk9zrZu/gWpQ/rhMWincvLmT0BQEcxwS0z4HEZuDwSwXKNq3cb+Nr+5e4mM15HkXWD
         jv6u/WLFY3BCwrTjki2ltytnlAfsoNTtNQ18caUTif2V00Yz5GNNkaWqI8BJkVeWDG6X
         fFv0Em4/R82uGfovC0R6LRM3qUWlzSvC4Bc1OVJ+tJAJgA3yZxV86EI+O9Sl3mJbYr+G
         eUaJaEgP+QN96rQiZY1lqo/ymqFddTm0w+10UlNtw9qLbr6aY0ZbNJFzzRyIHYM2OVaU
         /LjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgTvOje9fhV6wShkqwZ/Sbb+XOPurDptmeguuP9Tp6vyRah3ZJFTyf1aK2V3WlRwIp37/ewoQtP/I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrQyKlILPkq6+6VxEgMB/I4Xco0FTqkh9qhmjANqGTVy+BNg6q
	vrlTVSTzXWSl7nakbypk1f9AIqjnaCE+vpiu8PNQpCpP1qxnzstkNulG3GB4LDu7nvFB+WoWEj9
	jY+fh+RWzzN0S7nqdy5kc+T09GSLhy5RGJr5ARg4Q5pKZhLX9tKJO+N4MWgGilmInpm9OYytzVn
	lM+2e7HuquJtPVtxrjHcnOK6D0rwV6CX2Hx42e
X-Gm-Gg: ASbGnctMligXsQY5y3CXi0o29InfjyXPneIx5LzGHeYSlnm3FwtqMrAo3Gwe9BX1IzI
	A7V+pJ0V127xhDuh6wSoATplpn70Jzs0ax+3mHmX5sWm9whYmSNyfuSKnFGDtgmN+vGT6meYWl+
	8765nA7TZXoj2Khkp/lSf8J6KZd8gRwFRGjcqzA2/Yjvnb0HvRXG6DZ23FQvOKopGY
X-Received: by 2002:a05:690c:4c12:b0:786:68da:26d6 with SMTP id 00721157ae682-78a8b47f539mr225392587b3.2.1764334691009;
        Fri, 28 Nov 2025 04:58:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6o2vx3XDXGg+LlkIovRC1qPDpHivJwIyySPFZW+LOu2PT9QpULnJt3ZozP3PJjgQPuJtToIp2pCOkRf4ONwA=
X-Received: by 2002:a05:690c:4c12:b0:786:68da:26d6 with SMTP id
 00721157ae682-78a8b47f539mr225392307b3.2.1764334690627; Fri, 28 Nov 2025
 04:58:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-5-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-5-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 28 Nov 2025 13:57:59 +0100
X-Gm-Features: AWmQ_bkpqINzOqnBww77x7L-xnpoIyN1fhsiEmRMn1madN6s7Ak0j6O_sI0bIl0
Message-ID: <CAHc6FU6dmK1udCgj9vMj1ew-4+bZOK7BA47kyEgONEwGg42veg@mail.gmail.com>
Subject: Re: [PATCH v2 04/12] block: prohibit calls to bio_chain_endio
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, siangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 9:33=E2=80=AFAM zhangshida <starzhangzsd@gmail.com>=
 wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Now that all potential callers of bio_chain_endio have been
> eliminated, completely prohibit any future calls to this function.
>
> Suggested-by: Ming Lei <ming.lei@redhat.com>
> Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/block/bio.c b/block/bio.c
> index aa43435c15f..2473a2c0d2f 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -323,8 +323,13 @@ static struct bio *__bio_chain_endio(struct bio *bio=
)
>         return parent;
>  }
>
> +/**
> + * This function should only be used as a flag and must never be called.
> + * If execution reaches here, it indicates a serious programming error.
> + */
>  static void bio_chain_endio(struct bio *bio)
>  {
> +       BUG_ON(1);

The below call is dead code and should be removed. With that, nothing
remains of the first patch in this queue ("block: fix incorrect logic
in bio_chain_endio") and that patch can be dropped.

>         bio_endio(bio);
>  }
>
> --
> 2.34.1
>

Thanks,
Andreas

