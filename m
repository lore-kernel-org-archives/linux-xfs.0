Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751F6C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 07:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5397F20663
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 07:21:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="noPr+E7H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgEFHV4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 03:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726451AbgEFHV4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 03:21:56 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA83C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 00:21:56 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x77so572574pfc.0
        for <linux-xfs@vger.kernel.org>; Wed, 06 May 2020 00:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F+FSfwlm7b8vt5aTrB4oS7RBEoSZreEJnNwmAOuBrL4=;
        b=noPr+E7HF/gQ4sMrkLGCykICJBs5+uODyjzqmvPFuYJBVIbSTFw2JNoJHyNAS1iFK0
         gEkXkCdS/iJi5kxlqMIR97Rnb2TlBDyYo9m52xUWuTTxi9QOu/Qe25dlb247CCB6rGmA
         gATpGWsz3R0dpQm3evf1uHz8Nq1SsSHwtk0PnVfHXA0C7LWugFtm1HQWNYGgftD7uGGj
         QmBxySOJ1UJP1CS0YrD9ZvFEU02wCAQN+dYWNG8LExH7NxKhWmbkGaHdITcPzOs9hSGw
         dqWpJuQbIFiqvh0VoeOqiwsay5qeoj3biK31pGefLP5QtCiAG5C5gHvJIhYLcY3IpKR4
         1wfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F+FSfwlm7b8vt5aTrB4oS7RBEoSZreEJnNwmAOuBrL4=;
        b=Yr7bM3U6F8dIP2AMZLyfvZ8b8Llk3zR+l2LBzZDDehjmPpUzHxuXYGWsGs4L2JC0TF
         I6Id3A5WLM0g6/jFq6Z6bUYmnmdlzZIlDzDkEQlOWQIVynkpLdyYdL1j1tsBZPcOoHXZ
         sasDm9UrzRvRU61EmPlTWceruHpAq0LvCGsx4+6SOaJZvlhpwfwdRQ+gO55JaMi3F4+j
         cX6AyE0BMAx6jCvlh0XQCevdS37zpy7/3MuNb3uk9/CdO3hUqpD/wXVE6m9ozu7RZB13
         hXLiEnjjIZdzid3xfNhauFjPG8EkkNvRHpCzXayUpNzcfj4jgwm4IFiADG6SLpXD2DUF
         OcTg==
X-Gm-Message-State: AGi0PuZ95rakMqDq3VP2VMb/eXMx98CsuvnJV4mvgOWW2Nh1W5QxHJ3p
        JEG6E/9eDHiqjmZUyDZCvV4=
X-Google-Smtp-Source: APiQypIW/Ko2mXygbX504uczBs1qywA55ZfguhlwHxUr0kasFEwPRb7xmkzxlAdxWexdqRt2lGzUgA==
X-Received: by 2002:a62:f941:: with SMTP id g1mr6579029pfm.118.1588749715804;
        Wed, 06 May 2020 00:21:55 -0700 (PDT)
Received: from garuda.localnet ([122.171.200.101])
        by smtp.gmail.com with ESMTPSA id q11sm929652pfl.97.2020.05.06.00.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 00:21:55 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/28] xfs: remove unnecessary includes from xfs_log_recover.c
Date:   Wed, 06 May 2020 12:51:52 +0530
Message-ID: <1946382.xrkUgOOkNB@garuda>
In-Reply-To: <158864120453.182683.5638021226977031304.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864120453.182683.5638021226977031304.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:43:24 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove unnecessary includes from the log recovery code.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_log_recover.c |    8 --------
>  1 file changed, 8 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 0c8a1f4bf4ad..a9cc546535e0 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -18,21 +18,13 @@
>  #include "xfs_log.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
> -#include "xfs_inode_item.h"
> -#include "xfs_extfree_item.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_alloc.h"
>  #include "xfs_ialloc.h"
> -#include "xfs_quota.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"

Inclusion of xfs_icache.h can be removed as well. I have clarified this by
removing the above statement and successfully building the kernel.

The rest look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> -#include "xfs_bmap_btree.h"
>  #include "xfs_error.h"
> -#include "xfs_dir2.h"
> -#include "xfs_rmap_item.h"
>  #include "xfs_buf_item.h"
> -#include "xfs_refcount_item.h"
> -#include "xfs_bmap_item.h"
>  
>  #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
>  
> 
> 


-- 
chandan



