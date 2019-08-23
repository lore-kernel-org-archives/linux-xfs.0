Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD6AC3A5A2
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 19:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06C6422CEC
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 19:24:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZEzIWc6K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391495AbfHWTYi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 15:24:38 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39624 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391488AbfHWTYi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Aug 2019 15:24:38 -0400
Received: by mail-ed1-f68.google.com with SMTP id g8so15019119edm.6
        for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2019 12:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9aasssmPqIzIz73viuErkaBWw0n5N8MKFjvIV2BDpps=;
        b=ZEzIWc6KpfbuvBt17Y2PY1jBJIvndC9rXaEnsaFUy5gZNVjGau7LpW/EsEzJzXQtYQ
         lRkmHZfnEbkM0RThIHCZqcyL0vBNKZYwADrMDY/BY3uGsGVOTET3nP9SulyFQ2oumVrw
         tJnoYvIkEDAkeNVTs6e6cm3uruCA6vrTGGYx4ZewvvRghRrCDj2CT+5jt+u5p0FA+szZ
         3QKKdxYWAYxxq1SpOmWDv17BvsOUZfz87MBudZ88gwI939YMH53YuKFGPazvD0LfohRe
         aVUKOnoIBTbMvhfpe/Mq7Km9Ka9mE7yhLS2QOHtx7rR2Vzpw+YqHfkVPeyCtIYrUNeIU
         4jiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=9aasssmPqIzIz73viuErkaBWw0n5N8MKFjvIV2BDpps=;
        b=dE8JiA57ID4+Iut/kYsoYOxce0yVFJHvQf53wjFYcLm88KN2b/7eP0fdVMTurlcBYu
         0pUl4PHIla8p4SAUjcszARdN4yIlff+IE6y8ULbcT3n+JlAuA5fPtZc4TucvBip3fPnU
         WQc0Id5vp1onyedN6DmugdoMZS2aL96x+hm+TIq+AUDKicZbeoaWhPpS6xxVnsYTuAoS
         B/1i+qXLP+kIdsu9PPiZCHFQzDHwWlCzOCloUbSzHjYHNAD7zthgQPgW29itDniOS7WW
         pc2FHsYbZbtjunJWOnc+1805TDRH9Z5ElRU13C4xKSx7tgg/9k26DRiPOZvsM13N688y
         I1yg==
X-Gm-Message-State: APjAAAWQrMg2ddrzAVrtG9miMAo29Ee5TfBxVVn6OTy3LCN0xNPCWnmu
        CaPd/On/96Jrz5BgWNAOx9c+IJ2UKU4=
X-Google-Smtp-Source: APXvYqyhC+z269QZSNzLEnuWJr7Odyzu34XjORDvMeaYMkGxUnp/ZPMVybH2fOvccaKwjXQ8W35cbg==
X-Received: by 2002:a17:906:f198:: with SMTP id gs24mr5700704ejb.6.1566588276638;
        Fri, 23 Aug 2019 12:24:36 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id v7sm693577ede.71.2019.08.23.12.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 12:24:34 -0700 (PDT)
Date:   Fri, 23 Aug 2019 21:24:33 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix missing ILOCK unlock when xfs_setattr_nonsize
 fails due to EDQUOT
Message-ID: <20190823192433.GA8736@eldamar.local>
References: <20190823035528.GH1037422@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823035528.GH1037422@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Thu, Aug 22, 2019 at 08:55:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Benjamin Moody reported to Debian that XFS partially wedges when a chgrp
> fails on account of being out of disk quota.  I ran his reproducer
> script:
> 
> # adduser dummy
> # adduser dummy plugdev
> 
> # dd if=/dev/zero bs=1M count=100 of=test.img
> # mkfs.xfs test.img
> # mount -t xfs -o gquota test.img /mnt
> # mkdir -p /mnt/dummy
> # chown -c dummy /mnt/dummy
> # xfs_quota -xc 'limit -g bsoft=100k bhard=100k plugdev' /mnt
> 
> (and then as user dummy)
> 
> $ dd if=/dev/urandom bs=1M count=50 of=/mnt/dummy/foo
> $ chgrp plugdev /mnt/dummy/foo
> 
> and saw:
> 
> ================================================
> WARNING: lock held when returning to user space!
> 5.3.0-rc5 #rc5 Tainted: G        W
> ------------------------------------------------
> chgrp/47006 is leaving the kernel with locks still held!
> 1 lock held by chgrp/47006:
>  #0: 000000006664ea2d (&xfs_nondir_ilock_class){++++}, at: xfs_ilock+0xd2/0x290 [xfs]
> 
> ...which is clearly caused by xfs_setattr_nonsize failing to unlock the
> ILOCK after the xfs_qm_vop_chown_reserve call fails.  Add the missing
> unlock.
> 
> Reported-by: benjamin.moody@gmail.com
> Fixes: 253f4911f297 ("xfs: better xfs_trans_alloc interface")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_iops.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index dd4076ae228a..ea614b4ae052 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -804,6 +804,7 @@ xfs_setattr_nonsize(
>  
>  out_cancel:
>  	xfs_trans_cancel(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  out_dqrele:
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);

Confirmed the fix work.

Feel free to add a Tested-by if wanted.

Can this be backported to the relevant stable versions as well?

Regards,
Salvatore
