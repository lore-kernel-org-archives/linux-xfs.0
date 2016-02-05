Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3C6EF7CA2
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 07:13:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A31F9AC001
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 05:13:06 -0800 (PST)
Received: from mail-yw0-f181.google.com (mail-yw0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	irh0vtBU7NJ9RtfA (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 05 Feb 2016 05:13:01 -0800 (PST)
Received: by mail-yw0-f181.google.com with SMTP id g127so50416577ywf.2
	for <xfs@oss.sgi.com>; Fri, 05 Feb 2016 05:13:01 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 5 Feb 2016 14:13:00 +0100
Message-ID: <CAAgKQi+AOZO_K9Garmz3G6C1X8TuTRxrfF1MP2HPEZ3JkdE41w@mail.gmail.com>
Subject: Question about continous blocks for inode due to 'no space left on
	device' problem
From: Michel Verbraak <info1stsetup@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3861755506251503815=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3861755506251503815==
Content-Type: multipart/alternative; boundary=001a114735544e61cc052b059cce

--001a114735544e61cc052b059cce
Content-Type: text/plain; charset=UTF-8

All,

Recently we ran into a problem where our filesystem (300GB in size)
reported 'no space left on device' (ENOSPC) but when we looked at disk
space usage and inode usage it was around 52% for disk space and 11% for
inode. (sorry do not have a save of the output of df command).

Second we looked at the xfs_info and xfs_db -c freesp for each AG. Sadly we
do not have a copy anymore of the xfs_info from that time but I do have
that of the freesp (at end of this mail).

As we did not fully understand the output of the 'xfs_db -c freesp' we
simply added another 100GB to the filesystem and our problem was solved for
now. The AG count went from 4 to 6.

For now we are looking into how can we detect (monitor) this filesystem and
see the same problem creeping up to us before it happens.
After searching online, reading a lot of mail threads and info pages it
looks like we hit the problem of not having any continuous blocks of at
least 16k to hold a new inode (
http://oss.sgi.com/pipermail/xfs/2014-September/038301.html).

Currently the xfs_info (after adding 100GB) looks like this:

meta-data=/dev/sdb               isize=256    agcount=6, agsize=19660800
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096 blocks=104857600, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=38400, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

The output of 'xfs_db -c freesp' shows a historgram. We first thought the
"from" column shows the minimal number of continous blocks. And as each
block is 4K (4096) the row with 'from 4 to 7' contains at least 4
continuous blocks with a minimal size of 4x4k=16k. So our filesystem has
enough blocks and extents which are 16k for new inodes, atleast what we
think.

- So why did we still get the ENOSPC error?
- Where can I find a better explanation of the 'xfs_db -c freesp' output?
- What is the best way to monitor/detect this problem before it happens.

Some extra info about the system and files on the system:
- Ubuntu 12.04.5 LTS
- Kernel: Linux ealxs00170 3.2.0-97-generic #137-Ubuntu SMP Thu Dec 17
18:11:47 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
- 32 million files of which about 75% is smaller than 1k. Files are
separated over different folders to keep the number of files per folder low.
- mount options: defaults,noatime,inode64,nobarrier

Regards,

Michel Verbraak.

Store 03 (root@server):~# xfs_db -c freesp /dev/sdb
   from      to extents  blocks    pct
      1       1 3282633 3282633   9.03
      2       3 3416223 8372325  23.03
      4       7 6175009 24700036  67.94

Store 03 (root@server):~# xfs_db -c "freesp -a 0" /dev/sdb
   from      to extents  blocks    pct
      1       1  813491  813491   8.95
      2       3  806828 1953270  21.50
      4       7 1579585 6318340  69.55

Store 03 (root@server):~# xfs_db -c "freesp -a 1" /dev/sdb
   from      to extents  blocks    pct
      1       1  835174  835174   9.20
      2       3  953626 2381033  26.22
      4       7 1465787 5863148  64.58

Store 03 (root@server):~# xfs_db -c "freesp -a 2" /dev/sdb
   from      to extents  blocks    pct
      1       1  819098  819098   9.05
      2       3  846158 2074235  22.93
      4       7 1538593 6154372  68.02

Store 03 (root@server):~# xfs_db -c "freesp -a 3" /dev/sdb
   from      to extents  blocks    pct
      1       1  814870  814870   8.91
      2       3  809611 1963787  21.48
      4       7 1591044 6364176  69.61

--001a114735544e61cc052b059cce
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+PGRpdj5BbGwsDQo8YnI+DQo8YnI+UmVjZW50bHkgd2UgcmFuIGludG8g
YSBwcm9ibGVtIHdoZXJlIG91ciBmaWxlc3lzdGVtICgzMDBHQiBpbiBzaXplKSANCnJlcG9ydGVk
ICYjMzk7bm8gc3BhY2UgbGVmdCBvbiBkZXZpY2UmIzM5OyAoRU5PU1BDKSBidXQgd2hlbiB3ZSBs
b29rZWQgYXQgZGlzayANCnNwYWNlIHVzYWdlIGFuZCBpbm9kZSB1c2FnZSBpdCB3YXMgYXJvdW5k
IDUyJSBmb3IgZGlzayBzcGFjZSBhbmQgMTElIGZvciANCmlub2RlLiAoc29ycnkgZG8gbm90IGhh
dmUgYSBzYXZlIG9mIHRoZSBvdXRwdXQgb2YgZGYgY29tbWFuZCkuDQo8YnI+DQo8YnI+U2Vjb25k
IHdlIGxvb2tlZCBhdCB0aGUgeGZzX2luZm8gYW5kIHhmc19kYiAtYyBmcmVlc3AgZm9yIGVhY2gg
QUcuIFNhZGx5IA0Kd2UgZG8gbm90IGhhdmUgYSBjb3B5IGFueW1vcmUgb2YgdGhlIHhmc19pbmZv
IGZyb20gdGhhdCB0aW1lIGJ1dCBJIGRvIA0KaGF2ZSB0aGF0IG9mIHRoZSBmcmVlc3AgKGF0IGVu
ZCBvZiB0aGlzIG1haWwpLg0KPGJyPg0KPGJyPkFzIHdlIGRpZCBub3QgZnVsbHkgdW5kZXJzdGFu
ZCB0aGUgb3V0cHV0IG9mIHRoZSAmIzM5O3hmc19kYiAtYyBmcmVlc3AmIzM5OyB3ZSANCnNpbXBs
eSBhZGRlZCBhbm90aGVyIDEwMEdCIHRvIHRoZSBmaWxlc3lzdGVtIGFuZCBvdXIgcHJvYmxlbSB3
YXMgc29sdmVkIA0KZm9yIG5vdy4gVGhlIEFHIGNvdW50IHdlbnQgZnJvbSA0IHRvIDYuDQo8YnI+
DQo8YnI+Rm9yIG5vdyB3ZSBhcmUgbG9va2luZyBpbnRvIGhvdyBjYW4gd2UgZGV0ZWN0IChtb25p
dG9yKSB0aGlzIGZpbGVzeXN0ZW0gDQphbmQgc2VlIHRoZSBzYW1lIHByb2JsZW0gY3JlZXBpbmcg
dXAgdG8gdXMgYmVmb3JlIGl0IGhhcHBlbnMuDQo8YnI+QWZ0ZXIgc2VhcmNoaW5nIG9ubGluZSwg
cmVhZGluZyBhIGxvdCBvZiBtYWlsIHRocmVhZHMgYW5kIGluZm8gcGFnZXMgaXQgDQpsb29rcyBs
aWtlIHdlIGhpdCB0aGUgcHJvYmxlbSBvZiBub3QgaGF2aW5nIGFueSBjb250aW51b3VzIGJsb2Nr
cyBvZiBhdCANCmxlYXN0IDE2ayB0byBob2xkIGEgbmV3IGlub2RlIA0KKDxhIGNsYXNzPSIiIGhy
ZWY9Imh0dHA6Ly9vc3Muc2dpLmNvbS9waXBlcm1haWwveGZzLzIwMTQtU2VwdGVtYmVyLzAzODMw
MS5odG1sIj5odHRwOi8vb3NzLnNnaS5jb20vcGlwZXJtYWlsL3hmcy8yMDE0LVNlcHRlbWJlci8w
MzgzMDEuaHRtbDwvYT4pLg0KPGJyPg0KPGJyPkN1cnJlbnRseSB0aGUgeGZzX2luZm8gKGFmdGVy
IGFkZGluZyAxMDBHQikgbG9va3MgbGlrZSB0aGlzOg0KPGJyPg0KPGJyPm1ldGEtZGF0YT0vZGV2
L3NkYsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaXNpemU9MjU2wqDCoMKgIGFnY291bnQ9
NiwgYWdzaXplPTE5NjYwODAwIA0KYmxrcw0KPGJyPsKgwqDCoMKgwqDCoMKgwqAgPcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNlY3Rzej01MTLCoMKgIGF0dHI9
Mg0KPGJyPmRhdGHCoMKgwqDCoCA9wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgYnNpemU9NDA5NiBibG9ja3M9MTA0ODU3NjAwLCBpbWF4cGN0PTI1DQo8YnI+wqDC
oMKgwqDCoMKgwqDCoCA9wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgc3VuaXQ9MMKgwqDCoMKgwqAgc3dpZHRoPTAgYmxrcw0KPGJyPm5hbWluZ8KgwqAgPXZlcnNp
b24gMsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJzaXplPTQwOTbCoMKgIGFzY2lpLWNpPTAN
Cjxicj5sb2fCoMKgwqDCoMKgID1pbnRlcm5hbMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
YnNpemU9NDA5NsKgwqAgYmxvY2tzPTM4NDAwLCB2ZXJzaW9uPTINCjxicj7CoMKgwqDCoMKgwqDC
oMKgID3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZWN0c3o9
NTEywqDCoCBzdW5pdD0wIGJsa3MsIGxhenktY291bnQ9MQ0KPGJyPnJlYWx0aW1lID1ub25lwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGV4dHN6PTQwOTbCoMKgIGJsb2Nrcz0w
LCBydGV4dGVudHM9MA0KPGJyPg0KPGJyPlRoZSBvdXRwdXQgb2YgJiMzOTt4ZnNfZGIgLWMgZnJl
ZXNwJiMzOTsgc2hvd3MgYSBoaXN0b3JncmFtLiBXZSBmaXJzdCB0aG91Z2h0IA0KdGhlICZxdW90
O2Zyb20mcXVvdDsgY29sdW1uIHNob3dzIHRoZSBtaW5pbWFsIG51bWJlciBvZiBjb250aW5vdXMg
YmxvY2tzLiBBbmQgYXMgDQplYWNoIGJsb2NrIGlzIDRLICg0MDk2KSB0aGUgcm93IHdpdGggJiMz
OTtmcm9tIDQgdG8gNyYjMzk7IGNvbnRhaW5zIGF0IGxlYXN0IDQgDQpjb250aW51b3VzIGJsb2Nr
cyB3aXRoIGEgbWluaW1hbCBzaXplIG9mIDR4NGs9MTZrLiBTbyBvdXIgZmlsZXN5c3RlbSBoYXMg
DQplbm91Z2ggYmxvY2tzIGFuZCBleHRlbnRzIHdoaWNoIGFyZSAxNmsgZm9yIG5ldyBpbm9kZXMs
IGF0bGVhc3Qgd2hhdCB3ZSANCnRoaW5rLg0KPGJyPg0KPGJyPi0gU28gd2h5IGRpZCB3ZSBzdGls
bCBnZXQgdGhlIEVOT1NQQyBlcnJvcj8NCjxicj4tIFdoZXJlIGNhbiBJIGZpbmQgYSBiZXR0ZXIg
ZXhwbGFuYXRpb24gb2YgdGhlICYjMzk7eGZzX2RiIC1jIGZyZWVzcCYjMzk7IG91dHB1dD8NCjxi
cj4tIFdoYXQgaXMgdGhlIGJlc3Qgd2F5IHRvIG1vbml0b3IvZGV0ZWN0IHRoaXMgcHJvYmxlbSBi
ZWZvcmUgaXQgaGFwcGVucy4NCjxicj4NCjxicj5Tb21lIGV4dHJhIGluZm8gYWJvdXQgdGhlIHN5
c3RlbSBhbmQgZmlsZXMgb24gdGhlIHN5c3RlbToNCjxicj4tIFVidW50dSAxMi4wNC41IExUUw0K
PGJyPi0gS2VybmVsOiBMaW51eCBlYWx4czAwMTcwIDMuMi4wLTk3LWdlbmVyaWMgIzEzNy1VYnVu
dHUgU01QIFRodSBEZWMgMTcgDQoxODoxMTo0NyBVVEMgMjAxNSB4ODZfNjQgeDg2XzY0IHg4Nl82
NCBHTlUvTGludXgNCjxicj4tIDMyIG1pbGxpb24gZmlsZXMgb2Ygd2hpY2ggYWJvdXQgNzUlIGlz
IHNtYWxsZXIgdGhhbiAxay4gRmlsZXMgYXJlIA0Kc2VwYXJhdGVkIG92ZXIgZGlmZmVyZW50IGZv
bGRlcnMgdG8ga2VlcCB0aGUgbnVtYmVyIG9mIGZpbGVzIHBlciBmb2xkZXIgbG93Ljxicj48L2Rp
dj4tIG1vdW50IG9wdGlvbnM6IGRlZmF1bHRzLG5vYXRpbWUsaW5vZGU2NCxub2JhcnJpZXIgPGJy
PjxkaXY+DQo8YnI+UmVnYXJkcywNCjxicj4NCjxicj5NaWNoZWwgVmVyYnJhYWsuDQo8YnI+DQo8
YnI+U3RvcmUgMDMgKHJvb3RAc2VydmVyKTp+IyB4ZnNfZGIgLWMgZnJlZXNwIC9kZXYvc2RiDQo8
YnI+wqDCoCBmcm9twqDCoMKgwqDCoCB0byBleHRlbnRzwqAgYmxvY2tzwqDCoMKgIHBjdA0KPGJy
PsKgwqDCoMKgwqAgMcKgwqDCoMKgwqDCoCAxIDMyODI2MzMgMzI4MjYzM8KgwqAgOS4wMw0KPGJy
PsKgwqDCoMKgwqAgMsKgwqDCoMKgwqDCoCAzIDM0MTYyMjMgODM3MjMyNcKgIDIzLjAzDQo8YnI+
wqDCoMKgwqDCoCA0wqDCoMKgwqDCoMKgIDcgNjE3NTAwOSAyNDcwMDAzNsKgIDY3Ljk0DQo8YnI+
DQo8YnI+U3RvcmUgMDMgKHJvb3RAc2VydmVyKTp+IyB4ZnNfZGIgLWMgJnF1b3Q7ZnJlZXNwIC1h
IDAmcXVvdDsgL2Rldi9zZGINCjxicj7CoMKgIGZyb23CoMKgwqDCoMKgIHRvIGV4dGVudHPCoCBi
bG9ja3PCoMKgwqAgcGN0DQo8YnI+wqDCoMKgwqDCoCAxwqDCoMKgwqDCoMKgIDHCoCA4MTM0OTHC
oCA4MTM0OTHCoMKgIDguOTUNCjxicj7CoMKgwqDCoMKgIDLCoMKgwqDCoMKgwqAgM8KgIDgwNjgy
OCAxOTUzMjcwwqAgMjEuNTANCjxicj7CoMKgwqDCoMKgIDTCoMKgwqDCoMKgwqAgNyAxNTc5NTg1
IDYzMTgzNDDCoCA2OS41NQ0KPGJyPg0KPGJyPlN0b3JlIDAzIChyb290QHNlcnZlcik6fiMgeGZz
X2RiIC1jICZxdW90O2ZyZWVzcCAtYSAxJnF1b3Q7IC9kZXYvc2RiDQo8YnI+wqDCoCBmcm9twqDC
oMKgwqDCoCB0byBleHRlbnRzwqAgYmxvY2tzwqDCoMKgIHBjdA0KPGJyPsKgwqDCoMKgwqAgMcKg
wqDCoMKgwqDCoCAxwqAgODM1MTc0wqAgODM1MTc0wqDCoCA5LjIwDQo8YnI+wqDCoMKgwqDCoCAy
wqDCoMKgwqDCoMKgIDPCoCA5NTM2MjYgMjM4MTAzM8KgIDI2LjIyDQo8YnI+wqDCoMKgwqDCoCA0
wqDCoMKgwqDCoMKgIDcgMTQ2NTc4NyA1ODYzMTQ4wqAgNjQuNTgNCjxicj4NCjxicj5TdG9yZSAw
MyAocm9vdEBzZXJ2ZXIpOn4jIHhmc19kYiAtYyAmcXVvdDtmcmVlc3AgLWEgMiZxdW90OyAvZGV2
L3NkYg0KPGJyPsKgwqAgZnJvbcKgwqDCoMKgwqAgdG8gZXh0ZW50c8KgIGJsb2Nrc8KgwqDCoCBw
Y3QNCjxicj7CoMKgwqDCoMKgIDHCoMKgwqDCoMKgwqAgMcKgIDgxOTA5OMKgIDgxOTA5OMKgwqAg
OS4wNQ0KPGJyPsKgwqDCoMKgwqAgMsKgwqDCoMKgwqDCoCAzwqAgODQ2MTU4IDIwNzQyMzXCoCAy
Mi45Mw0KPGJyPsKgwqDCoMKgwqAgNMKgwqDCoMKgwqDCoCA3IDE1Mzg1OTMgNjE1NDM3MsKgIDY4
LjAyDQo8YnI+DQo8YnI+U3RvcmUgMDMgKHJvb3RAc2VydmVyKTp+IyB4ZnNfZGIgLWMgJnF1b3Q7
ZnJlZXNwIC1hIDMmcXVvdDsgL2Rldi9zZGINCjxicj7CoMKgIGZyb23CoMKgwqDCoMKgIHRvIGV4
dGVudHPCoCBibG9ja3PCoMKgwqAgcGN0DQo8YnI+wqDCoMKgwqDCoCAxwqDCoMKgwqDCoMKgIDHC
oCA4MTQ4NzDCoCA4MTQ4NzDCoMKgIDguOTENCjxicj7CoMKgwqDCoMKgIDLCoMKgwqDCoMKgwqAg
M8KgIDgwOTYxMSAxOTYzNzg3wqAgMjEuNDgNCjxicj7CoMKgwqDCoMKgIDTCoMKgwqDCoMKgwqAg
NyAxNTkxMDQ0IDYzNjQxNzbCoCA2OS42MQ0KPGJyPg0KPC9kaXY+PC9kaXY+DQo=
--001a114735544e61cc052b059cce--


--===============3861755506251503815==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3861755506251503815==--
