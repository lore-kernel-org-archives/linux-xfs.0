Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G7SLbn075463 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:28:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75D881C44777
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 00:27:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rCmdLTkpZZNZFzyI for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2009 00:27:39 -0700 (PDT)
Date: Mon, 16 Mar 2009 03:27:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/7] xfs: factor out code to find the longest free
	extent in the AG
Message-ID: <20090316072738.GA16563@infradead.org>
References: <20090220085207.663702000@bombadil.infradead.org>
	<20090220085230.115970000@bombadil.infradead.org>
	<20090315075824.GV26138@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090315075824.GV26138@disturbed>
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Dave Chinner <dgc@sgi.com>

On Sun, Mar 15, 2009 at 06:58:24PM +1100, Dave Chinner wrote:
> 
> Looking at this again, I'd change the name of this function
> to xfs_alloc_ag_longest_free_extent(), because that is what it
> is actually returning....

I've left the _ag out and made it xfs_alloc_longest_free_extent.
The ag is kinda implicit by the perag argument..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
