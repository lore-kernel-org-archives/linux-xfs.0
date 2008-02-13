Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Feb 2008 03:04:58 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1DB4rkE017101
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 03:04:56 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED2B5DFDB15
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 03:05:17 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id 9k4EBt9irePW4OVg for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 03:05:17 -0800 (PST)
Date: Wed, 13 Feb 2008 06:04:46 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file
 fs/xfs/xfs_trans.c
In-Reply-To: <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0802130604180.22567@p34.internal.lan>
References: <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-915850544-1202900686=:22567"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?ISO-8859-15?Q?Christian_R=F8snes?= <christian.rosnes@gmail.com>
Cc: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-915850544-1202900686=:22567
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 13 Feb 2008, Christian R=F8snes wrote:

> Over the past month I've been hit with two cases of "xfs_trans_cancel
> at line 1150"
> The two errors occurred on different raid sets. In both cases the
> error happened during
> rsync from a remote server to this server, and the local partition
> which reported
> the error was 99% full (as reported by df -k, see below for details).
>
> System: Dell 2850
> Mem: 4GB RAM
> OS: Debian 3 (32-bit)
> Kernel: 2.6.17.7 (custom compiled)

Just curious have you run memtest86 for a few passes and checked to make su=
re
the memory is OK?

Justin.

---1463747160-915850544-1202900686=:22567--
