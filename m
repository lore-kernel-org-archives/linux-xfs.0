Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n63NosSj199493 for <xfs@oss.sgi.com>; Fri, 3 Jul 2009 18:50:55 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8F121AEFDE5
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2009 16:51:26 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id ibyb3BdZYqJDZ2xP for
	<xfs@oss.sgi.com>; Fri, 03 Jul 2009 16:51:26 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217106033.dyn.cm.kabsi.at
	[81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 29C78445E
	for <xfs@oss.sgi.com>; Sat,  4 Jul 2009 01:52:29 +0200 (CEST)
Received: from saturn.localnet (unknown [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 72907400155
	for <xfs@oss.sgi.com>; Sat,  4 Jul 2009 01:51:24 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [PATCH] bump up nr_to_write in xfs_vm_writepage
Date: Sat, 4 Jul 2009 01:51:19 +0200
References: <4A4D26C5.9070606@redhat.com>
In-Reply-To: <4A4D26C5.9070606@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907040151.21013@zmi.at>
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

On Donnerstag 02 Juli 2009 Eric Sandeen wrote:
> With the following change things get moving again for xfs:

Amazeing, more than double speed with a one-liner. Do you have more such 
lines? ;-)

> +	/*
> +	 *  VM calculation for nr_to_write seems off.  Bump it way
> +	 *  up, this gets simple streaming writes zippy again.
> +	 */
> +	wbc->nr_to_write *= 4;

Could this be helpful here also: I've just transfered a copy of a 
directory from our server to a Linux desktop. Nothing else running, just 
an rsync from server to client, where the client has a Seagate 1TB ES.2 
SATA disk, whhic can do about 80MB/s on large writes. But it did this, 
measured on large files (>20MB each, no small files):

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-
sz avgqu-sz   await  svctm  %util
sdb               0,00   584,00    0,00  368,00     0,00  7448,00    
40,48   148,64  401,40   2,72 100,00

All the time around 300+ IOps, which is OK, but only 7-10MB/s? That 
can't be true. Then I killed the rsync process on the server, and the 
writes on the client jumped up:

sdb               0,00  4543,40    0,00  333,40     0,00 44965,60   
269,74   144,66  384,98   3,00 100,00

45MB/s is OK. I investigated a bit further: Seems the /proc/sys/vm 
values are strange, clients kernel is # uname -a
Linux saturn 2.6.30-ZMI #1 SMP PREEMPT Wed Jun 10 20:07:31 CEST 2009 
x86_64 x86_64 x86_64 GNU/Linux

This makes rsync slow:
cat /proc/sys/vm/dirty_*       
0                                       
5                                       
0                                       
8000                                    
50                                      
100                    

This fast:
cat /proc/sys/vm/dirty_*       
cat dirty_*
16123456
0
524123456
8000
0
100

Seems more like a kernel related stuff, but do others see the same 
thing?

So, I'm really out for a 1 week vacation now, have fun!

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
