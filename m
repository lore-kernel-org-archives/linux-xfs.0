Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3EEiiKl196450 for <xfs@oss.sgi.com>; Tue, 14 Apr 2009 09:44:54 -0500
Received: from mail.isg.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 564311CBD47D
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2009 07:44:04 -0700 (PDT)
Received: from mail.isg.de (rzfoobar.is-asp.com [217.11.194.155]) by
	cuda.sgi.com with ESMTP id 3M5KHISXz6MCA3ho for
	<xfs@oss.sgi.com>; Tue, 14 Apr 2009 07:44:04 -0700 (PDT)
Message-ID: <49E4A131.5040309@isg.de>
Date: Tue, 14 Apr 2009 16:44:01 +0200
From: Peter Niemayer <niemayer@isg.de>
MIME-Version: 1.0
Subject: XFS support for TRIM / blkdev_issue_discard?
References: <20090331053013.7642414167108@attica.americas.sgi.com>
In-Reply-To: <20090331053013.7642414167108@attica.americas.sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs@oss.sgi.com

Dear Felix Blyakher,

do you know whether there are plans to support the ATA TRIM command /
blkdev_issue_discard() call in XFS for Linux anytime soon?

I ask because as someone who is currently benchmarking solid state disks
for certain usage scenarios I noticed that other filesystems are starting
to support the discarding of unused blocks, which allows to prevent
performance-degradation of SSDs during heavy use.
(See e.g. http://www.mail-archive.com/cluster-devel@redhat.com/msg03401.html
  on the GFS2 support for the discard feature, it seems not too hard
  to implement the support)

Amongst other SSDs, we have one in our tests that supports the ATA TRIM command,
and I would like to test the benefits of it, even if that requires me
to install an early kernel pre-release.

(Currently, XFS is our favorite filesystem for several reasons, so it would
be great if we could run our TRIM-support-benchmarks using it)

Regards,

Peter Niemayer

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
