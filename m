Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0FCjdEk098092 for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 06:45:49 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 925791C52643
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 04:46:22 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	9Qaapm4YyvhtcuKw for <xfs@oss.sgi.com>;
	Fri, 15 Jan 2010 04:46:22 -0800 (PST)
Date: Fri, 15 Jan 2010 23:46:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: usage of xfsctrl for embedded development / uuid question
Message-ID: <20100115124617.GJ28498@discord.disaster>
References: <5340782.170001263558076439.JavaMail.www@wsfrf1111>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5340782.170001263558076439.JavaMail.www@wsfrf1111>
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
To: paul.chavent@fnac.net
Cc: xfs@oss.sgi.com

On Fri, Jan 15, 2010 at 01:21:16PM +0100, paul.chavent@fnac.net wrote:
> =

> > install-dev=A0is=A0dependent=A0on=A0a=A0full=A0build=A0of=A0xfsprogs.
> =A0
> Even if i only do =

> make -C include install-dev
> =

> > Why=A0not=A0just=A0include=A0the=A0xfsprogs-dev=A0package=A0(or=A0equiv=
alent)
> > from=A0your=A0base=A0distro?
> =

> For a different architecture, i can't include my distro package.
> =

> I don't want the binaries of xfs progs, only the xfsctrl function.

It's a wrapper around ioctl(). You can call ioctl() directly
on not need xfsctl at all...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
