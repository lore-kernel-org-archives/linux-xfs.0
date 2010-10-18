Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9IF6NK7245075 for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 10:06:24 -0500
Received: from purin.rz.uni-konstanz.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DAFB1E7C801
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 08:07:34 -0700 (PDT)
Received: from purin.rz.uni-konstanz.de (purin.rz.uni-konstanz.de
	[134.34.240.45]) by cuda.sgi.com with ESMTP id i9V49Ct5xhbnTunr
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 08:07:34 -0700 (PDT)
From: "Markus Roth" <Markus.Roth@uni-konstanz.de>
message-id: <2a05-4cbc6280-f8f-3364a400@207442557>
subject: Performance degeneration issues
date: Mon, 18 Oct 2010 17:07:33 +0200
MIME-Version: 1.0
Reply-To: Markus Roth <Markus.Roth@uni-konstanz.de>
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
To: xfs@oss.sgi.com

Hello,

I'm running a Centos 5.4 x64 Server with Raid0 HDDs and XFS.

I did some performance tweaking according to [1] as performance was not good enough with std. options.
Extracting a tar archive with 6.1 million files (avg. Size just below 2KiB) is blazingly fast after the fs has been
generated. But after some time while doing deletes/moves (need to sort those files by their contents) the fs
performance degenerates quite badly (from 8k file writes/sec to about 200).

Is there any way I can find out what the issue is and how I can help it?
(I tried numerous other FSs and of those XFS has left the best impression in my use case)

Tweaks I used:

mkfs.xfs -b size=2048 -l size=64m
mount -o noatime,nodiratime,logbufs=8

I tried playing with the log size and logbufs, but to no avail. I would be thankful if you could give me some 
pointers as I have spent the last 3 weeks fiddling with filesystem etc..

Thanks and Greets from Germany,
Markus Roth

[1] http://everything2.com/index.pl?node_id=1479435

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
