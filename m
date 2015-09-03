Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9F3D17FA0
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 15:55:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2A893AC005
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 13:55:59 -0700 (PDT)
Received: from mail-vk0-f48.google.com (mail-vk0-f48.google.com
	[209.85.213.48]) by cuda.sgi.com with ESMTP id ZJ3aBBsRKqTwGDsl
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Sep 2015 13:55:57 -0700 (PDT)
Received: by vkbf67 with SMTP id f67so1070954vkb.0
	for <xfs@oss.sgi.com>; Thu, 03 Sep 2015 13:55:57 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 3 Sep 2015 14:55:56 -0600
Message-ID: <CAAA5faEq0quyfE4zFp1G_r+igZ_vufCN9yFM-5Lr1wzN9r16Lw@mail.gmail.com>
Subject: every week new xfs errors
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
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
To: xfs@oss.sgi.com

Hi Everyone,

I am running xfs on a SSD.
smartd reports this:

Device: /dev/sdb [SAT], Crucial_CT256M550SSD3, S/N:15020ED48DF8,
WWN:5-00a075-10ed48df8, FW:MU02, 256 GB

I am running a compiled linux 4.1.6 kernel (before 4.1.2 and before
that 3.18.x) on ubuntu 14.04
xfs_repair had issues mostly every week to report.
Now xfs_repair says it's finally clean.
However:

reinoud@Mipam:/$ sudo xfs_db -r /dev/sdb1
xfs_db> frag
Metadata CRC error detected at block 0x773cac0/0x1000
Metadata CRC error detected at block 0xee79570/0x1000
Metadata CRC error detected at block 0x165b6020/0x1000
actual 2891336, ideal 2888294, fragmentation factor 0.11%

There are still issue.
Are there problems with running xfs on a SSD in general?
It's fast and stable (seems like), but mostly i start noticing
problems when i'm running git operations that fail, after that
xfs_repair reports issues indeed.

How can i fix these error reported here or can't i fix them?
Thanks,

Reinoud.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
