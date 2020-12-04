Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB1EC4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 09:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3557227BF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 09:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgLDJFx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 04:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgLDJFx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 04:05:53 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB50C061A4F
        for <linux-xfs@vger.kernel.org>; Fri,  4 Dec 2020 01:05:13 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id n10so3118466pgv.8
        for <linux-xfs@vger.kernel.org>; Fri, 04 Dec 2020 01:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D3xuCze3CH5HoQecC9QEMr+XtyvFycXmTQC2BfNI970=;
        b=Do34ZCqjN+ZKy/SquWrIN/o2j/82lPCVwbUx9/u+pcLevBBs8i66Uy9n+0+kSVl8hO
         +BMDPJN5gJteilwP6/iIADOkUjqfHc0uBXJk5bjYMnGUgeb3icDXasOJvgWCUbnHq7ZD
         lo4riwR1LbD7C9GE0T9j8HQTnyZJOx45JMmMEtfZQwy7sZIBJjUK+6qxuVFQk6TO6QEk
         +AJWI30pdPZCDVJl/v4/z+9i6JHZoxqd46vmjt42SN9xDT8iKAVPDiN7BvtUjEsiBXX/
         VEYppKC68WxW5tgi6wymKh/sQvMIxUhxPojvZQIW5/ADYBt5fWqx/6c1ktSHeELXmCkA
         PXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D3xuCze3CH5HoQecC9QEMr+XtyvFycXmTQC2BfNI970=;
        b=QqUH0xpD6r4Kt6sAhaNlfW1NLbrbNCHPWerlNO53ouyDIWweRloEW+2QXsp2pFwYVk
         M6LNeSfktZAPJe5iFqtrl9UAEVt0H4PL6jJ/dGUwH9Z5+okDapD2QdtFpwXZnEr+dCW8
         3YQy8LmJu4+IYhrCl5qWl6CKPyfL5QGj3kXpZCZlugChKFmr0zpQnLsDATe0tMzBeR9d
         HObeYuQ+Oakjffs5jV0dV1EeoEkfBY+nae3WYXPmKZpeH0jLxGC49w474nz+6yNzSewe
         e1cepmniqibv5yjHJxO8w8dmGB+2FoA4WYdJ12L23ubI/BKXgmWBTv9fbe4Il16FGJ7z
         Zrug==
X-Gm-Message-State: AOAM533b4uMEQ9ukuEyThN0Ufr6rnxDNtGQN95VmKXUjdCCE0A3DOxDP
        dLeFESublAq26TGbiPf3Z90=
X-Google-Smtp-Source: ABdhPJzbjvqUWuRSf3C2N1P1VM6v64BfHQ/JizgzFI1T270a6dNkAawpCdLc4eYNr7lvArZWon8p5Q==
X-Received: by 2002:a05:6a00:2384:b029:19a:eed3:7f42 with SMTP id f4-20020a056a002384b029019aeed37f42mr3022807pfc.4.1607072712442;
        Fri, 04 Dec 2020 01:05:12 -0800 (PST)
Received: from garuda.localnet ([122.171.196.244])
        by smtp.gmail.com with ESMTPSA id d19sm1522150pjs.0.2020.12.04.01.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 01:05:11 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V11 10/14] xfs: Introduce error injection to reduce maximum inode fork extent count
Date:   Fri, 04 Dec 2020 14:35:09 +0530
Message-ID: <4916889.lojSSAFOH7@garuda>
In-Reply-To: <20201203190616.GC106272@magnolia>
References: <20201117134416.207945-1-chandanrlinux@gmail.com> <20201117134416.207945-11-chandanrlinux@gmail.com> <20201203190616.GC106272@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 03 Dec 2020 11:06:16 -0800, Darrick J. Wong wrote:
> On Tue, Nov 17, 2020 at 07:14:12PM +0530, Chandan Babu R wrote:
> > This commit adds XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag which enables
> > userspace programs to test "Inode fork extent count overflow detection"
> > by reducing maximum possible inode fork extent count to 35.
> > 
> > With block size of 4k, xattr (with local value) insert operation would
> > require in the worst case "XFS_DA_NODE_MAXDEPTH + 1" plus
> > "XFS_DA_NODE_MAXDEPTH + (64k / 4k)" (required for guaranteeing removal
> > of a maximum sized xattr) number of extents. This evaluates to ~28
> > extents. To allow for additions of two or more xattrs during extent
> > overflow testing, the pseudo max extent count is set to 35.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_errortag.h   | 4 +++-
> >  fs/xfs/libxfs/xfs_inode_fork.c | 4 ++++
> >  fs/xfs/xfs_error.c             | 3 +++
> >  3 files changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> > index 53b305dea381..1c56fcceeea6 100644
> > --- a/fs/xfs/libxfs/xfs_errortag.h
> > +++ b/fs/xfs/libxfs/xfs_errortag.h
> > @@ -56,7 +56,8 @@
> >  #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
> >  #define XFS_ERRTAG_IUNLINK_FALLBACK			34
> >  #define XFS_ERRTAG_BUF_IOERROR				35
> > -#define XFS_ERRTAG_MAX					36
> > +#define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
> > +#define XFS_ERRTAG_MAX					37
> >  
> >  /*
> >   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> > @@ -97,5 +98,6 @@
> >  #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
> >  #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
> >  #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
> > +#define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
> >  
> >  #endif /* __XFS_ERRORTAG_H_ */
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index 8d48716547e5..989b20977654 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -24,6 +24,7 @@
> >  #include "xfs_dir2_priv.h"
> >  #include "xfs_attr_leaf.h"
> >  #include "xfs_types.h"
> > +#include "xfs_errortag.h"
> >  
> >  kmem_zone_t *xfs_ifork_zone;
> >  
> > @@ -745,6 +746,9 @@ xfs_iext_count_may_overflow(
> >  
> >  	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
> >  
> > +	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> > +		max_exts = 35;
> 
> Please add a comment here explaining why 35.

Sure. I will do that.

> 
> Sorry about the longish review delay, last week was a US holiday and
> this week I have eye problems again. :(

Np. Please take care.

> 
> --D
> 
> > +
> >  	nr_exts = ifp->if_nextents + nr_to_add;
> >  	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
> >  		return -EFBIG;
> > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > index 7f6e20899473..3780b118cc47 100644
> > --- a/fs/xfs/xfs_error.c
> > +++ b/fs/xfs/xfs_error.c
> > @@ -54,6 +54,7 @@ static unsigned int xfs_errortag_random_default[] = {
> >  	XFS_RANDOM_FORCE_SUMMARY_RECALC,
> >  	XFS_RANDOM_IUNLINK_FALLBACK,
> >  	XFS_RANDOM_BUF_IOERROR,
> > +	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
> >  };
> >  
> >  struct xfs_errortag_attr {
> > @@ -164,6 +165,7 @@ XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
> >  XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
> >  XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
> >  XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
> > +XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
> >  
> >  static struct attribute *xfs_errortag_attrs[] = {
> >  	XFS_ERRORTAG_ATTR_LIST(noerror),
> > @@ -202,6 +204,7 @@ static struct attribute *xfs_errortag_attrs[] = {
> >  	XFS_ERRORTAG_ATTR_LIST(bad_summary),
> >  	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
> >  	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
> > +	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
> >  	NULL,
> >  };
> >  
> 


-- 
chandan



