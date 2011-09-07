Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p87BbQmm155347 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 06:37:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A40213CCC58
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2011 04:41:29 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	GA2LzO1YAMRNbNGH for <xfs@oss.sgi.com>;
	Wed, 07 Sep 2011 04:41:29 -0700 (PDT)
Date: Wed, 7 Sep 2011 07:37:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: CPU stuck for 67s (kernel BUG) + in xfs_trans_committed_bulk
	while deleting lots a files (mostly hard-links)
Message-ID: <20110907113723.GA1701@infradead.org>
References: <4E674FD6.8030408@unfix.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E674FD6.8030408@unfix.org>
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
To: Jeroen Massar <jeroen@unfix.org>
Cc: xfs@oss.sgi.com

On Wed, Sep 07, 2011 at 01:04:54PM +0200, Jeroen Massar wrote:
> As partially mentioned in the kernel BUG message this is Debian's
> edition of linux-image-2.6.39-2-amd64 and according to the Debian
> changelogs nothing new has been introduced. 3.0.0-3 is available, but as
> kernel.org is down, bit hard to figure out what changes where made
> between those versions and if they can affect this at all...
> 
> Anybody any ideas? :)

You'll want at least commit 1316d4da3f632d5843d5a446203e73067dc40f09

	xfs: unpin stale inodes directly in IOP_COMMITTED

from kernel 3.0.  In addition commit 1d8c95a363bf8cd4d4182dd19c01693b635311c2

	xfs: use a cursor for bulk AIL insertion

from 3.1-rc should help even more with this workload.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
