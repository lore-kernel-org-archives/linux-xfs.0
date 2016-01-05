Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 80B407F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 18:15:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5920A304067
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 16:15:25 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Rulq6ulzqslJdJ2c (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 16:15:18 -0800 (PST)
Date: Mon, 4 Jan 2016 16:14:50 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 15/22] xfsdocs: document the operation of the realtime
	device and inodes
Message-ID: <20160105001450.GF28330@birch.djwong.org>
References: <20151219091208.15558.65013.stgit@birch.djwong.org>
	<20151219091351.15558.51417.stgit@birch.djwong.org>
	<20160103134151.GB9144@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160103134151.GB9144@infradead.org>
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

On Sun, Jan 03, 2016 at 05:41:51AM -0800, Christoph Hellwig wrote:
> Looks generally good, although I wonder the take on the realtime device
> is a bit too positive given that we generally advise people not to use
> it.

Last time I tried formatting with a rt device (a month ago) the kernel crashed,
as soon as I created an inode, so I guess we ought to warn people that this
feature is severely bitrotted.

What /is/ the official status of XFS RT?  Most sane distros (looking right at
you, Ubuntu) disable kernel support, so I guess:

------------------------------------------------------------------------
WARNING: The realtime feature is not well maintained.  Use with caution.
------------------------------------------------------------------------

--D

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
