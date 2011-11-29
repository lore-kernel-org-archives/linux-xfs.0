Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pATIlvpR089467 for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 12:47:57 -0600
Date: Tue, 29 Nov 2011 12:48:16 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/5] [PATCH] xfs: fix attr2 vs large data fork assert
Message-ID: <20111129184816.GV29840@sgi.com>
References: <20111115201407.038216766@bombadil.infradead.org>
	<20111115201426.498870090@bombadil.infradead.org>
	<20111116231517.GA7046@dastard>
	<20111117073004.GB3733@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111117073004.GB3733@infradead.org>
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
Cc: xfs@oss.sgi.com

Hey Christoph,

On Thu, Nov 17, 2011 at 02:30:04AM -0500, Christoph Hellwig wrote:
> On Thu, Nov 17, 2011 at 10:15:17AM +1100, Dave Chinner wrote:
> > On Tue, Nov 15, 2011 at 03:14:08PM -0500, Christoph Hellwig wrote:
> > > With Dmitry fsstress updates I've seen very reproducible crashes in
> > > xfs_attr_shortform_remove because xfs_attr_shortform_bytesfit claims that
> > > the attributes would not fit inline into the inode after removing an
> > > attribute.  It turns out that we were operating on an inode with lots
> > > of delalloc extents, and thus an if_bytes values for the data fork that
> > > is larger than biggest possible on-disk storage for it which utterly
> > > confuses the code near the end of xfs_attr_shortform_bytesfit.
> > 
> > We have a test that stresses allocated extents vs attributes in the
> > xfs_fsr swapext test (227), but that does not take into account
> > delalloc extents. It sounds like it would be relatively easy to
> > write a regression test for this particular case - create a file
> > with a bunch of attributes, then create a number of delalloc data
> > extents, then remove the attributes to trigger the condition in
> > xfs_attr_shortform_remove()....
> 
> Test 117 with Dmitries new fsstress changes hit it 100% reliably
> before
> 
> 	xfstests: freeze fsstress options for 117'th
>
> I was planning on adding a copy of the test using an explicit
> combination of fsstress seeds that reproduce the issue.

FYI, Test 117 also hit it for me after I backed off 'freeze fsstress
options'.  Are you still planning on adding a copy of the test with the
seeds in question?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
