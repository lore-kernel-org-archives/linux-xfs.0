Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1LGPji1194807 for <xfs@OSS.SGI.com>; Tue, 21 Feb 2012 10:25:45 -0600
Received: from anakin.london.02.net (anakin.london.02.net [87.194.255.134]) by
	cuda.sgi.com with ESMTP id yNMEAsJD5o415WSO for
	<xfs@OSS.SGI.com>; Tue, 21 Feb 2012 08:25:43 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by anakin.london.02.net (8.5.140)
	id 4EEB63D2012176EE for xfs@OSS.SGI.com;
	Tue, 21 Feb 2012 16:25:41 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1RzsWw-0003zZ-Hr
	for <xfs@OSS.SGI.com>; Tue, 21 Feb 2012 16:25:30 +0000
MIME-Version: 1.0
Message-ID: <20291.50554.414722.399249@tree.ty.sabi.co.UK>
Date: Tue, 21 Feb 2012 16:25:30 +0000
Subject: Re: XFS, empty files after a crash
In-Reply-To: <4F4387A7.2070009@gmail.com>
References: <4F4387A7.2070009@gmail.com>
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
To: Linux fs XFS <xfs@oss.sgi.com>

> Hi, After a crash, a lot of files on a xfs file system report
> an empty size with "ls -a" but not with "du". [ ... ]

It is a FAQ:

  http://xfs.org/index.php/XFS_FAQ#Q:_Why_do_I_see_binary_NULLS_in_some_files_after_recovery_when_I_unplugged_the_power.3F

Usually it is a good idea to do a web search before reporting a
problem.

> Is there a way to copy back the used blocks to recover the
> files ?

No, because your applications told XFS that the content of those
blocks could be thrown away in case of crash.

It is your responsibility to ensure that your applications use
'fsync' or at least 'fsyncdata' when data should be stored
permanently before a crash occurs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
