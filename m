Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0R8fKdV031811 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 02:41:20 -0600
Received: from pastinake.doctronic.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48B541866B7D
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 00:40:35 -0800 (PST)
Received: from pastinake.doctronic.de (pastinake.doctronic.de [217.6.226.210])
	by cuda.sgi.com with ESMTP id 7OjbO7e6v1yHXK3f for
	<xfs@oss.sgi.com>; Tue, 27 Jan 2009 00:40:35 -0800 (PST)
Received: from ZWERG.DOCTRONIC.LOCAL (zwerg.doctronic.de [192.168.4.131])
	by pastinake.doctronic.de (8.13.1/8.13.1) with ESMTP id n0R8eYZZ006900
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 09:40:34 +0100
Received: from co by ZWERG.DOCTRONIC.LOCAL with local (Exim 4.63)
	(envelope-from <oberscheid@doctronic.de>) id 1LRjUo-0004Yu-HH
	for xfs@oss.sgi.com; Tue, 27 Jan 2009 09:40:34 +0100
Date: Tue, 27 Jan 2009 09:40:34 +0100
From: Carsten Oberscheid <oberscheid@doctronic.de>
Subject: Re: Strange fragmentation in nearly empty filesystem
Message-ID: <20090127084034.GA16931@doctronic.de>
References: <20090123102130.GB8012@doctronic.de>
	<20090124003329.GE32390@disturbed>
	<20090126075724.GA1753@doctronic.de> <497E02CD.2020000@sandeen.net>
	<20090127071023.GA16511@doctronic.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090127071023.GA16511@doctronic.de>
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
To: xfs@oss.sgi.com

On Tue, Jan 27, 2009 at 08:10:23AM +0100, Carsten Oberscheid wrote:
> =

> I'll see what tests I can do and report back about the findings.

Just booted an Ubuntu live CD from October 2007 and mounted the
filesystem in question. Could not run vmware from there easily, so I
tried just a copy of the vmem file:


root@ubuntu# uname -a
Linux tangchai 2.6.27-7-generic #1 SMP Tue Nov 4 19:33:06 UTC 2008 x86_64 G=
NU/Linux

root@ubuntu# xfs_bmap -vvp foo.vmem | grep hole | wc -l
34
root@ubuntu# xfs_bmap -vvp foo.vmem | grep -v hole | wc -l
38

root@ubuntu# cp foo.vmem test

root@ubuntu# xfs_bmap -vvp test | grep hole | wc -l
27078
root@ubuntu# xfs_bmap -vvp test | grep -v hole | wc -l
27081


So a simple copy of a hardly fragmented vmem file gets very badly
fragmented. If we assume the vmem file fragmentation to be caused by
vmware writing this file inefficiently, does this mean that cp is even
worse?

For comparison, I created a new clean dummy file:


root@ubuntu# dd if=3D/dev/zero of=3Dztest bs=3D1000 count=3D500000
500000+0 records in
500000+0 records out
500000000 bytes (500 MB) copied, 6.52903 seconds, 76.6 MB/s

root@ubuntu# xfs_bmap -vvp ztest | grep hole | wc -l =

0

root@ubuntu# xfs_bmap -vvp ztest | grep -v hole | wc -l =

14

root@ubuntu# cp ztest ztest2

root@ubuntu# xfs_bmap -vvp ztest2 | grep hole | wc -l =

0

root@ubuntu# xfs_bmap -vvp ztest2 | grep -v hole | wc -l =

3


No problem here. I repeated all this after rebooting my current
kernel, with the same results. Copying the vmem file to an etx3
filesystem gives about 1,700 extents, which is also bad, but not as
bad as on the XFS disk.

While this test says nothing about the interaction of old/new kernel
and old/new VMware, for me it raises some questions about
file-specific properties affecting fragmentation which appear to be
independent of recent kernel changes. Please bear with me if I miss
something obvious, I'm just a user.

Regards


Carsten Oberscheid





-- =

carsten oberscheid                  d  o  c  t  r  o  n  i  c
email oberscheid@doctronic.de       information publishing + retrieval
phone +49 228 92 682 00             http://www.doctronic.de

doctronic GmbH & Co. KG, Bonn
Handelsregister: HRA 4685 (AG Bonn); USt-ID: DE 210 898 186
Komplement=E4rin:  doctronic Verwaltungsges. mbH, Bonn, HRB 8926 (AG Bonn)
Gesch=E4ftsf=FChrer: Holger Fl=F6rke, Ingo K=FCper, Carsten Oberscheid

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
