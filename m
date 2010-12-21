Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBLLemnh096907 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 15:40:48 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DF6F1472734
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 13:42:43 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	SHdJ1Fk1nSzMKGQz for <xfs@oss.sgi.com>;
	Tue, 21 Dec 2010 13:42:43 -0800 (PST)
Date: Wed, 22 Dec 2010 08:42:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/34] xfs: dynamic speculative EOF preallocation
Message-ID: <20101221214240.GB4907@dastard>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
	<1292916570-25015-7-git-send-email-david@fromorbit.com>
	<20101221151511.GA26127@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101221151511.GA26127@infradead.org>
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

On Tue, Dec 21, 2010 at 10:15:11AM -0500, Christoph Hellwig wrote:
> This patch causes tesr 014 to take ~ 870 seconds instead of 6, thus
> beeing almost 150 times slower on mt 32-bit test VM, so I'll have to NAK
> it for now.

It's not the speculative preallocation changes - ithey are just
exposing some other regression. That is, using MOUNT_OPTIONS="-o
allocsize=4k" gives the previous behaviour, while allocsize=512m
gives the same behaviour as the dynamic preallocation.

The dynamic behaviour is resulting in megabyte sized IOs being
issued for random 512 byte writes (which is wrong), so I'm tending
towards it being a regression caused by the reecent writeback path
changes. I'll dig deeper today.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
