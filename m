Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA3KwMFI186950 for <xfs@oss.sgi.com>; Tue, 3 Nov 2009 14:58:23 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB6D65B7F7
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2009 12:58:33 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id owrWSwCBRFspDYau for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2009 12:58:33 -0800 (PST)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 6549AC02730
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2009 21:58:30 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 2ABDB40016F
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2009 21:58:30 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS and DPX files
Date: Tue, 3 Nov 2009 21:58:29 +0100
References: <4AEC2CF4.8040703@aol.com> <200911022258.35164@zmi.at>
	<20091103121920.7e6b6d07@harpe.intellique.com>
In-Reply-To: <20091103121920.7e6b6d07@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200911032158.29684@zmi.at>
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

On Dienstag 03 November 2009 Emmanuel Florac wrote:
> Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:
> > Hence my suggestion for turning on the disk write cache just to see
> > if it makes a difference.
>
> Unfortunately there isn't any way in the 3Ware controllers to manage
> that. Worse, I couldn't get a clear answer from 3Ware support about
> the controller policy about drives caches. However from the tests
> I've done (pulling the plug on a server while writing) it looks like
> the 3Ware uses the disks caches in write-thru mode, however
> (fortunately now that many drives come with 32 or 64 MB caches).
>
> Some other SATA/SAS RAID controllers (Areca, LSI and Adaptec) allows
> to activate drive write-back cache separately from the controller
> cache, though.

Looks like you didn't read the FAQ until now, I tried to document the =

unclear bits as good as I could:

http://www.xfs.org/index.php/XFS_FAQ#Q._Which_settings_does_my_RAID_control=
ler_need_.3F

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
