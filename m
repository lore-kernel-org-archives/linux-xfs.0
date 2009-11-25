Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAP0GE27180436 for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 18:16:14 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C677A18D8E16
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 16:16:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	tjn90eayRAARXVTU for <xfs@oss.sgi.com>;
	Tue, 24 Nov 2009 16:16:39 -0800 (PST)
Date: Wed, 25 Nov 2009 11:16:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/7] xfs: simplify xfs_buf_get / xfs_buf_read interfaces
Message-ID: <20091125001636.GM3804@discord.disaster>
References: <20091114161717.233372584@bombadil.infradead.org>
	<20091114161801.411213050@bombadil.infradead.org>
	<20091124180223.GA1211@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091124180223.GA1211@infradead.org>
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

On Tue, Nov 24, 2009 at 01:02:23PM -0500, Christoph Hellwig wrote:
> 
> Currently these lowlevel buffer cache interfaces are highly confusing
> as we have a _flags variant of each that does actually respect the flags,
> and one without _flags which has a flags argument that gets ignored and
> overriden with a default set.  Given that very few places use the default
> arguments get rid of the duplication and convert all callers to pass the
> flags explicitly.  Also remove the now confusing _flags postfix.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
