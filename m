Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E084277F11
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 14:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714400457; cv=none; b=VSnTZxQxRE4BX7BGEZbpoiAXRKtakiNntRJak2848YGGaZWyscwum45dLag7VmIg9+e22m/dQVzAxxUk2RGitCnVUj8FWnDiT9c28pPGJd9/6rGTQvkRzM5A5Xa0AiA7hgsDtMylYIB46g40TyqCt76UfJIHyP3jnpUgDx+cOfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714400457; c=relaxed/simple;
	bh=oxcjuCsClzGt7kG7ieOC9UZaB1ndAR03opK5HDsYqbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O6x0uZx/icVlbEDNhzJJ+ouEWm6l/zoeKBwJf/SlmhzYt/LkftDlgc/WSCvjsRYADXKZV/avEUbUI+OyPF2b/5FSyKzAZjf6MsWhMprNOypMLj74bEYZAOu0UWZaM9F5acGN6YUpTeBrbj5jqCT48+bYFKZ2q9/AnYzs9rTnIYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CKLg7VNy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CKLg7VNy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714400454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uqmGiN5NrDbqqE/DWJqb5zJnPTX/FXC/9hqKXGHU6yU=;
	b=CKLg7VNyWawjMe1fODM9UzRQvfaY071SO0k6GO8v8PUOf8g97Ktdqo5JiGnqOxGgMxzaIo
	T/IZS6eMhzuYsJ2JK4IXcAyEc+W8RvrD9/Qz9qmVgY82/nmjoNOjbmxJRQhT15I9XwM7NU
	HekkBT2HLHX6f0QosGbyZTe+xzwFWfs=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-S7c5lasWPVWwiQno6tlqkQ-1; Mon, 29 Apr 2024 10:20:53 -0400
X-MC-Unique: S7c5lasWPVWwiQno6tlqkQ-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-6f3e2ae6c23so3022073b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 07:20:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714400452; x=1715005252;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uqmGiN5NrDbqqE/DWJqb5zJnPTX/FXC/9hqKXGHU6yU=;
        b=cXzaS59TRudPoJsbNSnzpWqLDjd9Ir5ZsKRlCjFLRObarS3jcmuSQSKlaKvoEUJVpu
         tH2qUyD8uhZjJcSjMVMDWn69rdidyQG/VaSkedXw5rkBYi/uzRX4r8sRiH7sB4KXaF0n
         xU/wIhILyDtaKG98nHeWNGIypWK7qZF1zLMGZsbrnUVXmAHkjO+HiIl2rP1hMkwJcZa9
         kS8zrNjkGKk9fvt/XEhaAl7Xk7ztv1vG90bROvrQkL7j3o2HAKzTuU26DLOU7+Xu0+rg
         UVPzXhbBQhDRCku4BfST21gdifxDI9XhNyDfcrihx542EZAXDM0dYFfv3AIwzHV0RAbb
         lMfg==
X-Forwarded-Encrypted: i=1; AJvYcCWvPN3GVs1a7bUKeMMwEhzSYoRr8Dobq1PuWPv/eZOCUXFLAHpGQ5szlClIK4lu6/w1CKt01JK9hbxgFKg3d4q94pwwIx3LA3X5
X-Gm-Message-State: AOJu0YxiXYb6VhkDx5+Vxh14vjliJZkaQHWWLchV8fhMfCZZ92AG4HPv
	y0wtqoxKa3MXxkI7pqoz8o7EWl9HDEvMK1Dby8jSeS301M6VbuUrQeXtdTxLPuL74kAaiclYiFx
	85CBfRrL7TMtF9PZvkQOk6SWcOOV1bdqiMfTr71It9ko9qt4iLmyN00GLiA==
X-Received: by 2002:aa7:88c1:0:b0:6e8:f66f:6b33 with SMTP id k1-20020aa788c1000000b006e8f66f6b33mr13592977pff.4.1714400450477;
        Mon, 29 Apr 2024 07:20:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCi/lLJ8ZRLjdiUU3OTGWsavGD1f6c86BhAd33cBWujTb75f9iky46wEjtW4xp2k7WS2ar+A==
X-Received: by 2002:aa7:88c1:0:b0:6e8:f66f:6b33 with SMTP id k1-20020aa788c1000000b006e8f66f6b33mr13592938pff.4.1714400449986;
        Mon, 29 Apr 2024 07:20:49 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e14-20020a62ee0e000000b006eaf43b5982sm19289700pfi.108.2024.04.29.07.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 07:20:49 -0700 (PDT)
Date: Mon, 29 Apr 2024 22:20:43 +0800
From: Zorro Lang <zlang@redhat.com>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: remove support for tools and kernels with v5
 support
Message-ID: <20240429142043.324fmguwtqyouuwb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240408133243.694134-1-hch@lst.de>
 <20240408133243.694134-2-hch@lst.de>
 <871q6oqzik.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871q6oqzik.fsf@debian-BULLSEYE-live-builder-AMD64>

On Mon, Apr 29, 2024 at 03:04:51PM +0530, Chandan Babu R wrote:
> On Mon, Apr 08, 2024 at 03:32:38 PM +0200, Christoph Hellwig wrote:
> > v5 file systems have been the default for more than 10 years.  Drop
> > support for non-v5 enabled kernels and xfsprogs.
> >
> 
> Hi,
> 
> This patch is causing xfs/077 to fail as shown below,
> 
> # ./check xfs/077
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 xfs-crc 6.9.0-rc4+ #2 SMP PREEMPT_DYNAMIC Mon Apr 29 08:08:05 GMT 2024
> MKFS_OPTIONS  -- -f -f -m crc=1,reflink=0,rmapbt=0, -i sparse=0 /dev/loop6
> MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota -o context=system_u:object_r:root_t:s0 /dev/loop6 /media/scratch
> 
> xfs/077 9s ... [not run] Kernel doesn't support meta_uuid feature
> Ran: xfs/077
> Not run: xfs/077
> Passed all 1 tests
> 
> The corresponding configuration file used had the following,
> 
>   export TEST_DEV=/dev/loop5
>   export TEST_DIR=/media/test
>   export SCRATCH_DEV=/dev/loop6
>   export SCRATCH_MNT=/media/scratch
>   
>   MKFS_OPTIONS='-f -m crc=1,reflink=0,rmapbt=0, -i sparse=0'
>   MOUNT_OPTIONS='-o usrquota,grpquota,prjquota'

Thanks for finding this issue, the _require_meta_uuid helper or the calling
of _require_meta_uuid looks not correct. The xfs/077 calls _require_meta_uuid
as:

  _supported_fs xfs
  _require_xfs_copy
  _require_scratch
  _require_no_large_scratch_dev
  _require_meta_uuid            <=====
  ...

The x/077 hasn't mkfs on SCRATCH_DEV, but the _require_meta_uuid does
_scratch_xfs_db directly. That looks not right.

I think we should do "_scratch_mkfs ..." before doing _require_meta_uuid.
E.g. mkfs at the beginning of _require_meta_uuid.

Any thoughts?

Thanks,
Zorro

> 
> -- 
> Chandan
> 

