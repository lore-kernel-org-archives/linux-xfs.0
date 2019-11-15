Return-Path: <SRS0=3CCN=ZH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B081C432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 11:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E9532072D
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 11:40:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A1vldeXs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfKOLkt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 06:40:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24004 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727135AbfKOLkt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Nov 2019 06:40:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573818048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TW6oOVtLwSmyX/RpXxdvqfk5bcGM6TPlxF11KUOwgtw=;
        b=A1vldeXsfTj9+k35nSihafUhYjP4sT0vvWtJlNsnNzg8RKSASEIGr9NtVQUyXXVjJVd5Rn
        Q6zKmBl4q/SJJM59MLDaAwSBLGa1iHjMV2/kLtL8Z06TqLYiYunwIDGD7q3a0Yfgv8f3Yc
        Znx/RkMF/RD1FQGYF+6DQNJQcuWCsMc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-_xSF8aBPNtu4XUYWNvSbzw-1; Fri, 15 Nov 2019 06:40:45 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7C26802682;
        Fri, 15 Nov 2019 11:40:44 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 811C160137;
        Fri, 15 Nov 2019 11:40:44 +0000 (UTC)
Date:   Fri, 15 Nov 2019 06:40:42 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix some memory leaks in log recovery
Message-ID: <20191115114042.GA54119@bfoster>
References: <20191114211110.GM6219@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191114211110.GM6219@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: _xSF8aBPNtu4XUYWNvSbzw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 14, 2019 at 01:11:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Fix a few places where we xlog_alloc_buffer a buffer, hit an error, and
> then bail out without freeing the buffer.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_recover.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index f64614c3c13e..165f5181d02d 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1342,10 +1342,11 @@ xlog_find_tail(
>  =09error =3D xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, buffer,
>  =09=09=09=09      &rhead_blk, &rhead, &wrapped);
>  =09if (error < 0)
> -=09=09return error;
> +=09=09goto done;
>  =09if (!error) {
>  =09=09xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
> -=09=09return -EFSCORRUPTED;
> +=09=09error =3D -EFSCORRUPTED;
> +=09=09goto done;
>  =09}
>  =09*tail_blk =3D BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
> =20
> @@ -5300,7 +5301,8 @@ xlog_do_recovery_pass(
>  =09=09=09} else {
>  =09=09=09=09XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
>  =09=09=09=09=09=09log->l_mp);
> -=09=09=09=09return -EFSCORRUPTED;
> +=09=09=09=09error =3D -EFSCORRUPTED;
> +=09=09=09=09goto bread_err1;
>  =09=09=09}
>  =09=09}
> =20
>=20

