Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7Q1F2ve238252 for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 20:15:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21DDE3FB148
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 18:15:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id M0kk35VwQD0gEkni for
	<xfs@oss.sgi.com>; Tue, 25 Aug 2009 18:15:33 -0700 (PDT)
Date: Tue, 25 Aug 2009 21:15:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6.30.4] XFS-related BUG and hang via shrink_icache_memory
Message-ID: <20090826011532.GA24362@infradead.org>
References: <20090826004658.GA30929@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090826004658.GA30929@hostway.ca>
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
To: Simon Kirby <sim@hostway.ca>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 25, 2009 at 05:46:58PM -0700, Simon Kirby wrote:
> On an NFS storage server, we started using some XFS filesystems along
> with many other EXT3 (on LVM on AOE).  The following bug has occurred
> twice, with the machine hanging immediately after (console full of
> scrolling oopses or bugs -- haven't seen it myself -- after this):

Known and fortunately fixed bug, get the patches to fix it from:

	http://bugzilla.kernel.org/attachment.cgi?id=22741

It should also be included in the next upcoming 2.6.30-stable release.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
