Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7AG1T8N095937
	for <linux-xfs@oss.sgi.com>; Tue, 10 Aug 2010 11:01:31 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C234D16D8947
	for <linux-xfs@oss.sgi.com>; Tue, 10 Aug 2010 09:01:51 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id RRkVzAgvf7Wm9C7h for <linux-xfs@oss.sgi.com>;
	Tue, 10 Aug 2010 09:01:51 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1OirGt-0008GP-IG
	for linux-xfs@oss.sgi.com; Tue, 10 Aug 2010 18:01:47 +0200
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 10 Aug 2010 18:01:47 +0200
Received: from niemayer by barriere.frankfurter-softwarefabrik.de with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 10 Aug 2010 18:01:47 +0200
From: Peter Niemayer <niemayer@isg.de>
Subject: observed significant performance improvement using "delaylog" in
	a real-world application
Date: Tue, 10 Aug 2010 18:01:33 +0200
Message-ID: <i3rt4t$46c$1@dough.gmane.org>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Hi all,

we use XFS for a very I/O-intensive, in-house developed real-time 
database application, and whenever we see new or significantly changed 
file-systems becoming available, we run a benchmark using this 
application on a conserved, fixed real-world data set.

I'm pleased to state that using the experimental "delaylog" mount option 
(in vanilla linux-2.6.35) we measured a 17% performance increase
for our benchmark scenario. (Other mount-options in use both before
and after the "delaylog" option: noatime,nodiratime,nobarrier)

That's a lot given that XFS was the fastest performing file-system
for this application already.

It's also a promising result regarding stability, as several other
tests (using e.g. reiser4 or ceph) in the past led to crashes in the
same benchmark scenario.

So thanks to all contributing developers for this significant optimization!

Regards,

Peter Niemayer


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
