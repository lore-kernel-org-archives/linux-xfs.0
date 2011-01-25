Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0PEMoLf024388 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 08:22:50 -0600
Received: from zixvpm02.zixvpm.davisvision.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DD1F28F0C8
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 06:25:13 -0800 (PST)
Received: from zixvpm02.zixvpm.davisvision.com
	(zixvpm02.zixvpm.davisvision.com [65.213.99.45]) by
	cuda.sgi.com with ESMTP id 4eNTuWeQmvVshGjp for
	<xfs@oss.sgi.com>; Tue, 25 Jan 2011 06:25:13 -0800 (PST)
Received: from zixvpm02.zixvpm.davisvision.com (ZixVPM [127.0.0.1])
	by Outbound.davisvision.com (Proprietary) with ESMTP id BAD065DC021
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 09:25:12 -0500 (EST)
Message-ID: <20047_1295965512_4D3EDD47_20047_8804_1_4D3EDD47.304@davisvision.com>
Date: Tue, 25 Jan 2011 09:25:11 -0500
From: Cory Coager <ccoager@davisvision.com>
MIME-Version: 1.0
Subject: Re: extremely slow write performance plaintext
References: <3205_1294953756_4D2F6D1C_3205_1943_1_4D2F6D1C.2060409@davisvision.com>	<4D30C7F3.3040105@hardwarefreak.com>	<1779_1295360207_4D35A0CF_1779_747_1_4D35A0CF.9050503@davisvision.com>	<201101250721.14716@zmi.at>
	<4D3E9C73.6090508@opencubetech.com>
In-Reply-To: <4D3E9C73.6090508@opencubetech.com>
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
To: Mathieu AVILA <mathieu.avila@opencubetech.com>
Cc: xfs@oss.sgi.com

On 01/25/2011 04:48 AM, Mathieu AVILA wrote
>> You're getting 40MB/s write speed and says that's fine? I get more
>> performance from a single SATA desktop drive. Your setup seems to suck
>> extremely somewhere.
>>
>> It already starts with your dd speed. I started it on a virtualized VM
>> on an old, overloaded server and get:
>>
>> # dd if=3D/dev/zero of=3Dtest.dd bs=3D1k count=3D1M
>> 1048576+0 Datens=E4tze ein
>> 1048576+0 Datens=E4tze aus
>> 1073741824 Bytes (1,1 GB) kopiert, 10,9992 s, 97,6 MB/s
>>
>
> I would say this is melted with cache hit, isn't it ? (although I =

> agree it depends on the server's memory dedicated to FS cache)
>
> A real cache hit on a real server would give me at least 500 MB/s =

> (actually I get something around 1 GB/s)
> When it starts to be disk-constrained, on a standard SATA disk, I get =

> from 75 MB/s to 140 MB/s depending on the position of the AG I hit.
I agree, it should be a lot faster even on the LV's that are functioning =

fine.  The disk arrays and disks are new but the rest of the hardware is =

pretty old, that might be part of the problem.  It is a ProLiant DL385 G1.



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
