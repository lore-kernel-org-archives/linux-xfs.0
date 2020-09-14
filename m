Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADB2C43461
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 07:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08EB32192A
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 07:34:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HkOQ6Fj6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgINHeM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 03:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgINHeJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 03:34:09 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D2DC06174A
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2020 00:34:09 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q4so5024594pjh.5
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2020 00:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v3E9Nm4+Q67iUigsuO/1iXV//lFgveWW1Ld25q2jpkI=;
        b=HkOQ6Fj6fR2U2SgLXDF0qjCwGQ/FwaLs5SjNSB/yP6tCRCm7/8GyEuwG2f6YdbwN2R
         d7QgOSJwIj3Pa4EnhQNNIPOALdiSRFneaE3NL9gO8SN3Q1nG79HiLl3u1b5tMY789b70
         O7gY2wsUqU/3zt6N+2S+9V4Ztlkw6t+ZGi04mbqXvNb8TML8q6xczAahydf9qn8FGFkZ
         5NQ1BdVyNpq9NM5CzK0K14JQP4epSKCLHtKYODkhKePddT0PKfs4CBFUHQ8OHqQyHMMF
         MgunQ/Dvm8x+5H19LZcCcPb0iJDIqt3w9639B2gQZ4sevON6cGvzeqZeZzvjm/kLGKB2
         SL0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v3E9Nm4+Q67iUigsuO/1iXV//lFgveWW1Ld25q2jpkI=;
        b=htoYD+M9PZc61+6NO2snYmOKnlyEoEx4rSAFW5SnGLjMkZ96y66lJaVTZEzhZwT0o4
         zDOAF+mzHJLtkHfDI9koDA/tNmnXe66gAYCMINafmTyfTc+FMpE8x1tV7x6Nx9brwCee
         KeDRLlojZi5Jx0wuxj8mXBYDDb/OmdWkaESgS0/ylvOz3lQD/7oZI1g51W6XAiNb+3D8
         9hneCWP9ueVd7yvmCyz569PxZ6K/+oBg55WPyiDxvm2lzd3QN0ptPZ0ukOoHxdiFu08Z
         wcYoRhwmRxucmGbqIwU6qHSWT6pITg3L4kik2QUF6CBbDGLB8DthP6bLbemB6d6CxHYp
         9ZIQ==
X-Gm-Message-State: AOAM533b0RGSaL8DFxU6ykLz3qK0tQh5Oib/H/B93j1xyOaK0geiEiTH
        35qCULTMXWOuFXGfsuVx7sA=
X-Google-Smtp-Source: ABdhPJz9q+2jjpbTEjJBDn19ke6IlgaJNfb7L175iLio548bflyaCu/S9ENnzXaHQSfRfyh/mi3A+w==
X-Received: by 2002:a17:90a:fb52:: with SMTP id iq18mr12698077pjb.207.1600068848832;
        Mon, 14 Sep 2020 00:34:08 -0700 (PDT)
Received: from garuda.localnet ([122.182.251.12])
        by smtp.gmail.com with ESMTPSA id a3sm9448636pfl.213.2020.09.14.00.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:34:08 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: Re: [PATCH] xfs: Set xfs_buf type flag when growing summary/bitmap files
Date:   Mon, 14 Sep 2020 13:04:02 +0530
Message-ID: <7145299.poBC1KmnEk@garuda>
In-Reply-To: <20200914072459.GA29046@infradead.org>
References: <20200912130015.11473-1-chandanrlinux@gmail.com> <20200914072459.GA29046@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 14 September 2020 12:54:59 PM IST Christoph Hellwig wrote:
> On Sat, Sep 12, 2020 at 06:30:15PM +0530, Chandan Babu R wrote:
> > The following sequence of commands,
> > 
> >   mkfs.xfs -f -m reflink=0 -r rtdev=/dev/loop1,size=10M /dev/loop0
> >   mount -o rtdev=/dev/loop1 /dev/loop0 /mnt
> >   xfs_growfs  /mnt
> > 
> > ... causes the following call trace to be printed on the console,
> > 
> > XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
> > Call Trace:
> >  xfs_buf_item_format+0x632/0x680
> >  ? kmem_alloc_large+0x29/0x90
> >  ? kmem_alloc+0x70/0x120
> >  ? xfs_log_commit_cil+0x132/0x940
> >  xfs_log_commit_cil+0x26f/0x940
> >  ? xfs_buf_item_init+0x1ad/0x240
> >  ? xfs_growfs_rt_alloc+0x1fc/0x280
> >  __xfs_trans_commit+0xac/0x370
> >  xfs_growfs_rt_alloc+0x1fc/0x280
> >  xfs_growfs_rt+0x1a0/0x5e0
> >  xfs_file_ioctl+0x3fd/0xc70
> >  ? selinux_file_ioctl+0x174/0x220
> >  ksys_ioctl+0x87/0xc0
> >  __x64_sys_ioctl+0x16/0x20
> >  do_syscall_64+0x3e/0x70
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > 
> > This occurs because the buffer being formatted has the value of
> > XFS_BLFT_UNKNOWN_BUF assigned to the 'type' subfield of
> > bip->bli_formats->blf_flags.
> > 
> > This commit fixes the issue by assigning one of XFS_BLFT_RTSUMMARY_BUF
> > and XFS_BLFT_RTBITMAP_BUF to the 'type' subfield of
> > bip->bli_formats->blf_flags before committing the corresponding
> > transaction.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/xfs_rtalloc.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index 6209e7b6b895..192a69f307d7 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -767,8 +767,12 @@ xfs_growfs_rt_alloc(
> >  	struct xfs_bmbt_irec	map;		/* block map output */
> >  	int			nmap;		/* number of block maps */
> >  	int			resblks;	/* space reservation */
> > +	enum xfs_blft		buf_type;
> >  	struct xfs_trans	*tp;
> >  
> > +	buf_type = (ip == mp->m_rsumip) ?
> > +		XFS_BLFT_RTSUMMARY_BUF : XFS_BLFT_RTBITMAP_BUF;
> 
> Nit:  can you turn this into a normal if / else?

Sure. Thanks for the review.

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

-- 
chandan



