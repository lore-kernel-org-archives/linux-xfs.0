Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0MKjhol139929 for <xfs@oss.sgi.com>; Fri, 22 Jan 2010 14:45:43 -0600
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90ECA1848E6
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2010 12:46:42 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id KzlanlZOQmbIrbY0 for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2010 12:46:42 -0800 (PST)
Date: Fri, 22 Jan 2010 21:46:24 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: nfs performance delta between filesystems
Message-ID: <20100122214624.7095a9c4@galadriel.home>
In-Reply-To: <20100122183848.GB28561@sgi.com>
References: <20100122185419.63ae6430@harpe.intellique.com>
	<20100122183848.GB28561@sgi.com>
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
To: bpm@sgi.com
Cc: xfs@oss.sgi.com

Le Fri, 22 Jan 2010 12:38:48 -0600 vous =E9criviez:

> There were small gains to be had by reordering the sync of the parent
> and child syncs where the two inodes were in the same cluster.  The
> larger problem seemed to be that we're not treating the log as stable
> storage. By calling write_inode_now we've written the changes to the
> log first and then gone and also written them out to the inode.  =


I thought that using nobarrier would prevent the log operations to be
sync'd to disk too quickly? Could I possibly enhance this behaviour by
using an external log on a very fast storage (ramdisk...)?

> nfsd_create, nfsd_link, and nfsd_setattr all do this (or do in the old
> kernel I'm looking at).  I have a patchset that changes
> this to an fsync so we force the log and call it good.  I'll be happy
> to dust it off if someone hasn't already addressed this situation.

Well, if you think this patchset can be applied to a current kernel
without too much hacking I'm ready to give it a try :)

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
