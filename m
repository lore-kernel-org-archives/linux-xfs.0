Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBBCjv3O041225 for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 06:45:58 -0600
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36ECE2B3497
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 04:45:55 -0800 (PST)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	zfWYnTb1DQqgb1CH for <xfs@oss.sgi.com>;
	Sun, 11 Dec 2011 04:45:55 -0800 (PST)
Received: by iaoo28 with SMTP id o28so7167405iao.26
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 04:45:55 -0800 (PST)
MIME-Version: 1.0
From: Xupeng Yun <xupeng@xupeng.me>
Date: Sun, 11 Dec 2011 20:45:14 +0800
Message-ID: <CACaf2aYZ=k=x8sPFJs4f-4vQxs+qNyoO1EUi8X=iBjWjRhy99Q@mail.gmail.com>
Subject: Bad performance with XFS + 2.6.38 / 2.6.39
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6456868705746311341=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: XFS group <xfs@oss.sgi.com>

--===============6456868705746311341==
Content-Type: multipart/alternative; boundary=14dae934110126ed0a04b3d0667d

--14dae934110126ed0a04b3d0667d
Content-Type: text/plain; charset=UTF-8

Hi,

I am using XFS + 2.6.29 on my MySQL servers, they perform great.

I am testing XFS on SSD these days, due to the fact that FITRIM support of
XFS was
shipped with Linux kernel 2.6.38 or newer, I tested XFS + 2.6.38 and XFS +
2.6.39, but
it surprises me that the performance of XFS with these two versions of
kernel drops so
much.

Here are the results of my tests with fio, all these two tests were taken
on the same hardware
with same testing environment (except for different kernel version).

====== XFS + 2.6.29 ======

# mount | grep /mnt/xfs
/dev/sdc1 on /mnt/xfs type xfs (rw,noatime,nodiratime,nobarrier,logbufs=8)
# fio --filename=/mnt/xfs/test --direct=1 --rw=randrw --bs=16k --size=50G
--numjobs=16 --runtime=120 --group_reporting --name=test --rwmixread=90
--thread --ioengine=psync
test: (g=0): rw=randrw, bs=16K-16K/16K-16K, ioengine=psync, iodepth=1
...
test: (g=0): rw=randrw, bs=16K-16K/16K-16K, ioengine=psync, iodepth=1
fio 1.58
Starting 16 threads
test: Laying out IO file(s) (1 file(s) / 51200MB)
Jobs: 16 (f=16): [mmmmmmmmmmmmmmmm] [100.0% done] [181.5M/21118K /s]
[11.4K/1289 iops] [eta 00m:00s]
test: (groupid=0, jobs=16): err= 0: pid=8446
read : io=21312MB, bw=181862KB/s, iops=11366 , runt=120001msec
clat (usec): min=80 , max=146337 , avg=1369.72, stdev=1026.26
lat (usec): min=81 , max=146338 , avg=1370.87, stdev=1026.27
bw (KB/s) : min= 6998, max=13600, per=6.26%, avg=11376.13, stdev=499.42
write: io=2369.4MB, bw=20218KB/s, iops=1263 , runt=120001msec
clat (usec): min=67 , max=145760 , avg=268.28, stdev=894.06
lat (usec): min=67 , max=145761 , avg=269.46, stdev=894.09
bw (KB/s) : min= 509, max= 2166, per=6.26%, avg=1265.42, stdev=213.82
cpu : usr=11.09%, sys=44.83%, ctx=26015341, majf=0, minf=8396
IO depths : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
issued r/w/d: total=1363980/151635/0, short=0/0/0
lat (usec): 100=0.11%, 250=5.85%, 500=3.79%, 750=0.32%, 1000=5.51%
lat (msec): 2=80.06%, 4=1.26%, 10=3.07%, 20=0.01%, 50=0.01%
lat (msec): 100=0.01%, 250=0.01%

Run status group 0 (all jobs):
READ: io=21312MB, aggrb=181862KB/s, minb=186227KB/s, maxb=186227KB/s,
mint=120001msec, maxt=120001msec
WRITE: io=2369.4MB, aggrb=20217KB/s, minb=20703KB/s, maxb=20703KB/s,
mint=120001msec, maxt=120001msec

Disk stats (read/write):
sdc: ios=1361926/151423, merge=0/0, ticks=1793432/27812, in_queue=1820240,
util=99.99%




====== XFS + 2.6.39 ======

# mount | grep /mnt/xfs
/dev/sdc1 on /mnt/xfs type xfs (rw,noatime,nodiratime,nobarrier,logbufs=8)
# fio --filename=/mnt/xfs/test --direct=1 --rw=randrw --bs=16k --size=50G
--numjobs=16 --runtime=120 --group_reporting --name=test --rwmixread=90
--thread --ioengine=psync
test: (g=0): rw=randrw, bs=16K-16K/16K-16K, ioengine=psync, iodepth=1
...
test: (g=0): rw=randrw, bs=16K-16K/16K-16K, ioengine=psync, iodepth=1
fio 1.58
Starting 16 threads
test: Laying out IO file(s) (1 file(s) / 51200MB)
Jobs: 16 (f=16): [mmmmmmmmmmmmmmmm] [100.0% done] [58416K/6680K /s] [3565
/407 iops] [eta 00m:00s]
test: (groupid=0, jobs=16): err= 0: pid=26902
read : io=6507.1MB, bw=55533KB/s, iops=3470 , runt=120004msec
clat (usec): min=155 , max=356038 , avg=4562.52, stdev=4748.18
lat (usec): min=156 , max=356038 , avg=4562.69, stdev=4748.19
bw (KB/s) : min= 1309, max= 4864, per=6.26%, avg=3479.03, stdev=441.47
write: io=741760KB, bw=6181.2KB/s, iops=386 , runt=120004msec
clat (usec): min=71 , max=348236 , avg=390.11, stdev=3106.30
lat (usec): min=71 , max=348236 , avg=390.31, stdev=3106.30
bw (KB/s) : min= 28, max= 921, per=6.29%, avg=389.02, stdev=114.68
cpu : usr=3.43%, sys=11.12%, ctx=21598477, majf=0, minf=7762
IO depths : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
issued r/w/d: total=416508/46360/0, short=0/0/0
lat (usec): 100=2.65%, 250=0.98%, 500=6.58%, 750=31.88%, 1000=0.27%
lat (msec): 2=0.08%, 4=0.23%, 10=55.04%, 20=1.76%, 50=0.49%
lat (msec): 100=0.02%, 250=0.01%, 500=0.01%

Run status group 0 (all jobs):
READ: io=6507.1MB, aggrb=55532KB/s, minb=56865KB/s, maxb=56865KB/s,
mint=120004msec, maxt=120004msec
WRITE: io=741760KB, aggrb=6181KB/s, minb=6329KB/s, maxb=6329KB/s,
mint=120004msec, maxt=120004msec

Disk stats (read/write):
sdc: ios=416285/46351, merge=0/1, ticks=108136/8768, in_queue=116368,
util=93.60%


as the tests result shows, the IOPS of XFS + 2.6.29 is about 12600, but it
drops to about 3900
with XFS + 2.6.39.

I tried different XFS format options and different mount options, but
it did not help.

Any thought?

--
Xupeng Yun
http://about.me/xupeng

--14dae934110126ed0a04b3d0667d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>I am using XFS + 2.6.29 on my MySQL servers, they perform great.=
=C2=A0<br><br>I am testing XFS on SSD these days, due to the fact that FITR=
IM support of XFS was=C2=A0<br>shipped with Linux kernel 2.6.38 or newer, I=
 tested XFS + 2.6.38 and XFS + 2.6.39, but<br>

it surprises me that the performance of XFS with these two versions of kern=
el=C2=A0drops so<br>much.<br><br>Here are the results of my tests with fio,=
 all these two tests were taken on the same hardware<div>with same testing =
environment (except for different kernel version).<br>

<br>=3D=3D=3D=3D=3D=3D XFS + 2.6.29 =3D=3D=3D=3D=3D=3D<br><br># mount | gre=
p /mnt/xfs<br>/dev/sdc1 on /mnt/xfs type xfs (rw,noatime,nodiratime,nobarri=
er,logbufs=3D8)<br># fio --filename=3D/mnt/xfs/test --direct=3D1 --rw=3Dran=
drw --bs=3D16k --size=3D50G --numjobs=3D16 --runtime=3D120 --group_reportin=
g --name=3Dtest --rwmixread=3D90 --thread --ioengine=3Dpsync<br>

test: (g=3D0): rw=3Drandrw, bs=3D16K-16K/16K-16K, ioengine=3Dpsync, iodepth=
=3D1<br>...<br>test: (g=3D0): rw=3Drandrw, bs=3D16K-16K/16K-16K, ioengine=
=3Dpsync, iodepth=3D1<br>fio 1.58<br>Starting 16 threads<br>test: Laying ou=
t IO file(s) (1 file(s) / 51200MB)<br>

Jobs: 16 (f=3D16): [mmmmmmmmmmmmmmmm] [100.0% done] [181.5M/21118K /s] [11.=
4K/1289 iops] [eta 00m:00s]<br>test: (groupid=3D0, jobs=3D16): err=3D 0: pi=
d=3D8446<br>read : io=3D21312MB, bw=3D181862KB/s, iops=3D11366 , runt=3D120=
001msec<br>clat (usec): min=3D80 , max=3D146337 , avg=3D1369.72, stdev=3D10=
26.26<br>

lat (usec): min=3D81 , max=3D146338 , avg=3D1370.87, stdev=3D1026.27<br>bw =
(KB/s) : min=3D 6998, max=3D13600, per=3D6.26%, avg=3D11376.13, stdev=3D499=
.42<br>write: io=3D2369.4MB, bw=3D20218KB/s, iops=3D1263 , runt=3D120001mse=
c<br>clat (usec): min=3D67 , max=3D145760 , avg=3D268.28, stdev=3D894.06<br=
>

lat (usec): min=3D67 , max=3D145761 , avg=3D269.46, stdev=3D894.09<br>bw (K=
B/s) : min=3D 509, max=3D 2166, per=3D6.26%, avg=3D1265.42, stdev=3D213.82<=
br>cpu : usr=3D11.09%, sys=3D44.83%, ctx=3D26015341, majf=3D0, minf=3D8396<=
br>IO depths : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, &gt;=3D64=3D0.0%<br>

submit : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, &=
gt;=3D64=3D0.0%<br>complete : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%<br>issued r/w/d: total=3D1363980/15163=
5/0, short=3D0/0/0<br>lat (usec): 100=3D0.11%, 250=3D5.85%, 500=3D3.79%, 75=
0=3D0.32%, 1000=3D5.51%<br>

lat (msec): 2=3D80.06%, 4=3D1.26%, 10=3D3.07%, 20=3D0.01%, 50=3D0.01%<br>la=
t (msec): 100=3D0.01%, 250=3D0.01%<br><br>Run status group 0 (all jobs):<br=
>READ: io=3D21312MB, aggrb=3D181862KB/s, minb=3D186227KB/s, maxb=3D186227KB=
/s, mint=3D120001msec, maxt=3D120001msec<br>

WRITE: io=3D2369.4MB, aggrb=3D20217KB/s, minb=3D20703KB/s, maxb=3D20703KB/s=
, mint=3D120001msec, maxt=3D120001msec<br><br>Disk stats (read/write):<br>s=
dc: ios=3D1361926/151423, merge=3D0/0, ticks=3D1793432/27812, in_queue=3D18=
20240, util=3D99.99%<br>

<br><br><br><div><br></div><div>=3D=3D=3D=3D=3D=3D XFS + 2.6.39 =3D=3D=3D=
=3D=3D=3D</div><div><br># mount | grep /mnt/xfs<br>/dev/sdc1 on /mnt/xfs ty=
pe xfs (rw,noatime,nodiratime,nobarrier,logbufs=3D8)<br># fio --filename=3D=
/mnt/xfs/test --direct=3D1 --rw=3Drandrw --bs=3D16k --size=3D50G --numjobs=
=3D16 --runtime=3D120 --group_reporting --name=3Dtest --rwmixread=3D90 --th=
read --ioengine=3Dpsync<br>

test: (g=3D0): rw=3Drandrw, bs=3D16K-16K/16K-16K, ioengine=3Dpsync, iodepth=
=3D1<br>...<br>test: (g=3D0): rw=3Drandrw, bs=3D16K-16K/16K-16K, ioengine=
=3Dpsync, iodepth=3D1<br>fio 1.58<br>Starting 16 threads<br>test: Laying ou=
t IO file(s) (1 file(s) / 51200MB)<br>

Jobs: 16 (f=3D16): [mmmmmmmmmmmmmmmm] [100.0% done] [58416K/6680K /s] [3565=
 /407  iops] [eta 00m:00s]<br>test: (groupid=3D0, jobs=3D16): err=3D 0: pid=
=3D26902<br>  read : io=3D6507.1MB, bw=3D55533KB/s, iops=3D3470 , runt=3D12=
0004msec<br>    clat (usec): min=3D155 , max=3D356038 , avg=3D4562.52, stde=
v=3D4748.18<br>

     lat (usec): min=3D156 , max=3D356038 , avg=3D4562.69, stdev=3D4748.19<=
br>    bw (KB/s) : min=3D 1309, max=3D 4864, per=3D6.26%, avg=3D3479.03, st=
dev=3D441.47<br>  write: io=3D741760KB, bw=3D6181.2KB/s, iops=3D386 , runt=
=3D120004msec<br>    clat (usec): min=3D71 , max=3D348236 , avg=3D390.11, s=
tdev=3D3106.30<br>

     lat (usec): min=3D71 , max=3D348236 , avg=3D390.31, stdev=3D3106.30<br=
>    bw (KB/s) : min=3D   28, max=3D  921, per=3D6.29%, avg=3D389.02, stdev=
=3D114.68<br>  cpu          : usr=3D3.43%, sys=3D11.12%, ctx=3D21598477, ma=
jf=3D0, minf=3D7762<br>
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, &gt;=3D64=3D0.0%<br>
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, &gt;=3D64=3D0.0%<br>     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0=
%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%<br>     issued r/w/d: =
total=3D416508/46360/0, short=3D0/0/0<br>

     lat (usec): 100=3D2.65%, 250=3D0.98%, 500=3D6.58%, 750=3D31.88%, 1000=
=3D0.27%<br>     lat (msec): 2=3D0.08%, 4=3D0.23%, 10=3D55.04%, 20=3D1.76%,=
 50=3D0.49%<br>     lat (msec): 100=3D0.02%, 250=3D0.01%, 500=3D0.01%<br><b=
r>Run status group 0 (all jobs):<br>

   READ: io=3D6507.1MB, aggrb=3D55532KB/s, minb=3D56865KB/s, maxb=3D56865KB=
/s, mint=3D120004msec, maxt=3D120004msec<br>  WRITE: io=3D741760KB, aggrb=
=3D6181KB/s, minb=3D6329KB/s, maxb=3D6329KB/s, mint=3D120004msec, maxt=3D12=
0004msec<br><br>Disk stats (read/write):<br>

  sdc: ios=3D416285/46351, merge=3D0/1, ticks=3D108136/8768, in_queue=3D116=
368, util=3D93.60%<br><br><br></div><div>as the tests result shows, the IOP=
S of XFS + 2.6.29 is about 12600, but it drops to about 3900</div><div>with=
 XFS + 2.6.39.</div>

<div><br></div><div>I tried different XFS format options and different moun=
t options, but it=C2=A0did not help.</div><div><br></div><div>Any thought?<=
/div><div><br>--<br>Xupeng Yun<br><a href=3D"http://about.me/xupeng">http:/=
/about.me/xupeng</a></div>

</div>

--14dae934110126ed0a04b3d0667d--


--===============6456868705746311341==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6456868705746311341==--
