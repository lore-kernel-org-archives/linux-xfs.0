Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 21F307F4E
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 16:43:13 -0600 (CST)
Message-ID: <511973FE.5000608@sgi.com>
Date: Mon, 11 Feb 2013 16:43:10 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: rearrange some code in xfs_bmap for better
	locality
References: <1360559102-20432-1-git-send-email-david@fromorbit.com>
	<1360559102-20432-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1360559102-20432-3-git-send-email-david@fromorbit.com>
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

On 02/10/13 23:05, Dave Chinner wrote:
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
>   fs/xfs/xfs_bmap.c |10659 ++++++++++++++++++++++++++---------------------------
>   1 file changed, 5261 insertions(+), 5398 deletions(-)

The organization looks good to me. If the file is getting that many
changes, isn't it time to fix all those spaces in the file? (looks like 
there are over 2500 unnecessary spaces in place of tabs).

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
