Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n57ItqJm184689
	for <linux-xfs@oss.sgi.com>; Sun, 7 Jun 2009 13:55:52 -0500
Received: from foehn.mgras.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E13F2DA9A9
	for <linux-xfs@oss.sgi.com>; Sun,  7 Jun 2009 11:56:11 -0700 (PDT)
Received: from foehn.mgras.de (quickstep.mgras.net [213.146.115.59]) by
	cuda.sgi.com with ESMTP id G94rssRhQCAiyXpS for
	<linux-xfs@oss.sgi.com>; Sun, 07 Jun 2009 11:56:11 -0700 (PDT)
Received: from osprey.mgras.de (osprey.mgras.de [192.168.48.3])
	by foehn.mgras.de (8.13.1/8.13.0) with ESMTP id n57ItMcF029646
	for <linux-xfs@oss.sgi.com>; Sun, 7 Jun 2009 20:55:22 +0200 (CEST)
Received: (from news@localhost) by osprey.mgras.de (AIX5.1/8.11.6p2/8.11.0) id
	n57ItL612510 for linux-xfs@oss.sgi.com;
	Sun, 7 Jun 2009 20:55:21 +0200
From: Martin Spott <Martin.Spott@mgras.net>
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Sun, 7 Jun 2009 18:55:21 +0000 (UTC)
Message-ID: <h0h2ep$8p0$1@osprey.mgras.de>
References: <20090520003745.GA27491@samad.com.au>
	<20090604112657.GA10738@infradead.org>
	<4A2C0698.9060800@sandeen.net>
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

Eric Sandeen wrote:

> CONFIG_XFS_DEBUG is more of addded checks and asserts, not so much in
> the way of extra messages - at least, until you actually hit a problem.

The problem I see is actually not logged as a crash in the 'usual' way
(panics, oopses, traces the way I know), instead, the issue
materializes in tons of messages of the sort:

reconnect_path: npd != pd
reconnect_path: npd != pd
reconnect_path: npd != pd


....  on a thorougly checked filesystem, plus the NFS service ceasing
to serve clients. Obviously this is not covered by the added checks
which are introduced by CONFIG_XFS_DEBUG.

Cheers,
	Martin.
-- 
 Unix _IS_ user friendly - it's just selective about who its friends are !
--------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
