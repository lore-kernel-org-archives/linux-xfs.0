Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2R8VYnu224613 for <xfs@oss.sgi.com>; Fri, 27 Mar 2009 03:31:49 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7943B1C752DF
	for <xfs@oss.sgi.com>; Fri, 27 Mar 2009 01:31:06 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id ml1SleM1SjyHsQxE for
	<xfs@oss.sgi.com>; Fri, 27 Mar 2009 01:31:06 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (unknown [81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 9AF944C29
	for <xfs@oss.sgi.com>; Fri, 27 Mar 2009 09:31:04 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 9491640DC04
	for <xfs@oss.sgi.com>; Fri, 27 Mar 2009 09:31:04 +0100 (CET)
Subject: Re: How to configure 36 disks ?
Content-Disposition: inline
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Date: Fri, 27 Mar 2009 09:31:03 +0100
MIME-Version: 1.0
Message-Id: <200903270931.03964@zmi.at>
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

(I sent this mail on Tue 23:40 CET, but it seems it didn't arrive on the =

list. At least I didn't receive it. So I send again)

On Montag 23 M=E4rz 2009 Raz wrote:
> 1. redundancy.
> 2. performance.

First, you should have bought enclosures with included RAID controllers, =

then you'd be finished already.

But then, I guess you wanted to save the money, but at least go get some =

real hardware RAID controller. Look at Areca ( http://www.areca.com.tw ) =

if you use Linux or Windows, the 1680 series SAS controllers can cope =

with SAS/SATA drives, up to 128 drives per controller. You can put a =

cache up to 4GB on the controller, and a battery backup module that =

protects your data in case of power outages. Those controllers are =

blazing fast, have good admin tools, send you an e-mail in case of =

problems, and they used it in the video that Chris mentioned:
http://blogs.sun.com/observatory/entry/don_t_shout_at_your

In the end you see they used an Areca 16port, plus an Adaptec 8port (I =

guess because they only had the Areca in 16port available).

Then configure a RAID-60 or whatever you like.

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
