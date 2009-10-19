Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9JAHQnl055087 for <xfs@oss.sgi.com>; Mon, 19 Oct 2009 05:17:27 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D96B1BF9337
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2009 03:18:59 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id I0MsHWr0c6b0lN0z for
	<xfs@oss.sgi.com>; Mon, 19 Oct 2009 03:18:58 -0700 (PDT)
Date: Mon, 19 Oct 2009 06:18:58 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.31+2.6.31.4: XFS - All I/O locks up to D-state after 24-48
	hours (sysrq-t+w available)
In-Reply-To: <20091019030456.GS9464@discord.disaster>
Message-ID: <alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>
	<alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>
	<20091019030456.GS9464@discord.disaster>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Mon, 19 Oct 2009, Dave Chinner wrote:

> On Sun, Oct 18, 2009 at 04:17:42PM -0400, Justin Piszcz wrote:
>> It has happened again, all sysrq-X output was saved this time.
>>
>> wget http://home.comcast.net/~jpiszcz/20091018/crash.txt
>> wget http://home.comcast.net/~jpiszcz/20091018/dmesg.txt
>> wget http://home.comcast.net/~jpiszcz/20091018/interrupts.txt
>> wget http://home.comcast.net/~jpiszcz/20091018/sysrq-l.txt
>> wget http://home.comcast.net/~jpiszcz/20091018/sysrq-m.txt
>> wget http://home.comcast.net/~jpiszcz/20091018/sysrq-p.txt
>> wget http://home.comcast.net/~jpiszcz/20091018/sysrq-q.txt
>> wget http://home.comcast.net/~jpiszcz/20091018/sysrq-t.txt
>> wget http://home.comcast.net/~jpiszcz/20091018/sysrq-w.txt
> .....
>
> All pointing to log IO not completing.
>
> That is, all of the D state processes are backed up on locks or
> waiting for IO completion processing. A lot of the processes are
> waiting for _xfs_log_force to complete, others are waiting for
> inodes to be unpinned or are backed up behind locked inodes that are
> waiting on log IO to complete before they can complete the
> transaction and unlock the inode, and so on.
>
> Unfortunately, the xfslogd and xfsdatad kernel threads are not
> present in any of the output given, so I can't tell if these have
> deadlocked themselves and caused the problem. However, my experience
> with such pile-ups is that an I/O completion has not been run for
> some reason and that is the cause of the problem. I don't know if
> you can provide enough information to tell us if this happened or
> not. Instead, do you have a test case that you can share?
>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
>

Hello,

So far I do not have a reproducible test case, the only other thing not posted
was the output of ps auxww during the time of the lockup, not sure if it will
help, but here it is:

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0  10320   684 ?        Ss   Oct16   0:00 init [2] 
root         2  0.0  0.0      0     0 ?        S<   Oct16   0:00 [kthreadd]
root         3  0.0  0.0      0     0 ?        S<   Oct16   0:00 [migration/0]
root         4  0.0  0.0      0     0 ?        S<   Oct16   0:00 [ksoftirqd/0]
root         5  0.0  0.0      0     0 ?        S<   Oct16   0:00 [migration/1]
root         6  0.0  0.0      0     0 ?        S<   Oct16   0:00 [ksoftirqd/1]
root         7  0.0  0.0      0     0 ?        S<   Oct16   0:00 [migration/2]
root         8  0.0  0.0      0     0 ?        S<   Oct16   0:00 [ksoftirqd/2]
root         9  0.0  0.0      0     0 ?        S<   Oct16   0:00 [migration/3]
root        10  0.0  0.0      0     0 ?        S<   Oct16   0:00 [ksoftirqd/3]
root        11  0.0  0.0      0     0 ?        R<   Oct16   0:00 [events/0]
root        12  0.0  0.0      0     0 ?        S<   Oct16   0:00 [events/1]
root        13  0.0  0.0      0     0 ?        S<   Oct16   0:00 [events/2]
root        14  0.0  0.0      0     0 ?        S<   Oct16   0:00 [events/3]
root        15  0.0  0.0      0     0 ?        S<   Oct16   0:00 [khelper]
root        20  0.0  0.0      0     0 ?        S<   Oct16   0:00 [async/mgr]
root       180  0.0  0.0      0     0 ?        S<   Oct16   0:00 [kblockd/0]
root       181  0.0  0.0      0     0 ?        S<   Oct16   0:00 [kblockd/1]
root       182  0.0  0.0      0     0 ?        S<   Oct16   0:00 [kblockd/2]
root       183  0.0  0.0      0     0 ?        S<   Oct16   0:00 [kblockd/3]
root       185  0.0  0.0      0     0 ?        S<   Oct16   0:00 [kacpid]
root       186  0.0  0.0      0     0 ?        S<   Oct16   0:00 [kacpi_notify]
root       187  0.0  0.0      0     0 ?        S<   Oct16   0:00 [kacpi_hotplug]
root       271  0.0  0.0      0     0 ?        S<   Oct16   0:00 [ata/0]
root       272  0.0  0.0      0     0 ?        S<   Oct16   0:00 [ata/1]
root       273  0.0  0.0      0     0 ?        S<   Oct16   0:00 [ata/2]
root       274  0.0  0.0      0     0 ?        S<   Oct16   0:00 [ata/3]
root       275  0.0  0.0      0     0 ?        S<   Oct16   0:00 [ata_aux]
root       276  0.0  0.0      0     0 ?        S<   Oct16   0:00 [ksuspend_usbd]
root       280  0.0  0.0      0     0 ?        S<   Oct16   0:00 [khubd]
root       283  0.0  0.0      0     0 ?        S<   Oct16   0:00 [kseriod]
root       318  0.0  0.0      0     0 ?        S<   Oct16   0:00 [khpsbpkt]
root       361  0.0  0.0      0     0 ?        S    Oct16   0:00 [pdflush]
root       362  0.0  0.0      0     0 ?        D    Oct16   0:43 [pdflush]
root       363  0.0  0.0      0     0 ?        S<   Oct16   0:21 [kswapd0]
root       364  0.0  0.0      0     0 ?        S<   Oct16   0:00 [aio/0]
root       365  0.0  0.0      0     0 ?        S<   Oct16   0:00 [aio/1]
root       366  0.0  0.0      0     0 ?        S<   Oct16   0:00 [aio/2]
root       367  0.0  0.0      0     0 ?        S<   Oct16   0:00 [aio/3]
root       368  0.0  0.0      0     0 ?        S<   Oct16   0:00 [nfsiod]
root       369  0.0  0.0      0     0 ?        S<   Oct16   0:00 [cifsoplockd]
root       370  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfs_mru_cache]
root       371  0.0  0.0      0     0 ?        R<   Oct16   0:01 [xfslogd/0]
root       372  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfslogd/1]
root       373  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfslogd/2]
root       374  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfslogd/3]
root       375  0.0  0.0      0     0 ?        R<   Oct16   0:00 [xfsdatad/0]
root       376  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsdatad/1]
root       377  0.0  0.0      0     0 ?        S<   Oct16   0:03 [xfsdatad/2]
root       378  0.0  0.0      0     0 ?        S<   Oct16   0:01 [xfsdatad/3]
root       379  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsconvertd/0]
root       380  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsconvertd/1]
root       381  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsconvertd/2]
root       382  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsconvertd/3]
root       518  0.0  0.0      0     0 ?        S<   Oct16   0:00 [scsi_eh_0]
root       521  0.0  0.0      0     0 ?        S<   Oct16   0:00 [scsi_eh_1]
root       524  0.0  0.0      0     0 ?        S<   Oct16   0:00 [scsi_eh_2]
root       527  0.0  0.0      0     0 ?        S<   Oct16   0:00 [scsi_eh_3]
root       530  0.0  0.0      0     0 ?        S<   Oct16   0:00 [scsi_eh_4]
root       533  0.0  0.0      0     0 ?        S<   Oct16   0:00 [scsi_eh_5]
root       542  0.0  0.0      0     0 ?        S<   Oct16   0:00 [scsi_eh_6]
root       545  0.0  0.0      0     0 ?        S<   Oct16   0:00 [scsi_eh_7]
root       551  0.0  0.0      0     0 ?        S<   Oct16   0:00 [scsi_eh_8]
root       554  0.0  0.0      0     0 ?        S<   Oct16   0:00 [scsi_eh_9]
root       558  0.0  0.0      0     0 ?        S<   Oct16   0:00 [scsi_eh_10]
root       562  0.0  0.0      0     0 ?        S<   Oct16   0:00 [scsi_eh_11]
root       568  0.0  0.0      0     0 ?        S<   Oct16   0:00 [scsi_eh_12]
root       571  0.0  0.0      0     0 ?        S<   Oct16   0:00 [scsi_eh_13]
root       584  0.0  0.0      0     0 ?        S<   Oct16   0:00 [knodemgrd_0]
root       616  0.0  0.0      0     0 ?        S<   Oct16   0:00 [kpsmoused]
root       666  0.0  0.0      0     0 ?        S<   Oct16   0:00 [usbhid_resumer]
root       683  0.0  0.0      0     0 ?        S<   Oct16   0:00 [hd-audio0]
root       703  0.0  0.0      0     0 ?        S<   Oct16   0:00 [rpciod/0]
root       704  0.0  0.0      0     0 ?        S<   Oct16   0:00 [rpciod/1]
root       705  0.0  0.0      0     0 ?        S<   Oct16   0:00 [rpciod/2]
root       706  0.0  0.0      0     0 ?        S<   Oct16   0:00 [rpciod/3]
root       811  4.0  0.0      0     0 ?        S<   Oct16  81:54 [md3_raid5]
root       817  0.3  0.0      0     0 ?        S<   Oct16   6:30 [md2_raid1]
root       823  0.0  0.0      0     0 ?        S<   Oct16   0:00 [md1_raid1]
root       827  0.0  0.0      0     0 ?        S<   Oct16   0:50 [md0_raid1]
root       829  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsbufd]
root       830  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsaild]
root       831  0.0  0.0      0     0 ?        D<   Oct16   0:00 [xfssyncd]
root       884  0.0  0.0  16736   740 ?        S<s  Oct16   0:00 udevd --daemon
postfix   1649  0.0  0.0  39124  2468 ?        S    05:00   0:00 qmgr -l -t fifo -u -c
www-data  1877  0.0  0.0 146612  5248 ?        S    05:01   0:00 /usr/sbin/apache2 -k start
root      3182  0.0  0.0      0     0 ?        S<   Oct16   0:00 [kjournald]
root      3183  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsbufd]
root      3184  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfsaild]
root      3185  0.0  0.0      0     0 ?        S<   Oct16   0:00 [xfssyncd]
root      3337  0.0  0.0   8072   132 ?        Ss   Oct16   0:00 /app/ulogd-1.24-x86_64/sbin/ulogd -c /app/ulogd-1.24-x86_64/etc/ulogd-eth0.conf -d
root      3339  0.0  0.0   8072   424 ?        Ds   Oct16   0:00 /app/ulogd-1.24-x86_64/sbin/ulogd -c /app/ulogd-1.24-x86_64/etc/ulogd-eth1.conf -d
daemon    3526  0.0  0.0   8016   564 ?        Ss   Oct16   0:00 /sbin/portmap
statd     3538  0.0  0.0  10148   776 ?        Ss   Oct16   0:00 /sbin/rpc.statd
root      3547  0.0  0.0  26956   572 ?        Ss   Oct16   0:00 /usr/sbin/rpc.idmapd
root      3732  0.0  0.0   5900   676 ?        Ds   Oct16   0:00 /sbin/syslogd
root      3741  0.0  0.0   3796   452 ?        Ss   Oct16   0:00 /sbin/klogd -x
root      3750  0.0  0.0   3804   640 ?        Ss   Oct16   0:00 /usr/sbin/acpid
110       3760  0.0  0.0  23560  1476 ?        Ss   Oct16   0:02 /usr/bin/dbus-daemon --system
bind      3773  0.0  0.8 264364 70004 ?        Ssl  Oct16   0:05 /usr/sbin/named -u bind -S 1024
root      3796  0.0  0.0  49028  1260 ?        Ss   Oct16   0:00 /usr/sbin/sshd
root      3827  0.0  0.0 104804  7452 ?        Ssl  Oct16   0:08 /usr/sbin/console-kit-daemon
amavis    3909  0.0  1.1 217948 91004 ?        Ss   Oct16   0:00 amavisd (master)
nobody    3913  0.0  0.2 118612 21632 ?        Sl   Oct16   0:02 /app/gross-1.0.1-x86_64/sbin/grossd -f /etc/grossd/grossd.conf -p /var/run/grossd/grossd.pid
polw      3932  0.0  0.1  51868 12084 ?        Ss   Oct16   0:00 policyd-weight (master)
polw      3933  0.0  0.1  51868 11744 ?        Ss   Oct16   0:00 policyd-weight (cache)
postfw    3937  0.0  0.1  55248 14064 ?        Ss   Oct16   0:00 /usr/sbin/postfwd --summary=0 --cache=600 --cache-rdomain-only --cache-no-size --daemon --file=/etc/postfwd/postfwd.cf --interface=127.0.0.1 --port=10040 --user=postfw --group=postfw --pidfile=/var/run/postfwd.pid
postgrey  3940  0.0  0.1  57900 13232 ?        Ss   Oct16   0:00 /usr/sbin/postgrey --pidfile=/var/run/postgrey.pid --daemonize --inet=127.0.0.1:60000 --greylist-action=421 
clamav    4166  0.0  1.3 215576 112772 ?       Ssl  Oct16   0:04 /usr/sbin/clamd
clamav    4262  0.0  0.0  25776  1328 ?        Ss   Oct16   0:00 /usr/bin/freshclam -d --quiet
amavis    4307  0.0  1.1 224072 96732 ?        S    Oct16   0:02 amavisd (ch14-avail)
amavis    4308  0.0  1.2 228168 100820 ?       S    Oct16   0:05 amavisd (ch14-avail)
root      4353  0.0  0.0   7224  3944 ?        S    Oct16   0:02 /usr/sbin/hddtemp -d -l 127.0.0.1 -p 7634 -s | /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj
root      4362  0.0  0.0   8864   520 ?        Ss   Oct16   0:00 /usr/sbin/irqbalance
daemon    4377  0.0  0.0  38488   840 ?        Ss   Oct16   0:00 lpd Waiting 
root      4412  0.0  0.0      0     0 ?        S<   Oct16   0:00 [lockd]
root      4413  0.0  0.0      0     0 ?        S<   Oct16   0:10 [nfsd]
root      4414  0.0  0.0      0     0 ?        D<   Oct16   0:03 [nfsd]
root      4415  0.0  0.0      0     0 ?        D<   Oct16   0:13 [nfsd]
root      4416  0.0  0.0      0     0 ?        S<   Oct16   0:07 [nfsd]
root      4417  0.0  0.0      0     0 ?        D<   Oct16   0:11 [nfsd]
root      4418  0.0  0.0      0     0 ?        D<   Oct16   0:01 [nfsd]
root      4419  0.0  0.0      0     0 ?        D<   Oct16   0:04 [nfsd]
root      4420  0.0  0.0      0     0 ?        D<   Oct16   0:02 [nfsd]
root      4424  0.0  0.0  18812  1208 ?        Ss   Oct16   0:00 /usr/sbin/rpc.mountd --manage-gids
oident    4432  0.0  0.0  12232   576 ?        Ss   Oct16   0:00 /usr/sbin/oidentd -m -u oident -g oident
root      4444  0.0  0.0  10124   660 ?        Ss   Oct16   0:00 /usr/sbin/inetd
root      4521  0.0  0.0  37020  2388 ?        Ss   Oct16   0:00 /usr/lib/postfix/master
root      4545  0.0  0.0  58084  1796 ?        Ds   Oct16   0:00 /usr/sbin/nmbd -D
root      4547  0.0  0.0  93724  3044 ?        Ss   Oct16   0:00 /usr/sbin/smbd -D
root      4568  0.0  0.0  93752  1776 ?        S    Oct16   0:00 /usr/sbin/smbd -D
root      4700  0.0  0.0  18768  1348 ?        S    Oct16   0:00 /usr/sbin/smartd --pidfile /var/run/smartd.pid
asterisk  4714  1.3  0.2 666972 24460 ?        Ssl  Oct16  26:36 /usr/sbin/asterisk -p -U asterisk
asterisk  4715  0.0  0.0  13656   880 ?        S    Oct16   0:00 astcanary /var/run/asterisk/alt.asterisk.canary.tweet.tweet.tweet
ntp       4734  0.0  0.0  23428  1400 ?        Ss   Oct16   0:00 /usr/sbin/ntpd -p /var/run/ntpd.pid -u 105:106 -g
root      4789  0.0  0.0  16644   780 ?        Ss   Oct16   0:00 /usr/sbin/dovecot
root      4790  0.0  0.0  74664  3196 ?        S    Oct16   0:00 dovecot-auth
root      4792  0.0  0.0  74664  3240 ?        S    Oct16   0:00 dovecot-auth -w
111       4797  0.0  0.0  38084  4616 ?        Ss   Oct16   0:07 /usr/sbin/hald
root      4798  0.0  0.0  20040  1432 ?        S    Oct16   0:01 hald-runner
root      4895  0.0  0.0  22028  1240 ?        S    Oct16   0:00 hald-addon-input: Listening on /dev/input/event1 /dev/input/event0 /dev/input/event3
root      4899  0.0  0.0  22032  1232 ?        S    Oct16   0:00 hald-addon-storage: no polling on /dev/sr0 because it is explicitly disabled
root      4900  0.0  0.0  22028  1228 ?        S    Oct16   0:00 hald-addon-storage: no polling on /dev/fd0 because it is explicitly disabled
111       4902  0.0  0.0  25920  1204 ?        S    Oct16   0:00 hald-addon-acpi: listening on acpid socket /var/run/acpid.socket
root      4911  0.0  0.0  12484   656 ?        Ss   Oct16   0:00 /sbin/mdadm --monitor --pid-file /var/run/mdadm/monitor.pid --daemonise --scan --syslog
root      4929  0.0  0.0  24020   584 ?        Ss   Oct16   0:00 /usr/sbin/squid -D -YC
proxy     4931  0.0  0.0  26900  5136 ?        S    Oct16   0:00 (squid) -D -YC
root      4942  0.0  0.0  28924  3548 ?        Ss   Oct16   0:00 /usr/bin/perl -T /usr/lib/postfix/p0f-analyzer.pl 2345
root      4943  0.0  0.0  17392  1380 ?        S    Oct16   0:00 sh -c p0f -u daemon -i eth1 -l 'tcp dst port 25' 2>&1
daemon    4945  0.3  0.0  16596  3172 ?        S    Oct16   7:01 p0f -u daemon -i eth1 -l tcp dst port 25
root      4947  0.0  0.0  93604  5832 ?        SNs  Oct16   0:10 /usr/bin/perl -w /app/mailgraph-1.14/bin/mailgraph.pl -l /var/log/mail.log -d --ignore-localhost --rbl-is-spam --daemon-pid=/var/run/mailgraph.pid --daemon-rrd=/var/lib/mailgraph
root      4951  0.0  0.0   9296  3716 ?        Ss   Oct16   0:00 /usr/sbin/dhcpd3 -q eth0
nut       4964  0.0  0.0  14384   744 ?        Ss   Oct16   0:15 /lib/nut/usbhid-ups -a apc
nut       4966  0.0  0.0  14316   600 ?        Ss   Oct16   0:01 /sbin/upsd
root      4968  0.0  0.0  14284   728 ?        Ss   Oct16   0:00 /sbin/upsmon
nut       4970  0.0  0.0  14284   712 ?        S    Oct16   0:01 /sbin/upsmon
daemon    5007  0.0  0.0  16356   416 ?        Ss   Oct16   0:00 /usr/sbin/atd
root      5027  0.0  0.0  20988  1060 ?        Ss   Oct16   0:00 /usr/sbin/cron
dovecot   5887  0.0  0.0  18504  2108 ?        S    15:31   0:00 imap-login
root      6184  0.0  0.0  73496  6380 ?        Sl   Oct16   0:00 /usr/bin/python /usr/bin/fail2ban-server -b -s /var/run/fail2ban/fail2ban.sock
root      6205  0.0  0.0  26292   720 ?        Ss   Oct16   0:00 /usr/bin/kdm -config /var/run/kdm/kdmrc
root      6213  0.1  1.3 192020 112852 tty7    Ss+  Oct16   2:34 /usr/bin/X -br -nolisten tcp :0 vt7 -auth /var/run/xauth/A:0-y1Rrr6
root      6284  0.0  0.0   5852   600 tty1     Ss+  Oct16   0:00 /sbin/getty 38400 tty1
root      6285  0.0  0.0   5852   596 tty2     Ss+  Oct16   0:00 /sbin/getty 38400 tty2
root      6286  0.0  0.0   5852   596 tty3     Ss+  Oct16   0:00 /sbin/getty 38400 tty3
root      6287  0.0  0.0   5852   600 tty4     Ss+  Oct16   0:00 /sbin/getty 38400 tty4
root      6288  0.0  0.0   5852   596 tty5     Ss+  Oct16   0:00 /sbin/getty 38400 tty5
root      6289  0.0  0.0   5852   600 tty6     Ss+  Oct16   0:00 /sbin/getty 38400 tty6
root      6297  0.0  0.0  55716  1864 ?        S    Oct16   0:00 -:0 
postfix   6362  0.0  0.0  39076  2308 ?        S    15:36   0:00 anvil -l -t unix -u -o max_idle=3600s
root      7003  0.0  0.0  80904  3412 ?        Ss   Oct16   0:00 sshd: ap [priv] 
polw      7443  0.0  0.1  52000 12516 ?        S    Oct16   0:00 policyd-weight (child)
dovecot   8922  0.0  0.0  18504  2108 ?        S    16:01   0:00 imap-login
dovecot   8923  0.0  0.0  18504  2112 ?        S    16:01   0:00 imap-login
postfix  18407  0.0  0.0  39076  2352 ?        D    17:50   0:00 pickup -l -t fifo -u -c -o receive_override_options=no_header_body_checks
asterisk 18424  0.0  0.0  36996  2260 ?        D    17:54   0:00 /usr/sbin/postdrop -r
root     18425  0.0  0.0  46372  1440 ?        S    17:55   0:00 /USR/SBIN/CRON
root     18459  0.0  0.0  11404  1328 ?        Ss   17:55   0:00 /bin/sh -c if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi
root     18460  0.0  0.0  21888  1432 ?        D    17:55   0:00 /usr/lib/hal/hal-acl-tool --reconfigure
root     18465  0.0  0.2  43416 16892 ?        S    17:55   0:00 /usr/bin/perl -w /usr/bin/mrtg /etc/mrtg.cfg
root     18479  0.0  0.0   4140   612 ?        S    17:55   0:00 tee -a /var/log/mrtg/mrtg.log
root     18538  0.0  0.0  38476  1976 ?        D    17:55   0:00 /usr/bin/rateup /var/www/monitor/mrtg/ eth0 1255816502 -Z u 21723041186 43737397048 125000000 c #00cc00 #0000ff #006600 #ff00ff k 1000 i /var/www/monitor/mrtg/eth0-day.png -125000000 -125000000 400 100 1 1 1 300 0 4 1 %Y-%m-%d %H:%M 0 i /var/www/monitor/mrtg/eth0-week.png -125000000 -125000000 400 100 1 1 1 1800 0 4 1 %Y-%m-%d %H:%M 0
postfix  18539  0.0  0.1  50740  9836 ?        S    17:55   0:00 cleanup -z -t unix -u -c
root     18555  0.0  0.0  46368  1172 ?        S    18:00   0:00 /USR/SBIN/CRON
root     18556  0.0  0.0  46368  1172 ?        S    18:00   0:00 /USR/SBIN/CRON
root     18557  0.0  0.0  46368  1172 ?        S    18:00   0:00 /USR/SBIN/CRON
root     18558  0.0  0.0  46368  1172 ?        S    18:00   0:00 /USR/SBIN/CRON
root     18559  0.0  0.0  46368  1172 ?        S    18:00   0:00 /USR/SBIN/CRON
root     18560  0.0  0.0  46368  1172 ?        S    18:02   0:00 /USR/SBIN/CRON
root     18561  0.0  0.0  46368  1172 ?        S    18:05   0:00 /USR/SBIN/CRON
root     18562  0.0  0.0  46368  1172 ?        S    18:05   0:00 /USR/SBIN/CRON
root     18563  0.0  0.0  46368  1172 ?        S    18:05   0:00 /USR/SBIN/CRON
root     18564  0.0  0.0  46368  1172 ?        S    18:05   0:00 /USR/SBIN/CRON
root     18565  0.0  0.0  46368  1172 ?        S    18:09   0:00 /USR/SBIN/CRON
root     18566  0.0  0.0  46368  1172 ?        S    18:10   0:00 /USR/SBIN/CRON
root     18567  0.0  0.0  46368  1172 ?        S    18:10   0:00 /USR/SBIN/CRON
root     18568  0.0  0.0  46368  1172 ?        S    18:10   0:00 /USR/SBIN/CRON
root     18578  0.0  0.0  46368  1172 ?        S    18:15   0:00 /USR/SBIN/CRON
root     18579  0.0  0.0  46368  1172 ?        S    18:15   0:00 /USR/SBIN/CRON
root     18580  0.0  0.0  46368  1172 ?        S    18:15   0:00 /USR/SBIN/CRON
root     18581  0.0  0.0  46368  1172 ?        S    18:15   0:00 /USR/SBIN/CRON
root     18582  0.0  0.0  46368  1172 ?        S    18:17   0:00 /USR/SBIN/CRON
root     18583  0.0  0.0  46368  1172 ?        S    18:18   0:00 /USR/SBIN/CRON
postfix  18584  0.0  0.0  71452  8104 ?        S    18:18   0:00 smtpd -n 75.144.35.65:smtp -t inet -u -c -o stress= -o stress=yes -o content_filter=amavisfeed:[127.0.0.1]:10024 -o receive_override_options=no_address_mappings
postfix  18585  0.0  0.0  39076  2300 ?        S    18:18   0:00 proxymap -t unix -u
sshd     18597  0.0  0.0      0     0 ?        Z    18:19   0:00 [sshd] <defunct>
root     18601  0.0  0.0  46368  1172 ?        S    18:20   0:00 /USR/SBIN/CRON
root     18602  0.0  0.0  46368  1172 ?        S    18:20   0:00 /USR/SBIN/CRON
root     18603  0.0  0.0  46368  1172 ?        S    18:20   0:00 /USR/SBIN/CRON
root     30866  0.0  0.0  54392   944 ?        Ss   04:31   0:00 /usr/sbin/saslauthd -a pam -c -m /var/run/saslauthd -n 5
root     30867  0.0  0.0  54392   652 ?        S    04:31   0:00 /usr/sbin/saslauthd -a pam -c -m /var/run/saslauthd -n 5
root     30868  0.0  0.0  54392   540 ?        S    04:31   0:00 /usr/sbin/saslauthd -a pam -c -m /var/run/saslauthd -n 5
root     30869  0.0  0.0  54392   540 ?        S    04:31   0:00 /usr/sbin/saslauthd -a pam -c -m /var/run/saslauthd -n 5
root     30870  0.0  0.0  54392   540 ?        S    04:31   0:00 /usr/sbin/saslauthd -a pam -c -m /var/run/saslauthd -n 5
root     31018  0.0  0.0 146612  7856 ?        Ss   04:31   0:00 /usr/sbin/apache2 -k start
www-data 31025  0.0  0.0 146612  5248 ?        S    04:31   0:00 /usr/sbin/apache2 -k start
www-data 31044  0.0  0.0 146612  5248 ?        S    04:31   0:00 /usr/sbin/apache2 -k start
root     31076  0.0  0.0  23128   756 ?        Ss   04:31   0:00 pure-ftpd (SERVER)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
