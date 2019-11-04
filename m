Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D075CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 15:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 254C520869
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 15:44:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HxhaLwQU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbfKDPo2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 10:44:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30906 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727796AbfKDPo2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 10:44:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572882267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xSpbAt7GSqplhiVfjybipxCd5SNBBcAW20Zrc0Ih/OA=;
        b=HxhaLwQUMwfFKH/NuuBcjaRC4UGyuAe6cBoBiYP5InTx0Tn94NA+joG6x1wcwf/0JHN4YQ
        xcnyAr5tJB6LSA/t5VBBI82sx0mL7LqrnB8Bm3UBXaADttKq8O54enwRoVscCWEK+0ge82
        x2Tq9jgewcF84Q7dyfCGNidh3VYXV/4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-ra2Y53RHOwmY17mI76MvIQ-1; Mon, 04 Nov 2019 10:44:25 -0500
Received: by mail-wm1-f72.google.com with SMTP id i23so6508444wmb.3
        for <linux-xfs@vger.kernel.org>; Mon, 04 Nov 2019 07:44:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=76Bod+y6+f6OQcN0ZEN7/hUDnf8TymgVsKvkwMXovvc=;
        b=NTAp3k6EaTw3kzId5WP9CMBaMQYY5vl+9lJMECf1JYgHH4DnbES8e8VBLqORR9vDrC
         qe5hTyQGOQ03dJ7JULwtBTv6gP3coqMFO2y3HFZ/GtCvUfFMKHsB2ejQG9kVBXi60YE0
         j+IY/QLn2keWmNhLccvBTrYQ1ZpfdrFz7IdsSCnr8fGmfOcOzLo7q+TgvdXjH7fZhYt2
         tjzf5QzPrQthjZPGM0y6WcGjY4wqHtGChgu3LYEGXesSLzL9UgPXSYqGhLmG6NtRNgcC
         aJiYQFNSWiZ6EgiQkw5G8H/PxMEysriDV+A9apiG59PDasL14XHb6ndFAJtS6cHgp8xf
         QsWg==
X-Gm-Message-State: APjAAAXvBKWl4n15U/RESIacnc6WY3wwtfotyiO6u4AuB0kGPDgt3Yjo
        EFP271NuB1NiuAkREogXhreudEU9zwFQQYhmrrAPujZrUc6LtsrQLse2B1xOpoTfwV2bsyxYxXS
        TZYJx7zdmjSq/P61Otw8t
X-Received: by 2002:a7b:c94f:: with SMTP id i15mr24076631wml.8.1572882264402;
        Mon, 04 Nov 2019 07:44:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqzlbN6UqlEboPPTxhW5lmyfElqvvE9dI/5AKCuQPCMWP8YVa+8perVfZG4FhDnvxkgPTdIMDw==
X-Received: by 2002:a7b:c94f:: with SMTP id i15mr24076613wml.8.1572882264186;
        Mon, 04 Nov 2019 07:44:24 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id 6sm24479095wmd.36.2019.11.04.07.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 07:44:23 -0800 (PST)
Date:   Mon, 4 Nov 2019 16:44:21 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: constify the buffer pointer arguments to error
 functions
Message-ID: <20191104154421.iyiphtp4la7zg2cv@orion>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <157281982341.4150947.10288936972373805803.stgit@magnolia>
 <157281983593.4150947.13692433066759624464.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157281983593.4150947.13692433066759624464.stgit@magnolia>
X-MC-Unique: ra2Y53RHOwmY17mI76MvIQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 03, 2019 at 02:23:55PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Some of the xfs error message functions take a pointer to a buffer that
> will be dumped to the system log.  The logging functions don't change
> the contents, so constify all the parameters.  This enables the next
> patch to ensure that we log bad metadata when we encounter it.
>=20

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_error.c   |    6 +++---
>  fs/xfs/xfs_error.h   |    6 +++---
>  fs/xfs/xfs_message.c |    2 +-
>  fs/xfs/xfs_message.h |    2 +-
>  4 files changed, 8 insertions(+), 8 deletions(-)
>=20
>=20
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 849fd4476950..0b156cc88108 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -329,7 +329,7 @@ xfs_corruption_error(
>  =09const char=09=09*tag,
>  =09int=09=09=09level,
>  =09struct xfs_mount=09*mp,
> -=09void=09=09=09*buf,
> +=09const void=09=09*buf,
>  =09size_t=09=09=09bufsize,
>  =09const char=09=09*filename,
>  =09int=09=09=09linenum,
> @@ -350,7 +350,7 @@ xfs_buf_verifier_error(
>  =09struct xfs_buf=09=09*bp,
>  =09int=09=09=09error,
>  =09const char=09=09*name,
> -=09void=09=09=09*buf,
> +=09const void=09=09*buf,
>  =09size_t=09=09=09bufsz,
>  =09xfs_failaddr_t=09=09failaddr)
>  {
> @@ -402,7 +402,7 @@ xfs_inode_verifier_error(
>  =09struct xfs_inode=09*ip,
>  =09int=09=09=09error,
>  =09const char=09=09*name,
> -=09void=09=09=09*buf,
> +=09const void=09=09*buf,
>  =09size_t=09=09=09bufsz,
>  =09xfs_failaddr_t=09=09failaddr)
>  {
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index 602aa7d62b66..e6a22cfb542f 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -12,16 +12,16 @@ extern void xfs_error_report(const char *tag, int lev=
el, struct xfs_mount *mp,
>  =09=09=09const char *filename, int linenum,
>  =09=09=09xfs_failaddr_t failaddr);
>  extern void xfs_corruption_error(const char *tag, int level,
> -=09=09=09struct xfs_mount *mp, void *buf, size_t bufsize,
> +=09=09=09struct xfs_mount *mp, const void *buf, size_t bufsize,
>  =09=09=09const char *filename, int linenum,
>  =09=09=09xfs_failaddr_t failaddr);
>  extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
> -=09=09=09const char *name, void *buf, size_t bufsz,
> +=09=09=09const char *name, const void *buf, size_t bufsz,
>  =09=09=09xfs_failaddr_t failaddr);
>  extern void xfs_verifier_error(struct xfs_buf *bp, int error,
>  =09=09=09xfs_failaddr_t failaddr);
>  extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
> -=09=09=09const char *name, void *buf, size_t bufsz,
> +=09=09=09const char *name, const void *buf, size_t bufsz,
>  =09=09=09xfs_failaddr_t failaddr);
> =20
>  #define=09XFS_ERROR_REPORT(e, lvl, mp)=09\
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index 9804efe525a9..c57e8ad39712 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -105,7 +105,7 @@ assfail(char *expr, char *file, int line)
>  }
> =20
>  void
> -xfs_hex_dump(void *p, int length)
> +xfs_hex_dump(const void *p, int length)
>  {
>  =09print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p, length, =
1);
>  }
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index 34447dca97d1..7f040b04b739 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -60,6 +60,6 @@ do {=09=09=09=09=09=09=09=09=09\
>  extern void assfail(char *expr, char *f, int l);
>  extern void asswarn(char *expr, char *f, int l);
> =20
> -extern void xfs_hex_dump(void *p, int length);
> +extern void xfs_hex_dump(const void *p, int length);
> =20
>  #endif=09/* __XFS_MESSAGE_H */
>=20

--=20
Carlos

