Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2CEEw9h080510 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 09:15:19 -0500
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3FE81C39119
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 07:14:13 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id sCmRaSVpMvk8Bn9Q for
	<xfs@oss.sgi.com>; Thu, 12 Mar 2009 07:14:13 -0700 (PDT)
Received: from shambhala.lichtvoll.home
	(DSL01.83.171.186.52.ip-pool.NEFkom.net [83.171.186.52])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id DD7C95ADB7
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 15:13:38 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: LWN article: ext4 and data loss
Date: Thu, 12 Mar 2009 15:14:11 +0100
References: <200903121239.35442@zmi.at> <49B9097C.1070003@sandeen.net>
	(sfid-20090312_151043_496061_D19DDB11)
In-Reply-To: <49B9097C.1070003@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903121514.12732.Martin@lichtvoll.de>
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
> Michael Monnerie wrote:
> > http://lwn.net/SubscriberLink/322823/e6979f02e5a73feb/
> >
> > Very good, maybe similar patches for XFS would help?
> > IANA Coder, but could be a hint.
> >
> > mfg zmi
>
> ext4 is taking its hints from XFS in this regard, not the other way
> around.  XFS dealt with this long ago.

Hmmm, I remember having had similar issues with XFS not to long ago, where =

at least some KDE configuration were lost or truncated. It seems =

applications will have to get rid of behavioral assumptions regation =

filesystem and use safe writing via fsync and whatever else for =

configuration and other important files.

I am thinking about a bug report for KDE at least.

-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
