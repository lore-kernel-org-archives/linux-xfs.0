Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 45A027F57
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 17:14:54 -0600 (CST)
Date: Tue, 3 Dec 2013 17:14:53 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs_repair: fix process_bmbt_reclist_int
Message-ID: <20131203231453.GT1935@sgi.com>
References: <20131203215735.GQ1935@sgi.com>
 <20131203230804.GA10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131203230804.GA10988@dastard>
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

On Wed, Dec 04, 2013 at 10:08:04AM +1100, Dave Chinner wrote:
> On Tue, Dec 03, 2013 at 03:57:35PM -0600, Ben Myers wrote:
> > There is a set checks for corruption in block map btrees in
> > process_bmbt_reclist_int that we identify but currently do not fix.  It
> > appears that the author's intent in this function was to set error = 1,
> > and then only clear it when all of the checks were completed
> > successfully.  Unfortunately error can be cleared when it is used for
> > the return value of blkmap_set_ext.  Some kinds of corruption are not
> > being fixed, including duplicate extents, claiming free blocks, claiming
> > metadata blocks, and multiply used blocks.
> > 
> > Fix this by shadowing error for blkmap_set_ext.
> 
> Shadowing variables is not a very nice way of solving the problem.
> Someone will come along in a couple of years anf go "huh?" and
> remove the shadowed declaration because it makes no sense and has
> no comments explaining it.
> 
> Better is to use a different variable name for this scope - say
> "error2" - or to reset error to a value of 1 after the call with a
> comment explaining it....

error2 it is.  Sounds good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
