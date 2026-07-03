Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995524C97
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 00:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783037202; cv=pass; b=YzyY1ETclzoA1ufwqZIclfByBBAH2IVpuzjMIwTRw+BlkwbgI3qU6tBbKqBFDST/KwshOIaOqMHocEhdArdg/s4u+6f/nwGIrYPk9iHF3CvJpezWIy4EQITqEsit6j0GFUW7NNNiLJv9mG0Ir6YtnKV0u8PqWe/K1P4Q/tX93RE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783037202; c=relaxed/simple;
	bh=gslqVT1C4ZAxfFgX/Lm3Op7ina+YCPCXFvipiwlHJKM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fUFgTxnHDbHImy7uWVHuEXXNMOlKHIzJVe3I9FkNO+VK/aOMULPpxS57R8WlLeUyLtlvxoNHbvR8FoTzWsS4roUdZ++nh4QpEv0C0oSIHLYfUDw6VmnHMtdhc9CbIDetDMmnbGUzE0OGZMuc4gqW/P8FbL5bGgt/sUTUlTH/y04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AVgJB4Vt; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AVgJB4Vt"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493b691cb44so16947055e9.0
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 17:06:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783037199; cv=none;
        d=google.com; s=arc-20260327;
        b=e4mix6lBlTomjDDGom5eCHq5HThax+CQQFRQ0FttZPWR0zjHK/4BkfOW3gu/eUrVi+
         pKW8KFGJ3d4a2n8oAL3BrRqWl+Tl67w36/41wSFP5X3p272ZI00H0w7yl9UW1CWn7Hrn
         VpvLzN8iAqSLH73Ai2bNRDK3FQWtHzT8t8t5/vh7RLzdcGQdPSVFQdX73ftMI5YZZbs4
         +TuDPTN3AEObXxjtRBp02Cumee0XKdw1K2uIz4WYCVEkSH02eyVOHCYrFp8dPbMnFc0o
         Vr4toWMz2qRYfbB4x7Gmsse0DLN45jNN/63EpW1EC4YBOVfSxXSK46yg2gYADuFpAaIE
         +xBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=S5DS9XhdwYciT3vOVgdq4aobfOtX1mJihQgroHMwxY4=;
        fh=0NIvucazQ4/TKI+k7ebaDitMuNrAwAjFDeWH1JzAe4c=;
        b=ExlzKc1wvNLl6Y1fVmdGBi/QZfX6SALl1DGuN4yJN+bQVw8JD4QkO0l6OlQxPU5Uhm
         U7Er80Nf3MDt6z7KhoAtrkKMSxuaVeuwaokz/ksNj+vqCv55whcQ4/D+gI8ItN7pxA5d
         bfy0vBxV4t7srT5s487YsjmvahXQ34X56/wuGacbt79hIFmvlNjuoss1iZhhOw8s8L9r
         BzkCf8/9b3IWtnekVI9SZK65Jp/rRku7dwZgCimOyPQUgum19ARnIT1z60NIOQ4wPbGb
         X9VNfu1t7f0MjNLM81WskVejoE+70t1qeOXAWULrA6Bq5gSNCviRJ7G0oVmcUwRs+1ny
         8Zkw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783037199; x=1783641999; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S5DS9XhdwYciT3vOVgdq4aobfOtX1mJihQgroHMwxY4=;
        b=AVgJB4Vtx27BcO1cdm5VPuhyft+sx1vbQjIKHjikjMs3dnbZCKjrLRwVIM0F82Vgsh
         Zlk4TqaBr8IH1nrscltvcgU84AkaKC9lglxNZt3ZW0hHoIGEM2ds3TLsTjrMU1vziRDB
         obwI4W3FpS3n76EF05KUJ4CRPXKvah3HjfKvZRYjJCXa2cMHm5VxSe27eir66OprVPMI
         V1MxZ6ew2nFkEQQk9TUMIz2ElA20dBwYPcFdDYGUc5ioml+o5YzMIoa33Wn+ZiCkUeIN
         Hq5I2o6sQ8Nuacr5iYhX9Ff7ZTUhsbObNEVb7AmMqIWQWLwU2vqGM17ukNUCra8xHT/y
         GXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783037199; x=1783641999;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S5DS9XhdwYciT3vOVgdq4aobfOtX1mJihQgroHMwxY4=;
        b=QVTVRTfegkUkAaPx4bNo7q/Dqj3+iTfaXlrGHHBuhZ15Pxc7t2sNum7qQ6TNASpoCM
         pw5P7Bq5gu/FiEvaiKzZz0+S9Ja/6zjQkRHAYM52RqZ8QNqqRUnADJqqTNEJVG7O3tLt
         Lr9UODZQwcjAA93d3kmHPR33jkg+hYLVAY4huEx52BBOi7mqF2PXc0M/jnACvn3hQFwY
         hAj+HBoUBQEKSQKXyVJzw3Mg1s2ATZ6QZBeiY10kHQfK/2FXT5llRTjL3hlHrXoDL0hU
         Kd25usXdcyXCiKXNjTurefm12d2Ecppuy6b4z+NDVx8tH1Px5W5pkRw4JjIl4fRkLsRs
         Oi3g==
X-Forwarded-Encrypted: i=1; AFNElJ+RlWmBQbK9kUm2z7c1q8J+5454U+Qd19MZ3OkqyN8w+jEBuEMmUOkV4NtI9E4Jvkc73Odoza7z/jo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjKspYDYdtiRVZdrXbWDTNdPFRht95jhYuaXkjArUVpkHHndWQ
	A9BRJTK31n3ByhoncAp4819AdnzAGWA4aJMoFVuIGNzG6rI6es7sug2nkKoidmjLAp4p7p+NLYo
	ne9skNGSagC5uku7vruaK06IUU7oJ4TU=
X-Gm-Gg: AfdE7cm/Ari2CX/LmU1OxYHy9Mtd7AsHP5CBcsuFOK+zCO3/CiJjGAer+17fEN4n9jd
	bdewP6i+v8wt1P6UVpTFE0G8qeaLCImzolIRuClaDat6XiIgRXkMZqJVTPPQBoosALCVnCCB/ZQ
	qwP5bsnS0mDgd0lr3s+SpiVIS4Hiq6MDM1e6K0gRlorAZD5e/pUylEYHa8gsvj1ACLJrXfmXl3f
	tJSE/zYvei/1cWvs4A09W8D8DUwHnE10tARN/fa9nRFOtPYlxKwM11n8UPdzbeiJ16RVTnw2QZb
	MJ5xpZsKIElwpoYnwL76hkE2iVzCYztz2gnhWpsQTkfQP/LugwrR
X-Received: by 2002:a05:600c:5808:b0:493:aa0a:45b0 with SMTP id
 5b1f17b1804b1-493c2b855famr82697505e9.23.1783037198482; Thu, 02 Jul 2026
 17:06:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-11-joannelkoong@gmail.com> <akRlehPHzy-F_105@kbusch-mbp>
In-Reply-To: <akRlehPHzy-F_105@kbusch-mbp>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 17:06:26 -0700
X-Gm-Features: AVVi8Cdk_C73wAd0LEg65xZ99iaBn5MPuJR0EWtJiHzmTYc6q8IOOPpqNnJDiic
Message-ID: <CAJnrk1b2T1GiWzvBKaBg-97sEZ_9SA6EVEUO=9CknK1vS3oJ8Q@mail.gmail.com>
Subject: Re: [PATCH v2 10/18] block: convert iomap ops to ->iomap_next()
To: Keith Busch <kbusch@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	"open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 30, 2026 at 5:55=E2=80=AFPM Keith Busch <kbusch@kernel.org> wro=
te:
>
> On Tue, Jun 30, 2026 at 05:09:25PM -0700, Joanne Koong wrote:
> >  static const struct iomap_ops blkdev_iomap_ops =3D {
> > -     .iomap_begin            =3D blkdev_iomap_begin,
> > +     .iomap_next             =3D blkdev_iomap_next,
> >  };
>
> I think it's generally safe to use the same mailing list for the entire
> series. There's no context here on what "iomap_next" is because I'm
> subscribed only to linux-block. I found the rest here:
>
>   https://lore.kernel.org/linux-fsdevel/20260701000949.1666714-1-joannelk=
oong@gmail.com/

Ahh I see, thanks for the heads up Keith. I'll do that from now on.

Thanks,
Joanne
