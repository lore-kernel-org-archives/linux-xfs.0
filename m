Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o22HLV2I001633 for <xfs@oss.sgi.com>; Tue, 2 Mar 2010 11:21:32 -0600
Received: from SBAPEXCH05.ad.corp.expertcity.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A68FF13E9DD6
	for <xfs@oss.sgi.com>; Tue,  2 Mar 2010 09:22:57 -0800 (PST)
Received: from SBAPEXCH05.ad.corp.expertcity.com
	(sbapexch05.ad.corp.expertcity.com [216.219.126.165]) by
	cuda.sgi.com with ESMTP id zwqar3etJKsfaPkB for
	<xfs@oss.sgi.com>; Tue, 02 Mar 2010 09:22:57 -0800 (PST)
From: Jason Vagalatos <Jason.Vagalatos@citrixonline.com>
Date: Tue, 2 Mar 2010 09:22:34 -0800
Subject: Stalled xfs_repair on 100TB filesystem
Message-ID: <DD534F7C25BFA14FB18E6D603135D7EA0A11E82ECB@sbapexch05>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hello,
On Friday 2/26 I started an xfs_repair on a 100TB filesystem:

#> nohup xfs_repair -v -l /dev/logfs-sessions/logdev /dev/logfs-sessions/se=
ssions > /root/xfs_repair.out.logfs1.sjc.02262010 &

I've been monitoring the process with 'top' and tailing the output file fro=
m the redirect above.=A0 I believe the repair has "stalled".=A0 When the pr=
ocess was running 'top' showed almost all physical memory consumed and 12.6=
G of virt memory consumed by xfs_repair.=A0 It made it all the way to Phase=
 6 and has been sitting at agno =3D 14 for almost 48 hours.=A0 The memory c=
onsumption of xfs_repair has ceased but the process is still "running" and =
consuming 100% CPU:

top - 10:10:37 up 3 days, 21:06,=A0 1 user,=A0 load average: 1.20, 1.13, 1.=
09
Tasks:=A0=A0 1 total,=A0=A0 1 running,=A0=A0 0 sleeping,=A0=A0 0 stopped,=
=A0=A0 0 zombie
Cpu(s): 12.5%us,=A0 0.0%sy,=A0 0.0%ni, 87.5%id,=A0 0.0%wa,=A0 0.0%hi,=A0 0.=
0%si,=A0 0.0%st
Mem:=A0=A0 8177380k total,=A0=A0 896668k used,=A0 7280712k free,=A0=A0 2471=
00k buffers
Swap: 56525356k total,=A0=A0 173852k used, 56351504k free,=A0=A0 304588k ca=
ched

=A0 PID =A0=A0=A0USER=A0=A0 PR=A0 NI=A0 VIRT=A0 RES=A0 SHR S =A0=A0%CPU %ME=
M=A0=A0=A0 TIME+=A0 COMMAND=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0
32705 =A0root=A0=A0=A0=A0 25=A0=A0 0=A0 160m=A0 95m=A0 704 R=A0 =A0=A0100=
=A0 =A0=A0=A0=A0=A0=A01.2=A0=A0 =A0=A0=A02629:53 =A0=A0=A0xfs_repair

#> tail -f -n1000 xfs_repair.out.logfs1.sjc.02262010
........
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 98
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 99
=A0=A0=A0=A0=A0=A0=A0 - reset superblock...
Phase 6 - check inode connectivity...
=A0=A0=A0=A0=A0=A0=A0 - resetting contents of realtime bitmap and summary i=
nodes
=A0=A0=A0=A0=A0=A0=A0 - traversing filesystem ...
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 0
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 1
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 2
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 3
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 4
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 5
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 6
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 7
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 8
=A0=A0=A0=A0=A0 =A0=A0- agno =3D 9
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 10
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 11
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 12
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 13
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 14
<stopped here, fs has 99 ag's>

Is there anything I can do at this point to salvage the repair?=A0 I do not=
 want to kill the repair process based on the amount of time it takes to ru=
n.=A0 If I do kill it, is there any risk of damaging the filesystem?

Any help would be greatly appreciated.

Thank you

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
