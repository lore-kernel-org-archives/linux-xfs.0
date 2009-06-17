Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5H13giB188403 for <xfs@oss.sgi.com>; Tue, 16 Jun 2009 20:03:43 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8FB22FF908
	for <xfs@oss.sgi.com>; Tue, 16 Jun 2009 18:04:04 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id cwddMguzy7SwqkKP for
	<xfs@oss.sgi.com>; Tue, 16 Jun 2009 18:04:04 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217106033.dyn.cm.kabsi.at
	[81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id F092F4EED
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2009 03:04:03 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 69679400154
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2009 03:04:03 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS Preallocate using ALLOCSP
Date: Wed, 17 Jun 2009 03:04:02 +0200
References: <24042506.post@talk.nabble.com> <4A37D737.70004@sandeen.net>
	<8770d98c0906161438u339440cdm783340485a3db898@mail.gmail.com>
In-Reply-To: <8770d98c0906161438u339440cdm783340485a3db898@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906170304.02775@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Dienstag 16 Juni 2009 Smit Shah wrote:
> In the vmware sparse disk

Ah, virtualization again. Yes, that's no good for performance ;-) 
There's a "defragment disk" button in VMware which simply copies the 
flat file on the filesystem in order to remove fragmentation. I guess 
running xfs_fsr would help more in that case. Did you try with that?

> chunks are allocated of the size of 64k,

It's a pity that there's no option to define how large each chunk should 
be. Using 1-50MB of real disk space for each new chunk could help a lot 
to keep the file less fragmented. It get's really funny when you run 
"defrag" within the VM on a sparse vdisk.

mfg zmi
-- 
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
