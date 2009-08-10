Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7AG8G1a068824 for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 11:08:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 562723B947C
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 09:09:10 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vDGUZMCjL2WAUhBY for
	<xfs@oss.sgi.com>; Mon, 10 Aug 2009 09:09:10 -0700 (PDT)
Date: Mon, 10 Aug 2009 12:09:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2 2/2] xfstests: 220 - generic quota sanity
Message-ID: <20090810160908.GA17332@infradead.org>
References: <4A7C7C1C.2010202@redhat.com> <4A803162.8020806@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A803162.8020806@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Aug 10, 2009 at 09:40:34AM -0500, Eric Sandeen wrote:
> Add some very basic quota sanity tests for generic filesystems.
> 
> This is based on test 108, but uses the generic quota tools,
> not xfs_quota, and therefore cannot test project quota.
> 
> Also, the IOs are much smaller (48k) so that ext3 won't get into
> indirect blocks and throw off the accounting.  This does
> assume 4k blocks though.

Looks good to me and passes at least for XFS.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
