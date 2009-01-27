Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0REeBO8051555 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 08:40:12 -0600
Received: from pastinake.doctronic.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C6C4BDBE1
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 06:39:28 -0800 (PST)
Received: from pastinake.doctronic.de (pastinake.doctronic.de [217.6.226.210])
	by cuda.sgi.com with ESMTP id hifTK671dSdwskMR for
	<xfs@oss.sgi.com>; Tue, 27 Jan 2009 06:39:28 -0800 (PST)
Received: from ZWERG.DOCTRONIC.LOCAL (zwerg.doctronic.de [192.168.4.131])
	by pastinake.doctronic.de (8.13.1/8.13.1) with ESMTP id n0REdQqk021126
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 15:39:27 +0100
Received: from co by ZWERG.DOCTRONIC.LOCAL with local (Exim 4.63)
	(envelope-from <oberscheid@doctronic.de>) id 1LRp66-0005bp-SK
	for xfs@oss.sgi.com; Tue, 27 Jan 2009 15:39:26 +0100
Date: Tue, 27 Jan 2009 15:39:26 +0100
From: Carsten Oberscheid <oberscheid@doctronic.de>
Subject: Re: Strange fragmentation in nearly empty filesystem
Message-ID: <20090127143926.GQ16931@doctronic.de>
References: <20090123102130.GB8012@doctronic.de>
	<20090127071023.GA16511@doctronic.de>
	<20090127084034.GA16931@doctronic.de> <200901271030.43234@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200901271030.43234@zmi.at>
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

On Tue, Jan 27, 2009 at 10:30:38AM +0100, Michael Monnerie wrote:
> What if you dd if=3Dfoo.vmem of=3Dtest bs=3D1000 ? That would do nearly t=
he =

> same as your "create empty file" test.

[co@tangchai]~/vmware/foo dd if=3Dfoo.vmem of=3Dtest_dd bs=3D1000
536870+1 Datens=E4tze ein
536870+1 Datens=E4tze aus
536870912 Bytes (537 MB) kopiert, 3,76026 s, 143 MB/s

[co@tangchai]~/vmware/foo xfs_bmap -vvp test_dd | grep hole | wc -l0

[co@tangchai]~/vmware/foo xfs_bmap -vvp test_dd | grep -v hole | wc -l =

10


Looks good. Seems like I'm ready to accept that XFS is innocent. See
other post.

Thank you & best regards


Carsten Oberscheid

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
