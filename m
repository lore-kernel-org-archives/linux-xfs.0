Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9EDrj59194603 for <xfs@oss.sgi.com>; Wed, 14 Oct 2009 08:53:46 -0500
Received: from mx5.informatik.uni-tuebingen.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 475C11787C67
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2009 06:55:15 -0700 (PDT)
Received: from mx5.informatik.uni-tuebingen.de
	(mx5.Informatik.Uni-Tuebingen.De [134.2.12.32]) by cuda.sgi.com
	with ESMTP id CqH6rQA2t4b99DUD for <xfs@oss.sgi.com>;
	Wed, 14 Oct 2009 06:55:15 -0700 (PDT)
Received: from localhost (loopback [127.0.0.1])
	by mx5.informatik.uni-tuebingen.de (Postfix) with ESMTP id 36F2E122
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2009 15:55:14 +0200 (DFT)
Received: from mx5.informatik.uni-tuebingen.de ([127.0.0.1])
	by localhost (mx5 [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 35778-05 for <xfs@oss.sgi.com>; Wed, 14 Oct 2009 15:55:11 +0200 (DFT)
Received: from zcs-bi.informatik.uni-tuebingen.de
	(zcs-bi.Informatik.Uni-Tuebingen.De [134.2.9.105])
	by mx5.informatik.uni-tuebingen.de (Postfix) with ESMTP id 71A97112
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2009 15:55:11 +0200 (DFT)
Received: from zcs-bi.informatik.uni-tuebingen.de
	(zcs-bi.informatik.uni-tuebingen.de [134.2.9.105])
	by zcs-bi.informatik.uni-tuebingen.de (Postfix) with ESMTP id
	23E6EF53910
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2009 15:54:05 +0200 (CEST)
Date: Wed, 14 Oct 2009 15:54:04 +0200 (CEST)
From: Jan Schulze <schulze@informatik.uni-tuebingen.de>
Message-ID: <1405891.561255528444882.JavaMail.root@zcs-bi.informatik.uni-tuebingen.de>
Subject: XFS project quota overrun => NFS client and server unresponsive
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all,

we are using XFS with project quota enabled on our NFS server. Server and clients are running Scientific Linux 5.2, NFS version is 3.

When a user overruns the project quota while copying data from an NFS client, the server and client become very unresponsive. On the server, one NFS thread per core is stuck in uninterruptible (D) state with a load of 1. The only solution to decrease the load, is to reboot the client. Any other method I tried (restarting NFS service, restarting network on client and/or server) did not help. I tried to vary mount options for XFS, but that did not solve the problem. It does not seem to be a hardware issue, as the problem could be easily reproduced on other server/client hardware.

Are there any ideas, how to debug this? Anyone having the same issue? Any help is highly appreciated.


Best Regards,
Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
