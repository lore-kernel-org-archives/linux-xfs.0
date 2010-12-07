Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB7Fehfj172239 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 09:40:43 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F6961CEFC7
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 07:42:29 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id bukVvV3Ym26ayXRm for
	<xfs@oss.sgi.com>; Tue, 07 Dec 2010 07:42:29 -0800 (PST)
Date: Tue, 7 Dec 2010 16:42:27 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: possible xfs corruption
Message-ID: <20101207164227.152cef01@harpe.intellique.com>
In-Reply-To: <30397173.post@talk.nabble.com>
References: <30395558.post@talk.nabble.com>
	<20101207151039.25d45cb5@harpe.intellique.com>
	<30397173.post@talk.nabble.com>
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
To: blacknred <leo1783@hotmail.co.uk>
Cc: xfs@oss.sgi.com

Le Tue, 7 Dec 2010 07:11:04 -0800 (PST)
blacknred <leo1783@hotmail.co.uk> =E9crivait:

> Yes, It's a Smart Array in HP Proliant Server.
> No power failure, just upgraded the controller firmware and rebooted
> the server.....
> =


Hu oh, that stinks. Nothing in the firmware release notes? Do you have
any other filesystem on this array? =


First you could try to backup the filesystem metadata using

xfs_metadump -o -w /dev/DEVICE outfile.meta

It can be useful later in case things turn bad.
Does it output any errors? IO errors particularly ?

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
