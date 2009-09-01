Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n81MrK3B213884 for <xfs@oss.sgi.com>; Tue, 1 Sep 2009 17:53:30 -0500
Received: from mailsrv5.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D69315A468D
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 15:53:41 -0700 (PDT)
Received: from mailsrv5.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 7iPRul3tJfchNnBb for
	<xfs@oss.sgi.com>; Tue, 01 Sep 2009 15:53:41 -0700 (PDT)
Received: from mailsrv.i.zmi.at (unknown [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv5.zmi.at (Postfix) with ESMTP id 476516C0
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 00:53:30 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 1DCED400161
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 00:53:33 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: zero size file after power failure with kernel 2.6.30.5
Date: Wed, 2 Sep 2009 00:52:41 +0200
References: <200908292102.21710@zmi.at> <200909010918.37886@zmi.at>
	<19100.63566.98250.185404@tree.ty.sabi.co.uk>
In-Reply-To: <19100.63566.98250.185404@tree.ty.sabi.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200909020052.42421@zmi.at>
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

On Dienstag 01 September 2009 Peter Grandi wrote:
> Other people have a very different impression. Like 'ext3'
> ReiserFS does ordered writes, but those don't necessarily help
> because of the colossal amount of buffering that happens anyhow
> nowadays.

Maybe. I had reiserfs on this system until two weeks ago, with this 
quad-core 8GB desktop. Had power failures, crashes, and so on. Can't 
remember a situation where a KDE app lost its config.

But I had a server with the OSS XEN, running a single VM which is my 
internal mailserver using PostgreSQL as it's store on XFS. My daughter 
managed to switch the server off (yeah, having redundant power supplies 
and UPS are still not enough). After reboot, the PostgreSQL database was 
*damaged*, so much that I had to restore. This should never have 
happened, and until now I don't know who was guilty for that: XFS? XEN? 
The RAID Controller with BBU and hard disk cache=off?
That's why I'm very sensible to even a small data loss (I had a backup 
of my kmail config), and I think the filesystem has to do everything to 
try to keep my data. XFS seems to be optimized more for speed before 
security, would you mean that? I've often heard "enterprise hardware", 
which sounds like "if anything crashes, it's your problem" ;-)

>   http://www.sabi.co.uk/blog/0707jul.html#070701

I like your blog, and
http://www.myri.com/scs/READMES/README.myri10ge-linux
gave me a good hint to optimize tcp settings a long time ago.

> In general on a fast machine I would use:
>   vm/dirty_ratio                  =4
>   vm/dirty_background_ratio       =2
>   vm/dirty_expire_centisecs       =400
>   vm/dirty_writeback_centisecs    =200

Since May I use these new settings with kernel 2.6.(29|30):
vm.dirty_background_bytes = 16123456
vm.dirty_bytes = 250123456
vm.dirty_expire_centisecs = 1000
vm.dirty_writeback_centisecs = 100

(the expire was on 3000 until the crash).

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
