Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74CD9C19F2A
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 15:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiHDP6E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 11:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbiHDP6A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 11:58:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1A4D5C949
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 08:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659628678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CqHOhrr0ZgyvCJWkEVbD/9LJIvx3in0HDAVYAA/bxSQ=;
        b=CIa8/lpdkmiEGXUi12zl2jD4Cy+6GitME8oIvOlBT+sBerzR9wtn2gkpwoCm0rAOwrctz/
        UdBy2pEUDY29HJitq+YSEXaSuWVvl9YAIDixWBU8aRqt/elAbfWs6Hgkl9Cr5FQD4ghMD+
        fJdbO7ff3Lq8qEVJ+32rU1OwBIzUstw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-0k8dDxCfOgidg46HKN9wtQ-1; Thu, 04 Aug 2022 11:57:57 -0400
X-MC-Unique: 0k8dDxCfOgidg46HKN9wtQ-1
Received: by mail-qt1-f197.google.com with SMTP id e3-20020ac84b43000000b0033efb06a30aso49084qts.22
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 08:57:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CqHOhrr0ZgyvCJWkEVbD/9LJIvx3in0HDAVYAA/bxSQ=;
        b=XTyUMFkWPhGPAtR63u9hYlcYslrZ6Tl5B6vUuZtbhktcZyZ5Q51N+9jInK7SnF8W18
         AGQ6QrysCAI7Vb29GlnH6HNyIcpTb7iUaqiXdM+RROqlgxB8bMfa137NNaiNQd/WfFUU
         i9MEtppYhhh7kq4Q9j6g3H9h0AquU6l2X0lCeNrbY9oqA6ppAcayOXN4OkTY/nmtjbYN
         jsTm1qtZqqEbQTZi3gRlDFHMQJM3nMYn4lXvKSvme5ZTF4HhK/8wIkq87+N2ZlApp0ue
         TP/lz3hqEn8brbKLexBsVCY/ATUiz1zRWS1V/UgCKP8AUsT5u/umQL9aQr1077iQp3A+
         dI5g==
X-Gm-Message-State: ACgBeo2a7HlupogfvfPRSrmXTEaOTpbEXyu29B6nY0IiFw4vcOwJyowX
        RCuU4e5TjdNhCfjP+x9VUEmdZMA/cH8iAK5q2U2BG8CG6RHJwi7oTkF0xguWWNW3Z0KvxpB/ElA
        U18x6Q1K4l5V2MpxozI0X
X-Received: by 2002:a05:622a:244:b0:31f:22e3:1cf9 with SMTP id c4-20020a05622a024400b0031f22e31cf9mr2117657qtx.44.1659628676952;
        Thu, 04 Aug 2022 08:57:56 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7ZfKErRWZpVcNdKVK2jG7D1EVTlfDhuH/i+C1CNt3fi/kmd+h2VatFU06Vs0ubno3BgJ6ZdA==
X-Received: by 2002:a05:622a:244:b0:31f:22e3:1cf9 with SMTP id c4-20020a05622a024400b0031f22e31cf9mr2117647qtx.44.1659628676736;
        Thu, 04 Aug 2022 08:57:56 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s13-20020a05622a178d00b0031eeefd896esm939918qtk.3.2022.08.04.08.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 08:57:56 -0700 (PDT)
Date:   Thu, 4 Aug 2022 23:57:51 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs/291: convert open-coded _scratch_xfs_repair usage
Message-ID: <20220804155751.owyjxbzvgddzwy6h@zlang-mailbox>
References: <165950048029.198815.11843926234080013062.stgit@magnolia>
 <165950049164.198815.17444582280704119144.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165950049164.198815.17444582280704119144.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 02, 2022 at 09:21:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Convert this test to use _scratch_xfs_repair, since the only variance
> from the standard usage is that it's called against a sparse file into
> which the scratch filesystem has been metadumped and mdrestored.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/291 |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> 
> diff --git a/tests/xfs/291 b/tests/xfs/291
> index 6d5e247e..a2425e47 100755
> --- a/tests/xfs/291
> +++ b/tests/xfs/291
> @@ -93,11 +93,7 @@ _scratch_xfs_check >> $seqres.full 2>&1 || _fail "xfs_check failed"
>  # Can xfs_metadump cope with this monster?
>  _scratch_xfs_metadump $tmp.metadump || _fail "xfs_metadump failed"
>  xfs_mdrestore $tmp.metadump $tmp.img || _fail "xfs_mdrestore failed"
> -[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && \
> -	rt_repair_opts="-r $SCRATCH_RTDEV"
> -[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_LOGDEV" ] && \
> -	log_repair_opts="-l $SCRATCH_LOGDEV"
> -$XFS_REPAIR_PROG $rt_repair_opts $log_repair_opts -f $tmp.img >> $seqres.full 2>&1 || \
> +SCRATCH_DEV=$tmp.img _scratch_xfs_repair -f &>> $seqres.full || \

Good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

Feel free to reply, if anyone has objection.

>  	_fail "xfs_repair of metadump failed"
>  
>  # Yes it can; success, all done
> 

