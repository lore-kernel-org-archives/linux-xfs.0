Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5K91NvZ014439 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 04:01:23 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	GGYPHQ5t01wKVB4u (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Jun 2012 02:01:22 -0700 (PDT)
Date: Wed, 20 Jun 2012 05:01:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Message-ID: <20120620090117.GA26764@infradead.org>
References: <alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
	<20120619131649.GA6811@redhat.com>
	<alpine.LFD.2.00.1206191519320.21961@dhcp-1-248.brq.redhat.com>
	<20120619133041.GB6811@redhat.com> <4FE0840F.2050704@shiftmail.org>
	<20120619144413.GA7225@redhat.com>
	<20120619184858.GA8841@redhat.com> <20120619200631.GL25389@dastard>
	<20120619202130.GF22805@thunk.org> <20120619203938.GM25389@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120619203938.GM25389@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ted Ts'o <tytso@mit.edu>, Mike Snitzer <snitzer@redhat.com>, xfs@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, Spelic <spelic@shiftmail.org>, Luk???? Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org

On Wed, Jun 20, 2012 at 06:39:38AM +1000, Dave Chinner wrote:
> Exactly - XFS transactions are fine grained, checkpoints are coarse.
> We don't merge extents freed in fine grained transactions inside
> checkpoints. We probably could, but, well, it's complex to do in XFS
> and merging adjacent requests is something the block layer is
> supposed to do....

Last time I checked it actually tries to do that for discard requests,
but then badly falls flat (=oopses).  That's the reason why the XFS
transaction commit code still uses the highly suboptimal synchronous
blkdev_issue_discard instead of the async variant I wrote when designing
the code.

Another "issue" with the XFS discard pattern and the current block
layer implementation is that XFS frees a lot of small metadata like
inode clusters and btree blocks and discards them as well.  If those
simply fill one of the vectors in a range ATA TRIM command and/or a
queueable command that's not much of an issue, but with the current
combination of non-queueable, non-vetored TRIM that's a fairly nasty
pattern.

So until the block layer is sorted out I can not recommend actually
using -o dicard.  I planned to sort out the block layer issues ASAP
when writing that code, but other things have kept me busy every since.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
