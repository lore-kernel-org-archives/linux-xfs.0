Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 37C057F54
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 06:02:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B8891AC007
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 04:02:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UrL9mEjtCFe6oKVo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2015 04:02:03 -0700 (PDT)
Date: Wed, 19 Aug 2015 07:02:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 04/13] xfs: ensure EFD trans aborts on log recovery
	extent free failure
Message-ID: <20150819110200.GA49174@bfoster.bfoster>
References: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
	<1439233309-19959-5-git-send-email-bfoster@redhat.com>
	<20150818232323.GN714@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150818232323.GN714@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 19, 2015 at 09:23:23AM +1000, Dave Chinner wrote:
> On Mon, Aug 10, 2015 at 03:01:40PM -0400, Brian Foster wrote:
> > Log recovery attempts to free extents with leftover EFIs in the AIL
> > after initial processing. If the extent free fails (e.g., due to
> > unrelated fs corruption), the transaction is cancelled, though it might
> > not be dirtied at the time. If this is the case, the EFD does not abort
> > and thus does not release the EFI. This can lead to hangs as the EFI
> > pins the AIL.
> > =

> > Update xlog_recover_process_efi() to log the EFD in the transaction
> > before xfs_free_extent() errors are handled to ensure the transaction is
> > dirty, aborts the EFD and releases the EFI on error. Since this is a
> > requirement for EFD processing (and consistent with xfs_bmap_finish()),
> > update the EFD logging helper to do the extent free and unconditionally
> > log the EFD. This encodes the required EFD logging behavior into the
> > helper and reduces the likelihood of errors down the road.
> > =

> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> ....
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 9d8f242..c77dfb5 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -34,7 +34,6 @@
> >  #include "xfs_inode_item.h"
> >  #include "xfs_extfree_item.h"
> >  #include "xfs_trans_priv.h"
> > -#include "xfs_alloc.h"
> >  #include "xfs_ialloc.h"
> >  #include "xfs_quota.h"
> >  #include "xfs_cksum.h"
> =

> Causes compilation failure:
> =

> fs/xfs/xfs_log_recover.c: In function =BFxlog_recover_check_summary=BF:
> fs/xfs/xfs_log_recover.c:4635:3: error: implicit declaration of function =
=BFxfs_read_agf=BF [-Werror=3Dimplicit-function-declaration]
>    error =3D xfs_read_agf(mp, NULL, agno, 0, &agfbp);
>    ^
> =

> I reinstated the include.
> =


Oops, I thought I had built this with debug mode. Sorry about that...

Brian

> Cheers,
> =

> Dave.
> -- =

> Dave Chinner
> david@fromorbit.com
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
