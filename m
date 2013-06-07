Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 915B97F4C
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 21:59:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 626BC30407A
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:59:39 -0700 (PDT)
Received: from esmtp1.es.uci.edu (esmtp1.es.uci.edu [128.195.153.131]) by
	cuda.sgi.com with ESMTP id rnHJtHG0mju7XqaN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 19:59:38 -0700 (PDT)
Received: from mail-we0-f171.google.com (mail-we0-f171.google.com
	[74.125.82.171]) (authenticated bits=0)
	by esmtp1.es.uci.edu (8.13.8/8.13.8) with ESMTP id r572xZkx413083
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Thu, 6 Jun 2013 19:59:37 -0700
Received: by mail-we0-f171.google.com with SMTP id m46so2638843wev.2
	for <xfs@oss.sgi.com>; Thu, 06 Jun 2013 19:59:34 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 6 Jun 2013 19:59:34 -0700
Message-ID: <CAO9TOLffaO62ZtvchpKnnORuNd0GJMsqKDeAhmdSQ1mnFn1EpA@mail.gmail.com>
Subject: XFS Adding Quotas - Skip Quota check on first mount/boot
From: Adam Brenner <aebrenne@uci.edu>
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

Howdy XFS Devs,

We run a 14TB XFS fileserver on our cluster and want to add quota
support. This is running 3.9.2-1.el6.elrepo.x86_64 kernel under CentOS
6.3 (Final).

The issue is when we unmount the XFS RAID, and re-mount it adding
quota support, the mount command hangs. Sever IS responsive and the
XFS mount point is not accessible. Reverting our changes in /etc/fstab
to remove the quota options does not have mount hang.

I suspect that upon re-mount, XFS is running a quota check on the 14TB
RAID. My question is: how do I disable the initial quota check so it
can mount it properly and have quota check run in the background?

/etc/fstab entry:

    /dev/sdb   /w1    xfs   defaults,noatime,usrquota,grpquota 1 2


/var/log/messages output:

    Jun  6 11:37:43 nas-2-1 kernel: XFS (sdb): Mounting Filesystem
    Jun  6 11:37:43 nas-2-1 kernel: XFS (sdb): Ending clean mount
    Jun  6 11:37:43 nas-2-1 kernel: XFS (sdb): Quotacheck needed:
                                    Please wait.

I do not mind high CPU usage or slow performance while the mount point
is active, but having it unavailable is not an option we would like
stick with. I suspect running quota check on 14TB would take roughly a
full work day and then some.

Thanks,
-Adam

--
Adam Brenner
Computer Science, Undergraduate Student
Donald Bren School of Information and Computer Sciences

Research Computing Support
Office of Information Technology
http://www.oit.uci.edu/rcs/

University of California, Irvine
www.ics.uci.edu/~aebrenne/
aebrenne@uci.edu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
