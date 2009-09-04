Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n84HPo1f225931 for <xfs@oss.sgi.com>; Fri, 4 Sep 2009 12:26:01 -0500
Received: from mailsrv5.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F20F042A3CF
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2009 10:26:21 -0700 (PDT)
Received: from mailsrv5.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id AqPWFdWAtapbA9kd for
	<xfs@oss.sgi.com>; Fri, 04 Sep 2009 10:26:21 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv5.zmi.at (Postfix) with ESMTP id 90A736CF
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2009 19:25:45 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id E0FB840015E
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2009 19:25:45 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [PATCH 00/14] repair memory usage reductions
Date: Fri, 4 Sep 2009 19:24:35 +0200
References: <20090902175531.469184575@bombadil.infradead.org>
	<20090904133737.GD12052@sgi.com>
	<20090904145109.GA8351@infradead.org>
In-Reply-To: <20090904145109.GA8351@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200909041924.35987@zmi.at>
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

On Freitag 04 September 2009 Christoph Hellwig wrote:
> In my testing I haven't seen big differences in performance, it
> sometimes got a bit faster and sometimes a bit slower. =A0I will send
> out a more detailed performace report in a few days.

>From what I've read, it should be faster on a machine with 2GB RAM and =

10TB storage, while it's maybe slower on a 64GB RAM machine with a 1TB =

xfs storage. Given that disks grow faster than RAM sizes, and that with =

virtualization a single machine typically has not too much RAM these =

days, I guess with the patches speed will improve overall.

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
