Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF4432ABEC
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 12:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764334659; cv=none; b=hWcuBdDpFGDwhvJHTUBCd+hnSb5m5dSnpYAK03aDpSH5QaG0PwWsfd5N8KY8enB/4OUB2qv60LjxjuAAEAv9TeLubJm3SSSKtlBZSlCn0A/xib3ZOPzSN4ERJDCLvIdSTYdCjQR1u+YB+IHvx0Huy9KD9TF7M/zXQx9hXqEsOPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764334659; c=relaxed/simple;
	bh=77RRIbnmoJwy1cEKeO1cRn3JJgXHE29OKRRM9cIvMcc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MMbbP7oB97N99SbGkAFGf86EOlP+UFZ9Bhj+s47uu+dNw8M6DcQQN1FY+vfeokC77FlIj+5lUgMpfVgL8/bB62RxhtD71obfUpWoXzCTMiSBfyVC649gvkaRYdS7P819/34Mzflf9WGe/2e0ULZ+t/HVBPrli6k3ahR9NjIcYfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eqGtPdEJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KkmTyH/+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eqGtPdEJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KkmTyH/+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764334655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k2NUtFfF9SbHj+pN5h7ZLsSymt83AD97eoXiZYz42dA=;
	b=eqGtPdEJ27UP49AIWSoGhqx3ahsyvnrQiOQhYP1ZdyQwTXcEviCdg6ZNVKwpUbnqreNB9f
	qZ3RdIPMgWU5nzNRfCaCAksCgGIhROBnVFjWZZ58I2kb0DhIlAIDIFfZXIMaZJL89uO9PP
	sRmQBWHdY3mROQAuySMyzMetrhn7IY8=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-hYFjolzQOEKj_C0JX0Ijkw-1; Fri, 28 Nov 2025 07:57:34 -0500
X-MC-Unique: hYFjolzQOEKj_C0JX0Ijkw-1
X-Mimecast-MFC-AGG-ID: hYFjolzQOEKj_C0JX0Ijkw_1764334654
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-786a0fe77d9so24475567b3.1
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 04:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764334654; x=1764939454; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2NUtFfF9SbHj+pN5h7ZLsSymt83AD97eoXiZYz42dA=;
        b=KkmTyH/+YC8Pr4pIQyvVOsSh7/2QgJLBbxgIZuOBDms7KR0jqwCdQJMYK0noUZabxW
         vW8EAUlW+I8yoPMRzsbbDc3BUEBQhAU4HonDoHxc1UHSxUCbI9D97catXteU/hsdKV8Q
         ghvO4e2HPI5CtwvSeOTymnEKR6q3xn4yE6kaKM9Cp8R7wy8mkAbjS1FbExKgFNg8lEne
         EFTD/D7wom7Pm1bnDbG9EL0phHFOL1uiNXahyh1YTgrj41RoQ8bsb7BZI66wvhqLAQiv
         IsIlXGncrulI4vLTi8kEkyLyfe4OJKN0fUtfD60sUZ6W8Wk3aXd8IlwtoXYIx0BO9rPl
         HcZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764334654; x=1764939454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k2NUtFfF9SbHj+pN5h7ZLsSymt83AD97eoXiZYz42dA=;
        b=L++LJFWAwob2t6j8KXYQSvSw5FIMuvwVe3G8ZpLSaljBd7RdIwZwqa6QKd0Q6BrxEv
         0tTpwrOhUn0L2GaSifgdiPp7d9UbNJ3UI0uegnFJ1FS11s94778Z+u+aU3Lp6HBFSVmy
         pf3RVRFooT+9bVkrjc2UdKOmQg292htisk9d9opfg1g/dtHnPfkiAYqNCoSEenABXZl3
         xu6P7DudnQ+USw4G2JzpkyRGwWg6Al8fGzFChYKzEASbpqmbuAYXhij41miDrgnEsDoL
         yZuWgaucnVslj7X2UjyzGnwjeVo1/lID6KMnd9bL/JE1lmpndAmfSuRCBtd2j5JjSK5i
         Vk0w==
X-Forwarded-Encrypted: i=1; AJvYcCXsl14KqyTuqY1SSR6bBjiq0ypRzNd3lteeu4oroh9ZkPBBXz5zL7Id33QGDKa+TCR5jFWBOGc6zm8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRwd47muNVZlfTNZ5i6wUOnZfI5I1O7HceOUNZTtmptwK6fOyN
	upGSYmJDMtyBfTYbX2Ks5UInjekztixFO91otIuc32Wta9Na5bjwupLAGnpuWROhK6IDH2XjpOl
	/kMQ2IWabCZIcP46fn0pmpEgQ9BIdLtX8ztpd5awj2UL9L/cGV4WnQs3HB4aoE2cTFugrxT9k3p
	SA+WGhYBKkTSOGF6QjAhGNuUcoev6Xo+d4bwIT
X-Gm-Gg: ASbGnctZDoB/wB1cDFcQzByYemBklwwDqBMUMRtK6RC+MzStnCD6KZIozRP99VY81bM
	hGl7piZsN/6OCjM40igxM5thvULnxGmQC0OOfhRyPhP5Kum9t20LkOth3CeXlLpYZX8uF6EnIA6
	uk46g/ceVaXClXdCPmU/QHxfqA8YgHFnCpsR66jtl8M4A8bZoaU9/CDp5snX7wPjp1
X-Received: by 2002:a05:690c:3348:b0:786:a967:5a8a with SMTP id 00721157ae682-78a8b521351mr209364527b3.51.1764334653929;
        Fri, 28 Nov 2025 04:57:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFYKB1oLuPGJAVoxdwBsDfFu85nnaWrR7frU4rGijoJHAkyVO4VlXEEBnQXgKFqXNy1QVvTkGpWt9+fdpViZKM=
X-Received: by 2002:a05:690c:3348:b0:786:a967:5a8a with SMTP id
 00721157ae682-78a8b521351mr209364247b3.51.1764334653580; Fri, 28 Nov 2025
 04:57:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-3-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-3-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 28 Nov 2025 13:57:22 +0100
X-Gm-Features: AWmQ_bncrRsjrklAzt9B3bsSktqMzFJHIbAcDYZydnWE535duaAjUcuyPEWTG9Q
Message-ID: <CAHc6FU53GR-FTPzWSuxQumJXX7z6HrzFGo5=kfA1VHt3KxwNOA@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] block: prevent race condition on bi_status in __bio_chain_endio
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, siangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 9:32=E2=80=AFAM zhangshida <starzhangzsd@gmail.com>=
 wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Andreas point out that multiple completions can race setting
> bi_status.
>
> The check (parent->bi_status) and the subsequent write are not an
> atomic operation. The value of parent->bi_status could have changed
> between the time you read it for the if check and the time you write
> to it. So we use cmpxchg to fix the race, as suggested by Christoph.
>
> Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index 55c2c1a0020..aa43435c15f 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -313,9 +313,12 @@ EXPORT_SYMBOL(bio_reset);
>  static struct bio *__bio_chain_endio(struct bio *bio)
>  {
>         struct bio *parent =3D bio->bi_private;
> +       blk_status_t *status =3D &parent->bi_status;
> +       blk_status_t new_status =3D bio->bi_status;
> +
> +       if (new_status !=3D BLK_STS_OK)
> +               cmpxchg(status, BLK_STS_OK, new_status);

This isn't wrong, but bi_status is explicitly set to 0 and compared
with 0 all over the place, so putting in BLK_STS_OK here doesn't
really help IMHO.

> -       if (bio->bi_status && !parent->bi_status)
> -               parent->bi_status =3D bio->bi_status;
>         bio_put(bio);
>         return parent;
>  }
> --
> 2.34.1
>

Thanks,
Andreas

