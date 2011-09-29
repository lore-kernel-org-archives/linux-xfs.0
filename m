Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8TB5W1f185288 for <xfs@oss.sgi.com>; Thu, 29 Sep 2011 06:05:32 -0500
Date: Thu, 29 Sep 2011 07:05:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: xfs_quota: don't print invalid quota file
	inode number
Message-ID: <20110929110528.GA509@infradead.org>
References: <43b1c14570decac4b102616fb8e9b14d101edc39.1317208532.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <43b1c14570decac4b102616fb8e9b14d101edc39.1317208532.git.aelder@sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 28, 2011 at 06:15:37AM -0500, Alex Elder wrote:
> When the state of quota files is dumped, xfs_quota blindly shows
> whatever inode number is returned by the kernel.  If one of the
> quota types is not enabled or enforced, the inode number provided
> is an invalid value ((__u64) -1).  Rather than print a meaningless
> large integer, print "N/A" in its place to make interpreting the
> result it a little more obvious.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
