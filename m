Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0PEP2bG024792 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 08:25:03 -0600
Received: from zixvpm01.zixvpm.davisvision.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C1D51057812
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 06:27:24 -0800 (PST)
Received: from zixvpm01.zixvpm.davisvision.com
	(zixvpm01.zixvpm.davisvision.com [65.213.99.44]) by
	cuda.sgi.com with ESMTP id u2GRPiNh0A0TQrEV for
	<xfs@oss.sgi.com>; Tue, 25 Jan 2011 06:27:24 -0800 (PST)
Received: from zixvpm01.zixvpm.davisvision.com (ZixVPM [127.0.0.1])
	by Outbound.davisvision.com (Proprietary) with ESMTP id B262D8CC032
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 09:27:23 -0500 (EST)
Message-ID: <12688_1295965643_4D3EDDCB_12688_316_1_4D3EDDCB.7000405@davisvision.com>
Date: Tue, 25 Jan 2011 09:27:23 -0500
From: Cory Coager <ccoager@davisvision.com>
MIME-Version: 1.0
Subject: Re: extremely slow write performance plaintext
References: <3205_1294953756_4D2F6D1C_3205_1943_1_4D2F6D1C.2060409@davisvision.com>
	<4D30C7F3.3040105@hardwarefreak.com>
	<1779_1295360207_4D35A0CF_1779_747_1_4D35A0CF.9050503@davisvision.com>
	<201101250721.14716@zmi.at>
In-Reply-To: <201101250721.14716@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On 01/25/2011 01:21 AM, Michael Monnerie wrote:
> You're getting 40MB/s write speed and says that's fine? I get more
> performance from a single SATA desktop drive. Your setup seems to suck
> extremely somewhere.
>
> It already starts with your dd speed. I started it on a virtualized VM
> on an old, overloaded server and get:
>
> # dd if=3D/dev/zero of=3Dtest.dd bs=3D1k count=3D1M
> 1048576+0 Datens=E4tze ein
> 1048576+0 Datens=E4tze aus
> 1073741824 Bytes (1,1 GB) kopiert, 10,9992 s, 97,6 MB/s
>
> This is a hardware RAID 6 with just 8x 10krpm WD SATA drives. Try to
> look into general I/O problems. Maybe you can try to boot from an actual
> linux CD with kernel>2.6.30 to see if that helps performance.
>
> Maybe one or more disks in your array are dead and the controller is
> crying for replacement?
I just checked the array configuration utility, no drives are dead.  =

Unfortunately this server is in production and I am not physical next to =

the machine so I won't be able to test with a LiveCD.



------------------------------------------------------------------------
The information contained in this communication is intended
only for the use of the recipient(s) named above. It may
contain information that is privileged or confidential, and
may be protected by State and/or Federal Regulations. If
the reader of this message is not the intended recipient,
you are hereby notified that any dissemination,
distribution, or copying of this communication, or any of
its contents, is strictly prohibited. If you have received
this communication in error, please return it to the sender
immediately and delete the original message and any copy
of it from your computer system. If you have any questions
concerning this message, please contact the sender.
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
