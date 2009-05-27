Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4RHMIKZ200186
	for <linux-xfs@oss.sgi.com>; Wed, 27 May 2009 12:22:21 -0500
Received: from foehn.mgras.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1EF9A101A193
	for <linux-xfs@oss.sgi.com>; Wed, 27 May 2009 10:28:25 -0700 (PDT)
Received: from foehn.mgras.de (quickstep.mgras.net [213.146.115.59]) by
	cuda.sgi.com with ESMTP id q3tMk33vdB1NHqXX for
	<linux-xfs@oss.sgi.com>; Wed, 27 May 2009 10:28:25 -0700 (PDT)
Received: from osprey.mgras.de (osprey.mgras.de [192.168.48.3])
	by foehn.mgras.de (8.13.1/8.13.0) with ESMTP id n4RHLeve002796
	for <linux-xfs@oss.sgi.com>; Wed, 27 May 2009 19:21:41 +0200 (CEST)
Received: (from news@localhost) by osprey.mgras.de (AIX5.1/8.11.6p2/8.11.0) id
	n4RHLeF35674 for linux-xfs@oss.sgi.com;
	Wed, 27 May 2009 19:21:40 +0200
From: Martin Spott <Martin.Spott@mgras.net>
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Wed, 27 May 2009 17:21:40 +0000 (UTC)
Message-ID: <gvjsr4$13l8$1@osprey.mgras.de>
References: <20090520003745.GA27491@samad.com.au>
	<20090526090916.GA17194@infradead.org>
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

Christoph Hellwig wrote:

> May 24 08:48:00 (none) last message repeated 61 times                           
> May 24 08:48:47 (none) last message repeated 760 times                          
> May 24 08:50:55 (none) kernel: reconnect_path: npd != pd                        
> May 24 08:50:55 (none) last message repeated 9 times                            
> May 24 08:55:04 (none) kernel: reconnect_path: npd != pd                        
> May 24 08:56:05 (none) last message repeated 47 times                           
> May 24 08:56:49 (none) last message repeated 419 times

Resembles me of trouble I've recently seen on some of the machines I
maintain after updating from 2.6.27.11 to 2.6.29.[2,3], serving a few
dozend LTSP (diskless so-called thin-clients) root filesystems via NFS
from XFS - not really huge load, to be honest.

After running 2.6.29.4 for one day now I have the feeling that the
issue had been cured - but I didn't manage to get a clue about the fix.

Very few people have been reporting a similar issue here:

  http://www.mail-archive.com/debian-user@lists.debian.org/msg545497.html

and here:

  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=527517

Additional information wanted ?

Cheers,
	Martin.
-- 
 Unix _IS_ user friendly - it's just selective about who its friends are !
--------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
