Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 16E597F50
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 18:50:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88E14AC002
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 16:50:34 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	BACSW6Hr5fgKzM7y for <xfs@oss.sgi.com>;
	Tue, 03 Sep 2013 16:50:29 -0700 (PDT)
Date: Wed, 4 Sep 2013 09:50:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: inode buffers may not be valid during recovery
	readahead
Message-ID: <20130903235023.GI23571@dastard>
References: <1377567577-24312-1-git-send-email-david@fromorbit.com>
	<20130830181520.GD1935@sgi.com> <20130831061420.GY12779@dastard>
	<20130903221712.GN1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130903221712.GN1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 03, 2013 at 05:17:12PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Sat, Aug 31, 2013 at 04:14:20PM +1000, Dave Chinner wrote:
> > On Fri, Aug 30, 2013 at 01:15:20PM -0500, Ben Myers wrote:
> > > Dave,
> > > 
> > > On Tue, Aug 27, 2013 at 11:39:37AM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > CRC enabled filesystems fail log recovery with 100% reliability on
> > > > xfstests xfs/085 with the following failure:
> > > 
> > > Unfortunately I have not been able to hit this one... not sure why.
> > > 
> > > > XFS (vdb): Mounting Filesystem
> > > > XFS (vdb): Starting recovery (logdev: internal)
> > > > XFS (vdb): Corruption detected. Unmount and run xfs_repair
> > > > XFS (vdb): bad inode magic/vsn daddr 144 #0 (magic=0)
> > > > XFS: Assertion failed: 0, file: fs/xfs/xfs_inode_buf.c, line: 95
> > > > 
> > > > The problem is that the inode buffer has not been recovered before
> > > > the readahead on the inode buffer is issued. The checkpoint being
> > > > recovered actually allocates the inode chunk we are doing readahead
> > > > from, so what comes from disk during readahead is essentially
> > > > random and the verifier barfs on it.
> > > > 
> > > > This inode buffer readahead problem affects non-crc filesystems,
> > > > too, but xfstests does not trigger it at all on such
> > > > configurations....
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > 
> > > I've been mulling this one over for a bit, and I'm not quite sure this
> > > is correct:
> > > 
> > > My feeling is that in light of commit 9222a9cf, if we do take part of a
> > > buffer back in time, the write verifier should fail.
> > 
> > I don't see the connection between 9222a9cf ("xfs: don't shutdown
> > log recovery on validation errors") and this issue. 9222a9cf works
> > around are a longstanding architectural deficiency of log
> > recovery, while this is a completely new problem introduced by the
> > inode buffer readahead in log recovery.
> 
> Commit 9222a9cf left buffer operations for inodes clear in the v2 inode case:
....

Ok, you need to make your review comments about the code directly in
the context of the code you are commenting on. i.e. something like
this:

>  		return;
>  
>  	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
> -				ilfp->ilf_len, &xfs_inode_buf_ops);
> +				ilfp->ilf_len, &xfs_inode_buf_ra_ops);

"verifiers shouldn't be set for v4 filesystems, see
xlog_recover_do_inode_buffer()".

That would have made it obvious what you are commenting on. Indeed,
that's a flaw in the original log readahead patch, and one that I
didn't pick up when fixing the problem I sawi on v5 filesystems.

---

As a process issue, Ben, you shouldn't be committing patches that
haven't finished the review cycles. Both author and reviewer need to
be satisfied the patch that is committed is good. This patch has a
(now) obvious (to me) bug in it, but you committed it even though
you thought it was wrong and commented as such. If I hadn't of said
"I don't understand your review" even though you committed the patch
this probably would have got dropped on the ground.

So, please don't commit patches while the review process is still
running...

> Here's what I suggest:
> 
> ---
>  fs/xfs/xfs_log_recover.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: b/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- a/fs/xfs/xfs_log_recover.c	2013-09-03 16:57:51.534388540 -0500
> +++ b/fs/xfs/xfs_log_recover.c	2013-09-03 16:59:13.784398092 -0500
> @@ -3309,7 +3309,9 @@ xlog_recover_inode_ra_pass2(
>  		return;
>  
>  	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
> -				ilfp->ilf_len, &xfs_inode_buf_ra_ops);
> +				ilfp->ilf_len,
> +				xfs_sb_version_hascrc(&mp->m_sb) ?
> +					&xfs_inode_buf_ra_ops : NULL);

That's fine. Please post it as a full patch with a commit message
and a SOB....

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
