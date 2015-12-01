Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 821167F37
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 02:30:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 53A0C8F8033
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 00:30:05 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id kGm1YBNbsldhWMeW for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2015 00:30:02 -0800 (PST)
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: Which xfsprogs version to which kernel version
Date: Tue, 01 Dec 2015 09:30:00 +0100
Message-ID: <2952345.NUOFtjxqgC@merkaba>
In-Reply-To: <20151130214104.GL26718@dastard>
References: <5656DD39.8060403@poczta.onet.pl> <20151130214104.GL26718@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>

Am Dienstag, 1. Dezember 2015, 08:41:04 CET schrieb Dave Chinner:
> On Thu, Nov 26, 2015 at 11:21:45AM +0100, aluno3@poczta.onet.pl wrote:
> > Hello,
> > =

> > I am using kernel 3.10 and would like to update xfsprogs (currently I
> > have 3.1.5).
> > =

> > When I tried to use the newest version of xfsprogs 4.3.0 I get the call
> > trace about detected version 5 of superblock when mounting volume which
> > was formatted using mkfs.xfs from 4.3.0.
> =

> More recent xfsprogs versions enable features that are only
> supported by recent kernels. We tend to wait at least a year before
> enabling new features by default in xfsprogs so that kernel support
> is usually picke dup by distros before they update xfsprogs....
> =

> If you have an old kernel, then you need to turn off the newer
> features that your kernel does not support. This has always been the
> case - if you update the xfsprogs yourself, then you need to use the
> correct options for your kernel. In general, this:
> =

> # mkfs.xfs -f -m crc=3D0 -n ftype=3D0 <dev>
> =

> will make a filesystem that can be mounted on old kernels. If
> distros are shipping old kernels with new xfsprogs and are not
> changing the default behaviour to suit their kernel, then that is a
> distro problem.

How about just checking running kernel version before enabling this by =

default? Of course this doesn=B4t cover the case where one does mkfs.xfs fr=
om a =

newer live distro and wants to mount with an older installed distro then. I=
t =

also makes sense to make it possible to override the default choice as it i=
s =

implemented right now.

Alternatively it would be an option to display a warning if by default a =

feature is enabled that is not supported by the running kernel.

While this is some implementation effort, it may help to reduce questions o=
n =

this mailing list. And as you see distro problem or not: People still ask =

here. :)

> As it is, in future the version of xfsprogs will tell you what
> kernel has the same feature support. i.e. xfsprogs 4.2.0 has exactly
> the same code/feature support as kernel 4.2.0. Similarly for
> xfsprogs/kernel 4.3.0. However, this won't prevent the fact that
> xfsprogs 4.8.0 might enable features that kernel 4.3.0 does not know
> about - the only way to prevent that sort of problem is to never
> enable new features in mkfs.xfs, and that's not a viable solution.

Nice to know. That is how btrfs-tools is versioned as well meanwhile.

Thanks,
-- =

Martin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
