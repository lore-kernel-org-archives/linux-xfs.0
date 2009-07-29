Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6TFE5WZ260268 for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 10:14:06 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F48F10D7999
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 08:23:42 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id amZfHHtTFfSRaVfx for
	<xfs@oss.sgi.com>; Wed, 29 Jul 2009 08:23:42 -0700 (PDT)
Message-ID: <4A70676B.4090105@sandeen.net>
Date: Wed, 29 Jul 2009 10:14:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: BUG REPORT: XFS LOG FORWARD COMPATIBILITY PROBLEM
References: <362522677.1010811248671789619.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>	<1938435153.1010831248671852499.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>	<b094161c0907280550y58cde45fja97b2c413c92a8d4@mail.gmail.com>	<4A6F0978.4070709@sandeen.net>	<b094161c0907280759w6c525201vd4a17e22a8c1d582@mail.gmail.com>	<4A6F20D0.4050303@sandeen.net>
	<b094161c0907290512q26efb74jc31f72ff7971210b@mail.gmail.com>
In-Reply-To: <b094161c0907290512q26efb74jc31f72ff7971210b@mail.gmail.com>
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
To: Eddy Zhao <eddy.y.zhao@gmail.com>
Cc: Lachlan McIlroy <lmcilroy@redhat.com>, xfs@oss.sgi.com

Eddy Zhao wrote:

...

> During fixing the problem, I find it is difficult to change the code to
> commit packed log item (restricted by xfs_log_iovec_t mechanism). If we
> could somehow change this piece of code to use packed structure. The
> endianess problem could be solved by add an byte-swap option to
> xfs_repair (like e2fsck "-s"). Then we solve the
> xfs-log-cant-migrate-between-archs problem.

Well, to be honest, the restriction of a clean log when migrating an xfs
filesystem between systems of differing endianness was design decision.
 And xfs userspace can't replay any log, native endian or not.  If it
could, then perhaps doing the swapping in userspace would be a migration
option.  If you're signing up to make xfs_repair replay logs, I'm sure
we'd welcome the patch.  :)

-Eric

> Thanks
> Eddy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
