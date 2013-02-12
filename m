Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AF4847F80
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 19:36:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1DC2DAC003
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 17:36:45 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	02TdVlqu5tvp1h0B for <xfs@oss.sgi.com>;
	Mon, 11 Feb 2013 17:36:44 -0800 (PST)
Date: Tue, 12 Feb 2013 12:36:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: rearrange some code in xfs_bmap for better
	locality
Message-ID: <20130212013629.GB10731@dastard>
References: <1360559102-20432-1-git-send-email-david@fromorbit.com>
	<1360559102-20432-3-git-send-email-david@fromorbit.com>
	<511973FE.5000608@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <511973FE.5000608@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 11, 2013 at 04:43:10PM -0600, Mark Tinguely wrote:
> On 02/10/13 23:05, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >xfs_bmap.c is a big file, and some of the related code is spread all
> >throughout the file requiring function prototypes for static
> >function and jumping all through the file to follow a single call
> >path. Rearrange the code so that:
> >
> >	a) related functionality is grouped together; and
> >	b) functions are grouped in call dependency order
> >
> >While the diffstat is large, there are no code changes in the patch;
> >it is just moving the functionality around and removing the function
> >prototypes at the top of the file. The resulting layout of the code
> >is as follows (top of file to bottom):
> >
> >	- miscellaneous helper functions
> >	- extent tree block counting routines
> >	- debug/sanity checking code
> >	- bmap free list manipulation functions
> >	- inode fork format manipulation functions
> >	- internal/external extent tree seach functions
> >	- extent tree manipulation functions used during allocation
> >	- functions used during extent read/allocate/removal
> >	  operations (i.e. xfs_bmapi_write, xfs_bmapi_read,
> >	  xfs_bunmapi and xfs_getbmap)
> >
> >This means that following logic paths through the bmapi code is much
> >simpler - most of the code relevant to a specific operation is now
> >clustered together rather than spread all over the file....
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> >  fs/xfs/xfs_bmap.c |10659 ++++++++++++++++++++++++++---------------------------
> >  1 file changed, 5261 insertions(+), 5398 deletions(-)
> 
> The organization looks good to me. If the file is getting that many
> changes, isn't it time to fix all those spaces in the file? (looks
> like there are over 2500 unnecessary spaces in place of tabs).

My "misplaced whitepsace" syntax highlighting doesn't trip on any,
so I didn't notice it. i.e the whitespace is entirely spaces or
entirely tabs and not tabs/spaces in combination.

A quick search shows that they are mostly in the variable
declaration comment formatting - I tend simply to remove those
comments as I modify the surrounding code because, IMO, they
are almost entirely redundant as we have well named structures
and variables.

So, yeah, maybe a followup patch that kills the comments and fixes
the whitespace damage is in order.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
