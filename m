Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8DNib5P096042 for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 18:44:37 -0500
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8195C6E502
	for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 16:45:25 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id 7SFpP5Brn7l1wcBO for
	<xfs@oss.sgi.com>; Mon, 13 Sep 2010 16:45:25 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1OvIiB-0007dl-Il
	for xfs@oss.sgi.com; Mon, 13 Sep 2010 16:45:23 -0700
Message-ID: <29704010.post@talk.nabble.com>
Date: Mon, 13 Sep 2010 16:45:23 -0700 (PDT)
From: pbrunnen <PBrunnen@bccnetworks.net>
Subject: XFS Filesystem not mounting
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


Hello all,

Pardon the cross post...

I have an XFS filesystem (not my root filesystem) on an OpenSuSE system that
is not mounting.

We had a power failure over the weekend. All but one of our XFS mounts is
comming up. Its a large mount (2TB) and I am not seeing errors per se...

But after attempting to mount it, it has been 4 hours and all we see in
either dmesg output or in the messages file from the kernel is:

"Starting FXS recovery on filesystem: sdd1 (logdev: internal)"

Our mount process is dead and I don't see any disk i/o going on. Am I
missing something here on this?

I rebooted the box once earlier and was able mount read-only with
norecovery...

I tried xfs_check and it also produced a dead "xfs_df -i -p xfs_check -c
check /dev/sdd1"

Thoughts? Ideas?

Thanks!! -Peter.
-- 
View this message in context: http://old.nabble.com/XFS-Filesystem-not-mounting-tp29704010p29704010.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
