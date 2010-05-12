Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4CCQq0k162615 for <xfs@oss.sgi.com>; Wed, 12 May 2010 07:26:52 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97EDF1DED988
	for <xfs@oss.sgi.com>; Wed, 12 May 2010 05:29:03 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id pxiVvJ6WwDH7nXbD for
	<xfs@oss.sgi.com>; Wed, 12 May 2010 05:29:03 -0700 (PDT)
Date: Wed, 12 May 2010 14:29:02 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: bad primary superblock - bad magic number !!!
Message-ID: <20100512142902.47d1022a@harpe.intellique.com>
In-Reply-To: <132290.52744.qm@web112902.mail.gq1.yahoo.com>
References: <28512276.post@talk.nabble.com> <4BE82955.2080009@sandeen.net>
	<978493.86662.qm@web112902.mail.gq1.yahoo.com>
	<20100510222211.3e73cdeb@galadriel.home>
	<132290.52744.qm@web112902.mail.gq1.yahoo.com>
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
To: Leo Davis <leo1783@yahoo.com>
Cc: xfs@oss.sgi.com

Le Wed, 12 May 2010 02:19:16 -0700 (PDT)
Leo Davis <leo1783@yahoo.com> =E9crivait:

> havent had much success with testing the hard drives, tried mhdd &
> seatools with no luck yet.

What do you mean? Does the tools report any problem with the drives?

> So is I do a - dd if=3D/dev/random of=3Ddev/cciss/c0d2 , that should fail
> and therby confirm that the drive or array has issues...do i make any
> sense here?

Uh, you should try the other way around to avoid breaking the
filesystem :

dd if=3D/dev/cciss/c0d2 of=3D/dev/null bs=3D131072

If no error occurs it should be OK.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
