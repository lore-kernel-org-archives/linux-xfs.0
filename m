Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 938017F69
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 11:24:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 07BBFAC003
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 09:24:05 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id wHaVcFo4P64XMu9V (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 09:24:04 -0700 (PDT)
Date: Sun, 26 Jul 2015 09:24:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_repair: set args.geo in dir2_kill_block
Message-ID: <20150726162403.GD29329@infradead.org>
References: <55B14B40.5030209@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55B14B40.5030209@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

And I have to say the API where we need to initialize this non-obvious
pointer in the da_args structure rally sucks :(

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
