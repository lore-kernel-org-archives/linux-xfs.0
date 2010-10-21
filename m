Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9LH4h8r035269 for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 12:04:43 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81FAE118049
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 10:05:55 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id knImySM18oCrOecy for
	<xfs@oss.sgi.com>; Thu, 21 Oct 2010 10:05:55 -0700 (PDT)
Date: Thu, 21 Oct 2010 19:05:42 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Question/Problem: Mounting of XFS filesystem takes a lot of time
Message-ID: <20101021190542.0ede7962@galadriel.home>
In-Reply-To: <19647.34574.786118.56593@tree.ty.sabi.co.uk>
References: <1287593846.2338.5.camel@nukebox>
	<19647.34574.786118.56593@tree.ty.sabi.co.uk>
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
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux XFS <xfs@oss.sgi.com>

Le Thu, 21 Oct 2010 01:19:26 +0100 vous =E9criviez:

> Usually SATA drives are pogrammed to do a large number of firmware
> driven retries in case of data errors, hanging the IO subsystem,

This is only the case for Desktop SATA drives. More expensive
"enterprise" SATA drives (Seagate ES or ES2 series, Hitachi Ultrastar,
etc) behave like SAS drives.
Desktop SATA drives also lack the logic to manage properly vibrations
happening in large arrays, which can totally kill performance.

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
