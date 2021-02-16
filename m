Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC730C433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 11:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A3C964DF0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 11:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhBPL6x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Feb 2021 06:58:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38799 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230348AbhBPL6R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Feb 2021 06:58:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613476610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=afONmEc+5qZJHJ5XlM70QwXtEAg2nSDTNTbQ0eS/ZMw=;
        b=HTCFqJ9z0OP9Jwer1Ad4G7xyDJSdDgoqt+NuObaOkDglWgricp56OCiEHX3EAgh6RpIB0H
        MJB9ThjgKmt3GLn6CRs34Fmz6D5Lo/VmU0miN13nAvZh2xmSO1CAh0CS72izYJyI+moT3U
        WJUcIhzJ7RfcoqRj0s1iU9HuO8ALnas=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-6Ksu0bW1MkO_7shh89NIlA-1; Tue, 16 Feb 2021 06:56:48 -0500
X-MC-Unique: 6Ksu0bW1MkO_7shh89NIlA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9ABD18A0836;
        Tue, 16 Feb 2021 11:56:47 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 315FE60C15;
        Tue, 16 Feb 2021 11:56:47 +0000 (UTC)
Date:   Tue, 16 Feb 2021 06:56:45 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] libxfs: simulate system failure after a certain
 number of writes
Message-ID: <20210216115645.GC534175@bfoster>
References: <161319520460.422860.10568013013578673175.stgit@magnolia>
 <161319521620.422860.17802896302850828411.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161319521620.422860.17802896302850828411.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 12, 2021 at 09:46:56PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add an error injection knob so that we can simulate system failure after
> a certain number of disk writes.  This knob is being added so that we
> can check repair's behavior after an arbitrary number of tests.
> 
> Set LIBXFS_DEBUG_WRITE_CRASH={ddev,logdev,rtdev}=nn in the environment
> to make libxfs SIGKILL itself after nn writes to the data, log, or rt
> devices.  Note that this only applies to xfs_buf writes and zero_range.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  libxfs/init.c      |   68 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  libxfs/libxfs_io.h |   19 +++++++++++++++
>  libxfs/rdwr.c      |    6 ++++-
>  3 files changed, 88 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 8a8ce3c4..1ec83791 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
...
> @@ -614,6 +634,46 @@ libxfs_buftarg_init(
>  	dev_t			logdev,
>  	dev_t			rtdev)
>  {
> +	char			*p = getenv("LIBXFS_DEBUG_WRITE_CRASH");
> +	unsigned long		dfail = 0, lfail = 0, rfail = 0;

Was there a reason for using an environment variable now rather than the
original command line option?

> +
> +	/* Simulate utility crash after a certain number of writes. */
> +	while (p && *p) {
> +		char *val;
> +
> +		switch (getsubopt(&p, wf_opts, &val)) {
> +		case WF_DATA:
> +			if (!val) {
> +				fprintf(stderr,
> +		_("ddev write fail requires a parameter\n"));
> +				exit(1);
> +			}
> +			dfail = strtoul(val, NULL, 0);
> +			break;
> +		case WF_LOG:
> +			if (!val) {
> +				fprintf(stderr,
> +		_("logdev write fail requires a parameter\n"));
> +				exit(1);
> +			}
> +			lfail = strtoul(val, NULL, 0);
> +			break;
> +		case WF_RT:
> +			if (!val) {
> +				fprintf(stderr,
> +		_("rtdev write fail requires a parameter\n"));
> +				exit(1);
> +			}
> +			rfail = strtoul(val, NULL, 0);
> +			break;
> +		default:
> +			fprintf(stderr, _("unknown write fail type %s\n"),
> +					val);
> +			exit(1);
> +			break;
> +		}
> +	}
> +
>  	if (mp->m_ddev_targp) {
>  		/* should already have all buftargs initialised */
>  		if (mp->m_ddev_targp->bt_bdev != dev ||
...
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index c80e2d59..85485257 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
...
> @@ -30,6 +32,23 @@ struct xfs_buftarg {
>  #define XFS_BUFTARG_LOST_WRITE		(1 << 0)
>  /* A dirty buffer failed the write verifier. */
>  #define XFS_BUFTARG_CORRUPT_WRITE	(1 << 1)
> +/* Simulate failure after a certain number of writes. */
> +#define XFS_BUFTARG_INJECT_WRITE_FAIL	(1 << 2)
> +
> +/* Simulate the system crashing after a write. */
> +static inline void
> +xfs_buftarg_trip_write(
> +	struct xfs_buftarg	*btp)
> +{
> +	if (!(btp->flags & XFS_BUFTARG_INJECT_WRITE_FAIL))
> +		return;
> +
> +	pthread_mutex_lock(&btp->lock);
> +	btp->writes_left--;
> +	if (!btp->writes_left)
> +		kill(getpid(), SIGKILL);

Can we just exit()?

(Same questions for the next patch..)

Brian

> +	pthread_mutex_unlock(&btp->lock);
> +}
>  
>  extern void	libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
>  				    dev_t logdev, dev_t rtdev);
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index ca272387..fd456d6b 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -74,8 +74,10 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
>  	/* try to use special zeroing methods, fall back to writes if needed */
>  	len_bytes = LIBXFS_BBTOOFF64(len);
>  	error = platform_zero_range(fd, start_offset, len_bytes);
> -	if (!error)
> +	if (!error) {
> +		xfs_buftarg_trip_write(btp);
>  		return 0;
> +	}
>  
>  	zsize = min(BDSTRAT_SIZE, BBTOB(len));
>  	if ((z = memalign(libxfs_device_alignment(), zsize)) == NULL) {
> @@ -105,6 +107,7 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
>  				progname, __FUNCTION__);
>  			exit(1);
>  		}
> +		xfs_buftarg_trip_write(btp);
>  		offset += bytes;
>  	}
>  	free(z);
> @@ -860,6 +863,7 @@ libxfs_bwrite(
>  	} else {
>  		bp->b_flags |= LIBXFS_B_UPTODATE;
>  		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);
> +		xfs_buftarg_trip_write(bp->b_target);
>  	}
>  	return bp->b_error;
>  }
> 

