Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9494729DF5
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 18:23:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 313C4AC007
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 16:23:26 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	QgNrZbiKdJkhi1Yg for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2015 16:23:25 -0700 (PDT)
Date: Wed, 19 Aug 2015 09:23:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 04/13] xfs: ensure EFD trans aborts on log recovery
	extent free failure
Message-ID: <20150818232323.GN714@dastard>
References: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
	<1439233309-19959-5-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439233309-19959-5-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 10, 2015 at 03:01:40PM -0400, Brian Foster wrote:
> Log recovery attempts to free extents with leftover EFIs in the AIL
> after initial processing. If the extent free fails (e.g., due to
> unrelated fs corruption), the transaction is cancelled, though it might
> not be dirtied at the time. If this is the case, the EFD does not abort
> and thus does not release the EFI. This can lead to hangs as the EFI
> pins the AIL.
> =

> Update xlog_recover_process_efi() to log the EFD in the transaction
> before xfs_free_extent() errors are handled to ensure the transaction is
> dirty, aborts the EFD and releases the EFI on error. Since this is a
> requirement for EFD processing (and consistent with xfs_bmap_finish()),
> update the EFD logging helper to do the extent free and unconditionally
> log the EFD. This encodes the required EFD logging behavior into the
> helper and reduces the likelihood of errors down the road.
> =

> Signed-off-by: Brian Foster <bfoster@redhat.com>
....
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 9d8f242..c77dfb5 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -34,7 +34,6 @@
>  #include "xfs_inode_item.h"
>  #include "xfs_extfree_item.h"
>  #include "xfs_trans_priv.h"
> -#include "xfs_alloc.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_quota.h"
>  #include "xfs_cksum.h"

Causes compilation failure:

fs/xfs/xfs_log_recover.c: In function =BFxlog_recover_check_summary=BF:
fs/xfs/xfs_log_recover.c:4635:3: error: implicit declaration of function =
=BFxfs_read_agf=BF [-Werror=3Dimplicit-function-declaration]
   error =3D xfs_read_agf(mp, NULL, agno, 0, &agfbp);
   ^

I reinstated the include.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
