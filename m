Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA37224B15
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 09:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744794954; cv=none; b=KTWvIDncQqNHN9WG3SFhmwD2P9bdRA1dlB/iVFcL7mQwMWca+mrBP8XNFMFuDT+hjXO8uQBUzn1VKFjDOd1ZurFjafJ3JWztzSSw3IK1ESL+HRiTYfigs//JLU1jX9Ow/KwNkcHvrpj0b99kfpeuKPlA4MgUd58RpQkWnQ9wpVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744794954; c=relaxed/simple;
	bh=U3ApHKeguNnpeUOCKc96tv7W7Whr6ecnULQEK+32iVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W94Fnf7m66ZiWaGdU23oVjGQnKDULsRfEPPy7UmDWSV9zZUSnOmJ75AdSn1q2fPptNEUAxyb4O3oPB79oc3fyu/w6XxJpARbY5g6CO6cx/WB9Rh+iltDug5iWkXtzB/AurX8CbykjKKWZqLXSr+J41JKpeSHFSr1bsAFsp1+Gm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ht9odxgr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ht9odxgr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744794951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Usj4uu7lji/2Q4aOz9bnmdWRIeoxcs4WNDv5gkN4gAc=;
	b=Ht9odxgrgKbJUpPmqJPma4r2iXw4tFD8NCPCmdqsdqh/XZrn/8/xVKEuGVynAUfAZdSUd1
	rF6JX6IbTUlzJV0YlJEoehWQCFHLZcaR+LDUB50sns8JMYxQiOZmPKBcWlLBqQvGZbku1B
	Ofv18UhCBHV06sT5/I79qt9A9aXFbT0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-1Ik9zAeUOsK7YddyDGfBTQ-1; Wed, 16 Apr 2025 05:15:50 -0400
X-MC-Unique: 1Ik9zAeUOsK7YddyDGfBTQ-1
X-Mimecast-MFC-AGG-ID: 1Ik9zAeUOsK7YddyDGfBTQ_1744794949
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ac710ace217so443972066b.1
        for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 02:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744794949; x=1745399749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Usj4uu7lji/2Q4aOz9bnmdWRIeoxcs4WNDv5gkN4gAc=;
        b=nqidAcDxePF1GybRApG9Tq8lfscB9PH0Sv93DqNd3eYzIZkmx55PPYIINFawTGDXJ/
         QPJ0niVwVQaYFiq+GyxZoF4Kkhx4YOlK/d5UKyr0h7iX1nlW8SBZJijAN9ZjWAkSjDVK
         WP0V7Obkkl8XI02MSLF3QKROgC6TDagPogQXKPp8dy8bQBHwnUZuoL3dDyO5F4GT0HNb
         6GFv6DcYkjS22XJ5Qo4rGdPtYm1k7P/vqPwDVfL2v75CYnJvr6M2IWxPA1BJPn5L79OK
         8qNn9p7rjKZbRjESWGsZU0oZ3/1pGtdJynE2WBJyfCzoy5pfVaZvXPfJFByH1i5GC0+9
         /0DA==
X-Gm-Message-State: AOJu0YxZrLcxalYBZuCL+foFesYfcqaufmFhnEJZfeUmyU/fuhkoHibY
	YY031G7MbxRP14zx8Ex9uZ2Cq65UlOe0/6VmRF1AmDFKznJVJz1P9f3o7thYWBpE1eeZmxhbNcZ
	KAR0iMy9ca/yj2ppR3PqyqP4AdQns2lpdT7VW5WiJ/lo0KICzA16I1Rl+
X-Gm-Gg: ASbGncsH0ANK6J/bU90KMgaCVLu5P+zsg+7fPDq8ry8HJiKuCmjKSP0tIvCv/A6PXkM
	sie4ONQxq+BPFxvsf0l6rWTbfSJl3eTcz24YQ7rUjqRe1ndJpIGk5rx1MWQNYJcWgxClM3M4X3/
	TFx5RvAse8DaQqvYQ69RFZSES6w+6iPACdXpMRXVvEZzZw2lvdE45Tf5O4JqwgfmLHQgEDG0bQe
	H3GjIgz1qdTTA9m14nV2UN1titJ33j6TZjacQUiS1kw0oqmgUuCHoHK9kIXfocthvY+M31qEx8A
	C+hfsfXEhfwfyD6TdZqE3mVqZQd9XCQ=
X-Received: by 2002:a17:907:7f1a:b0:ac6:ecd8:a235 with SMTP id a640c23a62f3a-acb429dc6f6mr94855466b.28.1744794949230;
        Wed, 16 Apr 2025 02:15:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFffSHg9zr9Fk0ms0KFdyzMZoG2Jwf37E4yJlwValcjyYmXChudUbOHCKpuAP0nLuHMDMiLWA==
X-Received: by 2002:a17:907:7f1a:b0:ac6:ecd8:a235 with SMTP id a640c23a62f3a-acb429dc6f6mr94853466b.28.1744794948775;
        Wed, 16 Apr 2025 02:15:48 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb3d1a5139sm89367866b.125.2025.04.16.02.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 02:15:48 -0700 (PDT)
Date: Wed, 16 Apr 2025 11:15:47 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs_io: catch statx fields up to 6.15
Message-ID: <vkznab7sz3qjejtqjc5cp2hmmvilmflwl3zlfjfxbolmvo2gbu@o4zv4jcage4u>
References: <20250416052134.GB25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416052134.GB25675@frogsfrogsfrogs>

On 2025-04-15 22:21:34, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add all the new statx fields that have accumulated for the past couple
> of years.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  io/statx.h            |   25 ++++++++++++++++++++++++-
>  io/stat.c             |    5 +++++
>  m4/package_libcdev.m4 |    2 +-
>  3 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/io/statx.h b/io/statx.h
> index 347f6d08210f83..273644f53cf1c4 100644
> --- a/io/statx.h
> +++ b/io/statx.h
> @@ -138,7 +138,10 @@ struct statx {
>  	__u32	stx_atomic_write_unit_max;	/* Max atomic write unit in bytes */
>  	/* 0xb0 */
>  	__u32   stx_atomic_write_segments_max;	/* Max atomic write segment count */
> -	__u32   __spare1[1];
> +
> +	/* File offset alignment for direct I/O reads */
> +	__u32	stx_dio_read_offset_align;
> +
>  	/* 0xb8 */
>  	__u64	__spare3[9];	/* Spare space for future expansion */
>  	/* 0x100 */
> @@ -191,8 +194,28 @@ struct statx {
>  
>  #endif /* STATX_TYPE */
>  
> +#ifndef STATX_MNT_ID
> +#define STATX_MNT_ID		0x00001000U	/* Got stx_mnt_id */
> +#endif
> +
> +#ifndef STATX_DIOALIGN
> +#define STATX_DIOALIGN		0x00002000U	/* Want/got direct I/O alignment info */
> +#endif
> +
> +#ifndef STATX_MNT_ID_UNIQUE
> +#define STATX_MNT_ID_UNIQUE	0x00004000U	/* Want/got extended stx_mount_id */
> +#endif
> +
> +#ifndef STATX_SUBVOL
> +#define STATX_SUBVOL		0x00008000U	/* Want/got stx_subvol */
> +#endif
> +
>  #ifndef STATX_WRITE_ATOMIC
>  #define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
>  #endif
>  
> +#ifndef STATX_DIO_READ_ALIGN
> +#define STATX_DIO_READ_ALIGN	0x00020000U	/* Want/got dio read alignment info */
> +#endif
> +
>  #endif /* XFS_IO_STATX_H */
> diff --git a/io/stat.c b/io/stat.c
> index d27f916800c00a..b37b1a12b8b2fd 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -365,9 +365,14 @@ dump_raw_statx(struct statx *stx)
>  	printf("stat.rdev_minor = %u\n", stx->stx_rdev_minor);
>  	printf("stat.dev_major = %u\n", stx->stx_dev_major);
>  	printf("stat.dev_minor = %u\n", stx->stx_dev_minor);
> +	printf("stat.mnt_id = 0x%llu\n", (unsigned long long)stx->stx_mnt_id);
> +	printf("stat.dio_mem_align = %u\n", stx->stx_dio_mem_align);
> +	printf("stat.dio_offset_align = %u\n", stx->stx_dio_offset_align);
> +	printf("stat.subvol = 0x%llu\n", (unsigned long long)stx->stx_subvol);
>  	printf("stat.atomic_write_unit_min = %u\n", stx->stx_atomic_write_unit_min);
>  	printf("stat.atomic_write_unit_max = %u\n", stx->stx_atomic_write_unit_max);
>  	printf("stat.atomic_write_segments_max = %u\n", stx->stx_atomic_write_segments_max);
> +	printf("stat.dio_read_offset_align = %u\n", stx->stx_dio_read_offset_align);
>  	return 0;
>  }
>  
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index af9da8124dbdc8..61353d0aa9d536 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -126,7 +126,7 @@ AC_DEFUN([AC_NEED_INTERNAL_FSCRYPT_POLICY_V2],
>  AC_DEFUN([AC_NEED_INTERNAL_STATX],
>    [ AC_CHECK_TYPE(struct statx,
>        [
> -        AC_CHECK_MEMBER(struct statx.stx_atomic_write_unit_min,
> +        AC_CHECK_MEMBER(struct statx.stx_dio_read_offset_align,
>            ,
>            need_internal_statx=yes,
>            [#include <linux/stat.h>]
> 

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

