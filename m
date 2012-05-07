Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q478Vfpd242986 for <xfs@oss.sgi.com>; Mon, 7 May 2012 03:31:41 -0500
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 3iziCgxf3Z5JPDdQ for
	<xfs@oss.sgi.com>; Mon, 07 May 2012 01:31:39 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: suddenly slow writes on XFS Filesystem
Date: Mon, 7 May 2012 10:31:38 +0200
References: <4FA63DDA.9070707@profihost.ag> <20120507013456.GW5091@dastard>
	<4FA76E11.1070708@profihost.ag>
	(sfid-20120507_095413_656560_122EB192)
In-Reply-To: <4FA76E11.1070708@profihost.ag>
MIME-Version: 1.0
Message-Id: <201205071031.38856.Martin@lichtvoll.de>
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
Cc: stan@hardwarefreak.com, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

Am Montag, 7. Mai 2012 schrieb Stefan Priebe - Profihost AG:
> > iostat -x -d -m 5 and vmstat 5 traces would be
> > useful to see if it is your array that is slow.....
> 
> ~ # iostat -x -d -m 5
> Linux 2.6.40.28intel (server844-han)    05/07/2012      _x86_64_
> (8 CPU)
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdb               0,00     0,00  254,80   25,40     1,72     0,16
> 13,71     0,86    3,08   2,39  67,06
> sda               0,00     0,20    0,00    1,20     0,00     0,00
> 6,50     0,00    0,00   0,00   0,00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdb               0,00     0,00  187,40   24,20     1,26     0,19
> 14,05     0,75    3,56   3,33  70,50
> sda               0,00     0,00    0,00    0,40     0,00     0,00
> 4,50     0,00    0,00   0,00   0,00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdb               0,00    11,20  242,40   92,00     1,56     0,89
> 15,00     4,70   14,06   1,58  52,68
> sda               0,00     0,20    0,00    2,60     0,00     0,02
> 12,00     0,00    0,00   0,00   0,00
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdb               0,00     0,00  166,20   24,00     0,99     0,17
> 12,51     0,57    3,02   2,40  45,56
> sda               0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     0,00    0,00   0,00   0,00
> 
> qDevice:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdb               0,00     0,00  188,00   25,40     1,22     0,16
> 13,23     0,44    2,04   1,78  38,02
> sda               0,00     0,00    0,00    0,00     0,00     0,00
> 0,00     0,00    0,00   0,00   0,00

Disk utilization seems to be quite high but it seems there not near to
90 to 100%. So there might be other overheads involved - like network
or (unlikely) CPU.

Did you verify that at the time you perceive slowness the servers you
backup can deliver data fast enough?

I would like to now, whether there are really processes waiting for I/O
during rsync workload.

Can you try vmstat 5 and 

while true; do ps aux | grep " D" | grep -v grep ; sleep 1; done

while the backup workload is running and slow?

Like this:

merkaba:~> while true; do ps aux | grep " D" | grep -v grep ; sleep 1; done
root      1508  0.0  0.0      0     0 ?        D    Mai06   0:00 [flush-253:2]
root      1508  0.0  0.0      0     0 ?        D    Mai06   0:00 [flush-253:2]
martin   28374  100  0.0   9800   652 pts/7    D+   10:27   0:02 dd if=/dev/zero of=fhgs
root      1508  0.0  0.0      0     0 ?        D    Mai06   0:00 [flush-253:2]

(this is with an Ext4, so its using the flush daemon, with XFS you
probably see xfssyncd or xfsbufd instead if I am not mistaken and if
rsync processes are waiting for I/O they should appear there too)

And yes, its important to have vmstat 5 output during workload is
happening to see the amount of CPU time that the kernel cannot use
for processing cause all processes that are runnable wait for I/O.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
