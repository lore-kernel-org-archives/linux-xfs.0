Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n869VCWW133288 for <xfs@oss.sgi.com>; Sun, 6 Sep 2009 04:31:22 -0500
Received: from mailsrv5.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7502D15EDB82
	for <xfs@oss.sgi.com>; Sun,  6 Sep 2009 02:31:58 -0700 (PDT)
Received: from mailsrv5.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 73wmeeTCXX9nGRzX for
	<xfs@oss.sgi.com>; Sun, 06 Sep 2009 02:31:58 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv5.zmi.at (Postfix) with ESMTP id 59C81693
	for <xfs@oss.sgi.com>; Sun,  6 Sep 2009 11:31:53 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id E48AF40015E
	for <xfs@oss.sgi.com>; Sun,  6 Sep 2009 11:31:55 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs data loss
Date: Sun, 6 Sep 2009 11:30:41 +0200
References: <B9A7B002C7FAFC469D4229539E909760308D8CAB6D@DU-EXC-MAIL.empa.emp-eaw.ch>
In-Reply-To: <B9A7B002C7FAFC469D4229539E909760308D8CAB6D@DU-EXC-MAIL.empa.emp-eaw.ch>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200909061130.41912@zmi.at>
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

On Sonntag 06 September 2009 Passerone, Daniele wrote:
> Well, a binary file with 5% data loss would simply not work.
> But I have executables on this filesystem, and they run!

Optimist. It just means the part of the binary you run are not random. 
Randomness of *all* code paths would have to be checked, which you 
probably can't do manually, so binaries are not a good check at all.

Since you didn't change any drives, chances are good that you really 
lost very little data.

> a MB-sized tar.gz file, compression of a postscript file,
> uncompressed perfectly and was visualized in a perfect way by
> ghostview.

That's a good test, so you are lucky.

> Moreover, a device died (a different one) yesterday, and in the
> messages I have ...

Is this on the same controller as the other broken disks were? Then this 
should be it (or it's cabling, or the backplane, etc.). And you should 
immediately shut down the RAID on that controller, as you might loose 
data (or the whole RAID) when the controller writes random data. A 
broken hardware is the worst thing to have. Replace it, test the new 
parts *thouroughly*, and only then start to use the RAID again.

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
