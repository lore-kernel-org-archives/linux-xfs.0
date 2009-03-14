Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2EJgdEd224063 for <xfs@oss.sgi.com>; Sat, 14 Mar 2009 14:42:59 -0500
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1939F1C42253
	for <xfs@oss.sgi.com>; Sat, 14 Mar 2009 12:42:14 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id Hao09N3SbH6jC9FT for
	<xfs@oss.sgi.com>; Sat, 14 Mar 2009 12:42:14 -0700 (PDT)
Received: from shambhala.lichtvoll.home
	(DSL01.212.114.239.210.ip-pool.NEFkom.net [212.114.239.210])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 9D2775AD2F
	for <xfs@oss.sgi.com>; Sat, 14 Mar 2009 20:42:12 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: LWN article: ext4 and data loss
Date: Sat, 14 Mar 2009 20:42:51 +0100
References: <200903121239.35442@zmi.at>
	<200903121514.12732.Martin@lichtvoll.de>
	<49B92423.4020708@sandeen.net>
	(sfid-20090312_171308_416656_6FF6859A)
In-Reply-To: <49B92423.4020708@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903142042.51574.Martin@lichtvoll.de>
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

Am Donnerstag 12 M=E4rz 2009 schrieb Eric Sandeen:
> Martin Steigerwald wrote:
> > Am Donnerstag 12 M=E4rz 2009 schrieb Eric Sandeen:
> >> Michael Monnerie wrote:
> >>> http://lwn.net/SubscriberLink/322823/e6979f02e5a73feb/
> >>>
> >>> Very good, maybe similar patches for XFS would help?
> >>> IANA Coder, but could be a hint.
> >>>
> >>> mfg zmi
> >>
> >> ext4 is taking its hints from XFS in this regard, not the other way
> >> around.  XFS dealt with this long ago.
> >
> > Hmmm, I remember having had similar issues with XFS not to long ago,
> > where
>
> depends on what you mean by not too long ago, I think.  Yes, kde had
> this issue on xfs too, and xfs gave up on teaching apps to fsync, and
> implemented the same sorts of things ext4 has done (or will do) to
> mitigate this quite some time ago.

Well 2.6.28 and 2.6.27.7. See

http://oss.sgi.com/archives/xfs/2008-12/msg00540.html

> > at least some KDE configuration were lost or truncated. It seems
> > applications will have to get rid of behavioral assumptions regation
> > filesystem and use safe writing via fsync and whatever else for
> > configuration and other important files.
>
> It's simple.  Want your data safe on disk?  fsync.  There's not a lot
> more to it than that.  (and if fsync hurts perf too much, re-think how
> you are storing your data)
>
> Filesystems can hack around some heuristics to try to make unsafe apps
> safer, but in the end, it's the app's job to make sure a buffered write
> hits permanent storage when it matters.

Hmmm, okay. So here is:

http://bugs.kde.org/187172

Feel free to add there. You'd need a bugzilla login tough.

Ciao,
-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
