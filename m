Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E01C7F52
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 12:49:33 -0500 (CDT)
Date: Thu, 30 May 2013 12:49:32 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/9] xfs: fix incorrect remote symlink block count
Message-ID: <20130530174932.GC20932@sgi.com>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-3-git-send-email-david@fromorbit.com>
	<51A62F45.5000004@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A62F45.5000004@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, May 29, 2013 at 12:39:33PM -0400, Brian Foster wrote:
> On 05/27/2013 02:38 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When CRCs are enabled, the number of blocks needed to hold a remote
> > symlink on a 1k block size filesystem may be 2 instead of 1. The
> > transaction reservation for the allocated bloks was not taking this
> > into account and only allocating one block. hence when trying to
> > read or invalidate such symlinks, we are mapping a hole where there
> > should be a block and things go bad at that point.
> > 
> > Fix the reservation to use the correct block count, clean up the
> > block count calculation similar to the remote attribute calculation,
> > and add a debug guard to detect when we don't write the entire
> > symlink to disk.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
