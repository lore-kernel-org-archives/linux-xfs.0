Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD50DC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 11:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A800A204EC
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 11:30:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JIyc0FAe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgHQLa5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 07:30:57 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53460 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728261AbgHQLaw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 07:30:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597663851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TxiFD7QsGIqrCyCiLTAFI2RQXVMH7Xb86SRr9Mo+yqI=;
        b=JIyc0FAeuQCopvE9Ik/BHH2Ye0iEYqYh887xSJXz2kP0MIL2a6j7fMcE+ul6ovSPfbE1K0
        jf0/i5VE3rhbs9BPbfkQOAQy6gZjR5jkP7SLEknfEPjVQ7ZQkR2RHKJcCHd2cO+GU5EOdN
        U98eET8q30I/3KVeLQtTo1NjK2ehuPE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-PL-U7FSMPTmDp0AChMCMXA-1; Mon, 17 Aug 2020 07:30:49 -0400
X-MC-Unique: PL-U7FSMPTmDp0AChMCMXA-1
Received: by mail-wr1-f70.google.com with SMTP id m7so6916175wrb.20
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2020 04:30:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=TxiFD7QsGIqrCyCiLTAFI2RQXVMH7Xb86SRr9Mo+yqI=;
        b=HqQdgzSHphmh2inO04CIweVarGYBQar9Ws/Qcx5tQhEeJrj4ZSPmP371xqpwUu0+EP
         SCX5vsUA/ZhmPJPa+aUP7CC0cxwcgBIvuhW1AU+jm64mpSrcMOaDSWR1tWRQJWLqZSZC
         +oB35CaoQZ0xcDtF74E5TsqEG4bwbjv5vla9kvpgJwFEnYNvG1eT1GhWVe1YDVcwGIBx
         JkM2wqn5/qGBfv1nzpsA79dlEeyOrnSMCdAPuw09TXsg9KViG349irHp4w3PBb7lBLDN
         /QUQKUo/0Y2fsD+2FO8GD2TlQwqBeyQP2uPWEGZJ7n1I021ppJwFbHLBVKLtccLBjbjI
         b9OQ==
X-Gm-Message-State: AOAM530QsX0l3QZgHDlrRb83X8MVi57233yYVU8JGgYc9dPtL7jgXvUS
        HJd5W4GJjAGP9y0k1tTsWilkJO+WzexJAHHemP2PLd/EAhIZJzHkKIKDKNtK2hYpoWW5jmV1i1K
        luyBkF+gwflti9eux3cDY
X-Received: by 2002:a5d:43c4:: with SMTP id v4mr15502711wrr.426.1597663848234;
        Mon, 17 Aug 2020 04:30:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFbahb1uVAgzg80k8xoD6sT1t75lRLhKeQrSwzIkhaUcnSB//Nl/z2cUkc7NsDpZfIGLWzJw==
X-Received: by 2002:a5d:43c4:: with SMTP id v4mr15502694wrr.426.1597663847988;
        Mon, 17 Aug 2020 04:30:47 -0700 (PDT)
Received: from eorzea (ip-86-49-45-232.net.upcbroadband.cz. [86.49.45.232])
        by smtp.gmail.com with ESMTPSA id z15sm31655762wrn.89.2020.08.17.04.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 04:30:47 -0700 (PDT)
Date:   Mon, 17 Aug 2020 13:30:45 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] mkfs: allow setting dax flag on root directory
Message-ID: <20200817113045.kqk37az3xog2ghfm@eorzea>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <159736123670.3063459.13610109048148937841.stgit@magnolia>
 <159736126408.3063459.10843086291491627861.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159736126408.3063459.10843086291491627861.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 13, 2020 at 04:27:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach mkfs to set the DAX flag on the root directory so that all new
> files can be created in dax mode.  This is a complement to removing the
> mount option.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man/man8/mkfs.xfs.8 |   10 ++++++++++
>  mkfs/xfs_mkfs.c     |   14 ++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 7d3f3552ff12..3ad9e5449f58 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -398,6 +398,16 @@ will have this extent size hint applied.
>  The value must be provided in units of filesystem blocks.
>  Directories will pass on this hint to newly created regular files and
>  directories.
> +.TP
> +.BI daxinherit= value
> +If set, all inodes created by
> +.B mkfs.xfs
> +will be created with the DAX flag set.
> +Directories will pass on this flag on to newly created regular files

I'm not English native speaker, but 'pass on this flag on' looks weird to me,
'pass this flag on' sounds better, but again, I'm no native speaker, and I might
well be just adding noise here :)

Other than that, everything else looks fine.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> +and directories.
> +By default,
> +.B mkfs.xfs
> +will not enable DAX mode.
>  .RE
>  .TP
>  .B \-f
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 2e6cd280e388..a687f385a9c1 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -60,6 +60,7 @@ enum {
>  	D_PROJINHERIT,
>  	D_EXTSZINHERIT,
>  	D_COWEXTSIZE,
> +	D_DAXINHERIT,
>  	D_MAX_OPTS,
>  };
>  
> @@ -254,6 +255,7 @@ static struct opt_params dopts = {
>  		[D_PROJINHERIT] = "projinherit",
>  		[D_EXTSZINHERIT] = "extszinherit",
>  		[D_COWEXTSIZE] = "cowextsize",
> +		[D_DAXINHERIT] = "daxinherit",
>  	},
>  	.subopt_params = {
>  		{ .index = D_AGCOUNT,
> @@ -369,6 +371,12 @@ static struct opt_params dopts = {
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
> +		{ .index = D_DAXINHERIT,
> +		  .conflicts = { { NULL, LAST_CONFLICT } },
> +		  .minval = 0,
> +		  .maxval = 1,
> +		  .defaultval = 1,
> +		},
>  	},
>  };
>  
> @@ -1434,6 +1442,12 @@ data_opts_parser(
>  		cli->fsx.fsx_cowextsize = getnum(value, opts, subopt);
>  		cli->fsx.fsx_xflags |= FS_XFLAG_COWEXTSIZE;
>  		break;
> +	case D_DAXINHERIT:
> +		if (getnum(value, opts, subopt))
> +			cli->fsx.fsx_xflags |= FS_XFLAG_DAX;
> +		else
> +			cli->fsx.fsx_xflags &= ~FS_XFLAG_DAX;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> 

-- 
Carlos

