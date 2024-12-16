Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D1720011D
	for <linux-xfs@vger.kernel.org>; Mon, 16 Dec 2024 09:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734340806; cv=none; b=SAeh2cuIlm95+rNTx8MLFbJ0J9fH4XE8KL/zVMaPfQWX7+kJVO0o85w1U5pQfkvwZQJiPO+eHirmGtuweIJ6NwRA1khdfQhn97L4M8wmOI4QwL37Ds3iCDHtuLLnDr2PHpsJPcWS+bSLQU/Xf4jn+G6E3ZEZCEJNJHupJtX8FKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734340806; c=relaxed/simple;
	bh=SGBEAsUHACZKRtnAOJcCNoz7Lrs3l/yvocjvK+XS87E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZrpryjBatB+Q40Tc91sfkX+OPvyWQ4xFPJjWVuSpBeYPFMvn7M0ZjtUtE/BR0dFzhucfAlLY54nr5SRrLqbWSQARcpJvEyF8rVfcZi4+9xeHDKmdscq9y4xCMzm2NgkONZct+RsLDtEBe9BC4bfJbS98FNitLNWVOpdM9wkaI5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cjv1v70A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cjv1v70A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734340802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ezr7V8tPAUqIcpXhm7ZLFTCr7/A1YkJY6xjiiBqkcIY=;
	b=cjv1v70AV5UoPCN4ePqYM8z0tEfyKAzVg9qe0Sm9ZRQAvBiHTDbVMimKJU0ED0wF/02065
	u9LX3fOd0qtoI2nMcKLsVyNgaOZgeyKzuE5iTb7EJPDvAtLdvBIali1p/D8WL7qmQtpfqw
	M9FGrQ+nXVP1/YnhlIc4T16D72jTWG4=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-AE7SpjiPPEm_i91Kfbb_og-1; Mon, 16 Dec 2024 04:20:00 -0500
X-MC-Unique: AE7SpjiPPEm_i91Kfbb_og-1
X-Mimecast-MFC-AGG-ID: AE7SpjiPPEm_i91Kfbb_og
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-84fee7916a9so370671241.2
        for <linux-xfs@vger.kernel.org>; Mon, 16 Dec 2024 01:20:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734340800; x=1734945600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ezr7V8tPAUqIcpXhm7ZLFTCr7/A1YkJY6xjiiBqkcIY=;
        b=YoEToD1OgO2Zl2vlPAoPx5NWDj+Ze5xadVozsoxym6R+3Tx90e2be4lBbZDcr13IjE
         kjsMLu6gkmcC6Uhfpl06Ea0OaSEnG0urHZEzF5NFSUEu1TCRZGBm8RaGMMTVuOgVX587
         cShPsbELcZdOxYDVSk0z3oI+NrE+KEmgYx0aUF+lMS7F0xIUF0B370L/QU7VgipCGoH5
         RJezou7LmwxBM5ZVy3Vw47rbN1xtUbSRGk9CKOLye9m/dLQoM1MlfZffOXcbtEkH90ar
         rxKPEZ/XQFAnFqrjKcAWi5+lzR9DLEvtLnR3UlEEAJ48ufmLigkF0umKosSh+Mn1BVpq
         K71w==
X-Forwarded-Encrypted: i=1; AJvYcCUWvN8R1ZVZKf/poOp3/hGOOiEsPnxC5POGALSNwo1st9iR7S1KkEOtA38UCgIuFuJdv5pbX2ZpYA4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNKWOq6T0ywbQQBzK4DhJeazDykJShlLsd/kf/DIK75A9TPgyG
	UdAzcrxUz3CJ2co9Hab4f4fX32xedGuX5ftBkQ6LuelznkkbvDOu/f52F8BmHA/6m4nKtYN+Qkq
	nf0zRppPgYWSlIIkBAtD924vegShNFS177zJ/mly85PkGW6YjnstCR2+MvOSF0f6hPyQ/iZNIH6
	wCI8Quds5sJ99/UaxI02pYvp3n4hXFbutR
X-Gm-Gg: ASbGnctj914lHbuDIBXNdYJmqtogHaMVmGbhHDG89VyzIKccgaEFcDEHYGV3qXv1dM/
	O0bMlTQ6f9zt7hNm3PJRuuP0+r8y3r3o7vwYHOmU=
X-Received: by 2002:a05:6102:f08:b0:4af:ba51:a25f with SMTP id ada2fe7eead31-4b25db0b0a1mr10592480137.20.1734340800316;
        Mon, 16 Dec 2024 01:20:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHhbzCeU5B+2v+R5K9FoBsbiFBRDBPbH+QRMgzW9zb6TVanCU3eaUlsdbe1uzLeYyZBNEEYYFyZyTin529p1eo=
X-Received: by 2002:a05:6102:f08:b0:4af:ba51:a25f with SMTP id
 ada2fe7eead31-4b25db0b0a1mr10592460137.20.1734340800088; Mon, 16 Dec 2024
 01:20:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241214031050.1337920-1-mcgrof@kernel.org> <20241214031050.1337920-10-mcgrof@kernel.org>
 <9fadee49-b545-440e-b0c9-e552bec1f079@oracle.com>
In-Reply-To: <9fadee49-b545-440e-b0c9-e552bec1f079@oracle.com>
From: Ming Lei <ming.lei@redhat.com>
Date: Mon, 16 Dec 2024 17:19:49 +0800
Message-ID: <CAFj5m9J0Lkr9hYx_3Vm2krC9Ja5+-xjmqkqjVjY0jvimjWbmTw@mail.gmail.com>
Subject: Re: [RFC v2 09/11] block/bdev: lift block size restrictions and use
 common definition
To: John Garry <john.g.garry@oracle.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, willy@infradead.org, hch@lst.de, hare@suse.de, 
	dave@stgolabs.net, david@fromorbit.com, djwong@kernel.org, 
	ritesh.list@gmail.com, kbusch@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, 
	gost.dev@samsung.com, p.raghav@samsung.com, da.gomez@samsung.com, 
	kernel@pankajraghav.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 16, 2024 at 4:58=E2=80=AFPM John Garry <john.g.garry@oracle.com=
> wrote:
>
> On 14/12/2024 03:10, Luis Chamberlain wrote:
> > index 167d82b46781..b57dc4bff81b 100644
> > --- a/block/bdev.c
> > +++ b/block/bdev.c
> > @@ -157,8 +157,7 @@ int set_blocksize(struct file *file, int size)
> >       struct inode *inode =3D file->f_mapping->host;
> >       struct block_device *bdev =3D I_BDEV(inode);
> >
> > -     /* Size must be a power of two, and between 512 and PAGE_SIZE */
> > -     if (size > PAGE_SIZE || size < 512 || !is_power_of_2(size))
> > +     if (blk_validate_block_size(size))
> >               return -EINVAL;
>
> I suppose that this can be sent as a separate patch to be merged now.

There have been some bugs found in case that PAGE_SIZE =3D=3D 64K, and I
think it is bad to use PAGE_SIZE for validating many hw/queue limits, we mi=
ght
have to fix them first.

Such as:

1) blk_validate_limits()

- failure if max_segment_size is less than 64K

- max_user_sectors

if (lim->max_user_sectors < PAGE_SIZE / SECTOR_SIZE)
       return -EINVAL;

2) bio_may_need_split()

- max_segment_size may be less than 64K

Thanks,

