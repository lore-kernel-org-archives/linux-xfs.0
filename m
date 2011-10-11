Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9BMegdZ025792 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 17:40:44 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 171DE1C7FAE6
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 15:40:41 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0qwtrziouOVWiLSY for <xfs@oss.sgi.com>;
	Tue, 11 Oct 2011 15:40:41 -0700 (PDT)
Date: Wed, 12 Oct 2011 09:40:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3 v2] xfstests: allow 091 for non-xfs filesystems
Message-ID: <20111011224039.GH3159@dastard>
References: <20111010182156.GA1323@infradead.org>
	<20111010182216.GA1335@infradead.org>
	<20111010182233.GB1335@infradead.org>
	<20111011141840.GA14750@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111011141840.GA14750@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Oct 11, 2011 at 10:18:40AM -0400, Christoph Hellwig wrote:
> The tests in 091 are entirely generic and pass e.g. on ext4 and jfs.
> btrfs fails it, but that looks a like a btrfs-specific issue to me.
> 
> Also use _supported_os properly instead of erroring out manually on
> IRIX.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
