Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7JFl68T215613 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 10:47:16 -0500
Received: from mail.jquigley.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 88A073E169C
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 08:47:26 -0700 (PDT)
Received: from mail.jquigley.com (main.jquigley.com [67.23.32.156]) by
	cuda.sgi.com with ESMTP id HwY66vKlfFjpiXM9 for
	<xfs@oss.sgi.com>; Wed, 19 Aug 2009 08:47:26 -0700 (PDT)
Received: from [10.1.1.11] (OSH-NAT-213-122.onshore.net [66.146.213.122])
	(Authenticated sender: jquigley@mail.jquigley.com)
	by mail.jquigley.com (Postfix) with ESMTPSA id 3250D204116
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 15:46:56 +0000 (UTC)
Message-ID: <4A8C1E6E.8020405@jquigley.com>
Date: Wed, 19 Aug 2009 10:46:54 -0500
From: John Quigley <jquigley@jquigley.com>
MIME-Version: 1.0
Subject: Re: XFS corruption with failover
References: <606994882.2142291250648292843.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <606994882.2142291250648292843.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
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
To: XFS Development <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> xfs_logprint doesn't find any problems with this log but that doesn't mean
> the kernel doesn't - they use different implementations to read the log.  I
> noticed that the active part of the log wraps around the physical end/start
> of the log which reminds of this fix:

Very interesting indeed, thank you /very/ much for looking at this.

> I think the fix made it into 2.6.24.

We're currently using the very latest 2.6.30, unfortunately.  We've distilled this into a reproducible environment with a stack of NFS + XFS to a local disk + automated sysrq 'b' reboots.  We're working on getting this bundled up into a nice little package as a VirtualBox vm for your consumption.  Please tell me if this is not desirable.

Thanks very much again.

John Quigley
jquigley.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
