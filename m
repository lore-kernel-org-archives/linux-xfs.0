Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C55F77F52
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 04:55:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63ED6AC004
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 02:55:37 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9C3Ravso3D6BODlq for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 02:55:35 -0800 (PST)
Date: Mon, 10 Feb 2014 21:55:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs/033: add golden output for CRC enaled filesystems
Message-ID: <20140210105533.GX13997@dastard>
References: <1391588590-6035-1-git-send-email-david@fromorbit.com>
	<20140207174950.GB31464@infradead.org>
	<20140210015105.GN13647@dastard>
	<20140210104426.GA9840@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140210104426.GA9840@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Feb 10, 2014 at 02:44:26AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 10, 2014 at 12:51:05PM +1100, Dave Chinner wrote:
> > I can't say I like adding that prefix to the mkfs varaibles. I'll
> > change this one to something less generic, but I'm going to ignore
> > the others right now because changing them involves modifying 30+
> > tests....
> 
> In that case let's keep the crc one without prefix for now.  But I think
> introducing very generic variables into the environment implicitly is
> a bad idea and will bite us long term.
> 
> Reluctantly:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

I renamed it earlier this afternoon to "_fs_has_crc" so that code
that checks it makes sense when you read it:

	if [ $_fs_has_crc -eq 1 ]; then
		.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
