Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2108C35E08
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7758921744
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:13:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bYyieiQX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbgBYPNc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 10:13:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37221 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729065AbgBYPNc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 10:13:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582643611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rnq60pWcCS36d3+HmkGYy1g2ULlrF5F1fj3K2Z0bFaY=;
        b=bYyieiQXSSkczsAOH301O+1WjoVszx69SBYMWnpX+LrEqRRDLiQFnzM65ydUuCPUW7fcCz
        VgMxirja8yrDeJ2jwY2fwFO2vX2tVgHDGx9ovkDSjfJGnSEQ6zvlg0qRyUZ/+AKtPsvvw+
        5K88UN696DN2VEBrozjx8Tnrd2s/nlw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-dyaoWSc7MwaAhLXRHoDz7w-1; Tue, 25 Feb 2020 10:13:28 -0500
X-MC-Unique: dyaoWSc7MwaAhLXRHoDz7w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2B00801F78;
        Tue, 25 Feb 2020 15:13:27 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5856428980;
        Tue, 25 Feb 2020 15:13:27 +0000 (UTC)
Date:   Tue, 25 Feb 2020 10:13:25 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] libxfs: clean up libxfs_destroy
Message-ID: <20200225151325.GE26938@bfoster>
References: <158258947401.451256.14269201133311837600.stgit@magnolia>
 <158258948621.451256.5275982330161893261.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258948621.451256.5275982330161893261.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:11:26PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> It's weird that libxfs_init opens the three devices passed in via the
> libxfs_xinit structure but libxfs_destroy doesn't actually close them.
> Fix this inconsistency and remove all the open-coded device closing.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  copy/xfs_copy.c     |    2 +-
>  db/init.c           |    8 +-------
>  include/libxfs.h    |    2 +-
>  libxfs/init.c       |   31 +++++++++++++++++++++++--------
>  mkfs/xfs_mkfs.c     |    7 +------
>  repair/xfs_repair.c |    7 +------
>  6 files changed, 28 insertions(+), 29 deletions(-)
> 
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index a6d67038..7f4615ac 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -1200,7 +1200,7 @@ main(int argc, char **argv)
>  
>  	check_errors();
>  	libxfs_umount(mp);
> -	libxfs_destroy();
> +	libxfs_destroy(&xargs);
>  
>  	return 0;
>  }
> diff --git a/db/init.c b/db/init.c
> index 0ac37368..e5450d2b 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -217,13 +217,7 @@ main(
>  	while (iocur_sp > start_iocur_sp)
>  		pop_cur();
>  	libxfs_umount(mp);
> -	if (x.ddev)
> -		libxfs_device_close(x.ddev);
> -	if (x.logdev && x.logdev != x.ddev)
> -		libxfs_device_close(x.logdev);
> -	if (x.rtdev)
> -		libxfs_device_close(x.rtdev);
> -	libxfs_destroy();
> +	libxfs_destroy(&x);
>  
>  	return exitcode;
>  }
> diff --git a/include/libxfs.h b/include/libxfs.h
> index aaac00f6..504f6e9c 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -136,7 +136,7 @@ typedef struct libxfs_xinit {
>  extern char	*progname;
>  extern xfs_lsn_t libxfs_max_lsn;
>  extern int	libxfs_init (libxfs_init_t *);
> -extern void	libxfs_destroy (void);
> +void		libxfs_destroy(struct libxfs_xinit *li);
>  extern int	libxfs_device_to_fd (dev_t);
>  extern dev_t	libxfs_device_open (char *, int, int, int);
>  extern void	libxfs_device_close (dev_t);
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 197690df..913f546f 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -259,6 +259,21 @@ destroy_zones(void)
>  	return leaked;
>  }
>  
> +static void
> +libxfs_close_devices(
> +	struct libxfs_xinit	*li)
> +{
> +	if (li->ddev)
> +		libxfs_device_close(li->ddev);
> +	if (li->logdev && li->logdev != li->ddev)
> +		libxfs_device_close(li->logdev);
> +	if (li->rtdev)
> +		libxfs_device_close(li->rtdev);
> +
> +	li->ddev = li->logdev = li->rtdev = 0;
> +	li->dfd = li->logfd = li->rtfd = -1;
> +}
> +
>  /*
>   * libxfs initialization.
>   * Caller gets a 0 on failure (and we print a message), 1 on success.
> @@ -385,12 +400,9 @@ libxfs_init(libxfs_init_t *a)
>  		unlink(rtpath);
>  	if (fd >= 0)
>  		close(fd);
> -	if (!rval && a->ddev)
> -		libxfs_device_close(a->ddev);
> -	if (!rval && a->logdev)
> -		libxfs_device_close(a->logdev);
> -	if (!rval && a->rtdev)
> -		libxfs_device_close(a->rtdev);
> +	if (!rval)
> +		libxfs_close_devices(a);
> +
>  	return rval;
>  }
>  
> @@ -913,9 +925,12 @@ libxfs_umount(
>   * Release any global resources used by libxfs.
>   */
>  void
> -libxfs_destroy(void)
> +libxfs_destroy(
> +	struct libxfs_xinit	*li)
>  {
> -	int	leaked;
> +	int			leaked;
> +
> +	libxfs_close_devices(li);
>  
>  	/* Free everything from the buffer cache before freeing buffer zone */
>  	libxfs_bcache_purge();
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 1038e604..7f315d8a 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3945,11 +3945,6 @@ main(
>  	if (error)
>  		exit(1);
>  
> -	if (xi.rtdev)
> -		libxfs_device_close(xi.rtdev);
> -	if (xi.logdev && xi.logdev != xi.ddev)
> -		libxfs_device_close(xi.logdev);
> -	libxfs_device_close(xi.ddev);
> -	libxfs_destroy();
> +	libxfs_destroy(&xi);
>  	return 0;
>  }
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index ccb13f4a..38578121 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -1111,12 +1111,7 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
>  	if (error)
>  		exit(1);
>  
> -	if (x.rtdev)
> -		libxfs_device_close(x.rtdev);
> -	if (x.logdev && x.logdev != x.ddev)
> -		libxfs_device_close(x.logdev);
> -	libxfs_device_close(x.ddev);
> -	libxfs_destroy();
> +	libxfs_destroy(&x);
>  
>  	if (verbose)
>  		summary_report();
> 

