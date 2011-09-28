Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8S1VJX3077483 for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 20:31:19 -0500
Received: from mta31.charter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8EBCA1425ECE
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 18:37:17 -0700 (PDT)
Received: from mta31.charter.net (mta31.charter.net [216.33.127.82]) by
	cuda.sgi.com with ESMTP id d89zwvL9g1GIIyvq for
	<xfs@oss.sgi.com>; Tue, 27 Sep 2011 18:37:17 -0700 (PDT)
Received: from imp11 ([10.20.200.11]) by mta31.charter.net
	(InterMail vM.7.09.02.04 201-2219-117-106-20090629) with ESMTP
	id <20110928013116.OWWX3994.mta31.charter.net@imp11>
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 21:31:16 -0400
Message-ID: <4E8278D8.9060309@cchtml.com>
Date: Tue, 27 Sep 2011 20:31:04 -0500
From: Michael Cronenworth <mike@cchtml.com>
MIME-Version: 1.0
Subject: Re: 64-bit inodes and back again
References: <4E825C25.6050804@cchtml.com> <20110928011020.GE3159@dastard>
In-Reply-To: <20110928011020.GE3159@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/27/2011 08:10 PM, Dave Chinner wrote:
> I'm pretty sure this was fixed in 2.6.37. There's nothing wrong with
> the filesystem, just the kernel code had an arbitrary restriction on
> where inodes code be read from in 32-bit inode mode. That was
> removed in commit d276734 ("xfs: fix bogus m_maxagi check in
> xfs_iget").

OK, great. I'll be moving the system to kernel 3.0 soon.

> xfs_reno is a tool designed to move all 64 bit inodes back into the
> 32 bit inode space again.
>
> http://xfs.org/index.php/Unfinished_work#The_xfs_reno_tool

I'll give this a shot first.

Thanks for the pointers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
