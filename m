Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E7AC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 01:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236551AbiLNB3e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 20:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiLNB3d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 20:29:33 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7D026481
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 17:29:32 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id r18so1018431pgr.12
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 17:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=659spw0vXfA9eHd9/kWHIcVxwornHt9ydiVIbN0sA9A=;
        b=GXOL14Nh7ibykzXHGGgZLHHtmbdZ5oB5z5sp7LKxFJSV4QSLE1HQcDx2HOrcharzip
         IP0UTMladS3B6MqsdxvPHRvDzf9p1aG/9FQJjl5o+KBcCzggoCVfwsOus6qsHrpJQcq5
         YXHvdTTqfCUkHWmVJrOH5kkI/ysV3+5GBJCWAjotGYkVB7VohoPZjOqXUSaGvmX0+bDj
         YsmXd9Q3ph21w/9SrROw8nBN8hFhKime+pDmUzlRN1pz72eNnoZOMSV6Ipc/NGlxJXcw
         FkssHZIVcPkhkHKqbXTermG64z0H/XWfA6/qBJdzteBWD5a3sRzDSP8FgAMBpa22J0n0
         mq9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=659spw0vXfA9eHd9/kWHIcVxwornHt9ydiVIbN0sA9A=;
        b=4Keo7vIecXAxcECA/MVp37OcF02esJaf3j0g9asiVLNmkFPh9QeQE3CiGLkLI5TXzC
         Fk8BWKvplLx0AFOpUuKfpVD3MGktdnRi5IuMeoZlCxDc0URwSo5Socmt/UVMaJlnMOLg
         AHkj/k5c7qJWddzXJTGrC2E4EYGT3PmdA/apnWbTJGpuKpZdbEi+Jw4VGk8J9QoF0+Ze
         e1LIbFfqT2P5K8rlf9JX/P+m/XJyxKeBjiAGgGL5m55Ou1teLMxFwIvsLuHPPwLG3KXe
         Aei8eFSpxfHB7wxpPfkU465GTumH42+F4j/phQf9zS+FMdPlwO3To4WXw3D/73J4Y2q6
         n1HQ==
X-Gm-Message-State: ANoB5pkXgMFT9yVxVI9MJWHi2/C5iK5kf5aH6eaNifYi0N6yzYGQ6xvh
        FTZjXQ+Lf5lYGbXAOtAsB/pS2w==
X-Google-Smtp-Source: AA0mqf7YL1nWc1cBSVm65RgwZrrbv7vfgFqui3I7WmkOfUsEc1PUbo/qjkI+eNq/ekOnqCzKTMy8Pw==
X-Received: by 2002:a62:b613:0:b0:574:3595:a4af with SMTP id j19-20020a62b613000000b005743595a4afmr19272752pff.2.1670981371922;
        Tue, 13 Dec 2022 17:29:31 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id q15-20020aa7842f000000b005672daedc8fsm8249682pfn.81.2022.12.13.17.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 17:29:31 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p5GaO-008A3P-Mf; Wed, 14 Dec 2022 12:29:28 +1100
Date:   Wed, 14 Dec 2022 12:29:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 05/11] xfs: add inode on-disk VERITY flag
Message-ID: <20221214012928.GE3600936@dread.disaster.area>
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-6-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213172935.680971-6-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 06:29:29PM +0100, Andrey Albershteyn wrote:
> Add flag to mark inodes which have fs-verity enabled on them (i.e.
> descriptor exist and tree is built).
.....
> 
>  static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
>  {
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f08a2d5f96ad4..8d9c9697d3619 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -636,6 +636,8 @@ xfs_ip2xflags(
>  			flags |= FS_XFLAG_DAX;
>  		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
>  			flags |= FS_XFLAG_COWEXTSIZE;
> +		if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
> +			flags |= FS_VERITY_FL;
>  	}

Ah, attribute flag confusion - easy to do. xflags (FS_XFLAG*) are a
different set of (extended) flags than the standard VFS inode flags
(FS_*_FL).

To place the verity enabled state in the extended flags, you would
need to define FS_XFLAG_VERITY in include/uapi/linux/fs.h. You'll
also need to add the conversion from FS_VERITY_FL to FS_XFLAG_VERITY
to fileattr_fill_flags() and vice versa to fileattr_fill_xflags()

This will allow both the VFS inode flags UAPI and the
FS_IOC_FSGETXATTR extended flag API to see the inode has verity
enabled on it.

Once FS_XFLAG_VERITY is defined, changing the code in XFS to use it
directly instead of FS_VERITY_FL will result in everything working
correct throughout the code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
