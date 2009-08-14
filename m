Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7E0R3dp060409 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 19:27:13 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A8531B690B0
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:27:24 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id oU4UeCa5dY1PpjfU for
	<xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:27:24 -0700 (PDT)
Message-ID: <4A84AF6C.3010801@sandeen.net>
Date: Thu, 13 Aug 2009 19:27:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Resizing XFS on GPT partition
References: <200908140148.28810@zmi.at>
In-Reply-To: <200908140148.28810@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:
> I've had a XEN VM with a 90GB disk, increased it to 250GB.
> Then I had the problem that I used GPT partitioning, meaning only 
> "parted" being usable. parted doesn't support resizing partitions for 
> xfs and refuses to do it.
> 
> The simple thing is to delete and recreate with bigger size that 
> partition. Later mount the partition and run xfs_growfs.
> 
> I don't understand why parted doesn't support that, just resizing the 
> partition and not refusing it. :-(

File a bug against parted.  :)

I agree, parted should just resize the partition as you asked and shut
up about anything else.  I'm surprised that it can't - even if the fs is
unmounted?

I have no idea what happened to "do one thing and do it well."  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
