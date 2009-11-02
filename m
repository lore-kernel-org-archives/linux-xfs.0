Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA2B5MVZ035634 for <xfs@oss.sgi.com>; Mon, 2 Nov 2009 05:05:24 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 082BE14CD492
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 03:05:31 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id dESBNfPtkuUiHIFw for
	<xfs@oss.sgi.com>; Mon, 02 Nov 2009 03:05:31 -0800 (PST)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id BD780C3AB09
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 12:05:28 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 7F71940016F
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 12:05:28 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS and DPX files
Date: Mon, 2 Nov 2009 12:05:27 +0100
References: <4AEC2CF4.8040703@aol.com> <4AEC4BAA.20606@aol.com>
	<20091031174836.3fc9505b@galadriel.home>
In-Reply-To: <20091031174836.3fc9505b@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200911021205.28006@zmi.at>
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

On Samstag 31 Oktober 2009 Emmanuel Florac wrote:
> Another trick is to mkfs the drive with su and sw matching the
> underlying RAID, for instance for a 15 drives RAID6 with 64K stripe
> use something like (beware, unverified syntax from memory):
>
> mkfs -t xfs -d su=65536,sw=15 /dev/sdXX

I believe for a 15 drive RAID-6, where 2 disks are used for redundancy, 
the correct mkfs would be:
mkfs -t xfs -d su=65536,sw=13 /dev/sdXX

That is, you tell XFS how many *data disks* there are, not how many 
disks the RAID uses, because the important thing is that XFS should 
distribute it's metadata over different disks.

One thing you could try: Each 2 minutes, create a new dir and store new 
files there. It could well be that XFS becomes slower when having a 
certain amount of files in a dir. If you change the dir, and now 
everything writes without drops, that should be the problem.
If you can't change the dir for your application, start a small batch 
job that moves the files to another dir, or removes them.

Another thing to try is if it would help to turn disk cache writes *on*, 
despite all warnings if the FAQ. That could also give an idea where to 
look at next time.

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
