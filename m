Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C52C47F37
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 05:06:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4500304039
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 03:06:05 -0800 (PST)
Received: from app1b.xlhost.de (mailout173.xlhost.de [84.200.252.173]) by
	cuda.sgi.com with ESMTP id qIV9tJGdGTEm3Dhg for
	<xfs@oss.sgi.com>; Mon, 23 Nov 2015 03:06:02 -0800 (PST)
Received: from [192.168.5.53] (barriere.frankfurter-softwarefabrik.de
	[217.11.197.1]) (Authenticated sender: lkv@5t9.de)
	by app1b.xlhost.de (Postfix) with ESMTPSA id 548303000AEC
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 12:05:59 +0100 (CET)
Message-ID: <5652F311.7000406@5t9.de>
Date: Mon, 23 Nov 2015 12:05:53 +0100
From: Lutz Vieweg <lvml@5t9.de>
MIME-Version: 1.0
Subject: Does XFS support cgroup writeback limiting?
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

in June 2015 the article https://lwn.net/Articles/648292/ mentioned
upcoming support for limiting the quantity of buffered writes
using control groups.

Back then, only ext4 was said to support that feature, with other
filesystems requiring some minor changes to do the same.

The generic cgroup writeback support made it into mainline
linux-4.2, I tried to find information on whether other filesystems
had meanwhile been adapted, but couldn't find this piece of information.

Therefore I'd like to ask: Does XFS (as of linux-4.3 or linux-4.4)
support limiting the quantity of buffered writes using control groups?

Regards,

Lutz Vieweg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
