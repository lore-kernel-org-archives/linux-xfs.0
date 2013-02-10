Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 660CD7F51
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2013 01:14:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EBCDEAC005
	for <xfs@oss.sgi.com>; Sat,  9 Feb 2013 23:14:18 -0800 (PST)
Received: from mail.six-q.net (mail.six-q.net [176.62.184.14]) by cuda.sgi.com
	with ESMTP id G32ocVVX06dgFiws (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 09 Feb 2013 23:14:14 -0800 (PST)
Received: from [192.168.1.2] by mail.six-q.net with esmtp (Exim 4.80.1)
	(envelope-from <nowhere@hakkenden.ath.cx>) id 1U4R73-00019W-UJ
	for xfs@oss.sgi.com; Sun, 10 Feb 2013 11:14:11 +0400
Message-ID: <1360480449.4034.8.camel@hakkenden.homenet>
Subject: xfs_inode slab
From: "Nikolay S." <nowhere@hakkenden.ath.cx>
Date: Sun, 10 Feb 2013 11:14:09 +0400
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
To: xfs@oss.sgi.com

Hello there,

I see some bad behavior of xfs, which I can reproduce:

1. Create some directories and files on xfs volume (I use ~800000 files
and 80000 directories on 4GB RAM system)
2. Create workload, that produces light page cache pressure (say, 4-8
MB/s) and while pagecache eats all of free ram. I use the code from [1])
3. Stat all the objects on xfs volume

The result depends on kernel version:
	3.2) See kswapd struggling through D-state for several minutes.
	3.7) See kswapd struggling through D-state forever

Same steps on ext4 do not produce any bad results

--
[1]	https://bugzilla.kernel.org/show_bug.cgi?id=53031

[2]


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
