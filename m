Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03292C388F7
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 00:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A15892080D
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 00:31:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VIFVpxxD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387913AbgJ1Wbc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:31:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30300 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387905AbgJ1Wbb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 18:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603924290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TQGrqXAUmlrtRtkH/30yLYIDSS640VbA/u3zdICZ6T0=;
        b=VIFVpxxD/s9v+kLyFdxSIheZaLw7aHveqD8H8wY6ByYQ46i8l0RvF0stwVHUOz0qkRbAKK
        L+if5D5M92AKnju9st+0mB6lkwj5JB+wGWEAp1vvHsbo5yEnEs19ZmzaFpR8ciTgcKDzGP
        OzcJ1VvBNjsxIK1q+p+0VTmupMNEviA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-wzc739XLMNClsWmeeTkZeQ-1; Wed, 28 Oct 2020 13:30:41 -0400
X-MC-Unique: wzc739XLMNClsWmeeTkZeQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65907805EFD;
        Wed, 28 Oct 2020 17:30:40 +0000 (UTC)
Received: from bfoster (ovpn-113-186.rdu2.redhat.com [10.10.113.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D8EAB100238E;
        Wed, 28 Oct 2020 17:30:39 +0000 (UTC)
Date:   Wed, 28 Oct 2020 13:30:38 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] mkfs: enable the inode btree counter feature
Message-ID: <20201028173038.GG1611922@bfoster>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
 <160375523682.880355.16796358046529188083.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375523682.880355.16796358046529188083.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:33:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach mkfs how to enable the inode btree counter feature.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man/man8/mkfs.xfs.8 |   15 +++++++++++++++
>  mkfs/xfs_mkfs.c     |   34 +++++++++++++++++++++++++++++++++-
>  2 files changed, 48 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 0a7858748457..1a6a5f93f0ea 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
...
> @@ -862,7 +871,8 @@ usage( void )
>  {
>  	fprintf(stderr, _("Usage: %s\n\
>  /* blocksize */		[-b size=num]\n\
> -/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1]\n\
> +/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
> +			    inobtcnt=0|1]\n\
>  /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
>  			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
>  			    sectsize=num\n\

Any plans to add a geometry flag so the feature state is reported on
success? Otherwise LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> @@ -1565,6 +1575,9 @@ meta_opts_parser(
>  	case M_REFLINK:
>  		cli->sb_feat.reflink = getnum(value, opts, subopt);
>  		break;
> +	case M_INOBTCNT:
> +		cli->sb_feat.inobtcnt = getnum(value, opts, subopt);
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -1988,6 +2001,22 @@ _("reflink not supported without CRC support\n"));
>  			usage();
>  		}
>  		cli->sb_feat.reflink = false;
> +
> +		if (cli->sb_feat.inobtcnt && cli_opt_set(&mopts, M_INOBTCNT)) {
> +			fprintf(stderr,
> +_("inode btree counters not supported without CRC support\n"));
> +			usage();
> +		}
> +		cli->sb_feat.inobtcnt = false;
> +	}
> +
> +	if (!cli->sb_feat.finobt) {
> +		if (cli->sb_feat.inobtcnt && cli_opt_set(&mopts, M_INOBTCNT)) {
> +			fprintf(stderr,
> +_("inode btree counters not supported without finobt support\n"));
> +			usage();
> +		}
> +		cli->sb_feat.inobtcnt = false;
>  	}
>  
>  	if ((cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
> @@ -2955,6 +2984,8 @@ sb_set_features(
>  		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
>  	if (fp->reflink)
>  		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
> +	if (fp->inobtcnt)
> +		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
>  
>  	/*
>  	 * Sparse inode chunk support has two main inode alignment requirements.
> @@ -3617,6 +3648,7 @@ main(
>  			.spinodes = true,
>  			.rmapbt = false,
>  			.reflink = true,
> +			.inobtcnt = false,
>  			.parent_pointers = false,
>  			.nodalign = false,
>  			.nortalign = false,
> 

