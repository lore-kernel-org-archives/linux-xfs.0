Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7I28L89106218 for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 21:08:39 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A88351074BA3
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 19:08:55 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id 1EPRJxDmRNoEYWSZ for
	<xfs@oss.sgi.com>; Mon, 17 Aug 2009 19:08:55 -0700 (PDT)
Received: from mailsrv.i.zmi.at (unknown [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id B3A753E4E
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2009 04:08:31 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 02516400166
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2009 04:08:23 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: disk performance strange/low
Date: Tue, 18 Aug 2009 04:08:05 +0200
References: <200908172311.07660@zmi.at> <20090817214136.GA26060@infradead.org>
In-Reply-To: <20090817214136.GA26060@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908180408.10738@zmi.at>
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

On Montag 17 August 2009 Christoph Hellwig wrote:
> Yes, that sounds like the problem of the VM not feeding us enough
> pages to write. =A0What kernel is this on? =A0Latest 2.6.31-rc has a
> workaround for it.

2.6.27.23-0.1-xen from openSUSE 11.1
I can't switch as I use it with the free Xen. Thanks for the info.

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
