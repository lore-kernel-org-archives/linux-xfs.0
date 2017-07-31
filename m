Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46037 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbdGaVZk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jul 2017 17:25:40 -0400
Date: Mon, 31 Jul 2017 14:25:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/7] xfs: remove double-underscore integer types
Message-ID: <20170731212530.GF4477@magnolia>
References: <150153520589.26081.8786864874176090813.stgit@magnolia>
 <150153521484.26081.9491485993495513310.stgit@magnolia>
 <243e1e47-250d-246e-946f-80e3aed3fa9d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <243e1e47-250d-246e-946f-80e3aed3fa9d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Mon, Jul 31, 2017 at 04:23:19PM -0500, Eric Sandeen wrote:
> On 7/31/17 4:06 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > This is a purely mechanical patch that removes the private
> > __{u,}int{8,16,32,64}_t typedefs in favor of using the system
> > {u,}int{8,16,32,64}_t typedefs.  This is the sed script used to perform
> > the transformation and fix the resulting whitespace and indentation
> > errors:
> > 
> > s/typedef\t__uint8_t/typedef __uint8_t\t/g
> > s/typedef\t__uint/typedef __uint/g
> > s/typedef\t__int\([0-9]*\)_t/typedef int\1_t\t/g
> > s/__uint8_t\t/__uint8_t\t\t/g
> > s/__uint/uint/g
> > s/__int\([0-9]*\)_t\t/__int\1_t\t\t/g
> > s/__int/int/g
> > /^typedef.*int[0-9]*_t;$/d
> > 
> 
> Thanks - I did this too and fixed up some incidentals, interdiff follows.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> and I'll add the delta below on the way in if you don't mind.
> 
> (just issues on the changed lines that would have been caught if 
> done manually, I think - mostly whitespace nitpicks)

Looks fine to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
> 
> Thanks,
> -Eric
> 
> 
> 
> diff -u b/db/inode.c b/db/inode.c
> --- b/db/inode.c
> +++ b/db/inode.c
> @@ -146,22 +146,22 @@
>  	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_RTINHERIT_BIT-1), C1,
>  	  0, TYP_NONE },
>  	{ "projinherit", FLDT_UINT1,
> -	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_PROJINHERIT_BIT-1),C1,
> +	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_PROJINHERIT_BIT-1), C1,
>  	  0, TYP_NONE },
>  	{ "nosymlinks", FLDT_UINT1,
>  	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_NOSYMLINKS_BIT-1), C1,
>  	  0, TYP_NONE },
>  	{ "extsz", FLDT_UINT1,
> -	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_EXTSIZE_BIT-1),C1,
> +	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_EXTSIZE_BIT-1), C1,
>  	  0, TYP_NONE },
>  	{ "extszinherit", FLDT_UINT1,
> -	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_EXTSZINHERIT_BIT-1),C1,
> +	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_EXTSZINHERIT_BIT-1), C1,
>  	  0, TYP_NONE },
>  	{ "nodefrag", FLDT_UINT1,
> -	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_NODEFRAG_BIT-1),C1,
> +	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_NODEFRAG_BIT-1), C1,
>  	  0, TYP_NONE },
>  	{ "filestream", FLDT_UINT1,
> -	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_FILESTREAM_BIT-1),C1,
> +	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_FILESTREAM_BIT-1), C1,
>  	  0, TYP_NONE },
>  	{ "gen", FLDT_UINT32D, OI(COFF(gen)), C1, 0, TYP_NONE },
>  	{ NULL }
> diff -u b/db/metadump.c b/db/metadump.c
> --- b/db/metadump.c
> +++ b/db/metadump.c
> @@ -2270,7 +2270,7 @@
>  	return success;
>  }
>  
> -static uint32_t	inodes_copied = 0;
> +static uint32_t	inodes_copied;
>  
>  static int
>  copy_inode_chunk(
> diff -u b/logprint/log_misc.c b/logprint/log_misc.c
> --- b/logprint/log_misc.c
> +++ b/logprint/log_misc.c
> @@ -171,7 +171,7 @@
>  
>      *ptr += len;
>  
> -    magic=*(uint32_t*)cptr; /* XXX be32_to_cpu soon */
> +    magic = *(uint32_t *)cptr; /* XXX be32_to_cpu soon */
>  
>      if (len >= 4) {
>  #if __BYTE_ORDER == __LITTLE_ENDIAN
> diff -u b/repair/globals.h b/repair/globals.h
> --- b/repair/globals.h
> +++ b/repair/globals.h
> @@ -177,8 +177,8 @@
>  };
>  EXTERN struct aglock	*ag_locks;
>  
> -EXTERN int 		report_interval;
> -EXTERN uint64_t 	*prog_rpt_done;
> +EXTERN int		report_interval;
> +EXTERN uint64_t		*prog_rpt_done;
>  
>  EXTERN int		ag_stride;
>  EXTERN int		thread_count;
> diff -u b/repair/phase5.c b/repair/phase5.c
> --- b/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -2471,7 +2471,7 @@
>  	int			error;
>  
>  	do_log(_("Phase 5 - rebuild AG headers and trees...\n"));
> -	set_progress_msg(PROG_FMT_REBUILD_AG, (uint64_t )glob_agcount);
> +	set_progress_msg(PROG_FMT_REBUILD_AG, (uint64_t)glob_agcount);
>  
>  #ifdef XR_BLD_FREE_TRACE
>  	fprintf(stderr, "inobt level 1, maxrec = %d, minrec = %d\n",
> diff -u b/repair/progress.c b/repair/progress.c
> --- b/repair/progress.c
> +++ b/repair/progress.c
> @@ -114,7 +114,7 @@
>  	 */
>  
>  	if ((prog_rpt_done = (uint64_t *)
> -		malloc(sizeof(uint64_t)*glob_agcount)) == NULL ) {
> +		malloc(sizeof(uint64_t)*glob_agcount)) == NULL) {
>  		do_error(_("cannot malloc pointer to done vector\n"));
>  	}
>  	bzero(prog_rpt_done, sizeof(uint64_t)*glob_agcount);
> @@ -286,7 +286,7 @@
>  }
>  
>  int
> -set_progress_msg (int report, uint64_t total)
> +set_progress_msg(int report, uint64_t total)
>  {
>  
>  	if (!ag_stride)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
