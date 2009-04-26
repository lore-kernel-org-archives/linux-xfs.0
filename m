Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3QLpRps252312 for <xfs@oss.sgi.com>; Sun, 26 Apr 2009 16:51:28 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B915F1CEA2EB
	for <xfs@oss.sgi.com>; Sun, 26 Apr 2009 14:51:24 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id EBEqtMwTCwbsenYu for
	<xfs@oss.sgi.com>; Sun, 26 Apr 2009 14:51:24 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217107103.dyn.cm.kabsi.at
	[81.217.107.103])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 1B5135144
	for <xfs@oss.sgi.com>; Sun, 26 Apr 2009 23:51:28 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 764E340017B
	for <xfs@oss.sgi.com>; Sun, 26 Apr 2009 23:51:23 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Slab memory usage
Date: Sun, 26 Apr 2009 23:51:22 +0200
References: <73EE3FB2-381F-43F1-82C1-FA4C020E7C02@strands.com>
	<49F260F1.4030503@sandeen.net>
In-Reply-To: <49F260F1.4030503@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904262351.22970@zmi.at>
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

On Samstag 25 April 2009 Eric Sandeen wrote:
> *from Documentation/sysctl/vm.txt:
>
> vfs_cache_pressure
> ------------------
>
> Controls the tendency of the kernel to reclaim the memory which is
> used for caching of directory and inode objects.
>
> At the default value of vfs_cache_pressure=3D100 the kernel will
> attempt to reclaim dentries and inodes at a "fair" rate with respect
> to pagecache and swapcache reclaim. =A0Decreasing vfs_cache_pressure
> causes the kernel to prefer to retain dentry and inode caches.
> =A0Increasing vfs_cache_pressure beyond 100 causes the kernel to prefer
> to reclaim dentries and inodes.

So if I decrease it, lets say to 60, Linux prefers to remember =

files/dirs over their content. An increase to 150 would mean Linux =

prefers to keep file contents over dirs/files?

If so, I think for a fileserver for many users accessing many =

dirs/files, I'd prefer a lower value, in order to prevent searching. =

Disk contents can be read fast, with all the read-ahead caching of =

disks/controllers and Linux itself, but the scattered dirs take loooong =

to scan sometimes. (Example: a foto collection with 50.000 files in many =

dirs). Am I right?

mfg zmi
-- =

// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
