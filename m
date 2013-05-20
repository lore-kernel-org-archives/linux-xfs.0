Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 464C829DF8
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 13:10:42 -0500 (CDT)
Date: Mon, 20 May 2013 13:10:38 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfs: Avoid pathological backwards allocation
Message-ID: <20130520181038.GY29359@sgi.com>
References: <1365710996-16439-1-git-send-email-jack@suse.cz>
	<20130520135607.GA11502@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130520135607.GA11502@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: dchinner@redhat.com, tinguely@sgi.com, xfs@oss.sgi.com

On Mon, May 20, 2013 at 03:56:07PM +0200, Jan Kara wrote:
> On Thu 11-04-13 22:09:56, Jan Kara wrote:
> > Writing a large file using direct IO in 16 MB chunks sometimes results
> > in a pathological allocation pattern where 16 MB chunks of large free
> > extent are allocated to a file in a reversed order. So extents of a file
> > look for example as:
> > 
> >  ext logical physical expected length flags
> >    0        0        13          4550656
> >    1  4550656 188136807   4550668 12562432
> >    2 17113088 200699240 200699238 622592
> >    3 17735680 182046055 201321831   4096
> >    4 17739776 182041959 182050150   4096
> >    5 17743872 182037863 182046054   4096
> >    6 17747968 182033767 182041958   4096
> >    7 17752064 182029671 182037862   4096
> > ...
> > 6757 45400064 154381644 154389835   4096
> > 6758 45404160 154377548 154385739   4096
> > 6759 45408256 252951571 154381643  73728 eof
> > 
> > This happens because XFS_ALLOCTYPE_THIS_BNO allocation fails (the last
> > extent in the file cannot be further extended) so we fall back to
> > XFS_ALLOCTYPE_NEAR_BNO allocation which picks end of a large free
> > extent as the best place to continue the file. Since the chunk at the
> > end of the free extent again cannot be further extended, this behavior
> > repeats until the whole free extent is consumed in a reversed order.
> > 
> > For data allocations this backward allocation isn't beneficial so make
> > xfs_alloc_compute_diff() pick start of a free extent instead of its end
> > for them. That avoids the backward allocation pattern.
> > 
> > See thread at http://oss.sgi.com/archives/xfs/2013-03/msg00144.html for
> > more details about the reproduction case and why this solution was
> > chosen.
> > 
> > Based on idea by Dave Chinner <dchinner@redhat.com>.
> > 
> > CC: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/xfs/xfs_alloc.c |   24 ++++++++++++++++++------
> >  1 files changed, 18 insertions(+), 6 deletions(-)
> > 
> > v2: Updated comment and commit description.
>   Could anybody pull this patch into XFS tree? I don't see it there...

Applied.

Thanks Jan.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
