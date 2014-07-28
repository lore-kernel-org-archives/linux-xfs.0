Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A59327F47
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2014 18:32:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1BB39AC003
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2014 16:32:24 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	K5DtTiu0HSzpAQE8 for <xfs@oss.sgi.com>;
	Mon, 28 Jul 2014 16:32:22 -0700 (PDT)
Date: Tue, 29 Jul 2014 09:32:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/18] xfs: refactor xfs_inobt_insert() to eliminate loop
	and support variable count
Message-ID: <20140728233219.GF26465@dastard>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-2-git-send-email-bfoster@redhat.com>
	<20140724221038.GN20518@dastard>
	<20140728160351.GB59542@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140728160351.GB59542@bfoster.bfoster>
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

On Mon, Jul 28, 2014 at 12:03:52PM -0400, Brian Foster wrote:
> On Fri, Jul 25, 2014 at 08:10:38AM +1000, Dave Chinner wrote:
> > On Thu, Jul 24, 2014 at 10:22:51AM -0400, Brian Foster wrote:
> > > Inodes are always allocated in chunks of 64 and thus the loop in
> > > xfs_inobt_insert() is unnecessary.
> > 
> > I don't believe this is true. The number of inodes allocated at once
> > is:
> > 
> >         mp->m_ialloc_inos = (int)MAX((__uint16_t)XFS_INODES_PER_CHUNK,
> > 	                                        sbp->sb_inopblock);
> > 
> 
> So I'm going on that effectively that the number of inodes per block
> will never be larger than 8 (v5) due to a max block size of 4k.

The whole world is not x86... ;)

> > So when the block size is, say, 64k, the number of 512 byte inodes
> > allocated at once is 128. i.e. 2 chunks. Hence xfs_inobt_insert()
> > can be called with a inode could of > 64 and therefore the loop is
> > still necessary...
> > 
> 
> Playing with mkfs I see that we actually can format >4k bsize
> filesystems and the min and max are set at 512b and 64k. I can't
> actually mount such filesystems due to the page size limitation.

The whole world is not x86.... ;)

ia64 and power default to 64k page size, so we have to code
everything to work with 64k block sizes.

> FWIW,
> the default log size params appear to be broken for bsize >= 32k as

In what way?

> well, so I wonder if/how often that format tends to occur.

More often than you think.

> What's the situation with regard to >PAGE_SIZE block size support? Is
> this something we actually could support today?

Well, the problem is bufferheads and page cache don't support blocks
large than page size. The metadata side of XFS supports it just fine
through the xfs_buf structures, but the file data side doesn't.
That's one of the things I'm slowly trying to find time to fix (i.e.
kill bufferheads).

> Do we know about any
> large page sized arches that could push us into this territory with the
> actual page size limitation?

Yes, see above. We have always supported 64k block sizes on Linux
ever since ia64 supported 64k page sizes (i.e. for at least 10
years), so we can't now say "we only support 4k block sizes"....

> I suppose if we have >4k page sized arches that utilize block sizes
> outside of the 256b-4k range, that's enough to justify the existence of
> the range in the general sense. I just might have to factor this area of
> code a bit differently. It would also be nice if there was a means to
> test.

Grab a ppc64 box from the RH QE guys or ask them to test it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
