Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6QFLro9131994 for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 10:21:53 -0500
Subject: Re: [PATCH] xfs: Fix wrong return value of xfs_file_aio_write
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110724120330.GC1626@x4.trippels.de>
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
	<20110723180942.GA1616@x4.trippels.de> <4E2B2E88.8080006@redhat.com>
	<20110723203824.GB1652@x4.trippels.de>
	<20110723220212.GA1648@x4.trippels.de>
	<20110724111625.GA12658@infradead.org>
	<20110724115420.GA1626@x4.trippels.de>
	<20110724115826.GB1626@x4.trippels.de>
	<20110724120330.GC1626@x4.trippels.de>
Date: Tue, 26 Jul 2011 10:21:48 -0500
Message-ID: <1311693708.2890.5.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, Josef Bacik <josef@redhat.com>

On Sun, 2011-07-24 at 14:03 +0200, Markus Trippelsdorf wrote:
> The fsync prototype change commit 02c24a82187d accidentally overwrote
> the ssize_t return value of xfs_file_aio_write with 0 for SYNC type
> writes. Fix this by checking if an error occured when calling
> xfs_file_fsync and only change the return value in this case.
> In addition xfs_file_fsync actually returns a normal negative error, so
> fix this, too.
> 
> Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Christoph Hellwig <hch@lst.de>

Finally looking at this I noticed the same thing Christoph
did; thanks for fixing both.  Your change got committed
yesterday via Al Viro's VFS tree.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
