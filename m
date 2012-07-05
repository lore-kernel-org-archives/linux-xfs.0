Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q65CirbU064165 for <xfs@oss.sgi.com>; Thu, 5 Jul 2012 07:44:54 -0500
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id qSg7nLGHASd5C7JQ for <xfs@oss.sgi.com>;
	Thu, 05 Jul 2012 05:44:52 -0700 (PDT)
Date: Thu, 5 Jul 2012 05:44:50 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 3.5.0-rc5: inconsistent lock state
In-Reply-To: <20120705074307.GA28127@infradead.org>
Message-ID: <alpine.DEB.2.01.1207050535420.5568@trent.utfs.org>
References: <alpine.DEB.2.01.1207041206390.5568@trent.utfs.org>
	<20120705074307.GA28127@infradead.org>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, 5 Jul 2012 at 03:43, Christoph Hellwig wrote:
> See my "do not take the iolock in inode reclaim context" series from
> yesterday, which should take care of this.

OK, good. I'll wait until this hits mainline then.

> Btw, if you hit this it's a sign you have out of the inode attributes,
> so if this isn't just a single inode with them you might be better off
> using larger inodes.

..."(run) out of inode attributes" - not really sure what that means and 
why that would be the case.

And "using larger inodes" sounds like a 
reformat with a larger "-i size=" option. Is there a way to find out my 
current inode size? "mkfs.xfs -N" does not print its default values on a 
mounted filesystem and I'm pretty sure I've used the default values when I 
created the filesystem a while ago (i.e. just plain "mkfs.xfs" w/o any 
options)

Thanks,
Christian.
-- 
BOFH excuse #109:

The electricity substation in the car park blew up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
