Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1DAD3dN127295 for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 04:13:04 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CECCA192C934
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 02:12:28 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id NYwkDxlsGWhWneoE for
	<xfs@oss.sgi.com>; Fri, 13 Feb 2009 02:12:28 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 5229C3FCE
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 11:12:27 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 4983F400154
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 11:12:27 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_force_shutdown after Raid crash
Date: Fri, 13 Feb 2009 11:12:26 +0100
References: <498376CF.8020806@renderforce.de>
	<20090204122625.GM24173@disturbed> <200902041603.22541@zmi.at>
In-Reply-To: <200902041603.22541@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902131112.26910@zmi.at>
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

On Mittwoch 04 Februar 2009 Michael Monnerie wrote:
> On Mittwoch 04 Februar 2009 Dave Chinner wrote:
> > > What just comes to my mind: what about XEN/VMware?
> > >
> > > What settings should be used within a virtual machine? Even if I
> > > have battery backed cache and nobarrier on the host, the VM
> > > itself could crash, or the whole host freeze. Is "nobarrier" save
> > > within a VM?
> >
> > Depends on the implementation of the hypervisor.
>
> OK, so we don't know?
> I guess VMware will be the most used for Linux systems, and XEN usage
> will soon grow a lot as it's directly in the kernel now. Does anybody
> know for those two, whether "nobarrier" is save/needed/a bad thing?

Does anybody know about XEN/VMware? It would be interesting, maybe worth 
a FAQ entry if we have a good answer.

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
