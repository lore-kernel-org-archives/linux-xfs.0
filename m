Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q94EI7EL156699 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 09:18:07 -0500
Received: from vwp1161.webpack.hosteurope.de (vwp1161.webpack.hosteurope.de
	[87.230.104.173]) by cuda.sgi.com with ESMTP id
	CeXyKCFB3TIYngg0 for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 07:19:31 -0700 (PDT)
Message-ID: <506D9AF0.4000506@blafoo.org>
Date: Thu, 04 Oct 2012 16:19:28 +0200
From: Volker <mail@blafoo.org>
MIME-Version: 1.0
Subject: Re: OOM on quotacheck (again?)
References: <5059D2B4.8010300@blafoo.org> <20120919205924.GC31501@dastard>
	<505AE2A1.5060703@blafoo.org> <20120924132113.GL20960@dastard>
	<5060727D.4000009@blafoo.org> <506B1667.4010203@blafoo.org>
	<20121002200946.GP23520@dastard> <506B5357.6060609@blafoo.org>
	<20121002221525.GU23520@dastard>
In-Reply-To: <20121002221525.GU23520@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi


> So you had a hang on 2.6.37 to do with dquot reclaim, you rebooted
> the server into what I think is a 3.6 kernel.
Correct.

> Log recovery failed with "bad clientid 0x0", so no superblock
> problem.
I was told by 'mount' that its a superblock-problem :-)

###
server044:~# mount -a
mount: /dev/sdb1: can't read superblock
###

What does the bad client-id in syslog indicate?

 It does tend to indicate that 2.6.37 wrote bad data to the
> log, though. If you reboot into 2.6.37, does log recovery run
> successfully? 
Yes. A server which was rebooted on Oct 3rd 07:18am, running 2.6.37 with
a stacktrace involving xfs_qm_dqreclaim_one came back up fine a couple
minutes later on 2.6.37.

If this would have not been working, we would have had way more trouble
with crashed xfs-partitions in the the past since the
xfs_qm_dqreclaim_one-stacktrace has been a very common error for us.

> i.e. does the failure only occur on 2.6.37 -> 3.6
> with a dirty log?
Yes. All 6 servers failed to mount the xfs-partition after they had
xfs-troubles on 2.6.37 and came back up on new 3.6 kernel. I did not try
to reboot them into 2.6.37 though.

> You them mounted the filesystem on the same kernel (has
> xfs_trans_read_buf_map() in the trace, hence the 3.6 version)
Correct. A quota-check was performed on all servers which ended in the
shown stack-trace also on all servers (see pastebin). After a reboot the
partition mounted just fine.

> What mount options are you using on the 2.6.37 kernel?
2.6.37 and 3.6 use the same options:

noatime,nosuid,nodev,gquota

> If you are upgrading your kernel, you should also upgrade your
> xfsprogs installation as well.
Will do.

- volker

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
