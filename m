Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LHwlmK168125 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 12:58:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A29A1510E51
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 11:02:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PBZO5J7MevI4YRC1 for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2011 11:02:15 -0700 (PDT)
Date: Thu, 21 Apr 2011 14:02:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: buffered writeback torture program
Message-ID: <20110421180213.GA19255@infradead.org>
References: <1303322378-sup-1722@think> <20110421083258.GA26784@infradead.org>
	<1303407205-sup-6141@think> <20110421174120.GA7267@infradead.org>
	<93CB867E-B908-4B38-A146-A9DC958ACF64@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <93CB867E-B908-4B38-A146-A9DC958ACF64@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: axboe <axboe@kernel.dk>, jack <jack@suse.cz>, xfs <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, dchinner <dchinner@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>

On Thu, Apr 21, 2011 at 11:59:37AM -0600, Andreas Dilger wrote:
> But doesn't XFS have potentially very large extents, especially in the case of files that were fallocate()'d or linearly written?  If there is a single 8GB extent, and then random writes within that extent (seems very database like) grouping the all of the writes in the extent doesn't seem so great.

It doesn't cluster any writes in an extent.  It only writes out
additional dirty pages directly following that one we were asked to
write out.  As soon as we hit a non-dirty page we give up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
