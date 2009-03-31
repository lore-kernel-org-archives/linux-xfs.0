Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2VCZhwC260495 for <xfs@oss.sgi.com>; Tue, 31 Mar 2009 07:35:58 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47B3A1C8353D
	for <xfs@oss.sgi.com>; Tue, 31 Mar 2009 05:34:58 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id kvADFkNBgX9NUqaK for
	<xfs@oss.sgi.com>; Tue, 31 Mar 2009 05:34:58 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 2E3654F74
	for <xfs@oss.sgi.com>; Tue, 31 Mar 2009 14:34:57 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 0ABB5400160
	for <xfs@oss.sgi.com>; Tue, 31 Mar 2009 14:34:57 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_freeze -f misbehaving under lenny / xfsprogs 2.9.8
Date: Tue, 31 Mar 2009 14:34:56 +0200
References: <49D09F2C.8060406@decisionsoft.co.uk>
	<49D0CCEB.1000404@sandeen.net>
	<49D0D01A.8090608@decisionsoft.co.uk>
In-Reply-To: <49D0D01A.8090608@decisionsoft.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903311434.56662@zmi.at>
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

On Montag 30 M=E4rz 2009 Stuart Rowan wrote:
> OOI when implementing the freeze ioctl, what made the developers
> decide that a freeze can't succeed on an already frozen filesystem
> ... you'd expect it to just be a no-op really?

So you would break the unfreeze:

xfs_freeze -f
lvcreate -s (lvcreate does freeze;work;unfreeze)
*now you are unfrozen*
xfs_freeze -u

The problem would be if you expect to be frozen still after the lvcreate =

command and do some processing, that might be bad.

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
