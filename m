Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 769AB7FEF
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 12:48:49 -0600 (CST)
Date: Thu, 7 Mar 2013 12:48:48 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 01/16] xfs: rearrange some code in xfs_bmap for better
	locality
Message-ID: <20130307184848.GS22182@sgi.com>
References: <1361755901-12453-1-git-send-email-david@fromorbit.com>
	<1361755901-12453-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1361755901-12453-2-git-send-email-david@fromorbit.com>
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

On Mon, Feb 25, 2013 at 12:31:26PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
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
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Applied.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
