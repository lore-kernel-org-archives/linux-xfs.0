Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n57K0ra5187700
	for <linux-xfs@oss.sgi.com>; Sun, 7 Jun 2009 15:00:54 -0500
Received: from foehn.mgras.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 219341D3AC8C
	for <linux-xfs@oss.sgi.com>; Sun,  7 Jun 2009 13:01:11 -0700 (PDT)
Received: from foehn.mgras.de (quickstep.mgras.net [213.146.115.59]) by
	cuda.sgi.com with ESMTP id KiM4XMCbnTAb3HLU for
	<linux-xfs@oss.sgi.com>; Sun, 07 Jun 2009 13:01:11 -0700 (PDT)
Received: from osprey.mgras.de (osprey.mgras.de [192.168.48.3])
	by foehn.mgras.de (8.13.1/8.13.0) with ESMTP id n57K0Mee029809
	for <linux-xfs@oss.sgi.com>; Sun, 7 Jun 2009 22:00:22 +0200 (CEST)
Received: (from news@localhost) by osprey.mgras.de (AIX5.1/8.11.6p2/8.11.0) id
	n57K0Lg15540 for linux-xfs@oss.sgi.com;
	Sun, 7 Jun 2009 22:00:21 +0200
From: Martin Spott <Martin.Spott@mgras.net>
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Sun, 7 Jun 2009 20:00:21 +0000 (UTC)
Message-ID: <h0h68l$136q$1@osprey.mgras.de>
References: <20090520003745.GA27491@samad.com.au>
	<20090607185558.GA753@infradead.org>
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

> That warning is what really makes me freak out, as it really, really
> shouldn't happen.  Can you see if it gives any additional useful output
> with the patch below?

Find here a package containing the respective syslog section plus a (I
think so) non-obfuscated metadump (in order to corellate to the
directory names to the syslog):

  http://foxtrot.mgras.net/static/xfs_debug-20090607.tgz

Cheers,
	Martin.
-- 
 Unix _IS_ user friendly - it's just selective about who its friends are !
--------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
