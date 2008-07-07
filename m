Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Jul 2008 11:31:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m67IUtIY013065
	for <xfs@oss.sgi.com>; Mon, 7 Jul 2008 11:30:55 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 068782C3489
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2008 11:31:59 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id Gt7spVsUoU5KWIuD for <xfs@oss.sgi.com>; Mon, 07 Jul 2008 11:31:59 -0700 (PDT)
Date: Mon, 7 Jul 2008 14:31:57 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 12 Veliciraptors again w/x4 card (~1gbyte/sec aggregate read)!
Message-ID: <alpine.DEB.1.10.0807071424100.4694@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Each PCI-e x1 card has 1 veliciraptor on it now.
Got an x4 card wit 4 sata ports:

Not quite the > 1 gbyte/sec I was hoping for in regards to the reads
but pretty close!

(For my RAID5)
Previously my write was limited to 400-420MiB/s now I see an additional
120-125 MiB/s increase!

jpiszcz@p34:/x/f$ dd if=/dev/zero of=bigfile bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 20.7054 s, 519 MB/s
jpiszcz@p34:/x/f$ sync
jpiszcz@p34:/x/f$ dd if=/dev/zero of=bigfile.1 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 20.4973 s, 524 MB/s
jpiszcz@p34:/x/f$ sync
jpiszcz@p34:/x/f$ dd if=bigfile of=/dev/null bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 11.3529 s, 946 MB/s
jpiszcz@p34:/x/f$ sync
jpiszcz@p34:/x/f$ dd if=bigfile.1 of=/dev/null bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 11.2635 s, 953 MB/s
jpiszcz@p34:/x/f$

--

For all disks:

Something I noticed is the x1 PCI-e cards are doing around 68MiB/s each 
for 3 of them where the x4 has no issue pumping out 100MiB/s+ without a 
problem, however keep in mind the bus is probably already taxed from the 
6 sata drives on the southbridge.

vmstat output:

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----

1 VR
  0  1    160  45220 341772 6480468    0    0 122112     0  584 2082  1  7 73 20
  0  1    160  46592 455436 6362088    0    0 113664     0  495 1968  0  4 74 21
2 VR
  1  1    160  45540 3027724 3720340    0    0 243216     0 1006 4030  0  9 74 17
  0  2    160  44988 3262220 3480648    0    0 234480     0 1008 4134  0  8 73 19
3 VR
  1  2    160  44816 6600068  50476    0    0 330248    16 1342 4126  0 12 70 18
  0  3    160  45440 6599812  50264    0    0 316032     8 1296 3878  0 12 72 17
4 VR
  0  4    160  44504 6602488  47644    0    0 495232     0 1992 6081  0 20 57 23
  1  3    160  45500 6602796  45980    0    0 483968     0 1915 6207  0 20 54 26
5 VR
  1  5    160  43932 6602972  45304    0    0 606080     0 2375 6622  0 25 56 19
  1  4    160  45412 6601852  45160    0    0 618756     0 2431 6791  0 25 53 21
6 VR
  0  6    160  45000 6602348  44512    0    0 683904     8 2746 7880  0 31 42 27
  0  6    160  45248 6602028  44460    0    0 705792     0 2754 7564  0 31 45 24
7 VR
  2  6    160  46744 6599020  44688    0    0 748204    17 3042 9084  0 34 40 26
  3  6    160  46592 6598824  44372    0    0 747520     8 2975 9047  1 33 31 36
8 VR
  2  7    160  46512 6598612  44580    0    0 761184    16 3089 9937  0 36 40 24
  2  7    160  44528 6600392  44360    0    0 759720     8 2993 9522  0 36 36 28
9 VR
  2  8    160  47152 6596824  44572    0    0 767016     0 3075 9730  1 37 39 24
  2  7    160  46576 6597728  44688    0    0 771200     0 3032 9568  0 37 40 23
10 VR
  0 10    160  45048 6598240  44428    0    0 889072     8 3599 11561  0 47 20 33
  2 10    160  45232 6598116  44772    0    0 890112     0 3495 11547  0 46 23 31
11 VR
  4  8    160  45536 6594716  44600    0    0 996352     0 3947 12134  1 62 13 25
  2  9    160  45348 6594912  44096    0    0 1009152     0 3949 11949  0 63 10 28
12 VR
  6  8    160  45092 6583136  47016    0    0 1063200     0 4187 12394  1 71  9 21
  3 11    160  47080 6578492  47588    0    0 1058412     0 4224 12547  1 72  8 20

Just about 1 gigabyte per second total aggregate read for all drives on a
965 chipset!

Justin.
