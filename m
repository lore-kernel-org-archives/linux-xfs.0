Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ODIFsi183484 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 08:18:15 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E569E54E19
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 06:31:47 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id u87S9BptuHwJDOwc for
	<xfs@oss.sgi.com>; Fri, 24 Sep 2010 06:31:47 -0700 (PDT)
Date: Fri, 24 Sep 2010 15:19:08 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS errors on large Infiniband fileserver setup
Message-ID: <20100924151908.314cf3b4@harpe.intellique.com>
In-Reply-To: <20100923235355.GO2614@dastard>
References: <29252416bd0d9dc973a909e411dbec6a@phys.ethz.ch>
	<20100923235355.GO2614@dastard>
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
Cc: Christian Herzog <horeizo@phys.ethz.ch>, isg@phys.ethz.ch, xfs@oss.sgi.com

Le Fri, 24 Sep 2010 09:53:55 +1000
Dave Chinner <david@fromorbit.com> =E9crivait:

> IMO, it is unneccessarily complex - you could easily do this (~30
> drives) with a single server with a couple of external SAS JBOD
> arrays and SAS RAID controllers. That would give you the same
> performance (or better), with many fewer points of failure (both
> hardware and software), use less rack space, and probably be
> significantly cheaper....

And it will use less power, too. Actually there are Supermicro chassis
with up to 40 drives in 4U, so you don't even need an external disk
enclosure.

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
