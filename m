Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6MCk7Xh241682
	for <linux-xfs@oss.sgi.com>; Wed, 22 Jul 2009 07:46:09 -0500
Received: from quickstep.mgras.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11C76ABFFB2
	for <linux-xfs@oss.sgi.com>; Wed, 22 Jul 2009 05:55:00 -0700 (PDT)
Received: from quickstep.mgras.net (quickstep.mgras.net [213.146.115.59]) by
	cuda.sgi.com with ESMTP id 7R9d2ZWUbty57lp8 for
	<linux-xfs@oss.sgi.com>; Wed, 22 Jul 2009 05:55:00 -0700 (PDT)
Received: from osprey.mgras.de (osprey.mgras.de [192.168.48.3])
	by quickstep.mgras.net (8.13.1/8.13.0) with ESMTP id n6MCju3V019039
	for <linux-xfs@oss.sgi.com>; Wed, 22 Jul 2009 14:45:57 +0200 (CEST)
Received: (from news@localhost) by osprey.mgras.de (AIX5.1/8.11.6p2/8.11.0) id
	n6MCjua26142 for linux-xfs@oss.sgi.com;
	Wed, 22 Jul 2009 14:45:56 +0200
From: Martin Spott <Martin.Spott@mgras.net>
Subject: Re: patch 2.6.30 and 2.6.30.1 xfs/nfs oops fix, radix tree
Date: Wed, 22 Jul 2009 12:45:55 +0000 (UTC)
Message-ID: <h471m3$1168$1@osprey.mgras.de>
References: <20090721012455.GG3229@rlogin.dk>
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

Michael Ole Olsen wrote:

> Eric has been very helpful in helping me downgrade xfs in 2.6.30.1 to 2.6.28.7
> version (getting 2.6.28.7 to compile in 2.6.30.1) which removed the oopses.
> 
> Just wanted to post here for other people like me that don't have an option
> of downgrading their kernel (need i.e. mdadm>=2.6.30).

A little side note here: Just I as an excercise, because I'm a curious
person, I performed a similar procedure, taking the xfs sources from
2.6.28.10, put them into a 2.6.30.2 tree, applied the patch and finally
booted the resulting kernel:
Don't try this on a machine you don't have console access to  ;-)

Cheers,
	Martin.
-- 
 Unix _IS_ user friendly - it's just selective about who its friends are !
--------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
