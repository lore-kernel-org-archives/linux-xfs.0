Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28Ie2Mj055956 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 12:40:02 -0600
Date: Thu, 8 Mar 2012 12:40:09 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 7/8] xfs: split in-core and on-disk inode log item fields
Message-ID: <20120308184009.GU7762@sgi.com>
References: <20120229095347.009884687@bombadil.infradead.org>
	<20120229095509.376594756@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120229095509.376594756@bombadil.infradead.org>
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

On Wed, Feb 29, 2012 at 04:53:54AM -0500, Christoph Hellwig wrote:
> Add a new ili_fields member to the inode log item to isolate the in-memory
> flags from the ones that actually go to the log.  This will allow tracking
> timestamp-only updates for fdatasync and O_DSYNC in the next patch and
> prepares for divorcing the on-disk log format from the in-memory log item
> a little further down the road.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

You were careful to update ilf_fields in xfs_inode_item_format... Looks
good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
