Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4NAGiT8116444 for <xfs@oss.sgi.com>; Sun, 23 May 2010 05:16:44 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9922DA18F80
	for <xfs@oss.sgi.com>; Sun, 23 May 2010 03:20:31 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	LHbKbb0zwXqKodF2 for <xfs@oss.sgi.com>;
	Sun, 23 May 2010 03:20:31 -0700 (PDT)
Date: Sun, 23 May 2010 20:18:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
Message-ID: <20100523101856.GL2150@dastard>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
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
To: Roman Kononov <roman@binarylife.net>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sun, May 23, 2010 at 12:20:23AM -0500, Roman Kononov wrote:
> Under some workload, once per ~10 seconds, I'm getting the following warnings
> with 2.6.32.13 and 2.6.33.4 (x86_64). Why are they?

You've got some workload that is mixing direct IO writes with some
form of buffered or mmap IO on the same file and they are racing.
Mixing different types of IO on the one inode is also known as A
Really Bad Idea because there is no guarantee of coherency between
them....

Can you find out what the application is triggering this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
