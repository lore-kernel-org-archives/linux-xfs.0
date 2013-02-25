Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2417F7F6B
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 08:44:21 -0600 (CST)
Message-ID: <512B78C0.4010301@sgi.com>
Date: Mon, 25 Feb 2013 08:44:16 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/16] xfs: rearrange some code in xfs_bmap for better
	locality
References: <1361755901-12453-1-git-send-email-david@fromorbit.com>
	<1361755901-12453-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1361755901-12453-2-git-send-email-david@fromorbit.com>
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

On 02/24/13 19:31, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> xfs_bmap.c is a big file, and some of the related code is spread all
> throughout the file requiring function prototypes for static
> function and jumping all through the file to follow a single call
> path. Rearrange the code so that:
>
> 	a) related functionality is grouped together; and
> 	b) functions are grouped in call dependency order
>
> While the diffstat is large, there are no code changes in the patch;
> it is just moving the functionality around and removing the function
> prototypes at the top of the file. The resulting layout of the code
> is as follows (top of file to bottom):
>
> 	- miscellaneous helper functions
> 	- extent tree block counting routines
> 	- debug/sanity checking code
> 	- bmap free list manipulation functions
> 	- inode fork format manipulation functions
> 	- internal/external extent tree seach functions
> 	- extent tree manipulation functions used during allocation
> 	- functions used during extent read/allocate/removal
> 	  operations (i.e. xfs_bmapi_write, xfs_bmapi_read,
> 	  xfs_bunmapi and xfs_getbmap)
>
> This means that following logic paths through the bmapi code is much
> simpler - most of the code relevant to a specific operation is now
> clustered together rather than spread all over the file....
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Same as the previous post:

	http://oss.sgi.com/archives/xfs/2013-02/msg00132.html

Reviewed-by: Mark Tinguely

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
