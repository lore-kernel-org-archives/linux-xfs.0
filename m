Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAEASlV0204929 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 04:28:47 -0600
Date: Mon, 14 Nov 2011 05:28:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] xfsprogs: clean up errors in libxfs_mount()
	consistently
Message-ID: <20111114102845.GB31043@infradead.org>
References: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
	<fa64086e0baa316ab27ca7cffa1e9cd214525a87.1320955676.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <fa64086e0baa316ab27ca7cffa1e9cd214525a87.1320955676.git.aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 10, 2011 at 02:35:17PM -0600, Alex Elder wrote:
> Until the perag structures for the filesystem have been set up,
> initialization of the mount point only assigns computed values and
> has no other side-effects (such as allocating additional
> structures).  So up to that point, returning a null pointer to
> signal an error is adequate.  Once the perag initialization is done
> there needs to be some teardown in case of an error.
> 
> Here the handling of errors is inconsistent.  If early perag
> initialization fails, the code currently just exits.  Then, if
> getting a reference to the root inode results in an error, a null
> pointer is returned but without first cleaning up the perag
> structures.  Next, if rtmount_inodes() returns an error, the
> reference to the root inode (if any) is released, but again the
> perag structures are not cleaned up.  Finally, when the perag data
> is read in, if an error occurs, a null pointer is returned but the
> root inode pointer reference is not released and the perag
> structures are not cleaned up.
> 
> Remedy all of that by having each of these error cases jump to error
> handling code at the end of the function.  That code needs to
> release the reference to the root inode and release all of the perag
> structures.  This (plus a few other things that will be no-ops at
> this point in the mount process) is exactly what libxfs_umount(), so
> just use that function to implement this cleanup activity.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Did you make sure libxfs_umount doesn't do too much work?  I'm usually
more of a fan of uninding each operation individually.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
