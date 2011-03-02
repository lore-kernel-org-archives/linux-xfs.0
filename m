Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p22I8ZaN036886
	for <linux-xfs@oss.sgi.com>; Wed, 2 Mar 2011 12:08:35 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57AA9157C20C
	for <linux-xfs@oss.sgi.com>; Wed,  2 Mar 2011 10:11:22 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id bKotgP4Ly6OZyotf for
	<linux-xfs@oss.sgi.com>; Wed, 02 Mar 2011 10:11:22 -0800 (PST)
Date: Wed, 2 Mar 2011 19:11:25 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs 14TB - check
Message-ID: <20110302191125.15cd6937@harpe.intellique.com>
In-Reply-To: <31051172.post@talk.nabble.com>
References: <31051172.post@talk.nabble.com>
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
To: tramper <michael.weingartner@tuwien.ac.at>
Cc: linux-xfs@oss.sgi.com

Le Wed, 2 Mar 2011 08:57:40 -0800 (PST)
tramper <michael.weingartner@tuwien.ac.at> =E9crivait:

> i used xfs_repair /dev/cciss/c0...p1 and got the following error
> message:
> =

> fatal error -- couldn't allocate block map, size XXXXXXX
> =

> I have 2 GB of Ram in the machine.
> =

> What should I do and how to check my volume?

You probably haven't got enough RAM. With an old version of xfs_progs,
you need 6 to 8 GB of RAM to check a 14 TB volume. =


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
