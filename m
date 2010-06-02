Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5269DQt055609 for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 01:09:13 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8EA55AAC50D
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 23:14:01 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	aCwgqvcKFlLeGJhH for <xfs@oss.sgi.com>;
	Tue, 01 Jun 2010 23:14:01 -0700 (PDT)
Date: Wed, 2 Jun 2010 16:11:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/17] xfs: remove unused delta tracking code in xfs_bmapi
Message-ID: <20100602061137.GQ7011@dastard>
References: <20100531160727.842750532@bombadil.infradead.org>
	<20100531160902.541889062@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100531160902.541889062@bombadil.infradead.org>
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

On Mon, May 31, 2010 at 12:07:44PM -0400, Christoph Hellwig wrote:
> This code was introduced four years ago in commit
> 3e57ecf640428c01ba1ed8c8fc538447ada1715b without any review and has
> been unused since.  Remove it just as the rest of the code introduced
> in that commit to reduce that stack usage and complexity in this central
> piece of code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Agreed. if we have need for it in the future, it's there in
revision history.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
