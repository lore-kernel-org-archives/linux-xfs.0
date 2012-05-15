Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4FE2lDf191851 for <xfs@oss.sgi.com>; Tue, 15 May 2012 09:02:47 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id 8zVLX5BsdEyqhxAx for
	<xfs@oss.sgi.com>; Tue, 15 May 2012 07:02:45 -0700 (PDT)
Date: Tue, 15 May 2012 15:02:37 +0100
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Storage server, hung tasks and tracebacks
Message-ID: <20120515140237.GA3630@nsrc.org>
References: <20120502184450.GA2557@nsrc.org>
	<4FA27EF8.6040002@hardwarefreak.com> <20120503204157.GC4387@nsrc.org>
	<4FA3047D.8060908@hardwarefreak.com> <20120504163237.GA6128@nsrc.org>
	<4FA4C321.2070105@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FA4C321.2070105@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

Update:

After a week away, I am continuing to try to narrow down the problem of this
system withing hanging I/O.

I can fairly reliably repeat the problem on a system with 24 disks, and I've
embarked on trying some different configs to see what's the simplest way I
can make this die.

During this, I found something of interest: I happened to leave an 'iostat
5' process running, and that hung too.  i.e. ps showed it in 'D+' state, and
it was unkillable.

root        34  0.6  0.0      0     0 ?        D    11:29   1:18 [kswapd0]
root      1258  0.0  0.0  15976   532 ?        Ds   11:29   0:00 /usr/sbin/irqbalance
root      1421  0.0  0.0      0     0 ?        D    12:49   0:01 [xfsaild/md127]
snmp      1430  0.0  0.0  48608  3440 ?        D    11:29   0:00 /usr/sbin/snmpd -Lsd -Lf /dev/null -u snmp -g snmp -I -smux -p /var/run/snmpd.pid
xxxx      1614  1.1  0.0 378860  3812 pts/1    D+   12:50   1:15 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
xxxx      1669  1.2  0.0 378860  3816 pts/2    D+   12:50   1:21 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
xxxx      1727  0.5  0.0 383424   692 pts/3    Dl+  12:51   0:37 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
xxxx      1782  1.2  0.0 378860  3824 pts/4    D+   12:51   1:20 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
xxxx      1954  0.0  0.0   5912   544 pts/0    D+   12:58   0:00 iostat 5
root      2642  0.2  0.0      0     0 ?        D    13:25   0:09 [kworker/0:1]
root      3233  0.0  0.0   5044   168 ?        Ds   13:50   0:00 /usr/sbin/sshd -D -R
xxxx      4648  0.0  0.0   8104   936 pts/6    S+   14:41   0:00 grep --color=auto  D
root     29491  0.0  0.0      0     0 ?        D    12:45   0:00 [kworker/1:2]

I wonder if iostat actually communicates with the device driver at all? If
not, then presumably it's looking at some kernel data structure.  Maybe
there is a lock being kept open on that by someone/something.

At the same time, I notice that 'cat /proc/diskstats' still works, and
starting a new 'iostat 5' process works too.

After issuing halt -p I get this:

root        34  0.6  0.0      0     0 ?        D    11:29   1:18 [kswapd0]
root      1258  0.0  0.0  15976   532 ?        Ds   11:29   0:00 /usr/sbin/irqbalance
root      1421  0.0  0.0      0     0 ?        D    12:49   0:01 [xfsaild/md127]
snmp      1430  0.0  0.0  48608  3440 ?        D    11:29   0:00 /usr/sbin/snmpd -Lsd -Lf /dev/null -u snmp -g snmp -I -smux -p /var/run/snmpd.pid
xxxx      1614  1.0  0.0 378860  3812 pts/1    D+   12:50   1:15 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
xxxx      1669  1.1  0.0 378860  3816 pts/2    D+   12:50   1:21 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
xxxx      1727  0.5  0.0 383424   692 pts/3    Dl+  12:51   0:37 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
xxxx      1782  1.1  0.0 378860  3824 pts/4    D+   12:51   1:20 bonnie++ -d /disk/scratch/test -s 16384k -n 98:800k:500k:1000
xxxx      1954  0.0  0.0   5912   544 pts/0    D+   12:58   0:00 iostat 5
root      2642  0.1  0.0      0     0 ?        D    13:25   0:09 [kworker/0:1]
root      3233  0.0  0.0   5044   168 ?        Ds   13:50   0:00 /usr/sbin/sshd -D -R
root      4753  0.0  0.0  15056   928 ?        D    14:42   0:00 umount /run/rpc_pipefs
root      4828  0.0  0.0   4296   348 ?        D    14:42   0:00 sync
root      4834  0.0  0.0   8100   624 pts/6    R+   14:50   0:00 grep --color=auto  D
root     29491  0.0  0.0      0     0 ?        D    12:45   0:00 [kworker/1:2]

I see even umount'ing rpc_pipefs is hanging. So this suggests there's some
sort of global lock involved.

Anyway, I just wonder if this jogs a memory in anyone, as to why iostat
would hang in an unkillable way.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
