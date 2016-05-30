Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 574977CB2
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 00:05:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C5843AC002
	for <xfs@oss.sgi.com>; Sun, 29 May 2016 22:05:36 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	05uqTGAGV8dfURro for <xfs@oss.sgi.com>;
	Sun, 29 May 2016 22:05:33 -0700 (PDT)
Date: Mon, 30 May 2016 15:04:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc
Message-ID: <20160530050452.GM26977@dastard>
References: <AD1240BA-DB24-44F2-893D-28A824063F99@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AD1240BA-DB24-44F2-893D-28A824063F99@gmail.com>
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
To: baotiao <baotiao@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, May 30, 2016 at 12:45:07PM +0800, baotiao wrote:
> This machine is running for qemu,  the file is qemu qcow file type
> 
> [root@w-openstack20 /data/nova/instances/7898b630-c4ef-49ab-9ce9-3735e090c282]# file disk
> disk: QEMU QCOW Image (v3), has backing file (path /data/nova/instances/_base/3f27393376152ac352b2d85703011e38517e), 429496729600 bytes

Oh, you're using delta/snapshot based qcow images. That, by it's
very nature, generates fragmented image files as they are a delta
over the backing file.

....
> actual 48421430, ideal 20716, fragmentation factor 99.96%
> 
> How can I solve this problem, what do you suggest me to do?

Use a extent size hint (say 1-8MB) for your qcow2 image files so that
they don't fragment badly as they are written to. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
