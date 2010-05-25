Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PBBqKB243674 for <xfs@oss.sgi.com>; Tue, 25 May 2010 06:11:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE699144056F
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 04:14:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MhElVvfboWnNMmhs for
	<xfs@oss.sgi.com>; Tue, 25 May 2010 04:14:14 -0700 (PDT)
Date: Tue, 25 May 2010 07:14:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: remove nr_to_write writeback windup.
Message-ID: <20100525111414.GC8931@infradead.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	<1274784852-30502-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274784852-30502-6-git-send-email-david@fromorbit.com>
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
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Tue, May 25, 2010 at 08:54:11PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the background flush code has been fixed, we shouldn't need to
> silently multiply the wbc->nr_to_write to get good writeback. Remove
> that code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Ok,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
