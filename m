Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF543C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 04:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90414224B8
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 04:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbhAREeY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Jan 2021 23:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731053AbhAREeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Jan 2021 23:34:22 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83ED8C061573
        for <linux-xfs@vger.kernel.org>; Sun, 17 Jan 2021 20:33:42 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y205so3636563pfc.5
        for <linux-xfs@vger.kernel.org>; Sun, 17 Jan 2021 20:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Ia+Q53Ma+h2EvErkpdSmuxfrU4gnnh+o9dnU1CfWoTk=;
        b=jYWTlmOzZExCrYWDyO0qN/2+YIsOTH1P+ZTGIdczNzTaXlIrTpp/gR7itckx/NTLs4
         WkVs4YK5aV69lmN/oSW+wj1xBPNYN9UCRV4qRUcjWqX08khywrujVDGXei/Cqqp7xfKr
         TJWKs1Rk6HpX9lQkqFUpbRNLoecIMvWhYFdld6drDMtrGYtDGqNdNYjyBXeQvkdAIBLQ
         y/SY1hnoD1V/3AsDPiZ4C+NoFFOWW0NzxvhBiJmQ2rpLHNJ8WCPGUPkYxUSnRp0U536L
         ZTNKRgZhKAy9mOLBsV+2agqN3Eg/3PlsiQVtZ/NnHDtXHROfcV+oRQRcoLUFtKn3KFAd
         OVhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Ia+Q53Ma+h2EvErkpdSmuxfrU4gnnh+o9dnU1CfWoTk=;
        b=hXP5DGJOjaBY0X1NWDkk2QOmAf2BWIHkkbEdNiggUu0SghOaSp6InYg/qxsL8jAUAp
         5qthF/7Dmpkei4qtmYBRJb1vyDHVcfNb/ETA3jfO7mvinaqg4/tjHwA00wiwV2OjS2+1
         /3lxZ6gls1kMjOqyReK84mkPUokHJ/CNZbCXKAR8O6DsrKRP/DW/Gy4hJm0Cf4CIupzz
         Sa8rr72ke4dt+kj+4SqX/aZSajKNoE8e7wq0uD9QHR7U5mE87v9RvY+1JWtXVt5LmARL
         yts9X3OGN+1RwzLPkRmWF6zQRsyAOKuGT5YvWKVBmAuTEgU7vjS+CKMbAk1LCH+y4dA2
         rssQ==
X-Gm-Message-State: AOAM531o4oYESShWRpznAprJtPAB4sQKRonvMjbmevV7wpe5KbgkbeFH
        n44Eyqo8+BkaY7wV7W/tmhCK6d4bVkg=
X-Google-Smtp-Source: ABdhPJwGK+R5ycvKYL9CXKTzTWKspvCqSRZm7phgJ4of7IuN5eJX+p+ShkMOtBUrIz4cqNtRbnFglA==
X-Received: by 2002:a63:c10f:: with SMTP id w15mr24075408pgf.99.1610944421944;
        Sun, 17 Jan 2021 20:33:41 -0800 (PST)
Received: from garuda ([122.179.96.31])
        by smtp.gmail.com with ESMTPSA id 19sm14193183pfn.133.2021.01.17.20.33.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Jan 2021 20:33:41 -0800 (PST)
References: <161076031261.3386689.3320804567045193864.stgit@magnolia> <161076031855.3386689.6419632333068855983.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] misc: fix valgrind complaints
In-reply-to: <161076031855.3386689.6419632333068855983.stgit@magnolia>
Date:   Mon, 18 Jan 2021 10:03:38 +0530
Message-ID: <87k0san9st.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 16 Jan 2021 at 06:55, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Zero the memory that we pass to the kernel via ioctls so that we never
> pass userspace heap/stack garbage around.  This silences valgrind
> complaints about uninitialized padding areas.
>

Looks good to me,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  libhandle/handle.c |   10 ++++++----
>  scrub/inodes.c     |    2 +-
>  scrub/spacemap.c   |    3 +--
>  3 files changed, 8 insertions(+), 7 deletions(-)
>
>
> diff --git a/libhandle/handle.c b/libhandle/handle.c
> index 5c1686b3..27abc6b2 100644
> --- a/libhandle/handle.c
> +++ b/libhandle/handle.c
> @@ -235,8 +235,10 @@ obj_to_handle(
>  {
>  	char		hbuf [MAXHANSIZ];
>  	int		ret;
> -	uint32_t	handlen;
> -	xfs_fsop_handlereq_t hreq;
> +	uint32_t	handlen = 0;
> +	struct xfs_fsop_handlereq hreq = { };
> +
> +	memset(hbuf, 0, MAXHANSIZ);
>  
>  	if (opcode == XFS_IOC_FD_TO_HANDLE) {
>  		hreq.fd      = obj.fd;
> @@ -275,7 +277,7 @@ open_by_fshandle(
>  {
>  	int		fsfd;
>  	char		*path;
> -	xfs_fsop_handlereq_t hreq;
> +	struct xfs_fsop_handlereq hreq = { };
>  
>  	if ((fsfd = handle_to_fsfd(fshanp, &path)) < 0)
>  		return -1;
> @@ -382,7 +384,7 @@ attr_list_by_handle(
>  {
>  	int		error, fd;
>  	char		*path;
> -	xfs_fsop_attrlist_handlereq_t alhreq;
> +	struct xfs_fsop_attrlist_handlereq alhreq = { };
>  
>  	if ((fd = handle_to_fsfd(hanp, &path)) < 0)
>  		return -1;
> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index bdc12df3..63865113 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -111,7 +111,7 @@ scan_ag_inodes(
>  	xfs_agnumber_t		agno,
>  	void			*arg)
>  {
> -	struct xfs_handle	handle;
> +	struct xfs_handle	handle = { };
>  	char			descr[DESCR_BUFSZ];
>  	struct xfs_inumbers_req	*ireq;
>  	struct xfs_bulkstat_req	*breq;
> diff --git a/scrub/spacemap.c b/scrub/spacemap.c
> index 9653916d..a5508d56 100644
> --- a/scrub/spacemap.c
> +++ b/scrub/spacemap.c
> @@ -47,11 +47,10 @@ scrub_iterate_fsmap(
>  	int			i;
>  	int			error;
>  
> -	head = malloc(fsmap_sizeof(FSMAP_NR));
> +	head = calloc(1, fsmap_sizeof(FSMAP_NR));
>  	if (!head)
>  		return errno;
>  
> -	memset(head, 0, sizeof(*head));
>  	memcpy(head->fmh_keys, keys, sizeof(struct fsmap) * 2);
>  	head->fmh_count = FSMAP_NR;
>  


-- 
chandan
