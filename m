Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1PBqTl6202999 for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 05:52:30 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D68D019A7216
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 03:51:56 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id HFjhbe8E16jHNkDB for
	<xfs@oss.sgi.com>; Wed, 25 Feb 2009 03:51:56 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 7DCB442BE
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 12:51:23 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 0BF8F400174
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 12:51:24 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
Date: Wed, 25 Feb 2009 12:51:23 +0100
References: <1235480661.17293.28.camel@disciplina.fs3.ph>
	<20090224224636.GF26138@disturbed>
	<1235556051.17569.4.camel@disciplina.fs3.ph>
In-Reply-To: <1235556051.17569.4.camel@disciplina.fs3.ph>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902251251.23675@zmi.at>
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

On Mittwoch 25 Februar 2009 Federico Sevilla III wrote:
> What would be the "community endorsed" approach to using our favorite
> file system on CentOS 5? Would you recommend we go with the
> CentOSPlus kernels instead?

We run openSUSE, but many servers with a vanilla kernel. So you can 
upgrade whenever you like. Currently, 2.6.28.x is the newest version.

Problem could be that CentOS relies on a patched kernel in some place (I 
don't use it so don't know), but if that doesn't hit you, it doesn't 
matter. For example, openSUSE kernels support a nice graphical boot 
instead of the text, but we don't need that.
You must also take care of kernel bugs and updates yourself from the 
moment you use your own compiled kernel.

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
