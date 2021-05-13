Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0724DC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 12:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5D00611CC
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 12:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbhEMMI0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 May 2021 08:08:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55541 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233656AbhEMMIY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 May 2021 08:08:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620907633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ExZQixp+skQIKZqqJ+OSN6/O4RC+Ej0K2QATy+xA63Q=;
        b=YPndAfBBfvWfug30/F1vytkINxum5lLL2sMqc1q1R3nw9yApTEP+ZmJdEXyJL/Z0gacBCI
        psLgq42ZdM/DD3Y4BIahr1k49e/qikEt83J3ZMneozaH+EZChmUlPao99QaNNkZy3CXfuE
        uc7lrikSBtQX0GLoe0b8p/V9NfmAL6c=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-WFKRHJcsO9SjK-JI_Mtrjw-1; Thu, 13 May 2021 08:07:11 -0400
X-MC-Unique: WFKRHJcsO9SjK-JI_Mtrjw-1
Received: by mail-qt1-f200.google.com with SMTP id d13-20020a05622a05cdb02901c2cffd946bso17814513qtb.23
        for <linux-xfs@vger.kernel.org>; Thu, 13 May 2021 05:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ExZQixp+skQIKZqqJ+OSN6/O4RC+Ej0K2QATy+xA63Q=;
        b=NhFONdxjfsC/lyvOWeHxtacZ88+3r49kNGIMOrC0Z1qv8Jcrn4fiItxy+3UYGw6MjA
         8O9kjOOwQJlIalWy91agEDO7Na/FrO+ujuq4sD0XIxnd4B8wQBDz9z2j9W4RrCVvaWju
         n+m3jN2PHtQRlecSWKGCiBuGlPehm07gJSWsw+684Jw6WVZBTHg962dMlOHjosD9+nTC
         HR07EG5OxBRkxBONk+4yX19I6nLArgETywnMEiTqYR4s9seIQ159p7n74tU9n/1kDEwJ
         cKd9tUdpQKslzEcXhGPzhseLjRYMQew2h9zj/COVIbELDuRBV7QZxPLIAsupI8euNL+5
         6dbw==
X-Gm-Message-State: AOAM5334jLBqp7ygqy6pQRxuyLg47H947u5VorXWBtTlRgW0edDIocsm
        /ehC9GTW7NE/tJxJw22oqAj7vnseYnUx6vUdePeuJRiMKEQHSreQYKMqVCEGxHeUGSGd/+PCBKz
        tW29ytcSh3RDuqcMDTkpd
X-Received: by 2002:ac8:1192:: with SMTP id d18mr37306204qtj.253.1620907631324;
        Thu, 13 May 2021 05:07:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyS9tnN0Si7AQQZ3BBDthBTB+GmDq8LYdyPw0Fo6KGxujfDrEJnELr5OBC2tr8Ll2Nhne95HA==
X-Received: by 2002:ac8:1192:: with SMTP id d18mr37306189qtj.253.1620907631092;
        Thu, 13 May 2021 05:07:11 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id 28sm2288296qkr.36.2021.05.13.05.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 05:07:10 -0700 (PDT)
Date:   Thu, 13 May 2021 08:07:09 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix deadlock retry tracepoint arguments
Message-ID: <YJ0WbaNLjQb6opW5@bfoster>
References: <162086768823.3685697.11936501771461638870.stgit@magnolia>
 <162086769410.3685697.9016566085994934364.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162086769410.3685697.9016566085994934364.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 06:01:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> sc->ip is the inode that's being scrubbed, which means that it's not set
> for scrub types that don't involve inodes.  If one of those scrubbers
> (e.g. inode btrees) returns EDEADLOCK, we'll trip over the null pointer.
> Fix that by reporting either the file being examined or the file that
> was used to call scrub.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/common.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index aa874607618a..be38c960da85 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -74,7 +74,9 @@ __xchk_process_error(
>  		return true;
>  	case -EDEADLOCK:
>  		/* Used to restart an op with deadlock avoidance. */
> -		trace_xchk_deadlock_retry(sc->ip, sc->sm, *error);
> +		trace_xchk_deadlock_retry(
> +				sc->ip ? sc->ip : XFS_I(file_inode(sc->file)),
> +				sc->sm, *error);
>  		break;
>  	case -EFSBADCRC:
>  	case -EFSCORRUPTED:
> 

