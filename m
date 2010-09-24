Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ODIRp0183505 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 08:18:28 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E97471BAB689
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 06:19:20 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id c80lOyeJP6sq4OHL for
	<xfs@oss.sgi.com>; Fri, 24 Sep 2010 06:19:20 -0700 (PDT)
Date: Fri, 24 Sep 2010 15:19:18 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS errors on large Infiniband fileserver setup
Message-ID: <20100924151918.598148c6@harpe.intellique.com>
In-Reply-To: <2276da2491527ca8044fa1daec496b48@phys.ethz.ch>
References: <29252416bd0d9dc973a909e411dbec6a@phys.ethz.ch>
	<20100923235355.GO2614@dastard>
	<2276da2491527ca8044fa1daec496b48@phys.ethz.ch>
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
To: Christian Herzog <horeizo@phys.ethz.ch>
Cc: xfs@oss.sgi.com

Le Fri, 24 Sep 2010 07:41:53 +0200
Christian Herzog <horeizo@phys.ethz.ch> =E9crivait:

>  We start off
> with 52T and can easily add additional disk units to the Infiniband
> switch.

I don't know if using iscsi-over-infiniband is optimal. The problem is
that you plan to expand your existing XFS filesystem by leaps and
bounds up to some extremely large size, through a simple raid-0 like
aggregation, that's really fragile.

It's a configuration that's supposed to work well with something like
ZFS, though in real life setups (no I won't tell who sent back recently
all of a 2 PB cluster to Sun but that happened in 2010 :) large raid-z
iscsi clusters aren't so great :)

For similar setups, I used PVFS2 by aggregating 40 TB nodes. PVFS2 is
known to scale up to petabytes, and (contrary to XFS over RAID-0) is
extremely tolerant to node failure (though it is not redundant); if a
node crashes, the cluster IO may freeze (though write activity can
usually go on) but restart instantly when the failed node is revived.

However PVFS isn't made for general purpose file sharing (though it
works with both samba and nfs), but really flies when used with
applications properly set up (MPIO). It's tailored for scientific work
and heavy computation clusters.

In contrast with Lustre, PVFS2 is very easy to set up, and very easy
to extend if you planned it from the start (Lustre is a fantastic PITA
to set up and administer, and don't even talk about NFS sharing).

So I would set up a storage cluster this way : each storage node is a
PVFS server, the PVFS data resides on an XFS filesystem (officially
recommended by PVFS developers anyway).
You can expand the PVFS filesystem either by enlarging the XFS on the
storage nodes, or by adding new independant storage nodes.

Each storage node can be a PVFS client too, and use its computing power
to crunch data. =


As I said, the main problem is to know how you plan to make space
available to clients systems. You can use NFS/CIFS for ease of use,
desktop access, etc but performance will be low. However native PVFS
performance can be huge over infiniband (in the several GB/s range).
And the more storage nodes you're adding, the more performance you get.

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
