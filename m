Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5RKtSje142498
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jun 2011 15:55:28 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 107DE16727FB
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jun 2011 13:55:27 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id cZDJQCfbNmFqr9Tf
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jun 2011 13:55:27 -0700 (PDT)
Message-ID: <4E08EE3E.1090604@hardwarefreak.com>
Date: Mon, 27 Jun 2011 15:55:26 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: mkfs.xfs error creating large agcount an raid
References: <4E063BC6.9000801@task.com.br>	<4E0694CC.8050003@hardwarefreak.com>	<4E06C967.2060107@task.com.br>	<20110626235959.GC32466@dastard>	<4E07FA07.4050907@hardwarefreak.com>	<4E0803AA.20809@task.com.br>	<4E08456F.1090503@hardwarefreak.com>	<BANLkTimJm5Fe1LvD1AQYZC5QCDs0gXJpFA@mail.gmail.com>	<4E089D4E.1060503@sandeen.net>
	<BANLkTikJe7ayzwD2Yqc7BHePfZ4x-M_SyQ@mail.gmail.com>
In-Reply-To: <BANLkTikJe7ayzwD2Yqc7BHePfZ4x-M_SyQ@mail.gmail.com>
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
To: Paul Anderson <pha@umich.edu>
Cc: linux-xfs@oss.sgi.com, Marcus Pereira <marcus@task.com.br>, Eric Sandeen <sandeen@sandeen.net>

On 6/27/2011 10:27 AM, Paul Anderson wrote:

> There is nothing in the man page I see indicating what is good or bad
> regarding allocation groups - either document it there or warn in the
> software.  If allocation algorithms are linear with respect to
> allocation groups, the something like this should be stated in the man
> pages.

It is.  From the 2nd paragraph of 'man 5 xfs':

...The data section is divided into a number of allocation groups. The
number and size of the allocation groups are chosen by mkfs.xfs(8) so
that there is normally a small number of equal-sized groups. The number
of allocation groups controls the amount of parallelism available in
file and block allocation. It should be increased from the default if
there is sufficient memory and a lot of allocation activity. The number
of allocation groups should not be set very high, since this can cause
large amounts of CPU time to be used by the filesystem, especially when
the filesystem is nearly full. More allocation groups are added (of the
original size) when xfs_growfs(8) is run.

Maybe some of this information could/should be moved to the agcount
section of 'man mkfs.xfs'.  I'll concede that "should not be set very
high" is subjective for novice XFS users.  To Marcus 20,000 may not be
"very high". :)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
