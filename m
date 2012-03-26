Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QJoCCd077389 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 14:50:12 -0500
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 7Nq7UK5SoOkGUUkp for
	<xfs@oss.sgi.com>; Mon, 26 Mar 2012 12:50:11 -0700 (PDT)
Received: from merkaba.localnet (ppp-93-104-132-184.dynamic.mnet-online.de
	[93.104.132.184])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 76354193
	for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 21:50:10 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Mon, 26 Mar 2012 21:50:09 +0200
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
	<20324.44842.473837.511238@tree.ty.sabi.co.UK>
	(sfid-20120317_170615_344209_38609A88)
In-Reply-To: <20324.44842.473837.511238@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Message-Id: <201203262150.09969.Martin@lichtvoll.de>
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

Am Samstag, 17. M=E4rz 2012 schrieb Peter Grandi:
> > I'd like to read about the NFS blog entry but the link you
> > included results in a 404.  I forgot to mention in my last
> > reply.
> =

> Oops I forgot a bit of the URL:
>   http://www.sabi.co.uk/blog/0707jul.html#070701b
> =

> Note that currently I suggest different values from:
> =

>  =ABvm/dirty_ratio                  =3D4
>   vm/dirty_background_ratio       =3D2=BB

Consider dirty_background_bytes as thats indepentend of the amount of =

installed memory.

Ciao,
-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
