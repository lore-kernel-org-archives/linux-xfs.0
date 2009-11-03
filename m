Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA38aGoE137942 for <xfs@oss.sgi.com>; Tue, 3 Nov 2009 02:36:17 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB9B857C4C
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2009 00:36:27 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id On5NVQ5Rjyz66Q8P for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2009 00:36:27 -0800 (PST)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 15F41C3AB07
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2009 09:36:26 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id D81D340016F
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2009 09:36:25 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 3ware hardware raid with battery backup and the impact on barrier
	and no write cache options.
Date: Tue, 3 Nov 2009 09:36:25 +0100
References: <7a12b48b0911021202l126e10a1pbc281f6922380f48@mail.gmail.com>
	<alpine.DEB.2.00.0911021628030.811@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0911021628030.811@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200911030936.25442@zmi.at>
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

On Montag 02 November 2009 Justin Piszcz wrote:
> I am also curious, I have a 16 drive RAID-6 configuration on a
> 9650SE-16ML and using -o nobarrier or mounting normal the
> speed/benchmarks seemed to be the same. =A0Either barriers are not
> enabled by default for 3ware RAID arrays or they make no difference
> in performance?

I'd say a RAID controller with it's own write cache enabled + BBM will =

effectively turn barriers off, even if you can use them as a mount =

options. What happens with barriers, is that it writes =

1,2,3,barrier,4,5,barrier,6 etc. so, that 123 are sure on disk before 45 =

happen etc.
The RAID controller will happily tell you it did flush everything, =

because as soon as data is in it's cache, it's claimed sure that the =

data gets written, and therefore it will tell that the barrier is =

already done. And that's why it's a *must* to turn off disk cache =

writes, because the filesystem got it's barrier ACK and believes it, the =

controller has it's cache written to disk, powerfail.... all gone. That =

will do a bigger damage than any single disk could have done.

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
