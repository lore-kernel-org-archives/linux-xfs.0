Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1AB6C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 13:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACE65222D0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 13:05:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZhdrtmOP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfKMNFu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 08:05:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54914 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727073AbfKMNFu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 08:05:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573650349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1qar+R2tGsJi0DV/ywOG9+4EybBYfLY48nWyPPMSXaE=;
        b=ZhdrtmOPnqh5tJKjuPxT8R7MJrWKfIgz5/vpuI7ijjeGrC/yDrYJZabBknQ2BWyMvGchX5
        wqe6LRSvISzzNrWglAEGjHIaEMzx4ZKyJDmjrZjlZYdLzIJ9TS+x0hS9WJ2z+OgMlcBHV/
        3rJF5Gtt3mOJe42sAn2jILYSb1ROi2w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-bTjQAcCmMIaqFmNch88WEQ-1; Wed, 13 Nov 2019 08:05:46 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 127331083E82;
        Wed, 13 Nov 2019 13:05:45 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97B8C101F967;
        Wed, 13 Nov 2019 13:05:44 +0000 (UTC)
Date:   Wed, 13 Nov 2019 08:05:42 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix another missing include
Message-ID: <20191113130542.GB54921@bfoster>
References: <20191113044543.GQ6219@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191113044543.GQ6219@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: bTjQAcCmMIaqFmNch88WEQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 08:45:44PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Fix missing include of xfs_filestream.h in xfs_filestream.c so that we
> actually check the function declarations against the definitions.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_filestream.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 2ae356775f63..5f12b5d8527a 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -18,6 +18,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_trans.h"
> +#include "xfs_filestream.h"
> =20
>  struct xfs_fstrm_item {
>  =09struct xfs_mru_cache_elem=09mru;
>=20

