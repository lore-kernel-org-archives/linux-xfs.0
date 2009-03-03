Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n23Kumqd035266 for <xfs@oss.sgi.com>; Tue, 3 Mar 2009 14:56:49 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A463B1C14848
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2009 12:56:19 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id FjlEJywMiMAzFiph for
	<xfs@oss.sgi.com>; Tue, 03 Mar 2009 12:56:19 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 0BF1643B4
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2009 21:56:18 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id F1C52400176
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2009 21:56:17 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS and XEN
Date: Tue, 3 Mar 2009 21:56:17 +0100
References: <200902170959.55077@zmi.at> <200902241604.29566@zmi.at>
	<20090224163823.GA19811@infradead.org>
In-Reply-To: <20090224163823.GA19811@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903032156.17671@zmi.at>
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

On Dienstag 24 Februar 2009 Christoph Hellwig wrote:
> The difference is just that you actually see the
> corruption on XFS while it's pretty silent on extN. =A0If your Hardware
> (or Hypervisor) is not reliable you _will_ lose data. =A0Either
> silently or with a spectacular blowup if the filesystem actually has
> consistency checking (which XFS has a lot).

One more question: My hardware should be reliable: RAID controller, =

battery backed cache, disk write cache=3Doff. So even in the event of a =

power fail, nothing should happen. The controller should write open =

blocks after reboot.

But it doesn't. I've retested: power off. On bootup, the XEN domU =

PostgreSQL reported errors again. This time of course I had a good =

backup from a minute before. But still: Shouldn't it be impossible for =

such an error to happen, as my hardware shouldn't eat any data? I'm =

trying to find out where the DB gets destroyed. Is it that "just" =

breaking within a transaction where XEN doesn't correctly fsync is =

enough, despite all hardware else configured well?

Damn, that's a complicated world.

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
