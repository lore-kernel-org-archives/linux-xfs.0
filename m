Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6OL6dUp022699 for <xfs@oss.sgi.com>; Sat, 24 Jul 2010 16:06:39 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C8CB46F382
	for <xfs@oss.sgi.com>; Sat, 24 Jul 2010 14:09:42 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id b4Wpumn5xSNSkIDw for
	<xfs@oss.sgi.com>; Sat, 24 Jul 2010 14:09:42 -0700 (PDT)
Message-ID: <4C4B5696.8060302@sandeen.net>
Date: Sat, 24 Jul 2010 16:09:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: filesystem shrinks after using xfs_repair
References: <F2D7937E-43FC-47F4-B041-B9C5C2CBCCD4@ucsc.edu>
In-Reply-To: <F2D7937E-43FC-47F4-B041-B9C5C2CBCCD4@ucsc.edu>
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
To: Eli Morris <ermorris@ucsc.edu>
Cc: xfs@oss.sgi.com

Eli Morris wrote:
> Hi All,
> 
> I've got this problem where if I run xfs_repair, my filesystem
> shrinks by 11 TB, from a volume size of 62 TB to 51 TB. I can grow
> the filesystem again with xfs_growfs, but then rerunning xfs_repair
> shrinks it back down again. The first time this happened was a few
> days ago and running xfs_repair took about 7 TB of data with it. That
> is, out of the 11 TB of disk space that vanished, 7 TB had data on
> it, and 4 TB was empty space. XFS is running on top of an LVM volume.
> It's on an Intel/Linux system running Centos 5 (2.6.18-128.1.14.el5).

Running 2.6.18-138.el5 and beyond will have a much more uptodate xfs,
just FWIW.

-Eric

> Does anyone have an idea on what would cause such a thing and what I
> might try to keep it from continuing to happen. I could just never
> run xfs_repair again, but that doesn't seem like a good thing to
> count on. Major bonus points if anyone has any ideas on how to get my
> 7 TB of data back also. It must be there somewhere and it would be
> very bad to lose.
> 
> thanks for any help and ideas. I'm just stumped right now.
> 
> Eli _______________________________________________ xfs mailing list 
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
