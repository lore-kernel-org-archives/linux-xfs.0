Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2SLIKdJ261517 for <xfs@OSS.SGI.com>; Sun, 28 Mar 2010 16:18:20 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B38D28217F
	for <xfs@OSS.SGI.com>; Sun, 28 Mar 2010 14:19:55 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id f88HNGvzXjcrwyYX
	for <xfs@OSS.SGI.com>; Sun, 28 Mar 2010 14:19:55 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1Nvzqy-0006iy-6l
	for <xfs@OSS.SGI.com>; Sun, 28 Mar 2010 22:17:04 +0100
MIME-Version: 1.0
Message-ID: <19375.51023.126178.657360@tree.ty.sabi.co.uk>
Date: Sun, 28 Mar 2010 22:17:03 +0100
Subject: Re: 128TB filesystem limit?
In-Reply-To: <alpine.DEB.2.00.1003251609160.12435@asgard.lang.hm>
References: <alpine.DEB.2.00.1003251609160.12435@asgard.lang.hm>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <xfs@oss.sgi.com>

> I'm working with a raid 0 (md) array on top of 10 16x1TB raid
> 6 hardware arrays.  fdisk -l shows me 10 drives like [ ... ] I
> then did mkfs.xfs /dev/md0 but a df is showing me 128TB [ ... ]

A 128Tb single filesystem ontop a 160 drives RAID60! Even
better, one made of 10x 14+2 RAID6 components.

It shows a dedication to "if it is possible it must make sense"
logic and an admirable faith in luck.

Perhaps a small discrepancy in size units is not the most
interesting aspect of this query.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
