Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n57HTJQL180255
	for <linux-xfs@oss.sgi.com>; Sun, 7 Jun 2009 12:29:21 -0500
Received: from foehn.mgras.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A976148F196
	for <linux-xfs@oss.sgi.com>; Sun,  7 Jun 2009 10:36:31 -0700 (PDT)
Received: from foehn.mgras.de (quickstep.mgras.net [213.146.115.59]) by
	cuda.sgi.com with ESMTP id bb5PBfNGKnoB3Wvw for
	<linux-xfs@oss.sgi.com>; Sun, 07 Jun 2009 10:36:31 -0700 (PDT)
Received: from osprey.mgras.de (osprey.mgras.de [192.168.48.3])
	by foehn.mgras.de (8.13.1/8.13.0) with ESMTP id n57HSk7i027958
	for <linux-xfs@oss.sgi.com>; Sun, 7 Jun 2009 19:28:46 +0200 (CEST)
Received: (from news@localhost) by osprey.mgras.de (AIX5.1/8.11.6p2/8.11.0) id
	n57HSjY34724 for linux-xfs@oss.sgi.com;
	Sun, 7 Jun 2009 19:28:45 +0200
From: Martin Spott <Martin.Spott@mgras.net>
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Sun, 7 Jun 2009 17:28:45 +0000 (UTC)
Message-ID: <h0gtcd$136u$1@osprey.mgras.de>
References: <20090520003745.GA27491@samad.com.au>
	<20090604112657.GA10738@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Hi Christoph,

Christoph Hellwig wrote:

> Sorry guys, still haven't been able to track it down.  Any chance one
> of you could run with CONFIG_XFS_DEBUG enabled and see if it trips
> over any of the asserts?

  "Say N unless you are an XFS developer, or you play one on TV."

Very nice  ;-)

I'm have to regret that I'm neither an XFS developer nor do I pretend
to be one. Yet, as I understand, I should see at least _some_ debug
info via 'dmesg', if there is any. Apparently the kernel is now having
XFS with debugging enabled:

Jun  7 18:53:33 isnix1 kernel: SGI XFS with ACLs, security attributes, large block/inode numbers, debug enabled
Jun  7 18:53:33 isnix1 kernel: SGI XFS Quota Management subsystem
Jun  7 18:53:33 isnix1 kernel: XFS mounting filesystem cciss/c0d0p2
[...]


....  but aside from the well-known messages as:

Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery
directory
NFSD: unable to find recovery directory /var/lib/nfs/v4recovery
NFSD: starting 90-second grace period
reconnect_path: npd != pd
reconnect_path: npd != pd
reconnect_path: npd != pd
[...]


....  I'm unable to find any helpful information in this context.
Anything I could try - this sunday evening ?

Cheers,
	Martin.
-- 
 Unix _IS_ user friendly - it's just selective about who its friends are !
--------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
