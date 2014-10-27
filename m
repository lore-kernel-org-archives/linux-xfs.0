Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9AB1E7F4E
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 06:26:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 288DFAC002
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 04:26:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Y9sZNT5PBeahpBgs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Oct 2014 04:25:56 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9RBPt0o031121
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 07:25:56 -0400
Date: Mon, 27 Oct 2014 07:25:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfsprogs: fix endian mishap in xfs_dialloc_ag()
Message-ID: <20141027112552.GA39598@bfoster.bfoster>
References: <54498FE9.4000103@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54498FE9.4000103@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 23, 2014 at 06:31:53PM -0500, Eric Sandeen wrote:
> Fixes a regression introduced by:
> 
> 88fc730 xfs: use and update the finobt on inode allocation
> 
> which passed the non-swapped version of agi->agi_newino to
> xfs_inobt_lookup()
> 
> Caught by make C=2, ftw!
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
> index 5462c54..b20a9ec 100644
> --- a/libxfs/xfs_ialloc.c
> +++ b/libxfs/xfs_ialloc.c
> @@ -1057,7 +1057,8 @@ xfs_dialloc_ag(
>  		 * most recently allocated inode.
>  		 */
>  		if (agi->agi_newino != cpu_to_be32(NULLAGINO)) {
> -			error = xfs_inobt_lookup(cur, agi->agi_newino,
> +			error = xfs_inobt_lookup(cur,
> +						 be32_to_cpu(agi->agi_newino),
>  						 XFS_LOOKUP_EQ, &i);
>  			if (error)
>  				goto error_cur;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
