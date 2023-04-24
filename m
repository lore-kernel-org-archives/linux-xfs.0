Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C19C7618E
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Apr 2023 14:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjDXO0P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Apr 2023 10:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbjDXO0I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Apr 2023 10:26:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1791E67
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 07:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682346319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zJPOoUD1R2oeYGmNOLzpgpTmVIy72RD/4CIA6McqrE8=;
        b=OMFEg2j5fABamg6qr7brLrndQOZ3ZNpuI8QqJCg0ka3NUm8G0AzvgAZQpGTxnr0L0NCcX1
        1qbNBoGw7fsTfqnCI4v34AqZqdjpfx5O2/nahguIKH2XH19v+ZQ4F5VEPXmCGfNb0h/Ujz
        nKyaJk1ZTCGMPpRSlDmRRkSrUZiQe1Q=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-O_OGC_B4MJKX3VZey5PA2w-1; Mon, 24 Apr 2023 10:25:17 -0400
X-MC-Unique: O_OGC_B4MJKX3VZey5PA2w-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-74ab517c14bso1744401385a.1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 07:25:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682346317; x=1684938317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zJPOoUD1R2oeYGmNOLzpgpTmVIy72RD/4CIA6McqrE8=;
        b=RUYpS0nXCKCjw6dEwdtDvmYl0FxznePxZGQpwnwIP86SK3yqg8wk71M3FbUvTUCAme
         O0+aO23omanscP5q2XLOw/suZfWJoNB2H7DmDhQJTXvyUvMg3HY6NJeEx2Dy/Tctkwjr
         DAexqUYYKknv0ORaeElkt+GvvR+dYrLqCEB+X6Ti1X8lfg9c9e5n32YAPm7jZ7RQT3t+
         RO0spUD1tP8ST/G5YWIQISHlo9uqhDOgTCjjwQEGMQKxif8uzjYoR9P8IacpRk0CAUGX
         isrVKs71KnQFoaGZB77UzTsfOw+p6yuzLnUdyTss+VTEcY2e+Gx7JB8DXu09AcaMNk2l
         B14g==
X-Gm-Message-State: AAQBX9crA2IERfmvtC/sFxp6eZm5BV27mhphDe+PiZjMiMIHemkR4z9D
        Y1zNFrfEh3QG19tXAEhajshTYbgux8KVkXfztec86f1ij8jtGKBNtRy3gzYib50TN5BcyRyPlOD
        DszenIKJdxvcff0vB1RTm/yDBiUwv
X-Received: by 2002:a05:6214:21a5:b0:572:6e81:ae9c with SMTP id t5-20020a05621421a500b005726e81ae9cmr23085528qvc.1.1682346316767;
        Mon, 24 Apr 2023 07:25:16 -0700 (PDT)
X-Google-Smtp-Source: AKy350aVaKv9zaS7DqR2kDwBHQnZXOrY3NMILkGqJKA7pEoJHOnKt/X40JkFcYkoGnsuxfeFKSgDkg==
X-Received: by 2002:a05:6214:21a5:b0:572:6e81:ae9c with SMTP id t5-20020a05621421a500b005726e81ae9cmr23085497qvc.1.1682346316470;
        Mon, 24 Apr 2023 07:25:16 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id v2-20020a0ce1c2000000b005e95c46e42asm3349466qvl.74.2023.04.24.07.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 07:25:16 -0700 (PDT)
Date:   Mon, 24 Apr 2023 10:27:20 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix livelock in delayed allocation at ENOSPC
Message-ID: <ZEaRyPqXf3lSigCO@bfoster>
References: <20230421222440.2722482-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421222440.2722482-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 22, 2023 at 08:24:40AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On a filesystem with a non-zero stripe unit and a large sequential
> write, delayed allocation will set a minimum allocation length of
> the stripe unit. If allocation fails because there are no extents
> long enough for an aligned minlen allocation, it is supposed to
> fall back to unaligned allocation which allows single block extents
> to be allocated.
> 
> When the allocator code was rewritting in the 6.3 cycle, this
> fallback was broken - the old code used args->fsbno as the both the
> allocation target and the allocation result, the new code passes the
> target as a separate parameter. The conversion didn't handle the
> aligned->unaligned fallback path correctly - it reset args->fsbno to
> the target fsbno on failure which broke allocation failure detection
> in the high level code and so it never fell back to unaligned
> allocations.
> 
> This resulted in a loop in writeback trying to allocate an aligned
> block, getting a false positive success, trying to insert the result
> in the BMBT. This did nothing because the extent already was in the
> BMBT (merge results in an unchanged extent) and so it returned the
> prior extent to the conversion code as the current iomap.
> 
> Because the iomap returned didn't cover the offset we tried to map,
> xfs_convert_blocks() then retries the allocation, which fails in the
> same way and now we have a livelock.
> 
> Reported-by: Brian Foster <bfoster@redhat.com>
> Fixes: 85843327094f ("xfs: factor xfs_bmap_btalloc()")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Problem solved, thanks. FWIW:

Tested-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 1a4e446194dd..b512de0540d5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3540,7 +3540,6 @@ xfs_bmap_btalloc_at_eof(
>  	 * original non-aligned state so the caller can proceed on allocation
>  	 * failure as if this function was never called.
>  	 */
> -	args->fsbno = ap->blkno;
>  	args->alignment = 1;
>  	return 0;
>  }
> -- 
> 2.39.2
> 

