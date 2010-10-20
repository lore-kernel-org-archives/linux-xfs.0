Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9KFLRJu083714 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 10:21:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84A88135CC43
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 08:37:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id yklJ45rf14jFrWhy for
	<xfs@oss.sgi.com>; Wed, 20 Oct 2010 08:37:41 -0700 (PDT)
Date: Wed, 20 Oct 2010 11:22:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS bad inode magic/vsn daddr 64 #8 (magic=5858)
Message-ID: <20101020152238.GA24405@infradead.org>
References: <20101020082409.GA5415@amd> <20101020151927.GA21057@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101020151927.GA21057@infradead.org>
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
To: Nick Piggin <npiggin@kernel.dk>
Cc: xfs@oss.sgi.com

Alternatively if you have CONFIG_DEBUG_BLOCK_EXT_DEVT enabled please
disabled it.  This option unfortunately casues data corruption very
similar to that if you use ramdisks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
