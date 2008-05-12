Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 May 2008 15:55:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4CMsfVF023432
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 15:54:47 -0700
Received: from ns.unixsol.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0ACD157D2F
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 15:55:25 -0700 (PDT)
Received: from ns.unixsol.org ([193.110.159.2]) by cuda.sgi.com with ESMTP id DAGNpR1I6NkPV6HW for <xfs@oss.sgi.com>; Mon, 12 May 2008 15:55:25 -0700 (PDT)
Message-ID: <4828CAC6.3090402@unixsol.org>
Date: Tue, 13 May 2008 01:55:02 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
MIME-Version: 1.0
Subject: Unneeded kernel threads (xfs, jfs, gfs2)
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hi guys, I know that not all kernel thread users are converted to
start only when needed but the following is little annoying specially
when I'm not even using jfs, xfs and gfs2.

Look at the ps output from a standard distro 2.6.24.5 kernel after a
fresh boot:

>   PID TTY      STAT   TIME COMMAND
>     2 ?        S<     0:00 [kthreadd]
>     3 ?        S<     0:00  \_ [migration/0]
>     4 ?        S<     0:00  \_ [ksoftirqd/0]
>     5 ?        S<     0:00  \_ [migration/1]
>     6 ?        S<     0:00  \_ [ksoftirqd/1]
>     7 ?        S<     0:00  \_ [events/0]
>     8 ?        S<     0:00  \_ [events/1]
>     9 ?        S<     0:00  \_ [khelper]
>   102 ?        S<     0:00  \_ [kblockd/0]
>   103 ?        S<     0:00  \_ [kblockd/1]
>   106 ?        S<     0:00  \_ [kacpid]
>   107 ?        S<     0:00  \_ [kacpi_notify]
>   230 ?        S<     0:00  \_ [ata/0]
>   231 ?        S<     0:00  \_ [ata/1]
>   232 ?        S<     0:00  \_ [ata_aux]
>   233 ?        S<     0:00  \_ [ksuspend_usbd]
>   239 ?        S<     0:00  \_ [khubd]
>   242 ?        S<     0:00  \_ [kseriod]
>   284 ?        S      0:00  \_ [pdflush]
>   285 ?        S      0:00  \_ [pdflush]
>   286 ?        S<     0:00  \_ [kswapd0]
>   326 ?        S<     0:00  \_ [aio/0]
>   327 ?        S<     0:00  \_ [aio/1]
>   349 ?        S<     0:00  \_ [jfsIO]
>   350 ?        S<     0:00  \_ [jfsCommit]
>   351 ?        S<     0:00  \_ [jfsCommit]
>   352 ?        S<     0:00  \_ [jfsSync]

Not needed here, because no jfs partition is in use.

>   354 ?        S<     0:00  \_ [xfslogd/0]
>   355 ?        S<     0:00  \_ [xfslogd/1]
>   356 ?        S<     0:00  \_ [xfsdatad/0]
>   357 ?        S<     0:00  \_ [xfsdatad/1]
>   361 ?        S<     0:00  \_ [xfs_mru_cache]

Not needed here, because no xfs partition is in use.

>   366 ?        S<     0:00  \_ [gfs2_scand]
>   367 ?        S<     0:00  \_ [glock_workqueue]
>   368 ?        S<     0:00  \_ [glock_workqueue]

I dont use gfs2

>  1047 ?        S<     0:00  \_ [scsi_tgtd/0]
>  1048 ?        S<     0:00  \_ [scsi_tgtd/1]
>  1118 ?        S<     0:00  \_ [scsi_eh_2]
>  1120 ?        S<     0:00  \_ [scsi_eh_3]
>  1122 ?        S<     0:00  \_ [scsi_eh_4]
>  1124 ?        S<     0:00  \_ [scsi_eh_5]
>  1133 ?        S<     0:00  \_ [exec-osm/0]
>  1134 ?        S<     0:00  \_ [exec-osm/1]
>  1140 ?        S<     0:00  \_ [block-osm/0]
>  1141 ?        S<     0:00  \_ [block-osm/1]

What is osm? Can't find anything in kernel config?

>  1148 ?        S<     0:00  \_ [khpsbpkt]

What is this?

>  1193 ?        S<     0:00  \_ [ksnapd]
>  1201 ?        S<     0:00  \_ [rpciod/0]
>  1202 ?        S<     0:00  \_ [rpciod/1]
>  1204 ?        S<     0:00  \_ [kjournald]
>  2448 ?        S<     0:00  \_ [kjournald]
>  2649 ?        S      0:00  \_ [lockd]

Kernel config can be found here:
  http://mirrors.unixsol.org/slackware/slackware-12.1/kernels/hugesmp.s/config

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/
