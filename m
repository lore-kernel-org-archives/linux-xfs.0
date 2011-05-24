Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4ODXTfE075395 for <xfs@oss.sgi.com>; Tue, 24 May 2011 08:33:29 -0500
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABBB915D823B
	for <xfs@oss.sgi.com>; Tue, 24 May 2011 06:33:27 -0700 (PDT)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	sedrbjNeuH5PjzBR for <xfs@oss.sgi.com>;
	Tue, 24 May 2011 06:33:27 -0700 (PDT)
Received: by qyk7 with SMTP id 7so1676561qyk.5
	for <xfs@oss.sgi.com>; Tue, 24 May 2011 06:33:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikNMrFzxJF4a86ZM55r3D=ThPFmOw@mail.gmail.com>
References: <BANLkTikNMrFzxJF4a86ZM55r3D=ThPFmOw@mail.gmail.com>
Date: Tue, 24 May 2011 09:33:27 -0400
Message-ID: <BANLkTin26bRHiaCxc15ZwjX__NR3QHaSFA@mail.gmail.com>
Subject: Re: XFS umount issue
From: Paul Anderson <pha@umich.edu>
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
To: Nuno Subtil <subtil@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Hi Nuno - can you elaborate on the ARM hardware?  I noticed that my
XFS on ARM was mildly unstable, but felt it wasn't XFS code, but
rather the ARM port of Linux.  My test case is a Seagate Dockstar
hacked to run Linux.

I'll see if I can update to the latest kernel and test this use case
as well - it would be interesting to see how well it works (I'd like
to run my Dockstar as a mythtv server - stability was good enough for
proof of concept, but not longer term use).

Thanks,

Paul

On Mon, May 23, 2011 at 5:39 PM, Nuno Subtil <subtil@gmail.com> wrote:
> I have an MD RAID-1 array with two SATA drives, formatted as XFS.
> Occasionally, doing an umount followed by a mount causes the mount to
> fail with errors that strongly suggest some sort of filesystem
> corruption (usually 'bad clientid' with a seemingly arbitrary ID, but
> occasionally invalid log errors as well).
>
> The one thing in common among all these failures is that they require
> xfs_repair -L to recover from. This has already caused a few
> lost+found entries (and data loss on recently written files). I
> originally noticed this bug because of mount failures at boot, but
> I've managed to repro it reliably with this script:
>
> while true; do
> =A0 =A0 =A0 =A0mount /store
> =A0 =A0 =A0 =A0(cd /store && tar xf test.tar)
> =A0 =A0 =A0 =A0umount /store
> =A0 =A0 =A0 =A0mount /store
> =A0 =A0 =A0 =A0rm -rf /store/test-data
> =A0 =A0 =A0 =A0umount /store
> done
>
> test.tar contains around 100 files with various sizes inside
> test-data/, ranging from a few hundred KB to around 5-6MB. The failure
> triggers within minutes of starting this loop.
>
> I'm not entirely sure that this is XFS-specific, but the same script
> does run successfully overnight on the same MD array with ext3 on it.
> This is on an ARM system running kernel 2.6.39.
>
> Has something like this been seen before?
>
> Thanks,
> Nuno
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
