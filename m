Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A570A7F3F
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 15:33:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3BDFAAC001
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 13:33:31 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	rCaXit3mAzIaYsnW for <xfs@oss.sgi.com>;
	Tue, 22 Oct 2013 13:33:28 -0700 (PDT)
Date: Wed, 23 Oct 2013 07:33:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs:xfs_dir2_node.c: pointer use before check for null
Message-ID: <20131022203322.GA2797@dastard>
References: <1382427375-8863-1-git-send-email-yefremov.denis@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1382427375-8863-1-git-send-email-yefremov.denis@gmail.com>
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
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: ldv-project@linuxtesting.org, Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Oct 22, 2013 at 11:36:15AM +0400, Denis Efremov wrote:
> Reorder of assert and args pointer dereference.
> 
> Found by Linux Driver Verification project (linuxtesting.org) -
> PVS-Studio analyzer.
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
> ---
>  fs/xfs/xfs_dir2_node.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
> index 4c3dba7..0ba7382 100644
> --- a/fs/xfs/xfs_dir2_node.c
> +++ b/fs/xfs/xfs_dir2_node.c
> @@ -1365,8 +1365,8 @@ xfs_dir2_leafn_split(
>  	 * Allocate space for a new leaf node.
>  	 */
>  	args = state->args;
> -	mp = args->dp->i_mount;
>  	ASSERT(args != NULL);
> +	mp = args->dp->i_mount;

Just remove the ASSERT. Either way we are going to panic.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
