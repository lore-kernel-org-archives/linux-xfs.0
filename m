Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6O2N0C4094518 for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 21:23:00 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 487F91B596A4
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 19:23:43 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id JvPLPMhqTFXaXds6 for
	<xfs@oss.sgi.com>; Thu, 23 Jul 2009 19:23:43 -0700 (PDT)
Message-ID: <4A691B2D.1090600@sandeen.net>
Date: Thu, 23 Jul 2009 21:23:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Using xfsdump On Linux With IRIX Version 1 FS?
References: <008401ca0bf1$64c2eac0$2e48c040$@com>
In-Reply-To: <008401ca0bf1$64c2eac0$2e48c040$@com>
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
To: Sean Elble <elbles@sessys.com>
Cc: xfs@oss.sgi.com

Sean Elble wrote:
> Hi all,
> 
> While I am aware that the current kernel implementation of XFS doesn't
> support mounting an IRIX filesystem with version 1 directories, I'm not so
> sure whether xfsdump/xfsrestore will support the dumping of an IRIX
> filesystem with version 1 directories.  To be more specific, I am dealing
> with an old disk from an Indigo2, running IRIX 6.5.6m with version 1
> (0x1094) directories.  I was hoping it had version 2 directories, but after
> finding an old SCSI card I could put in a Linux box with XFS support, I
> found just the opposite, obviously.  I had the old SCSI card back in its
> donor system (which was up-and-running) when it occurred to me that
> xfsdump/xfsrestore *might* be a possibility, and I can't take it (the donor
> system) down again unless I know I can make this work.
> 
> If anyone can give me an answer to this question, I would certainly
> appreciate it.  I didn't see anything in the man pages, and my Google
> searches have proven fruitless thus far, but I've been known to be blind on
> occasion.  :-)  Thanks, in advance.
> 

linux used to work with v1 dirs, though there were some problems.  It
never got fixed, was not critical for 99.9% of users, and got taken out.
 But it might work well enough to do what you need.  Go through the
changelogs or google, and try an older Linux kernel, perhaps ....

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
