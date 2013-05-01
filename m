Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8AE927F37
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 13:06:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7A494304070
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 11:06:55 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id 0S1bua9qlBwfQdMA for
	<xfs@oss.sgi.com>; Wed, 01 May 2013 11:06:52 -0700 (PDT)
Received: from galadriel.home (unknown [82.235.234.79])
	by smtp3-g21.free.fr (Postfix) with ESMTP id C6F55A6289
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 20:06:48 +0200 (CEST)
Date: Wed, 1 May 2013 20:06:33 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Weird message from xfs_repair
Message-ID: <20130501200633.5d24caf5@galadriel.home>
Mime-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


Hi everyone,

I've just had to resort to the latest devel version of xfs_repair to
get back some heavily damaged filesystem (thanks to a failing RAID
controller), and it ended with the following message:

cache_purge: shake on cache 0x672030 left 1 nodes!?

What's this about? I didn't look at the source, but a new run of
xfs_repair detected nothing. 

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
