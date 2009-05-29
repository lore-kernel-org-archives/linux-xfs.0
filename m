Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4TCv66Y054241 for <xfs@oss.sgi.com>; Fri, 29 May 2009 07:57:08 -0500
Received: from mx5.informatik.uni-tuebingen.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CABC2BB551
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 05:57:20 -0700 (PDT)
Received: from mx5.informatik.uni-tuebingen.de
	(mx5.Informatik.Uni-Tuebingen.De [134.2.12.32]) by cuda.sgi.com
	with ESMTP id 1rv0tiVo9zJvihuM for <xfs@oss.sgi.com>;
	Fri, 29 May 2009 05:57:20 -0700 (PDT)
Received: from localhost (loopback [127.0.0.1])
	by mx5.informatik.uni-tuebingen.de (Postfix) with ESMTP id 3D7F4125
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 14:57:19 +0200 (DFT)
Received: from mx5.informatik.uni-tuebingen.de ([127.0.0.1])
	by localhost (mx5 [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 38954-02 for <xfs@oss.sgi.com>; Fri, 29 May 2009 14:57:17 +0200 (DFT)
Received: from zcs-bi.informatik.uni-tuebingen.de
	(zcs-bi.Informatik.Uni-Tuebingen.De [134.2.9.105])
	by mx5.informatik.uni-tuebingen.de (Postfix) with ESMTP id 8846611C
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 14:57:16 +0200 (DFT)
Received: from localhost (localhost [127.0.0.1])
	by zcs-bi.informatik.uni-tuebingen.de (Postfix) with ESMTP id
	DEFED4ABB3F
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 14:56:30 +0200 (CEST)
Received: from zcs-bi.informatik.uni-tuebingen.de ([127.0.0.1])
	by localhost (zcs-bi.informatik.uni-tuebingen.de [127.0.0.1])
	(amavisd-new, port 10024)
	with ESMTP id RF7K23unFq9P for <xfs@oss.sgi.com>;
	Fri, 29 May 2009 14:56:30 +0200 (CEST)
Received: from zcs-bi.informatik.uni-tuebingen.de
	(zcs-bi.informatik.uni-tuebingen.de [134.2.9.105])
	by zcs-bi.informatik.uni-tuebingen.de (Postfix) with ESMTP id
	2357D4ABB3B
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 14:56:30 +0200 (CEST)
Date: Fri, 29 May 2009 14:56:30 +0200 (CEST)
From: Jan Schulze <schulze@informatik.uni-tuebingen.de>
Message-ID: <8418003.3381243601790069.JavaMail.root@zcs-bi.informatik.uni-tuebingen.de>
In-Reply-To: <8097683.3361243601669032.JavaMail.root@zcs-bi.informatik.uni-tuebingen.de>
Subject: xfsdump on mounted filesystem
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

is it advisable to use xfsdump on a mounted file system, or am I likely to be running into problems when doing so? 

The Wikipedia article on XFS states "The xfsdump utility backs up an XFS filesystem in inode order, and in contrast to traditional UNIX file systems which must be unmounted before dumping to guarantee a consistent dump image, XFS file systems can be dumped while the file system is in use."

However, I have not found any other reference, that supports this statement. Also, I do not really understand, what "backing up in inode orde" means. Anybody can clear this up?


Best Regards,
Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
