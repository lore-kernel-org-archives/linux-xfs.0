Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97656TL168614 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 01:05:06 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 436874A9568
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 23:06:30 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 0aG9Sb3scYMi66mz for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 23:06:30 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id E153A6A5
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 08:06:19 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id AD9C9400155
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 08:06:27 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [PATCH] mkfs: add discard support
Date: Wed, 7 Oct 2009 08:05:46 +0200
References: <20091006184758.GA4780@infradead.org>
	<20091007044215.GK9464@discord.disaster>
In-Reply-To: <20091007044215.GK9464@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200910070805.46767@zmi.at>
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

On Mittwoch 07 Oktober 2009 Dave Chinner wrote:
> Good idea, but perhaps the discard should be optional rather than
> unconditional. =A0My immediate thought was the SOP for setting up
> encrypted devices - fill the empty disk with random data before
> setting up the encrypted device. If you then send it a discard....

You could change the order to
mkfs ; mount
dd if=3D/dev/urandom of=3D/encrytped/fill.dd
(one day the disk will be full)
sync ; rm /encrytped/fill.dd

That should fill the disk with random garbage too. Should be nearly the =

same result, right?

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
