Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB7Hwsbe194335 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 11:58:54 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46F841CF6C6
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 10:00:35 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id BizM1J0JydViSYtp for
	<xfs@oss.sgi.com>; Tue, 07 Dec 2010 10:00:35 -0800 (PST)
Date: Tue, 7 Dec 2010 19:00:38 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: kernel panic-xfs errors
Message-ID: <20101207190038.61e9dbb7@harpe.intellique.com>
In-Reply-To: <30398448.post@talk.nabble.com>
References: <30397503.post@talk.nabble.com>
	<20101207165917.0c96dd95@harpe.intellique.com>
	<30398448.post@talk.nabble.com>
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

Le Tue, 7 Dec 2010 09:20:17 -0800 (PST)
blacknred <leo1783@hotmail.co.uk> =E9crivait:

>  [<f894585c>] do_cciss_request+0x397/0x3a3 [cciss]
> looks like the controller was wedged there?
> =


Yes, apparently your controller wrote garbage at the beginning of the
filesystem... you have lots of trouble with these controllers, has
anything special happened? that's weird.

You should try using a newer xfs_repair (> 3.x), for instance by booting
from an Ubuntu 10.10 live CD, and see if it fares any better from there.

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
