Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9319C04EBE
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 07:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8234C2173E
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 07:32:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B09in2qQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbgJHHcU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 03:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727232AbgJHHcT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 03:32:19 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE12DC0613D4
        for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2020 00:32:18 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id l126so3278047pfd.5
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 00:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uWbmHdjxwA80tcOwgQRRW8SfF/eQcrcriiHWeHWmEwE=;
        b=B09in2qQPJJsRxq7Z96nEE4eUTzkoLwYuQ/YDFfjaOEN+ZdB8YV0ajBDnPJ36QJcrO
         B/qLfLOKAtPLsr8RmtAq0R5o+sNL/qwLiNCRBlKC2f9peGOQugwVFOV+6SUot0gaBPtZ
         uFHNuQR0yZQBsLY/YbHynad0EXhCZ1V9Dasc6ItP5pioNdFhE8KIdJhds9O+lvcV9Sci
         qS5eVaKZgVUY3nK1FUhWfCRZpqhcNSAziLFNuKe0fSupmkTbMjOuMMeTMNCbApfGIEsy
         +BDarfMmY9g5H7AhYPLVvYieTM1G+Li5UfMxyrbOjLq+DVb70EFf/RubxF4AFO+GPdQ5
         QRdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uWbmHdjxwA80tcOwgQRRW8SfF/eQcrcriiHWeHWmEwE=;
        b=ipazJuRB4WvKjew6qE8m7qghouyjxEaEVNyvIHW1X/AinuBVNlqOwMdDwrZ3e/wyy6
         ARg8aUExN+wm+jElpbAqMcHRjnApiMxw73ZL5GBHh1xhnSI1rJEQLklCCzJpVnl4Y/ip
         +xkDArgsKn7Gxwso8zSp8EnfDjqOMwgQ/dBWYnqtFMNiQZQWmYltvOCIUFep7OhW7Kqq
         rxddDo/SaiRxaahMeMbdF08esl9yys1+mIpXOhqllbkrf87nJnAxbTjR1T4753mBwTDx
         x2AalGzXGxuOKnrpaNDyW2MClZdoy6lk68KJb0Tdtl6Gey01ZMK+lnd9+0fX9peYJx0F
         dLCg==
X-Gm-Message-State: AOAM533mLeXewGbhXlsdGb8I5pidKd7Vg3nWmL2EyJ/vPOx53dFEgOCd
        M9Bb13gBJdDD8DYNeCQERlg=
X-Google-Smtp-Source: ABdhPJzg/qkvDdS9kRciCGZhmebj9gw4dtbynCGt75SafrHbvqfAV6v3SvaIfx1xzWy7yu1C9MM2Yg==
X-Received: by 2002:a17:90a:b285:: with SMTP id c5mr6530791pjr.44.1602142338325;
        Thu, 08 Oct 2020 00:32:18 -0700 (PDT)
Received: from garuda.localnet ([122.171.164.182])
        by smtp.gmail.com with ESMTPSA id g4sm6154831pgg.75.2020.10.08.00.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 00:32:17 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@redhat.com
Subject: Re: [PATCH 2/2] xfs: make xfs_growfs_rt update secondary superblocks
Date:   Thu, 08 Oct 2020 13:01:59 +0530
Message-ID: <4070961.BB4q84YiFQ@garuda>
In-Reply-To: <160212937238.248573.3832120826354421788.stgit@magnolia>
References: <160212936001.248573.7813264584242634489.stgit@magnolia> <160212937238.248573.3832120826354421788.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday 8 October 2020 9:26:12 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we call growfs on the data device, we update the secondary
> superblocks to reflect the updated filesystem geometry.  We need to do
> this for growfs on the realtime volume too, because a future xfs_repair
> run could try to fix the filesystem using a backup superblock.
> 
> This was observed by the online superblock scrubbers while running
> xfs/233.  One can also trigger this by growing an rt volume, cycling the
> mount, and creating new rt files.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_rtalloc.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 1c3969807fb9..5b2e68d9face 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -18,7 +18,7 @@
>  #include "xfs_trans_space.h"
>  #include "xfs_icache.h"
>  #include "xfs_rtalloc.h"
> -
> +#include "xfs_sb.h"
>  
>  /*
>   * Read and return the summary information for a given extent size,
> @@ -1108,6 +1108,11 @@ xfs_growfs_rt(
>  	 */
>  	kmem_free(nmp);
>  
> +	/* Update secondary superblocks now the physical grow has completed */
> +	error = xfs_update_secondary_sbs(mp);
> +	if (error)
> +		return error;
> +

If any of the operations in the previous "for" loop causes "error" to be set
and the loop to be exited, the call to xfs_update_secondary_sbs() would
overwrite this error value. In the worst case it might set error to 0 and
hence return a success status to the caller when the growfs operation
had actually failed.

-- 
chandan



