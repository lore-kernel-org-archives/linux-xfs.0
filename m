Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 472E07FF4
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 18:04:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C9AAEAC005
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 16:04:25 -0800 (PST)
Received: from smtp.tsag.net (smtp.tsag.net [208.118.68.4]) by cuda.sgi.com
	with ESMTP id qkBZWdpC7TFb1aM4 for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 16:04:24 -0800 (PST)
From: Gerard Beekmans <GBeekmans@tsag.net>
Subject: RE: Unable to mount and repair filesystems
Date: Fri, 30 Jan 2015 00:04:21 +0000
Message-ID: <D90435AEFF34654AA1122988C66C8678023F029B20@exchange.tsag.local>
References: <D90435AEFF34654AA1122988C66C8678023F0277C9@exchange.tsag.local>
	<54CA9586.1010607@sandeen.net>
	<D90435AEFF34654AA1122988C66C8678023F027956@exchange.tsag.local>
	<54CAAAEC.1080803@sandeen.net>
	<D90435AEFF34654AA1122988C66C8678023F0279AB@exchange.tsag.local>
	<54CAB11A.7040509@sandeen.net> <20150129231231.GD6282@dastard>
In-Reply-To: <20150129231231.GD6282@dastard>
Content-Language: en-US
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

<snip>

> Hence if the superblock is showing 25 AGs and the new ags from 4-25 are not
> found on disk then either:
> 
> 	a) if the grow was very recent the storage is not obeying
> 	cache flushes and hence breaking fundamental IO ordering
> 	behaviour; or,
> 
> 	b) if the growfs happened long ago, the storage has lost the
> 	data that was written to stable media...


To answer both Dave and Eric in a single email:

The growfs happened about 1 month ago. The storage crash occurred yesterday so that would make me think enough time would have passed to commit that data to disk so it must be option b) above.

I think it's academic at this point but to answer the SAN questions that came up:

The NFS server is the SAN itself. The SAN software is Nexenta which provides various methods of accessing its data (NFS, SMB and iSCSI being the primary ones).  When the SAN crashed, there was no warning so the Hypervisors had their shared NFS storage disconnected and ultimately after a timeout, the VMs that were running from those NFS shares were shutoff.

Eric: agf 5, 6, 7 and beyond are also full of 0s. 1-4 don't appear to be.

Gerard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
