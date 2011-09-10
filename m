Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8ACNRft100853 for <xfs@oss.sgi.com>; Sat, 10 Sep 2011 07:23:28 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5469D13DCD86
	for <xfs@oss.sgi.com>; Sat, 10 Sep 2011 05:27:45 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id zMP9cTHLNRUlOxM2
	for <xfs@oss.sgi.com>; Sat, 10 Sep 2011 05:27:45 -0700 (PDT)
Subject: xfs deadlock in stable kernel 3.0.4
From: Stefan Priebe <s.priebe@profihost.ag>
Message-Id: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
Date: Sat, 10 Sep 2011 14:23:12 +0200
Mime-Version: 1.0 (iPhone Mail 8H7)
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>

Hello List,

on some of our heavy loaded servers using xfs we're seeing a deadlock where reading/writing to the xfs filesystem suddenly stops working.

Here you can find sysrq w triggered log messages of the locked processes.

http://pastebin.com/JWjrbrh4

Please help! Thanks!

Please cc me i'm not subscribed.

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
