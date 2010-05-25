Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PB8k1n243491 for <xfs@oss.sgi.com>; Tue, 25 May 2010 06:08:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7B261440466
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 04:11:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9T2jAeIJh5F4BTnC for
	<xfs@oss.sgi.com>; Tue, 25 May 2010 04:11:08 -0700 (PDT)
Date: Tue, 25 May 2010 07:11:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
Message-ID: <20100525111106.GA6076@infradead.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	<1274784852-30502-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274784852-30502-5-git-send-email-david@fromorbit.com>
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

On Tue, May 25, 2010 at 08:54:10PM +1000, Dave Chinner wrote:
> This commit adds a ->writepage tracepoint inside write_cache_pages() (how the
> above trace was generated) and does the revert manually leaving the subsequent

The tracepoint really should be a separate commit, probably ordered
before the ext4 revert.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
