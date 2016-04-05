Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 78CA27CA0
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 05:42:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 46A51304048
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 03:42:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3nWgB7po9BnRcCP0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Apr 2016 03:42:13 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 8CAB864380
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 10:42:12 +0000 (UTC)
Received: from redhat.com (gfs-i24c-02.mpc.lab.eng.bos.redhat.com
	[10.16.144.214])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u35AgAls014902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Tue, 5 Apr 2016 06:42:12 -0400
Date: Tue, 5 Apr 2016 06:42:10 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/4] xfs: Don't wrap growfs AGFL indexes
Message-ID: <20160405104210.GB55837@redhat.com>
References: <1459836310-12619-1-git-send-email-david@fromorbit.com>
	<1459836310-12619-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459836310-12619-2-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

Looks good to me, feel free to add

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


On Tue, Apr 05, 2016 at 04:05:07PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit 96f859d ("libxfs: pack the agfl header structure so
> XFS_AGFL_SIZE is correct") allowed the freelist to use the empty
> slot at the end of the freelist on 64 bit systems that was not
> being used due to sizeof() rounding up the structure size.
> 
> This has caused versions of xfs_repair prior to 4.5.0 (which also
> has the fix) to report this as a corruption once the filesystem has
> been grown. Older kernels can also have problems (seen from a whacky
> container/vm management environment) mounting filesystems grown on a
> system with a newer kernel than the vm/container it is deployed on.
> 
> To avoid this problem, change the initial free list indexes not to
> wrap across the end of the AGFL, hence avoiding the initialisation
> of agf_fllast to the last index in the AGFL.
> 
> cc: <stable@vger.kernel.org> # 4.4-4.5
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index ee3aaa0a..ca0d3eb 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -243,8 +243,8 @@ xfs_growfs_data_private(
>  		agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(XFS_CNT_BLOCK(mp));
>  		agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
>  		agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
> -		agf->agf_flfirst = 0;
> -		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
> +		agf->agf_flfirst = cpu_to_be32(1);
> +		agf->agf_fllast = 0;
>  		agf->agf_flcount = 0;
>  		tmpsize = agsize - XFS_PREALLOC_BLOCKS(mp);
>  		agf->agf_freeblks = cpu_to_be32(tmpsize);
> -- 
> 2.7.0
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
