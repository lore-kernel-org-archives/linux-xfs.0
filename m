Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2EM3cBO230552 for <xfs@oss.sgi.com>; Sat, 14 Mar 2009 17:03:59 -0500
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 758161993DD
	for <xfs@oss.sgi.com>; Sat, 14 Mar 2009 15:02:55 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id bI4CSVzKAvhfZtE3 for
	<xfs@oss.sgi.com>; Sat, 14 Mar 2009 15:02:55 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: LWN article: ext4 and data loss
Date: Sat, 14 Mar 2009 23:03:01 +0100
References: <200903121239.35442@zmi.at>
	<200903142042.51574.Martin@lichtvoll.de>
	<49BC0D38.5060106@sandeen.net>
	(sfid-20090314_215133_422517_98614840)
In-Reply-To: <49BC0D38.5060106@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903142303.01619.Martin@lichtvoll.de>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Am Samstag 14 M=E4rz 2009 schrieben Sie:
> Martin Steigerwald wrote:
> > Am Donnerstag 12 M=E4rz 2009 schrieb Eric Sandeen:
>
> ...
>
> >> Filesystems can hack around some heuristics to try to make unsafe
> >> apps safer, but in the end, it's the app's job to make sure a
> >> buffered write hits permanent storage when it matters.
> >
> > Hmmm, okay. So here is:
> >
> > http://bugs.kde.org/187172
> >
> > Feel free to add there. You'd need a bugzilla login tough.
> >
> > Ciao,
>
> Perhaps you can try this and add info if you like.
>
> There is an environment variable KDE_EXTRA_FSYNC, put in with this
> changelog:

[...]

Added this and your other post and added

export KDE_EXTRA_FSYNC=3D1

to my .zshrc. Just logged out and on and do not notice a difference in =

speed. At least no abysmal performance degradation.

Would need to switch of the machine hardly to see if it helps. Not today =

anymore tough.

-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
