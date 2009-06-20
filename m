Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5KHwo0t129337 for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 12:58:50 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E07E30E95C
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 10:59:17 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JhXzepj2q3Dw1jef for
	<xfs@oss.sgi.com>; Sat, 20 Jun 2009 10:59:17 -0700 (PDT)
Date: Sat, 20 Jun 2009 13:59:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfstests: move xfs_io filters to common.filter
Message-ID: <20090620175916.GB3984@infradead.org>
References: <4A370D00.7030309@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A370D00.7030309@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 15, 2009 at 10:09:52PM -0500, Eric Sandeen wrote:
> Move duplicated xfs_io filters to common.filter
> 
> Also fix up 132 output, which was misfiltered due
> to a bug in the filtering.
> 
> Doing this because I need this same filter for the next
> added test.


Ah, nice - common filters for xfs_io output were long overdue.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
