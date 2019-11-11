Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC38C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 13:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADE59206A3
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 13:51:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AqqvXT2F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfKKNv0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 08:51:26 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37715 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726887AbfKKNv0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 08:51:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573480285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+NFiFYmhiV8ckxH+VWyi0UtOtPtn6sSe9qafpYDa+Fc=;
        b=AqqvXT2FQWR7VHPMVKZxpZeemjb2m+s/Vy3aCN0qmVaZb+PSa7c512o32onvwy0Acj+274
        14u7r4HNAXIbGrH2hON/gaPTkXxaX833weebejsGYWz04OcWUDYcFPFr33NtiaSQbstRni
        TLcx5Wkj9anzepCAOnxOZcHase0ru+Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-fmHO5LfeN2m0NXhFKDDqFw-1; Mon, 11 Nov 2019 08:51:22 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B230E800EBA;
        Mon, 11 Nov 2019 13:51:21 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A6CC9F59;
        Mon, 11 Nov 2019 13:51:21 +0000 (UTC)
Date:   Mon, 11 Nov 2019 08:51:19 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a if_xfs_meta_bad macro for testing and
 logging bad metadata
Message-ID: <20191111134904.GB46312@bfoster>
References: <157343507145.1945685.2940312466469213044.stgit@magnolia>
 <157343507829.1945685.13191379852906635565.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157343507829.1945685.13191379852906635565.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: fmHO5LfeN2m0NXhFKDDqFw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 10, 2019 at 05:17:58PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Add a new macro, if_xfs_meta_bad, which we will use to integrate some
> corruption reporting when the corruption test expression is true.  This
> will be used in the next patch to remove the ugly XFS_WANT_CORRUPT*
> macros.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Ooh a new bikeshed... :)

>  fs/xfs/xfs_linux.h |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>=20
>=20
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 2271db4e8d66..d0fb1e612c42 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -229,6 +229,10 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t =
sector, unsigned int count,
>  #define ASSERT(expr)=09\
>  =09(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
> =20
> +#define xfs_meta_bad(mp, expr)=09\
> +=09(unlikely(expr) ? assfail((mp), #expr, __FILE__, __LINE__), \
> +=09=09=09  true : false)
> +
>  #else=09/* !DEBUG */
> =20
>  #ifdef XFS_WARN
> @@ -236,13 +240,23 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t=
 sector, unsigned int count,
>  #define ASSERT(expr)=09\
>  =09(likely(expr) ? (void)0 : asswarn(NULL, #expr, __FILE__, __LINE__))
> =20
> +#define xfs_meta_bad(mp, expr)=09\
> +=09(unlikely(expr) ? asswarn((mp), #expr, __FILE__, __LINE__), \
> +=09=09=09  true : false)
> +
>  #else=09/* !DEBUG && !XFS_WARN */
> =20
> -#define ASSERT(expr)=09((void)0)
> +#define ASSERT(expr)=09=09((void)0)
> +
> +#define xfs_meta_bad(mp, expr)=09\
> +=09(unlikely(expr) ? XFS_ERROR_REPORT(#expr, XFS_ERRLEVEL_LOW, (mp)), \
> +=09=09=09  true : false)
> =20
>  #endif /* XFS_WARN */
>  #endif /* DEBUG */
> =20
> +#define if_xfs_meta_bad(mp, expr)=09if (xfs_meta_bad((mp), (expr)))
> +

FWIW, 'xfs_meta_bad' doesn't really tell me anything about what the
macro is for, particularly since the logic that determines whether
metadata is bad is fed into it. IOW, I read that and expect the macro to
actually do something generic to determine whether metadata is bad.

Also having taken a quick look at the next patch, I agree with Christoph
on embedding if logic into the macro itself, at least with respect to
readability. It makes the code look like a typo/syntax error to me. :P I
agree that the existing macros are ugly, but they at least express
operational semantics reasonably well between [_RETURN|_GOTO]. If we
really want to fix the latter bit, perhaps the best incremental step is
to drop the branching logic and naming portion from the existing macros
and leave everything else as is (from the commit logs, it sounds like
this is more along the lines of your previous version, just without the
name change). From there perhaps we can come up with better naming
eventually. Just a thought.

Brian

>  #define STATIC static noinline
> =20
>  #ifdef CONFIG_XFS_RT
>=20

