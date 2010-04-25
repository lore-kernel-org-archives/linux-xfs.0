Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3PL2Xb7035346 for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 16:02:34 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72ED71326E30
	for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 14:04:35 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id ysieoUHDxT9OkmJr for
	<xfs@oss.sgi.com>; Sun, 25 Apr 2010 14:04:35 -0700 (PDT)
Message-ID: <4BD4AE62.9080600@sandeen.net>
Date: Sun, 25 Apr 2010 16:04:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr question for improvement
References: <201004161043.11243@zmi.at>
	<20100417012415.GE2493@dastard>	<20100417091357.4e7ad1e0@galadriel.home>	<19412.9412.177637.116303@tree.ty.sabi.co.uk>
	<20100425150209.5167fe96@galadriel.home>
In-Reply-To: <20100425150209.5167fe96@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>, Linux XFS <xfs@oss.sgi.com>

Emmanuel Florac wrote:
> Le Sun, 25 Apr 2010 12:17:24 +0100 vous =E9criviez:
> =

>>> my test VMware server (performance dropped down to abysmal
>>> level until I set up a daily xfs_fsr cron job),  =

>> That should not be the case unless you are using very sparse
>> VM image files, in which case you get what you pay for.
>>
> =

> This is a development and test VM Ware server, so it hosts lots ( 100
> or so) of test VM with sparse image files (when you start a VM to host
> a quick test, you don't want to spend 15 minutes initializing the
> drives).

If you have the -space- then you can use space preallocation to
do this very quickly, FWIW.  xfs_io's resvsp command, or fallocate
in recent util-linux-ng, if vmware doesn't do it on its own already.

You pay some penalty for unwritten extent conversion but it'd be
better than massive fragmentation of the images.

>>> and a write-intensive video server.  =

>> That also should not be the case unless your applications write
>> strategy is wrong and you get extremely interleaved streams, in
>> which case you get what you paid for the application programmer.
> =

> The application write strategy is as simple as possible; several
> different machines unaware of every other write huge media files to a
> samba share. I don't know how it could be worse, however it could
> hardly be enhanced in any way.

If it's all large writes, you could mount -o allocsize=3D512m or so:

  allocsize=3Dsize
        Sets the buffered I/O end-of-file preallocation size when
        doing delayed allocation writeout (default size is 64KiB).
        Valid values for this option are page size (typically 4KiB)
        through to 1GiB, inclusive, in power-of-2 increments.

and that might help.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
