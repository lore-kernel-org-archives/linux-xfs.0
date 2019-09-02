Return-Path: <SRS0=DNa4=W5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C7EC3A59B
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 03:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EA7B21874
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Sep 2019 03:43:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0/vQNmO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbfIBDn6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Sep 2019 23:43:58 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34674 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfIBDn6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Sep 2019 23:43:58 -0400
Received: by mail-pf1-f196.google.com with SMTP id b24so8230345pfp.1
        for <linux-xfs@vger.kernel.org>; Sun, 01 Sep 2019 20:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K2p4+Eiq4sOKUr8EqGB9slCjqbtUTDBPD3ABdDaIlwU=;
        b=g0/vQNmO6FSveOxz9lFyWpwCuoZXpsv0Tg5trYWp2qOViyJQGdGqdVNusG5/R2+4T2
         OyDwsn9acYfAbXtQRX7Dos7+YO3983FfnDwM/pJYO5nRQVdZMPVFYr7mi0DEeC1WLCza
         9zdZH1b7qoWEkltj6mCofbs2dCGTQgirAgJ0oE1l4QdW8VeDpkTGaZ+wzRof50iVbteL
         9nu3oJE/RoSQCxlchVHf5KhwfOd2VdHr5aCC5ZRiTLwLed9gXU+g8qIFE34RGxkA9s3Y
         PEIWiN9ZuW/dumbSEcXMcrrCwSK95dyrUAYEFNvxic1DC+AZfFFjT/XiRHyct5gdLwGy
         kndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K2p4+Eiq4sOKUr8EqGB9slCjqbtUTDBPD3ABdDaIlwU=;
        b=lB49CqqfmKt79+YhtWu132z6R7tF62oZjN15gZRP4t5DpGSrChS+h/8l26HLVEo4To
         0oYwkLi4C1x3eVOBTWCyWcI0pUt6FdkqFDVKe61FYaZnUah3d4BkegS+AznIEBYuWpnR
         Y7rwIkWUVKjy4QQzYo1O+UlUyCRffptVZ3jvFpjKFzKwWZwrYnU2mgSKSXFOYLKXw1jw
         V/8ABCB2JkLwJUGMoqHi+oqnlH0Zu97bHK08Lmoz6g0evMY9zT7HJVIpqLb5RBnLFcsG
         BhxdDVIvEbEeD6OSo17qo7XrjDmkpM+4/gXcgugyKahi1MfVpyQadA+NCsTWi6Og3C3r
         mVSw==
X-Gm-Message-State: APjAAAURAU4g8zrbvwLGKgvHLPNFP8UHCUB2UuivgFCCuWuIA9pP9rEd
        25C1n1MFLgrqR7UHhZmEH4c=
X-Google-Smtp-Source: APXvYqx7X7gVASlM4gSl+IpsDM9H3k/robpsUJp/HWT9GGXKGuusn4RPBXq9TvPg/eiTqna9ZQQhvQ==
X-Received: by 2002:a62:3644:: with SMTP id d65mr32330135pfa.128.1567395837658;
        Sun, 01 Sep 2019 20:43:57 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f128sm8087507pfg.143.2019.09.01.20.43.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Sep 2019 20:43:56 -0700 (PDT)
Date:   Mon, 2 Sep 2019 11:43:49 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Murphy Zhou <jencce.kernel@gmail.com>
Subject: Re: [PATCH v2] xfsprogs: provide a few compatibility typedefs
Message-ID: <20190902034349.rzglgsd4aajmhtup@XZHOUW.usersys.redhat.com>
References: <20190830150327.20874-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830150327.20874-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 05:03:27PM +0200, Christoph Hellwig wrote:
> Add back four typedefs that allow xfsdump to compile against the
> headers from the latests xfsprogs.
> 
> Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/xfs.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/xfs.h b/include/xfs.h
> index f2f675df..35435b18 100644
> --- a/include/xfs.h
> +++ b/include/xfs.h
> @@ -37,4 +37,13 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
>  #include <xfs/xfs_types.h>
>  #include <xfs/xfs_fs.h>
>  
> +/*
> + * Backards compatibility for users of this header, now that the kernel
> + * removed these typedefs from xfs_fs.h.
> + */
> +typedef struct xfs_bstat xfs_bstat_t;
> +typedef struct xfs_fsop_bulkreq xfs_fsop_bulkreq_t;
> +typedef struct xfs_fsop_geom_v1 xfs_fsop;

Still got build failure about this one.

Either change this line to:

+typedef struct xfs_fsop_geom_v1 xfs_fsop_geom_v1_t;

Or delete this line add this in xfsdump:

---
diff --git a/common/fs.c b/common/fs.c
index a4c175c..ff8c75a 100644
--- a/common/fs.c
+++ b/common/fs.c
@@ -204,7 +204,7 @@ fs_mounted(char *typs, char *chrs, char *mnts, uuid_t *idp)
 int
 fs_getid(char *mnts, uuid_t *idb)
 {
-	xfs_fsop_geom_v1_t geo;
+	struct xfs_fsop_geom_v1 geo;
 	int fd;
 
 	fd = open(mnts, O_RDONLY);

---

I prefer the later one since it's the only one, no need for a typedef.

Thanks,
Murphy

> +typedef struct xfs_inogrp xfs_inogrp_t;
> +
>  #endif	/* __XFS_H__ */
> -- 
> 2.20.1
> 
