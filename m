Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6AC787F63
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 06:31:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0B2B5AC00E
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 04:31:25 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id HMfynBAgbC09Hi5T (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Oct 2014 04:31:24 -0700 (PDT)
Date: Thu, 2 Oct 2014 13:31:23 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: preadv2/pwritev2 updates
Message-ID: <20141002113123.GB32112@lst.de>
References: <1412197494-7655-1-git-send-email-hch@lst.de>
	<20141001222637.GU4758@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141001222637.GU4758@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>, Milosz Tanski <milosz@adfin.com>

On Thu, Oct 02, 2014 at 08:26:37AM +1000, Dave Chinner wrote:
> On Wed, Oct 01, 2014 at 11:04:51PM +0200, Christoph Hellwig wrote:
> > Hi Miklos,
> > 
> > attached are the patches that go on top of your
> > "[RFC v3 0/4] vfs: Non-blockling buffered fs read (page cache only)"
> > series.  The first one adds RWF_NONBLOCK to XFS, the other two
> > add a new RWF_DSYNC flag that adds a per-operation O_DSYNC flag.
> 
> Christoph, any plans to add these new syscalls to xfs_io and
> data integrity tests for the new RWF_DSYNC flag?

I've got some hacked up xfs_io support, but Milosz was planning a
slight revision of the syscall interface that I'm still waiting for.

How would you want to automatically test for data integrity?  That requires
a powerfail or crash unfortunately and we don't have good infrastructure
for that yet.  I've tested it by adding a printk that RWF_DSYNC triggers
the same code path as O_DSYNC.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
