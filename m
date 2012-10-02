Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92IjqB4075570 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 13:45:52 -0500
Received: from vwp1161.webpack.hosteurope.de (vwp1161.webpack.hosteurope.de
	[87.230.104.173]) by cuda.sgi.com with ESMTP id
	B8oRD8ENkbWtehD5 for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 11:47:14 -0700 (PDT)
Message-ID: <506B1667.4010203@blafoo.org>
Date: Tue, 02 Oct 2012 18:29:27 +0200
From: Volker <mail@blafoo.org>
MIME-Version: 1.0
Subject: Re: OOM on quotacheck (again?)
References: <5059D2B4.8010300@blafoo.org> <20120919205924.GC31501@dastard>
	<505AE2A1.5060703@blafoo.org> <20120924132113.GL20960@dastard>
	<5060727D.4000009@blafoo.org>
In-Reply-To: <5060727D.4000009@blafoo.org>
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

Hi again,

> Great! That answered all my questions! Thanks a lot!
> 
> 3.6.0-rc6-x64 ist currently running fine on 6 machines.

just as a follow up i would like to share some info.

The six machines mentioned above are still running fine. So are few more
we tested with the new kernel. All of the servers tested so far, were
rebooted immediately after the new 3.6 kernel was installed.

Because of that, we decided to roll out the new kernel to all our
servers (approximately 330) and have the kernel "sink in" over the next
few days if the machines get rebooted.

This morning we experienced some problems with the superblock being
corrupted on 6 machines that had been rebooted during the night. For all
of them, the following was true:

a) the server was still running the old buggy 2.6.37 and had
filesystem-troubles on heavy i/o (that was our problem to begin with
besides the OOM)

b) because of the filesystem-troubles the server had been rebooted by
our hardware-support-team (sadly not necessarily using sys-requests)
because the xfs-partition was unresponsive

c) after being rebooted with the new 3.6 kernel, the server complained
about the super-block of the xfs-partition being corrupted and was not
able to mount the partition

d) by running xfs_repair -L -P <device> we were able to fix the problem

e) trying a remount of the fixed partition caused a quota-check which
always ended in a stack-trace, after a reboot, the quota-check was fine
and the partition successfully mounted

Has anyone ever experienced problems like this updating from an older
kernel to the current 3.6?

Any Idea what could have caused the bad superblock the 3.6 kernel
complained about?

Is it possible that the 2.6.37 kernel left a superblock behing that
could not be recognized by the 3.6 kernel?

If its of any interest, i can supply the stack-traces.

- volker

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
