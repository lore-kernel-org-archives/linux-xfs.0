Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22JeuFj135025 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 13:40:56 -0600
Message-ID: <4F512246.6070308@sgi.com>
Date: Fri, 02 Mar 2012 13:40:54 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 7/8] xfs: split in-core and on-disk inode log item fields
References: <20120229095347.009884687@bombadil.infradead.org>
	<20120229095509.376594756@bombadil.infradead.org>
In-Reply-To: <20120229095509.376594756@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 02/29/12 03:53, Christoph Hellwig wrote:
> Add a new ili_fields member to the inode log item to isolate the in-memory
> flags from the ones that actually go to the log.  This will allow tracking
> timestamp-only updates for fdatasync and O_DSYNC in the next patch and
> prepares for divorcing the on-disk log format from the in-memory log item
> a little further down the road.
>
> Reviewed-by: Dave Chinner<dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>
> ---

Looks good.

Reviewed-by: Mark Tinguely

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
