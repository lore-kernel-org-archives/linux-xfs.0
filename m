Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p78Cs0HW035392 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 07:54:00 -0500
Received: from fileserver.binf.ku.dk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C5491EF8DF3
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2011 05:53:58 -0700 (PDT)
Received: from fileserver.binf.ku.dk (174.binf.ku.dk [130.225.125.174]) by
	cuda.sgi.com with ESMTP id geHiwxgpuWGS8UuT for
	<xfs@oss.sgi.com>; Mon, 08 Aug 2011 05:53:58 -0700 (PDT)
Date: Mon, 8 Aug 2011 14:53:57 +0200 (CEST)
From: Hanne Munkholm <hanne@binf.ku.dk>
Subject: Re: "Corrupt dinode 6242615, (btree extents).  This is a bug."<o
In-Reply-To: <201108081358.43727@zmi.at>
Message-ID: <alpine.OSX.1.00.1108081422500.240@pegasus.binf.ku.dk>
References: <alpine.OSX.1.00.1108081203550.26464@pegasus.binf.ku.dk>
	<201108081358.43727@zmi.at>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Mon, 8 Aug 2011, Michael Monnerie wrote:
> Yes, mount -L/umount once to replay the log, when you are sure the block
> device works correctly again.

Thank you very much for your reply.

I don't see an -L option to the mount command meaning "replay
log", I think if I was able to mount it, it would replay the log
by itself? However, I cannot mount it.

<snip>

> Try to get the newest xfsprogs, maybe that's a bug in xfs_repair itself
> that has been fixed. If that doesn't help, a newer kernel might solve
> your problem.

That is a good idea, I downloaded xfsprogs 3.1.5 but it gave the
same results. Provided that it's OK to run it from the folder I
compiled it and it is not using libraries from the old version
somehow.

Trying with a newer kernel is possible but some trouble, is it
likely to help?

If I run an xfs_repair, will it get me anywhere even if it
segfaults at the same point?

Do you recommend that I run an xfs_repair with or without -L, or
should I definetly try a new kernel first?


Med venlig hilsen / Best regards
--
Hanne Munkholm                      Email: hanne@binf.ku.dk
Systemadministrator                 Tlf: +45 35 32 13 49

Bioinformatik-centret
K=F8benhavns Biocenter, Biologisk Institut
Ole Maal=F8es Vej 5, 2200 K=F8benhavn N

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
