Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE5287F56
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 16:50:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7DB11AC004
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 14:50:51 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ytzdz5zD84L3A9EJ for <xfs@oss.sgi.com>;
	Fri, 07 Mar 2014 14:50:48 -0800 (PST)
Date: Sat, 8 Mar 2014 09:50:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/13] xfsprogs: initial EFSBADCRC support
Message-ID: <20140307225044.GR6851@dastard>
References: <1393923117-9559-1-git-send-email-david@fromorbit.com>
	<20140307104604.GA32753@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140307104604.GA32753@infradead.org>
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

On Fri, Mar 07, 2014 at 02:46:04AM -0800, Christoph Hellwig wrote:
> Seems like xfstests will need some updates after this series to
> ignore
> 
> Metadata corruption detected at block XXX/XXX

Yes, I'm seeing that from 2 tests - xfs/030 and xfs/033. I've got a
patch in my local xfstests tree that handles this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
