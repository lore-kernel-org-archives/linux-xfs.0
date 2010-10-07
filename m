Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o97JLHOi217168 for <xfs@oss.sgi.com>; Thu, 7 Oct 2010 14:21:17 -0500
Subject: Re: [PATCH] xfs: fix bogus m_maxagi check in xfs_iget
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101006183123.GA2166@lst.de>
References: <20101006183123.GA2166@lst.de>
Date: Thu, 07 Oct 2010 14:22:18 -0500
Message-ID: <1286479338.2670.26.camel@doink>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, 2010-10-06 at 14:31 -0400, Christoph Hellwig wrote:
> These days inode64 should only control which AGs we allocate new inodes
> from, while we still try to support reading all existing inodes.  To make
> this actually work the check ontop of xfs_iget needs to be relaxed to allow
> inodes in all allocation groups instead of just those that we allow
> allocating inodes from.  Note that we can't simply remove the check - it
> prevents us from accessing invalid data when fed invalid inode numbers
> from NFS or bulkstat.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
