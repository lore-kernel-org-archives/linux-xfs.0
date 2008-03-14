Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Mar 2008 05:13:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2ECDGf9012144
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 05:13:18 -0700
Received: from node2.t-mail.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 981DAF9D7B9
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 05:13:48 -0700 (PDT)
Received: from node2.t-mail.cz (node2.t-mail.cz [62.141.0.167]) by cuda.sgi.com with ESMTP id A4vZ3xXzSI6iD1RS for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 05:13:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by bl311.tmo.cz (Postfix) with ESMTP id 312A2442
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 13:13:15 +0100 (CET)
Received: from node2.t-mail.cz ([127.0.0.1])
	by localhost (bl311.tmo.cz [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4d2-wFgol-b2 for <xfs@oss.sgi.com>;
	Fri, 14 Mar 2008 13:13:14 +0100 (CET)
Received: from yalta.homelinux.doma (89-24-53-65.i4g.tmcz.cz [89.24.53.65])
	by bl311.tmo.cz (Postfix) with ESMTP id E5FA2AE
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 13:13:13 +0100 (CET)
Received: from AXALTO-9A9B4636.homelinux.doma (AXALTO-9A9B4636.homelinux.doma [192.168.0.95])
	by yalta.homelinux.doma (Postfix) with ESMTP id 8B33A1813D90
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 13:13:13 +0100 (CET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by AXALTO-9A9B4636.homelinux.doma (Postfix) with ESMTP id BDF11349745D
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 13:13:15 +0100 (CET)
Subject: xfs_repair on root filesystem
From: Massimiliano Adamo <maxadamo@gmail.com>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 13:13:15 +0100
Message-Id: <1205496795.16829.6.camel@AXALTO-9A9B4636.homelinux.doma>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,

I have seen that it's possible to run xfs_check on filesystems mounted
read-only, but in order to use xfs_repair the filesystem must be
unmounted.
I can't even imagine how to run xfs_repair on root filesystem, without
booting from a live cd.

Do you think it would be possible to implement xfs_repair on 'ro'
filesystem, or on filesytems frozen with xfs_freeze?

The other question would be about the possibility to shrink a XFS
filesystem... but as I can see this is a work already in progress.

cheers
Massimiliano Adamo
