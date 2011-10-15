Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9FM9SO6136726
	for <linux-xfs@oss.sgi.com>; Sat, 15 Oct 2011 17:09:28 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E36AF1CDD2A
	for <linux-xfs@oss.sgi.com>; Sat, 15 Oct 2011 15:09:25 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	JjAxZMDgGxxfeZEO for <linux-xfs@oss.sgi.com>;
	Sat, 15 Oct 2011 15:09:25 -0700 (PDT)
Date: Sun, 16 Oct 2011 09:09:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: tasks hangs in D state while writing to xfs
Message-ID: <20111015220922.GR3159@dastard>
References: <j7bs98$5bs$1@dough.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <j7bs98$5bs$1@dough.gmane.org>
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
To: Marcin M <gmane@mejor.pl>
Cc: linux-xfs@oss.sgi.com

On Sat, Oct 15, 2011 at 01:54:15PM +0200, Marcin M wrote:
> Hello!
> I've noticed strange problem with xfs. I've created filesystem with
> blocksize=1024 and log as small as it possible. Next i'm copying files
> using rsync, after sometime rsync hangs in D state. So i can't kill it,
> i've got to reboot hosts. In dmesg i'm getting such messages:

Known problem - it's a log space hang. You can often get stuff
moving again via "echo 2 > /proc/sys/vm/drop_caches".

That said, Christoph's fixes for the 3.0.x kernel series are here:

http://oss.sgi.com/archives/xfs/2011-10/msg00305.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
