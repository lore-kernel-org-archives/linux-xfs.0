Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B4AD7F5A
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 03:09:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5BE7AC001
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 01:09:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2UIp17TIKsLNTJhF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 01:09:43 -0700 (PDT)
Date: Fri, 16 Oct 2015 10:09:39 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] db: fix AGI ops definition in CRC type table
Message-ID: <20151016080939.GA3970@redhat.com>
References: <1444709821-5009-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1444709821-5009-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 13, 2015 at 03:17:01PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The wrong buffer ops structure was added to the AGI field of the
> type table when initially committed. This was not noticed because it
> only affects manually setting the type of a buffer from xfs_db. e.g

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> xfs_db> agi 0
> xfs_db> p
> .....
> crc = 0xbc58d757 (correct)
> .....
> xfs_db> fsb 2
> xfs_db> type agi
> Metadata CRC error detected at block 0x10/0x1000
> xfs_db>
> 
> This is because (trimmed for clarity):
> 
> Breakpoint 1, xfs_verifier_error:
> (gdb) bt
> #0  xfs_verifier_error
> #1  xfs_agfl_read_verify
> #2  set_iocur_type
> #3  type_f
> #4  main
> 
> It's clear that the wrong verifier is being run (AGFL, not AGI).
> The fix is simple.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  db/type.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/db/type.c b/db/type.c
> index 955986b..1da7ee1 100644
> --- a/db/type.c
> +++ b/db/type.c
> @@ -77,7 +77,7 @@ static const typ_t	__typtab[] = {
>  static const typ_t	__typtab_crc[] = {
>  	{ TYP_AGF, "agf", handle_struct, agf_hfld, &xfs_agf_buf_ops },
>  	{ TYP_AGFL, "agfl", handle_struct, agfl_crc_hfld, &xfs_agfl_buf_ops },
> -	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agfl_buf_ops },
> +	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agi_buf_ops },
>  	{ TYP_ATTR, "attr3", handle_struct, attr3_hfld,
>  		&xfs_attr3_db_buf_ops },
>  	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_crc_hfld,
> @@ -113,7 +113,7 @@ static const typ_t	__typtab_crc[] = {
>  static const typ_t	__typtab_spcrc[] = {
>  	{ TYP_AGF, "agf", handle_struct, agf_hfld, &xfs_agf_buf_ops },
>  	{ TYP_AGFL, "agfl", handle_struct, agfl_crc_hfld, &xfs_agfl_buf_ops },
> -	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agfl_buf_ops },
> +	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agi_buf_ops },
>  	{ TYP_ATTR, "attr3", handle_struct, attr3_hfld,
>  		&xfs_attr3_db_buf_ops },
>  	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_crc_hfld,
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
