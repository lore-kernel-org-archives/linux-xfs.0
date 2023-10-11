Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7372BCDB47E
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 21:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbjJKVI3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 17:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbjJKVI2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 17:08:28 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80557A9
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 14:08:24 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1c9b95943beso2416965ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 14:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1697058504; x=1697663304; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v7R1roJ751hIf+3hBWRUh4FPKj0adoze6R+eV6UScxw=;
        b=FL41fwqvm1CdmXzwvAJ7hytg+m9Wqe5SDz/n53K7Ks6twwLURb86JXVCh2rXZY2QOy
         U6TSS2Tx1mMUqPC3qdaTZb33cLGZh4fUOhMirWUpyy68knV/FhWRAccCDUjSlX/oiPUM
         polJwywIe+rVb2Kf2ImbtYNxbWLmcG3MP0RDsV/6s3BpC3X/5tlRVJFm+q5liUk0wakT
         FtSgpPFmoF3Eec/CFiFJ9nswAdbT0QQaardr5oWYh3seFR0pQY2fJGYWGonjGaseMSW0
         evn7z80elN1FrnP1PIzaQMR5gReGRoCC4K9VhJHLwfu/pCIziHs31D16qafRSalL3WwP
         UwvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697058504; x=1697663304;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7R1roJ751hIf+3hBWRUh4FPKj0adoze6R+eV6UScxw=;
        b=hHp34zjb3jqCvQ2Ze1xZwCgOPjiX6EGoC4yJD2fkVoB9ifHXA+3KX+sN/MdnfsE9T5
         fjXzxihBRAGIg1qg2Y0YnvsCRzXwEbcK5+Xo9yQkbYTF/Zyhn9R4ijDPZNnCf2+w7dD7
         W/5dbwBCWp8CPIYnA+m3GG737kDK6KNeVliB3gYYOfpVPdpdcwigJSrmZnh6Ia4XV5yC
         EcpAwkGs4g/fTIsPbSxmwYuDmp9w0bEdMJ+xUyUAWFoKO4dY6POsFh+f5225+Neo5osL
         MWFcVslAu/+in9wKFxYUvznGsEEkvHxpF2JogY5LalHIQuRjZenEiv9qcPQYMjwxOg4C
         Xh9Q==
X-Gm-Message-State: AOJu0Yxdt1ucqfpRuxk4B0sYzsV3tvnWSVXJktnRKu/kkwg4rOGe4qB0
        UIN+SD0cICHoFHreEZ/Dn11U4Q==
X-Google-Smtp-Source: AGHT+IHoahnVOxrLmE0HFU8FljQX+3tC1IPn3XD3GHou+vM+SGN/HU0ZouOunzrnKo7Ct+914NXs7g==
X-Received: by 2002:a17:903:2282:b0:1c5:a49e:7aa with SMTP id b2-20020a170903228200b001c5a49e07aamr28888847plh.27.1697058503754;
        Wed, 11 Oct 2023 14:08:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id z15-20020a1709027e8f00b001bdeb6bdfbasm291564pla.241.2023.10.11.14.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 14:08:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qqgRI-00CYwN-15;
        Thu, 12 Oct 2023 08:08:20 +1100
Date:   Thu, 12 Oct 2023 08:08:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, cheng.lin130@zte.com.cn,
        linux-xfs@vger.kernel.org, jiang.yong5@zte.com.cn,
        wang.liang82@zte.com.cn, liu.dong3@zte.com.cn
Subject: Re: [PATCH] xfs: pin inodes that would otherwise overflow link count
Message-ID: <ZScOxEP5V/fQNDW8@dread.disaster.area>
References: <20231011203350.GY21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011203350.GY21298@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 01:33:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The VFS inc_nlink function does not explicitly check for integer
> overflows in the i_nlink field.  Instead, it checks the link count
> against s_max_links in the vfs_{link,create,rename} functions.  XFS
> sets the maximum link count to 2.1 billion, so integer overflows should
> not be a problem.
> 
> However.  It's possible that online repair could find that a file has
> more than four billion links, particularly if the link count got

I don't think we should be attempting to fix that online - if we've
really found an inode with 4 billion links then something else has
gone wrong during repair because we shouldn't get there in the first
place.

IOWs, we should be preventing a link count overflow at the time 
that the link count is being added and returning -EMLINK errors to
that operation. This prevents overflow, and so if repair does find
more than 2.1 billion links to the inode, there's clearly something
else very wrong (either in repair or a bug in the filesystem that
has leaked many, many link counts).

huh.

We set sb->s_max_links = XFS_MAXLINKS, but nowhere does the VFS
enforce that, nor does any XFS code. The lack of checking or
enforcement of filesystem max link count anywhere is ... not ideal.

Regardless, I don't think fixing nlink overflow cases should be done
online. A couple of billion links to a single inode takes a
*long* time to create and even longer to validate (and take a -lot-
of memory).  Hence I think we should just punt "more than 2.1
billion links" to the offline repair, because online repair can't do
anything to actually find whatever caused the overflow in the
first place, nor can it actually fix it - it should never have
happened in the first place....

> corrupted while creating hardlinks to the file.  The di_nlinkv2 field is
> not large enough to store a value larger than 2^32, so we ought to
> define a magic pin value of ~0U which means that the inode never gets
> deleted.  This will prevent a UAF error if the repair finds this
> situation and users begin deleting links to the file.

I think that's fine as a defence against implementation bugs, but I
don't think that it really makes any real difference to the "repair
might find an overflow" case...

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_format.h |    6 ++++++
>  fs/xfs/scrub/nlinks.c      |    8 ++++----
>  fs/xfs/scrub/repair.c      |   12 ++++++------
>  fs/xfs/xfs_inode.c         |   28 +++++++++++++++++++++++-----
>  4 files changed, 39 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 6409dd22530f2..320522b887bb3 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -896,6 +896,12 @@ static inline uint xfs_dinode_size(int version)
>   */
>  #define	XFS_MAXLINK		((1U << 31) - 1U)
>  
> +/*
> + * Any file that hits the maximum ondisk link count should be pinned to avoid
> + * a use-after-free situation.
> + */
> +#define XFS_NLINK_PINNED	(~0U)
> +
>  /*
>   * Values for di_format
>   *
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4db2c2a6538d6..30604e11182c4 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -910,15 +910,25 @@ xfs_init_new_inode(
>   */
>  static int			/* error */
>  xfs_droplink(
> -	xfs_trans_t *tp,
> -	xfs_inode_t *ip)
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip)
>  {
> +	struct inode		*inode = VFS_I(ip);
> +
>  	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
>  
> -	drop_nlink(VFS_I(ip));
> +	if (inode->i_nlink == 0) {
> +		xfs_info_ratelimited(tp->t_mountp,
> + "Inode 0x%llx link count dropped below zero.  Pinning link count.",
> +				ip->i_ino);
> +		set_nlink(inode, XFS_NLINK_PINNED);
> +	}
> +	if (inode->i_nlink != XFS_NLINK_PINNED)
> +		drop_nlink(inode);
> +
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);

I think the di_nlink field now needs to be checked by verifiers to
ensure the value is in the range of:

	(0 <= di_nlink <= XFS_MAXLINKS || di_nlink == XFS_NLINK_PINNED)

And we need to ensure that in xfs_bumplink() - or earlier (top avoid
dirty xaction cancle shutdowns) - that adding a count to di_nlink is
not going to exceed XFS_MAXLINKS....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
