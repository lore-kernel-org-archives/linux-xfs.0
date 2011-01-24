Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0OLstKt121655 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 15:54:56 -0600
Received: from mail-out.m-online.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 762F528CE07
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 13:57:16 -0800 (PST)
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9]) by
	cuda.sgi.com with ESMTP id FL2zDxFDlZFUKwlD for
	<xfs@oss.sgi.com>; Mon, 24 Jan 2011 13:57:16 -0800 (PST)
From: Wolfgang Denk <wd@denx.de>
Subject: Re: Optimize RAID0 for max IOPS?
MIME-Version: 1.0
In-reply-to: <alpine.DEB.2.00.1101241024230.14640@p34.internal.lan>
References: <20110118210112.D13A236C@gemini.denx.de>
	<4D361F26.3060507@stud.tu-ilmenau.de>
	<20110119192104.1FA92D30267@gemini.denx.de>
	<AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com>
	<alpine.DEB.2.00.1101241024230.14640@p34.internal.lan>
Date: Mon, 24 Jan 2011 22:57:13 +0100
Message-Id: <20110124215713.82D75B187@gemini.denx.de>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com

Dear Justin,

In message <alpine.DEB.2.00.1101241024230.14640@p34.internal.lan> you wrote:
> 
> Some info on XFS benchmark with delaylog here:
> http://comments.gmane.org/gmane.comp.file-systems.xfs.general/34379

For the record: I tested both the "delaylog" and "logbsize=262144" on
two systems running Fedora 14 x86_64 (kernel version
2.6.35.10-74.fc14.x86_64).


Test No.	Mount options
1		rw,noatime
2		rw,noatime,delaylog
3		rw,noatime,delaylog,logbsize=262144


System A: Gigabyte EP35C-DS3R Mainbord, Core 2 Quad CPU Q9550 @ 2.83GHz, 4 GB RAM
--------- software RAID 5 using 4 x old Maxtor 7Y250M0 S-ATA I disks
	  (chunk size 16 kB, using S-ATA ports on main board), XFS

Test 1:

Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
A1               8G   844  96 153107  19 56427  11  2006  98 127174  15 369.4   6
Latency             13686us    1480ms    1128ms   14986us     136ms   74911us
Version  1.96       ------Sequential Create------ --------Random Create--------
A1                  -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16   104   0 +++++ +++   115   0    89   0 +++++ +++   111   0
Latency               326ms     171us     277ms     343ms       9us     360ms
1.96,1.96,A1,1,1295714835,8G,,844,96,153107,19,56427,11,2006,98,127174,15,369.4,6,16,,,,,104,0,+++++,+++,115,0,89,0,+++++,+++,111,0,13686us,1480ms,1128ms,14986us,136ms,74911us,326ms,171us,277ms,343ms,9us,360ms

Test 2:

Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
A2               8G   417  46 67526   8 28251   5  1338  63 53780   5 236.0   4
Latency             38626us    1859ms     508ms   26689us     258ms     188ms
Version  1.96       ------Sequential Create------ --------Random Create--------
A2                  -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16    51   0 +++++ +++   128   0   102   0 +++++ +++   125   0
Latency              1526ms     169us     277ms     363ms       8us     324ms
1.96,1.96,A2,1,1295901138,8G,,417,46,67526,8,28251,5,1338,63,53780,5,236.0,4,16,,,,,51,0,+++++,+++,128,0,102,0,+++++,+++,125,0,38626us,1859ms,508ms,26689us,258ms,188ms,1526ms,169us,277ms,363ms,8us,324ms

Test 3:

Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
A3               8G   417  46 67526   8 28251   5  1338  63 53780   5 236.0   4
Latency             38626us    1859ms     508ms   26689us     258ms     188ms
Version  1.96       ------Sequential Create------ --------Random Create--------
A3                  -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16    51   0 +++++ +++   128   0   102   0 +++++ +++   125   0
Latency              1526ms     169us     277ms     363ms       8us     324ms
1.96,1.96,A3,1,1295901138,8G,,417,46,67526,8,28251,5,1338,63,53780,5,236.0,4,16,,,,,51,0,+++++,+++,128,0,102,0,+++++,+++,125,0,38626us,1859ms,508ms,26689us,258ms,188ms,1526ms,169us,277ms,363ms,8us,324ms

System B: Supermicro H8DM8-2 Mainbord, Dual-Core AMD Opteron 2216 @ 2.4 GHz, 8 GB RAM
          software RAID 6 using 6 x Seagate ST31000524NS S-ATA II disks
          (chunk size 16 kB, using a Marvell MV88SX6081 8-port SATA II PCI-X Controller)
          XFS

Test 1:

Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
B1              16G   403  98 198720  66 53287  49  1013  99 228076  91 545.0  31
Latency             43022us     127ms     126ms   29328us     105ms   66395us
Version  1.96       ------Sequential Create------ --------Random Create--------
B1                  -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16    97   1 +++++ +++    96   1    96   1 +++++ +++    95   1
Latency               326ms     349us     351ms     355ms      49us     363ms
1.96,1.96,B1,1,1295784794,16G,,403,98,198720,66,53287,49,1013,99,228076,91,545.0,31,16,,,,,97,1,+++++,+++,96,1,96,1,+++++,+++,95,1,43022us,127ms,126ms,29328us,105ms,66395us,326ms,349us,351ms,355ms,49us,363ms

Test 2:

Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
B2              16G   380  98 197319  68 54835  48   983  99 216812  89 527.8  31
Latency             47456us     227ms     280ms   24696us   38233us   80147us
Version  1.96       ------Sequential Create------ --------Random Create--------
B2                  -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16    91   1 +++++ +++   115   1    73   1 +++++ +++    96   1
Latency               355ms    2274us     833ms     750ms    1079us     400ms
1.96,1.96,B2,1,1295884032,16G,,380,98,197319,68,54835,48,983,99,216812,89,527.8,31,16,,,,,91,1,+++++,+++,115,1,73,1,+++++,+++,96,1,47456us,227ms,280ms,24696us,38233us,80147us,355ms,2274us,833ms,750ms,1079us,400ms

Test 3:

Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
B3              16G   402  99 175802  64 55639  48  1006  99 232748  87 543.7  32
Latency             43160us     426ms     164ms   13306us   40857us   65114us
Version  1.96       ------Sequential Create------ --------Random Create--------
B3                  -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16    93   1 +++++ +++   101   1    95   1 +++++ +++    95   1
Latency               479ms    2281us     383ms     366ms      22us     402ms
1.96,1.96,B3,1,1295880202,16G,,402,99,175802,64,55639,48,1006,99,232748,87,543.7,32,16,,,,,93,1,+++++,+++,101,1,95,1,+++++,+++,95,1,43160us,426ms,164ms,13306us,40857us,65114us,479ms,2281us,383ms,366ms,22us,402ms


I do not see any significant improvement in any of the parameters -
especially when compared to the serious performance degradation (down
to 44% for block write, 42% for block read) on system A.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
A supercomputer is a machine that runs an endless loop in 2 seconds.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
