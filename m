Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA2M8Gss097132 for <xfs@oss.sgi.com>; Mon, 2 Nov 2009 16:08:17 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DD7E180C066
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 14:08:29 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id SOARbVnotIZMtPbn for
	<xfs@oss.sgi.com>; Mon, 02 Nov 2009 14:08:29 -0800 (PST)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id EC018C02700
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 23:08:26 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id B719B40016F
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 23:08:26 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 3ware hardware raid with battery backup and the impact on barrier
	and no write cache options.
Date: Mon, 2 Nov 2009 23:08:26 +0100
References: <7a12b48b0911021202l126e10a1pbc281f6922380f48@mail.gmail.com>
In-Reply-To: <7a12b48b0911021202l126e10a1pbc281f6922380f48@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200911022308.26282@zmi.at>
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

On Montag 02 November 2009 William Lewis wrote:
> Reading your FAQ at http://xfs.org/index.php/XFS_FAQ I understand
> that it is advisable to mount the file system with nobarrier to
> improve performance. 

I edited that part, so I'll answer.

> However going on to read about recommended
> settings for write cache, the advice for 3ware hardware doesn't seem
> to account for the fact that there are 2 levels of write cache in
> play, that in the 3ware card itself protected by the battery and the
> write cache of the disks themselves,

There are 2 different caches. One in the controller, on on the disks.

> which as far as I can understand
> is also protected by the battery backup (in the correct storage modes
> - balanced/protection) because the 3ware card uses write journaling
> to keep track of pending write operations in the disks' cache.

I can't believe it's possible for the controller to know when a disk 
write is actually on disk while the disk write cache is on. There are 
lots of disk who plainly *lie* about that fact. I've seen a web page 
once with a listing of disks who lie - quiet long. I don't find the link 
ATM, maybe googling helps.

> Therefore unless I am misunderstanding something the most benefit is
> to be gained by mounting with nobarrier and having the write cache
> turned on?

If you care about your data, don't turn on the disk write cache. I 
wonder why there's not a single disk vendor building a disk with a small 
battery buffer that is able to keep the disk spinning until it can 
savely empty disk cache to platters. Would be a real performance benefit 
in server environments.

> One thing I am not clear about is if nobarrier interacts with the
> page cache at all and if the lack of barrier leaves you with a
> situation in which pending writes can be lost from main memory on
> power failure?

Writes in main RAM will always be lost on power fail. If you need 
protection for that, use fsync(). The thing about barries is to ensure 
that metadata is kept consistent on powerfail. It's in fact nothing to 
protect your data, only the filesystem metadata. Well, in the end your 
data also, as the filesystem survives.

> Thanks in advance for any clarification you can provide.

I hope I could help.

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
