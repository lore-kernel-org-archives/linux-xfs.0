Return-Path: <xfs-bounces@oss.sgi.com>
Subject: Re: [PATCH 34/44] includecheck fix: fs/xfs, xfs_iops.c
References: <1247063308.4382.12.camel@ht.satnam>
	<1247067971.4382.94.camel@ht.satnam>
From: Olaf Weber <olaf@sgi.com>
Date: Thu, 09 Jul 2009 16:52:48 +0200
In-Reply-To: <1247067971.4382.94.camel@ht.satnam> (Jaswinder Singh Rajput's
	message of "Wed, 08 Jul 2009 21:16:11 +0530")
Message-ID: <bzyhbxlx60v.fsf@fransum.emea.sgi.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: xfs-masters@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>, xfs@oss.sgi.com

Jaswinder Singh Rajput writes:

> fix the following 'make includecheck' warning:

>   fs/xfs/linux-2.6/xfs_iops.c: xfs_acl.h is included more than once.

> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Acked-By: Olaf Weber <olaf@sgi.com>



> ---
>  fs/xfs/linux-2.6/xfs_iops.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

> diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
> index 58973bb..793a146 100644
> --- a/fs/xfs/linux-2.6/xfs_iops.c
> +++ b/fs/xfs/linux-2.6/xfs_iops.c
> @@ -43,7 +43,6 @@
>  #include "xfs_error.h"
>  #include "xfs_itable.h"
>  #include "xfs_rw.h"
> -#include "xfs_acl.h"
>  #include "xfs_attr.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_utils.h"
> -- 
> 1.6.0.6

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
