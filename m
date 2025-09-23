Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95821F09A3
	for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 15:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758641981; cv=none; b=BKIzqS6bkv2omPrKgubZ/hifekBbcd9eAwATUJcT40MwGr7mPro5/8Cctvlm7pryxM3Wp6IJ3AwpIVhg651K004vQrBPafRBj+bWY5LwNtzE9j3jDoAV0rqza5/1xDZuWAem1wtEQf+L/T6c9PJnBo4MGmBoFacj2zKIimds+FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758641981; c=relaxed/simple;
	bh=leaYlnpusCp0sviLQ30QGe0J2gUEvF7RJCcVhGVbZ14=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LjhhlVyQgAIoDWk/voNi6RZdG3iA56mt3DkP031DpJXwXqdg2S95CiNAX6dBL3rUtlmFM3ZD92YYOCDGmzTshMkT9ybmdRMej9C1oLl/TsAJX79IYw7P36+7lkhKwDb0Y5UlNi5zH8VmPUWBilQ7OJdx/H9iRCC8LT7yLUz3NVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=XFBsSAOS; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="XFBsSAOS"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b7a8ceaad3so56348241cf.2
        for <linux-xfs@vger.kernel.org>; Tue, 23 Sep 2025 08:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758641979; x=1759246779; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DZbdjr9165OSR3oEX8S38orQ1XZpFhmOJaG/L+oMydw=;
        b=XFBsSAOSkNNBCgIHM/jKfQNGj4uSj9EQlt0cFgJHkFOyOKC7kmCDBKNJMj2KeN6n5y
         v0HP1/T1smZv3jtMbwDhmrogOyQV4/yerCIowlzcsLDu251YPlVtiAaqBbOETPWQ8Mbt
         Ua9/zrGmL9NHQRBwrwVHf9qE05S6H3Sh2DFCs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758641979; x=1759246779;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DZbdjr9165OSR3oEX8S38orQ1XZpFhmOJaG/L+oMydw=;
        b=GtOFJq8VTzP+12nORnJnkhMNmEQg8UVfH78ef54NQ0L+5FfMR0rZy2Wc5apbBt9rsQ
         0iPrWeuWdpxuh0F6ORRF1K6ChafMHG3Sg8tIkuJ6Hj9PKBBz4KhPC0szJ1d5xTkdIrjJ
         LxEPbsfUASZLajsfmF4SdqvXLBpHexo6OjYfuLzgOXdqL7sHvlVZ5burYDUf38CJiAMt
         fO7WFEWntKU6lsxppbM9bGMyqNrSrv7jKGxDl9vT5YTJhr7Nx00IIQ3NlOqkL655FweV
         oTNl2s5gXBbAWMVyvIHo97BCYkLyZvkac4QrRdNEpW71NKcjnlbGoK/meEuYmnV5RKbf
         Op6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVV88jC5h2vYpXxuH8+xi/d5eFGlMr1xENXXnqB0W+8j34TFvDFIeRcyJbn4y/2axBMGqLcKFuyhnw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxAjC/zdudaL3+DDaFy0qG0183tY6M9YBCrUNgeOZJZ0mlB50O
	9yoBQMXoOx/7vnAA2qkYd7AZHlJnVBnw3OMh36qRH81GxHoz7yGN2P04dmZHTGzxry8x2KF0C6f
	bG/1k6zflxuMpQsZCj2wklaDrTRSyTPf/yIPPtCqpJg==
X-Gm-Gg: ASbGncti/TLxmhzhkYr7edsBTHBAaDajwtfZP6GQhtPZXwrqddYbXmzfKSElusrxWlb
	h4zD3suX5QeIEWCkuYXZAxmxKhlv10HZKmbYrDaj8jat87bzfhzvfq+FtvLn9Ny840KlFCQxWkV
	wXvPsgCGv4XRd9Aako/rgcEmXGklmFrSp3F//OnVTb5dDK5iw+NPR2c59r17nrCHGnXbWTd4H8U
	l/rPshw9e9zmhdZdzCX/aB8bxHD84+0zfJXmYEU+pknnyvDIcSdfM+y1OkxZbmb6933Th8W/cW4
	JTbZaYI=
X-Google-Smtp-Source: AGHT+IGspaeUy0TVQz+LKc1fihw58Q7yPvQbyT2d42SL63rUJcZogQsEDyrgJGDuBFJvNYzyLCvEvUn0X00pmc3DhAA=
X-Received: by 2002:a05:622a:1b13:b0:4ba:c079:b0d8 with SMTP id
 d75a77b69052e-4d367081860mr29707731cf.17.1758641978539; Tue, 23 Sep 2025
 08:39:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250923002353.2961514-1-joannelkoong@gmail.com> <20250923002353.2961514-14-joannelkoong@gmail.com>
In-Reply-To: <20250923002353.2961514-14-joannelkoong@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Sep 2025 17:39:13 +0200
X-Gm-Features: AS18NWD8_t8WUM8mJa_Wrlt8XR1hgYkR6Ub6lG20YNejgtDUqRhxsnnPFLDpPVI
Message-ID: <CAJfpegsBRg6hozmZ1-kfYaOTjn3HYcYMJrGVE_z-gtqXWbT_=w@mail.gmail.com>
Subject: Re: [PATCH v4 13/15] fuse: use iomap for read_folio
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org, 
	linux-block@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-doc@vger.kernel.org, hsiangkao@linux.alibaba.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Sept 2025 at 02:34, Joanne Koong <joannelkoong@gmail.com> wrote:

>  static int fuse_read_folio(struct file *file, struct folio *folio)
>  {
>         struct inode *inode = folio->mapping->host;
> -       int err;
> +       struct fuse_fill_read_data data = {
> +               .file = file,
> +       };
> +       struct iomap_read_folio_ctx ctx = {
> +               .cur_folio = folio,
> +               .ops = &fuse_iomap_read_ops,
> +               .read_ctx = &data,
>
> -       err = -EIO;
> -       if (fuse_is_bad(inode))
> -               goto out;
> +       };
>
> -       err = fuse_do_readfolio(file, folio, 0, folio_size(folio));
> -       if (!err)
> -               folio_mark_uptodate(folio);
> +       if (fuse_is_bad(inode)) {
> +               folio_unlock(folio);
> +               return -EIO;
> +       }
>
> +       iomap_read_folio(&fuse_iomap_ops, &ctx);

Why is the return value ignored?

Thanks,
Miklos
