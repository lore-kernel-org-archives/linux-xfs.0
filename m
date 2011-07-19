Return-Path: <xfs-bounces@oss.sgi.com>
Subject: Re: [xfs-masters] [PATCH] xfs: failure mapping nfs fh to inode
	should return ESTALE
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110718133710.GB9741@fieldses.org>
References: <20110714205036.GA19457@fieldses.org>
	<20110714223126.GA28694@infradead.org> <20110716015014.GF21663@dastard>
	<20110716015346.GA589@infradead.org>
	<20110718133710.GB9741@fieldses.org>
Date: Tue, 19 Jul 2011 14:29:25 -0500
Message-ID: <1311103765.1964.20.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, 2011-07-18 at 09:37 -0400, J. Bruce Fields wrote:
> On Fri, Jul 15, 2011 at 09:53:46PM -0400, Christoph Hellwig wrote:
> > On Sat, Jul 16, 2011 at 11:50:14AM +1000, Dave Chinner wrote:
> > > Bulkstat also checks for ENOENT returns from xfs_iget() as the
> > > lookup it does is inherently racy. That is, if the inode is
> > > allocated when it is read from the IBT, but then has been unlinked
> > > before the actual xfs_iget() call, it expects to get back an ENOENT
> > > to tell it the inode has been unlinked and shouldn't be included in
> > > the bulkstat output. Otherwise, it returns the error to userspace.
> > > 
> > > So converting the mode checks to return ESTALE definitely has the
> > > chance of breaking stuff that uses bulkstat (e.g. xfsdump) because
> > > it will return errors now where it previously just skipped the
> > > (unlinked) inode.
> > 
> > Sounds like we should simply go with the original version of the patch
> > then.
> 
> OK.  Let me know if someone needs that resent....
> 
> --b.

No need.  I'll use the original one.  Thanks.	-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
