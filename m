Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1K0IVwh139459 for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 18:18:32 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E77ED137168
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 16:17:57 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	Qn3VuBHPFsoUglbl for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2009 16:17:57 -0800 (PST)
Date: Fri, 20 Feb 2009 11:17:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, needs a new owner] XFS misc patches
Message-ID: <20090220001753.GG8830@disturbed>
References: <49939FDA.6090401@sgi.com> <20090219193403.GA22736@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090219193403.GA22736@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 19, 2009 at 02:34:03PM -0500, Christoph Hellwig wrote:
> On Thu, Feb 12, 2009 at 03:04:42PM +1100, Mark Goodwin wrote:
> >
> > Series of 12 patches, originally by Dave Chinner. These will need
> > forward porting to top-of-tree and careful review. See the description
> > in each individual patch for details of each patch.
> >
> > 01/12 readpage-unwritten-mapping
> 
> Is there any other reason for this except for the slight cleanup?
> Looks goodish to me and I'll throw it into my QA queue.

Cleanup, may as well use the buffer_unwritten state....

> > 02/12 xfs-fix-log-io-latency
> > 03/12 xfs-use-meta-io-for-async-metadata
> 
> Whered did we get stuck on these?  IIRC there was some sort of
> regression on either the AS or deadlinke scheduler, right?

optimisations for a specific scheduler that aren't applicable to
all. I have to get back to these at some point.

> > 04/12 xfs-inval-page-fixup
> 
> Looks good to me, but not really useful until we actually have back
> tracing in some useable tree..

Though it will tell use whenever that nasty 'throw away delalloc
pages without converting the extent first' problem is hit. That
was the main purpose of the patch. Probably good to have that.

> > 05/12 xfs-iolock-on-page-mkwrite
> 
> Do we have a testcase for those races?

IIRC, fsx mixing direct io and mmap will trigger it fairly reliably.

> > 06/12 xfs-non-block-writes-when-frozen
> 
> We don't actually ever set O_NDELAY for regular files, so this can't
> actually be triggered.

Was for NFS servers to prevent them from locking up all threads on a
single fs while a snapshot was in progress on it. There was probably
a matching piece to the NFS server write path.

> > 07/12 xfs-non-block-setattr-size-when-frozen

Ditto.

> I wonder if we should do these kinds of things higher up, e.g. in the
> vfsmount writer count API in the VFS.

Probably be a good idea.

> > 08/12 xfs-inode-search
> 
> Interesting idea, but really wants some refactoring of the surrounding
> code first..

Yes, needs reworking. But it was always sitting in my QA tree, so
the concept seems to be sound. ;)

> > 09/12 xfs-v2-inodes-default
> 
> Do we really care?  There shouldn't be any Linux filesystems with v1
> inodes in the wild.

Not really. it can be dropped.

> > 10/12 xfs-inode-writeback-checking
> 
> b_io_callback is now in the CRC patch series, and we could add
> additional checking there. 

Yes, that was the intent.

> Must say I don't really like the string
> buffer on stack in that path.

Neither do I - it was a quick hack ;)

> > 11/12 xfs-inode-swap
> 
> Yeah, we need to revisit this eventually.  Big qustions is what we want
> to do with symlinks in an xfs_reno or shrinkfs using this ioctl.

Yup.

> > 12/12 xfs-increase-iclogs
> 
> Interesting idea.  But 2MB is much larger than the current log buffer
> window..

No it isn't. We default to 8 log buffers, and when you say
logbsize=262144, you have a 2MB window. I should go back and
look at this again....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
