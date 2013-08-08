Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB4F27F5F
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 17:04:10 -0500 (CDT)
Message-ID: <520415D2.1090108@sgi.com>
Date: Thu, 08 Aug 2013 17:04:02 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 10/49] libxfs: sync dir2 kernel differences
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-11-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/19/13 01:44, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


> diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
> index bdce1b3..222f08c 100644
> --- a/libxfs/xfs_dir2_node.c
> +++ b/libxfs/xfs_dir2_node.c

9th chunk in libxfs/xfs_dir2_node.c patch

> @@ -1795,9 +1793,9 @@ xfs_dir2_node_addname_int(
>   		/*
>   		 * Look at the current free entry.  Is it good enough?
>   		 *
> -		 * The bests initialisation should be wher eteh bufer is read in
> +		 * The bests initialisation should be where the bufer is read in
>   		 * the above branch. But gcc is too stupid to realise that bests
> -		 * iand the freehdr are actually initialised if they are placed
> +		 * and the freehdr are actually initialised if they are placed
>   		 * there, so we have to do it here to avoid warnings. Blech.
>   		 */
>   		bests = xfs_dir3_free_bests_p(mp, free);

A clean up in the xfsprogs master branch requires this to be removed.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
