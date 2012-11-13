Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qADFJ8W5099873 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 09:19:08 -0600
Received: from two.mjh.name (two.mjh.name [78.47.207.35]) by cuda.sgi.com with
	ESMTP id xBvSEtlYM7XiH5gy (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Nov 2012 07:21:10 -0800 (PST)
Date: Tue, 13 Nov 2012 16:23:56 +0100
From: Milan =?ISO-8859-1?Q?Holz=E4pfel?= <listen@mjh.name>
Subject: Re: Enabling quota on XFS filesystem with many files hangs
Message-Id: <20121113162356.a0b9290312b1a5ab527b8078@mjh.name>
In-Reply-To: <20121028215713.GM29378@dastard>
References: <20121026191540.ca9ee64db2a51e7166b7fadc@mjh.name>
	<508ADE1C.40208@sandeen.net>
	<20121028132050.c8d143729cd565307fcee279@mjh.name>
	<20121028215713.GM29378@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 29 Oct 2012 08:57:13 +1100
Dave Chinner <david@fromorbit.com> wrote:

> On Sun, Oct 28, 2012 at 01:20:50PM +0100, Milan Holz=E4pfel wrote:
> > On Fri, 26 Oct 2012 14:01:48 -0500
> > Eric Sandeen <sandeen@sandeen.net> wrote:
> > =

> > > On 10/26/12 12:15 PM, Milan Holz=E4pfel wrote:
> > > > Hello all, =

> > > > =

> > > > I have an XFS filesystem of size 1.2 TiB with 101 GiB free space an=
d 14
> > > > million inodes in use. =

> > =

> > Meanwhile, I deleted 200 GiB of data on that filesystem, with 9.9
> > million inodes still in use. Now, quotacheck just works. =

> =

> IOWs, the problem is load related.

I'm not quite sure what you mean by "load". During the quotacheck, the
quotacheck was almost the sole source of I/O. I only started programs
like "top", "iotop", "smartctl -a" or "hddtemp" during the quotacheck. =


> And slow SATA drives will not improve the situation, either.  The
> software RAID with small random writes that quotacheck does will
> cause lots of RMW cycles and hence be very slow. This, alone, can
> trigger hung task warnings. When you add encryption to the stack,
> the storage stack will be even slower.
> =

> If you can reproduce it, I'd be really interested to know what the
> sysrq-w output shows, as it will probably indicate a dm-crypt or md
> thread hung waiting for something else to occur....

I tried to reproduce it, but didn't succeed. I moved a copy of the
original 200 GiB of data on the filesystem, I created lot's of new,
small files until the FS had 17 M used inodes and 84 GiB free space,
but quotacheck finished normally. =


I really don't understand why it has disappeared: As far as I remember,
I made two attempts to run quotacheck before removing the 200 GiB, and
it hung both times.  Nothing in the system setup has changed. =

Anyway, the problem doesn't seem to exist anymore. =


Thanks for your interest. =


Regards,
Milan Holz=E4pfel


-- =

Milan Holz=E4pfel <listen@mjh.name>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
