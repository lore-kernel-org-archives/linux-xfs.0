Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4NELPV6125472 for <xfs@oss.sgi.com>; Sun, 23 May 2010 09:21:26 -0500
Received: from out3.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 167C23678C0
	for <xfs@oss.sgi.com>; Sun, 23 May 2010 07:23:46 -0700 (PDT)
Received: from out3.smtp.messagingengine.com (out3.smtp.messagingengine.com
	[66.111.4.27]) by cuda.sgi.com with ESMTP id x3HbUoczSuBvNVNf
	for <xfs@oss.sgi.com>; Sun, 23 May 2010 07:23:46 -0700 (PDT)
Date: Sun, 23 May 2010 09:23:44 -0500
From: Roman Kononov <roman@binarylife.net>
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
Message-ID: <20100523092344.0fcaab42@aaa.pulp.binarylife.net>
In-Reply-To: <20100523101856.GL2150@dastard>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 2010-05-23, 20:18:56 +1000, Dave Chinner <david@fromorbit.com> wrote:
> You've got some workload that is mixing direct IO writes with some
> form of buffered or mmap IO on the same file and they are racing.
> Mixing different types of IO on the one inode is also known as A
> Really Bad Idea because there is no guarantee of coherency between
> them....
> 
> Can you find out what the application is triggering this?

This is severely modified Postgresql, which does mix direct IO with
buffered one.

You say "they are racing". Do you mean that this can cause file system
corruption? Doest it simply warn that direct user data races with
buffered user data and one of them wins? This warning "taints" the
kernel. Should it be safe to do different types of IOs on different
non-overlapping 4-KiB-aligned regions of the same file (I am unsure
if this is what the application really does)?

Thanks,

Roman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
