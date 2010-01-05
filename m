Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o05KaZ1a236179 for <xfs@oss.sgi.com>; Tue, 5 Jan 2010 14:36:35 -0600
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 282F4ECF3EF
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2010 12:37:24 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id htfUZPAq9VCfeXAi for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2010 12:37:24 -0800 (PST)
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by smtp5-g21.free.fr (Postfix) with ESMTP id B6491D48084
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2010 21:37:21 +0100 (CET)
Received: from galadriel.home (pla78-1-82-235-234-79.fbx.proxad.net
	[82.235.234.79])
	by smtp5-g21.free.fr (Postfix) with ESMTP id C1BDCD480F3
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2010 21:37:18 +0100 (CET)
Date: Tue, 5 Jan 2010 21:37:14 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: NFS export broke with change from ext3 to xfs
Message-ID: <20100105213714.5b9b2a11@galadriel.home>
In-Reply-To: <20100105174332.GA14496@infradead.org>
References: <1262652500.24160.27.camel@oxygen.netxsys.com>
	<20100105174332.GA14496@infradead.org>
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
To: xfs@oss.sgi.com

Le Tue, 5 Jan 2010 12:43:32 -0500 vous =E9criviez:

> Remove the inode64 mount option or move every export to a separate
> filesystem.  The NFS code can't cope with 64 bit inode numbers when
> exporting a subtree of a filesystem.  You'd see the same issue with
> e.g. ocfs2 or gfs2.

Does the kernel architecture (32 or 64 bits) have any influence there?

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
