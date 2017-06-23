Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751107AbdFWLDR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Jun 2017 07:03:17 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A4741F59A
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2017 11:03:16 +0000 (UTC)
Date: Fri, 23 Jun 2017 13:03:11 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v3] xfs_db: update sector size when type is set
Message-ID: <20170623110311.ikixwvticrwiqbrh@eorzea.usersys.redhat.com>
References: <20170622193352.22346-1-billodo@redhat.com>
 <20170623103405.19428-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170623103405.19428-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 23, 2017 at 05:34:05AM -0500, Bill O'Donnell wrote:
> xfs_db doesn't take sector size into account when setting type.
> This can result in an errant crc. For example, with a sector size
> of 4096:
> 
> xfs_db> agi 0
> xfs_db> p crc
> crc = 0xab85043e (correct)
> xfs_db> daddr
> current daddr is 16
> xfs_db> daddr 42
> xfs_db> daddr 16
> xfs_db> type agi
> Metadata CRC error detected at xfs_agi block 0x10/0x200
> xfs_db> p crc
> crc = 0xab85043e (bad)
> 
> When xfs_db sets the new daddr in daddr_f, it does so with one
> BBSIZE sector (512). Changing the type doesn't change the size
> of the current buffer in iocur_top, so the checksum is calculated
> on the wrong length for the type (when the actual sector size > BBSIZE (512).
> 
> For types with fields, reread the buffer to pick up the correct size for
> the new type when it gets set. Facilitate the reread by setting the cursor
> with set_cur().
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
> 
> v2: correction to argument 3 in call to set_cur: compute and pass basic block count;
>     add comment regarding conditional call to set_cur.
> v3: include bit.h for byteize function
> 
>  db/io.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/db/io.c b/db/io.c
> index 9918a51..b97b710 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -28,6 +28,7 @@
>  #include "init.h"
>  #include "malloc.h"
>  #include "crc.h"
> +#include "bit.h"
>  
Thanks!!

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


>  static int	pop_f(int argc, char **argv);
>  static void     pop_help(void);
> @@ -615,7 +616,13 @@ set_iocur_type(
>  	const typ_t	*t)
>  {
>  	struct xfs_buf	*bp = iocur_top->bp;
> +	int bb_count;
>  
> +	/* adjust cursor for types that contain fields */
> +	if (t->fields) {
> +		bb_count = BTOBB(byteize(fsize(t->fields, iocur_top->data, 0, 0)));
> +		set_cur(t, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
> +	}
>  	iocur_top->typ = t;
>  
>  	/* verify the buffer if the type has one. */
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
