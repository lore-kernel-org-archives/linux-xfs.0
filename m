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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63243C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 13:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3601B221EC
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 13:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731666AbhAKNjN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 08:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731665AbhAKNjM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 08:39:12 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BBFC061786
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 05:38:32 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id c13so8282999pfi.12
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 05:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=lf/IbMVfoSrJlsKiti3SIsC8UJKVFgLkYBaJyhmYIi0=;
        b=WeJaHcgO4IG1oBiORkAfLoNyNtGm9InJsqbFLI/webOw70r6PxnU0ZV03reFDc2qtk
         K7Nt88FgqhTWky/mM3ZoT4HHp/9gsWsVj6jsgaDPoCO9sXEZmuaQSx986y4wHzAPvZl4
         cUXJyOAuWzYaQz/cEB3yz1FzRmurPXrdyif4Akh11jrYVk3fhUUXGjdLREJPz40klJFq
         PDhkJ5jdlWWi9WHaVdwgICqfO2WEmfRYkBeqvBifudVmp+rMPHTmdcCA3fdZ/olF6YJp
         0LGVArtFePHZ1uxNX7h+8rrdkCAeQDzaK4Is0kmMZuO9V223xCa7es4Ght6jFl28Ip62
         tU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=lf/IbMVfoSrJlsKiti3SIsC8UJKVFgLkYBaJyhmYIi0=;
        b=fYAGrURbdhq4Uq2RNy/7TkbBXZc98Wypjjb7AHbGCAdLrif6A5ncyPhTOUf3UetpSS
         NXVRL6J2hk8Fv2bNf1VLL25OZChicP8nfMfQ3J4JEo5h5lDgcjCQcXJSFjJK2X2D/At3
         LzxvsDXzTfJ4EIdzq0VFlA3VyHbLuTOlnMxqH4Cs3YorGVPngG5pySiqjzbXD6lcYf/v
         xGp6yJFgi2fiCaVcWOR0y352yprIO55TqbhHfCDCuWCUlVnS2OkCt2V8Fh+QDU1sUp+Y
         ZmEFQPWgMeywqbOq/DtD3t8FzLldDKWIbL28kfFgPg+ai7s7DaxGyMA725q3khKmcmOl
         zGrw==
X-Gm-Message-State: AOAM533gKMbcWXK1WD2wE8Rsf0CRWIvY/PA3/XLw02qrL+cpkdvx+YsS
        mxKvqu3KDzywT3Cv34HskNVy3J/I7To=
X-Google-Smtp-Source: ABdhPJyl1nUEIlEbcsPf128UCWB595hWBOqH/5AgfWTlDLudrF5nEuTB2wG06Vo0OqQUnr9f2nfYvA==
X-Received: by 2002:a63:dc44:: with SMTP id f4mr19550894pgj.261.1610372311848;
        Mon, 11 Jan 2021 05:38:31 -0800 (PST)
Received: from garuda ([122.179.76.16])
        by smtp.gmail.com with ESMTPSA id p187sm19000520pfp.60.2021.01.11.05.38.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 05:38:31 -0800 (PST)
References: <161017371478.1142776.6610535704942901172.stgit@magnolia> <161017372088.1142776.17470250928392025583.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] misc: fix valgrind complaints
In-reply-to: <161017372088.1142776.17470250928392025583.stgit@magnolia>
Date:   Mon, 11 Jan 2021 19:08:27 +0530
Message-ID: <871rerpp9o.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 09 Jan 2021 at 11:58, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Zero the memory that we pass to the kernel via ioctls so that we never
> pass userspace heap/stack garbage around.  This silences valgrind
> complaints about uninitialized padding areas.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  libhandle/handle.c |    7 ++++++-
>  scrub/inodes.c     |    1 +
>  scrub/spacemap.c   |    2 +-
>  3 files changed, 8 insertions(+), 2 deletions(-)
>
>
> diff --git a/libhandle/handle.c b/libhandle/handle.c
> index 5c1686b3..a6b35b09 100644
> --- a/libhandle/handle.c
> +++ b/libhandle/handle.c
> @@ -235,9 +235,12 @@ obj_to_handle(
>  {
>  	char		hbuf [MAXHANSIZ];
>  	int		ret;
> -	uint32_t	handlen;
> +	uint32_t	handlen = 0;
>  	xfs_fsop_handlereq_t hreq;
>
> +	memset(&hreq, 0, sizeof(hreq));
> +	memset(hbuf, 0, MAXHANSIZ);
> +
>  	if (opcode == XFS_IOC_FD_TO_HANDLE) {
>  		hreq.fd      = obj.fd;
>  		hreq.path    = NULL;
> @@ -280,6 +283,7 @@ open_by_fshandle(
>  	if ((fsfd = handle_to_fsfd(fshanp, &path)) < 0)
>  		return -1;
>
> +	memset(&hreq, 0, sizeof(hreq));
>  	hreq.fd       = 0;
>  	hreq.path     = NULL;
>  	hreq.oflags   = rw | O_LARGEFILE;
> @@ -387,6 +391,7 @@ attr_list_by_handle(
>  	if ((fd = handle_to_fsfd(hanp, &path)) < 0)
>  		return -1;
>
> +	memset(&alhreq, 0, sizeof(alhreq));
>  	alhreq.hreq.fd       = 0;
>  	alhreq.hreq.path     = NULL;
>  	alhreq.hreq.oflags   = O_LARGEFILE;
> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index 4550db83..f2bce16f 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -129,6 +129,7 @@ scan_ag_inodes(
>  				minor(ctx->fsinfo.fs_datadev),
>  				agno);
>
> +	memset(&handle, 0, sizeof(handle));
>  	memcpy(&handle.ha_fsid, ctx->fshandle, sizeof(handle.ha_fsid));
>  	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
>  			sizeof(handle.ha_fid.fid_len);
> diff --git a/scrub/spacemap.c b/scrub/spacemap.c
> index 9653916d..9362710e 100644
> --- a/scrub/spacemap.c
> +++ b/scrub/spacemap.c
> @@ -47,7 +47,7 @@ scrub_iterate_fsmap(
>  	int			i;
>  	int			error;
>
> -	head = malloc(fsmap_sizeof(FSMAP_NR));
> +	head = calloc(1, fsmap_sizeof(FSMAP_NR));
>  	if (!head)
>  		return errno;
>

Minor nit: The "memset(head, 0, sizeof(*head))" statement following the above
call to calloc() can now be removed.

--
chandan
