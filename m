Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5AC0C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 18:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F810214E0
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 18:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SGr31ud7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKKSXe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 13:23:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41924 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726821AbfKKSXe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 13:23:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573496612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9ykE8P7amfN6aXdXTYeLeoHJVq9nSI//gdhG8fMTa20=;
        b=SGr31ud7KYhA0TRgJ+rRalUA4xtYixoN4Wfg1wjolptxjrn6GD4Eu7TeHNIIg95XABKycx
        3To6DyWVc+LQFXbQ3smPdvCb1XkfUPmwAC+KcYFFvFKQOz2evzpEOY0CxhBc7wdNjpZ6gk
        AGPYlrmIKJbE+3WEgxTGhL2T3Ypq3tg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-QT57w0U5PzaOmc4094cstw-1; Mon, 11 Nov 2019 13:23:29 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7793618A44ED;
        Mon, 11 Nov 2019 18:23:28 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 223F928D19;
        Mon, 11 Nov 2019 18:23:28 +0000 (UTC)
Date:   Mon, 11 Nov 2019 13:23:26 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 14/17] xfs: Add delay context to xfs_da_args
Message-ID: <20191111182326.GE46312@bfoster>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-15-allison.henderson@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20191107012801.22863-15-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: QT57w0U5PzaOmc4094cstw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:27:58PM -0700, Allison Collins wrote:
> This patch adds a new struct xfs_delay_context, which we
> will use to keep track of the current state of a delayed
> attribute operation.
>=20

Technically, this should track delayed or non-delayed attr operations,
right? IIRC, the goal is that the difference between the two is that the
former is driven by the dfops mechanism while the latter executes the
same code with a higher level hack to roll transactions and loop through
the state machine...

Brian

> The new enum is used to track various operations that
> are in progress so that we know not to repeat them, and
> resume where we left off before EAGAIN was returned to
> cycle out the transaction.  Other members take the place
> of local variables that need to retain their values
> across multiple function recalls.
>=20
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.h | 28 ++++++++++++++++++++++++++++
>  fs/xfs/scrub/common.c        |  2 ++
>  fs/xfs/xfs_acl.c             |  2 ++
>  fs/xfs/xfs_attr_list.c       |  1 +
>  fs/xfs/xfs_ioctl.c           |  2 ++
>  fs/xfs/xfs_ioctl32.c         |  2 ++
>  fs/xfs/xfs_iops.c            |  2 ++
>  fs/xfs/xfs_xattr.c           |  1 +
>  8 files changed, 40 insertions(+)
>=20
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index bed4f40..ef23ed8 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -42,6 +42,33 @@ enum xfs_dacmp {
>  =09XFS_CMP_CASE=09=09/* names are same but differ in case */
>  };
> =20
> +enum xfs_attr_state {
> +=09XFS_DC_INIT=09=09=3D 1, /* Init delay info */
> +=09XFS_DC_SF_TO_LEAF=09=3D 2, /* Converted short form to leaf */
> +=09XFS_DC_FOUND_LBLK=09=3D 3, /* We found leaf blk for attr */
> +=09XFS_DC_LEAF_TO_NODE=09=3D 4, /* Converted leaf to node */
> +=09XFS_DC_FOUND_NBLK=09=3D 5, /* We found node blk for attr */
> +=09XFS_DC_ALLOC_LEAF=09=3D 6, /* We are allocating leaf blocks */
> +=09XFS_DC_ALLOC_NODE=09=3D 7, /* We are allocating node blocks */
> +=09XFS_DC_RM_INVALIDATE=09=3D 8, /* We are invalidating blocks */
> +=09XFS_DC_RM_SHRINK=09=3D 9, /* We are shrinking the tree */
> +=09XFS_DC_RM_NODE_BLKS=09=3D 10,/* We are removing node blocks */
> +};
> +
> +/*
> + * Context used for keeping track of delayed attribute operations
> + */
> +struct xfs_delay_context {
> +=09enum xfs_attr_state=09dc_state;
> +=09struct xfs_buf=09=09*leaf_bp;
> +=09struct xfs_bmbt_irec=09map;
> +=09xfs_dablk_t=09=09lblkno;
> +=09xfs_fileoff_t=09=09lfileoff;
> +=09int=09=09=09blkcnt;
> +=09struct xfs_da_state=09*da_state;
> +=09struct xfs_da_state_blk *blk;
> +};
> +
>  /*
>   * Structure to ease passing around component names.
>   */
> @@ -69,6 +96,7 @@ typedef struct xfs_da_args {
>  =09int=09=09rmtvaluelen2;=09/* remote attr value length in bytes */
>  =09int=09=09op_flags;=09/* operation flags */
>  =09enum xfs_dacmp=09cmpresult;=09/* name compare result for lookups */
> +=09struct xfs_delay_context  dc;=09/* context used for delay attr ops */
>  } xfs_da_args_t;
> =20
>  /*
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 1887605..9a649d1 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -24,6 +24,8 @@
>  #include "xfs_rmap_btree.h"
>  #include "xfs_log.h"
>  #include "xfs_trans_priv.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_reflink.h"
>  #include "scrub/scrub.h"
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index e868755..1336477 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -10,6 +10,8 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_trace.h"
>  #include <linux/posix_acl_xattr.h>
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index fab416c..e395864 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -12,6 +12,7 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_bmap.h"
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index ae0ed88..23b0ca6 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -15,6 +15,8 @@
>  #include "xfs_iwalk.h"
>  #include "xfs_itable.h"
>  #include "xfs_error.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_util.h"
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 3c0d518..e3278ac 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -17,6 +17,8 @@
>  #include "xfs_itable.h"
>  #include "xfs_fsops.h"
>  #include "xfs_rtalloc.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_ioctl.h"
>  #include "xfs_ioctl32.h"
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index aef346e..68b9cd0 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -13,6 +13,8 @@
>  #include "xfs_inode.h"
>  #include "xfs_acl.h"
>  #include "xfs_quota.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
>  #include "xfs_trans.h"
>  #include "xfs_trace.h"
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 6c5321d..0f0ebab 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -10,6 +10,7 @@
>  #include "xfs_log_format.h"
>  #include "xfs_da_format.h"
>  #include "xfs_inode.h"
> +#include "xfs_da_btree.h"
>  #include "xfs_attr.h"
> =20
>  #include <linux/posix_acl_xattr.h>
> --=20
> 2.7.4
>=20

