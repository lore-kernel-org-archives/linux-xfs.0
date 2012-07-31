Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6VDv14B184246 for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 08:57:02 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id zmS7P6opRPEjA2Kv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 31 Jul 2012 06:56:59 -0700 (PDT)
Message-ID: <5017E426.2040709@profihost.ag>
Date: Tue, 31 Jul 2012 15:56:54 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: xfs_growfs / planned resize / performance impact
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hello list,

i'm planning to create a couple of VMs with just 30GB of space while 
using xfs as the main filesystem.

Now i alreay know that some of the VMs will grow up to 250GB while 
resizing the block device and using xfs_growfs.

Should i take care of that and format these disks with special parameters?

I've discovered that a 500GB volume has agcount=4 and 64000 blocks of 
internal log - while a 300GB volume resized to 500GB has agcount 7 ad 
only 40960 blocks of internal log.

Is it a problem if this grow will happen in small portions (30GB => 50GB 
=> 75GB => 100GB => ... 300GB)?

Thanks!

Greets,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
