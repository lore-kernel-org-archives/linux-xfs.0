Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p22K9xPg042447
	for <linux-xfs@oss.sgi.com>; Wed, 2 Mar 2011 14:10:00 -0600
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B185AA5C02D
	for <linux-xfs@oss.sgi.com>; Wed,  2 Mar 2011 12:12:48 -0800 (PST)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id mKZFJRJ2ro3LL0yM
	for <linux-xfs@oss.sgi.com>; Wed, 02 Mar 2011 12:12:48 -0800 (PST)
Received: by bwg12 with SMTP id 12so604080bwg.26
	for <linux-xfs@oss.sgi.com>; Wed, 02 Mar 2011 12:12:48 -0800 (PST)
Message-ID: <4D6EA4BB.5050703@gmail.com>
Date: Wed, 02 Mar 2011 21:12:43 +0100
From: Zdenek Kaspar <zkaspar82@gmail.com>
MIME-Version: 1.0
Subject: Re: xfs 14TB - check
References: <31051172.post@talk.nabble.com>
In-Reply-To: <31051172.post@talk.nabble.com>
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
To: tramper <michael.weingartner@tuwien.ac.at>
Cc: linux-xfs@oss.sgi.com

Dne 2.3.2011 17:57, tramper napsal(a):
> 
> Hallo Forum,
> 
> i formated a storage with 16 disks (Raid5  and sparedrive) with xfs. The
> volume is 14TB big. There where circuit Problems and we had several server
> shutdowns and Problems.
> Now I want to check my xfs Partition.
> 
> i used xfs_repair /dev/cciss/c0...p1 and got the following error message:
> 
> fatal error -- couldn't allocate block map, size XXXXXXX
> 
> I have 2 GB of Ram in the machine.
> 
> What should I do and how to check my volume?
> 
> with kind regards
> traper

Try big temporary swap for this purpose..

HTH, Z.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
