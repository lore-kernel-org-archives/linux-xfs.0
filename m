Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o159a4Hg125947 for <xfs@oss.sgi.com>; Fri, 5 Feb 2010 03:36:04 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 482B71B21CC
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2010 01:37:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9bXkrBOBTK2JFSrN for
	<xfs@oss.sgi.com>; Fri, 05 Feb 2010 01:37:15 -0800 (PST)
Date: Fri, 5 Feb 2010 04:37:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfstests: routine to create scratch of certain size
Message-ID: <20100205093714.GA14508@infradead.org>
References: <4B69EC23.8040207@sandeen.net> <4B69EC89.5050400@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B69EC89.5050400@sandeen.net>
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
Cc: xfs mailing list <xfs@oss.sgi.com>

On Wed, Feb 03, 2010 at 03:37:13PM -0600, Eric Sandeen wrote:
> This is needed for later enospc tests to be generic
> 
> We have to explicitly call the mkfs rather than
> _scratch_mkfs since extN wants nr-of-blocks as
> an argument -after- the device name.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
