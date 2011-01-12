Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0CNZKdb014501 for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 17:35:21 -0600
Received: from mail.pzystorm.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F5CE1258982
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 15:37:33 -0800 (PST)
Received: from mail.pzystorm.de (mail.pzystorm.de [188.40.193.4]) by
	cuda.sgi.com with ESMTP id 4vuhGX6DmjFF3KkK for
	<xfs@oss.sgi.com>; Wed, 12 Jan 2011 15:37:33 -0800 (PST)
Received: from 77-22-192-189-dynip.superkabel.de ([77.22.192.189]
	helo=[192.168.178.27])
	by mail.pzystorm.de with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69) (envelope-from <xfs@pzystorm.de>) id 1PdAFu-0005pI-Cn
	for xfs@oss.sgi.com; Thu, 13 Jan 2011 00:37:30 +0100
Message-ID: <4D2E3B38.6010506@pzystorm.de>
Date: Thu, 13 Jan 2011 00:37:28 +0100
From: Kevin Richter <xfs@pzystorm.de>
MIME-Version: 1.0
Subject: Re: Problem with XFS on USB 2TB HD
References: <4D0C9A4F.4040108@pzystorm.de>
	<20101220001024.GH5193@dastard>	<4D0EC5C5.2070407@pzystorm.de>
	<20101220045126.GK5193@dastard>
	<20101220105547.4f9e7218@galadriel.home>
In-Reply-To: <20101220105547.4f9e7218@galadriel.home>
Reply-To: xfs@pzystorm.de
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
Cc: xfs@oss.sgi.com

> That's because you had the misfortune of garbling the root directory
> inode along with the superblock. That's a very specific corruption,
> but if the corruption occurred a few blocks away in a data extent
> you wouldn't even know about it until you restore from backup and
> realised the file content in the backup are corrupted. Indeed - you
> should consider that entire backup as corrupted and redo it from
> scratch.

I am wondering if there is a simple solution to backup/restore the inode
table (the relation "inode <-> filename").

With "ls -aliR" I get a list which I am now saving every few days.
The parameter "-i" displays the inode, that I can reconstruct the
filename from the inode, if this garbling error occurs a second time.

The reconstruction process probably would be a simple "grep | cut" thing.

Is there perhaps a finished script doing exactly this? Or any other ideas?


Bye,
Kevin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
