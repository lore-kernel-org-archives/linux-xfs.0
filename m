Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9QLWRsH037975 for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 16:32:27 -0500
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAFD95643F7
	for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 14:32:07 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id eZrVgurCGa2aycPy for
	<xfs@oss.sgi.com>; Wed, 26 Oct 2011 14:32:07 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 26 Oct 2011 17:32:07 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p9QLW4rk264836 for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 17:32:04 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p9QLW4q0025205 for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 19:32:04 -0200
Received: from [9.53.40.164] (chandra-lucid.austin.ibm.com [9.53.40.164])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p9QLW3YC025185 for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 19:32:03 -0200
Subject: Question w.r.t xfsprogs changes
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Wed, 26 Oct 2011 16:32:03 -0500
Message-ID: <1319664723.1959.90.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: XFS Mailing List <xfs@oss.sgi.com>

Hello All,

I am trying to make changes to the xfsprogs to support the patches I
posted last week (and few minutes earlier).

Looking at the xfsprogs code, I realize that the content of some of the
files(xfs_mount.c, xfs_quota.h, etc.,) are pretty much same as the
kernel files.

Just wondering if those changes are to be made explicitly or they will
be copied over from the kernel tree at some regular intervals ? IOW,
should I be changing those files (in xfsprogs) and posting them as
patches or have to wait for the sync to happen and then make only the
changes that are specific to user space ?

Regards,

Chandra


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
