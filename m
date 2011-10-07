Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p971bewS211832 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 20:37:41 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 984941B3ADB
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 18:37:38 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	yUnzRjGD74IQlsWW for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 18:37:38 -0700 (PDT)
Date: Fri, 7 Oct 2011 12:37:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Premature "No Space left on device" on XFS
Message-ID: <20111007013711.GW3159@dastard>
References: <4E8E079B.4040103@birkenwald.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E8E079B.4040103@birkenwald.de>
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
To: Bernhard Schmidt <berni@birkenwald.de>
Cc: xfs@oss.sgi.com

On Thu, Oct 06, 2011 at 09:55:07PM +0200, Bernhard Schmidt wrote:
> Hi,
> 
> this is an XFS-related summary of a problem report I sent to the
> postfix mailinglist a few minutes ago after a bulkmail test system
> blew up during a stress test.
> 
> We have a few MTAs running SLES11.1 amd64 (2.6.32.45-0.3-default),
> 10 GB XFS Spooldirectory with default blocksize (4k). It was
> bombarded with mails faster than it could send them on, which
> eventually led to almost 2 million files of ~1.5kB in one directory.
> Suddenly, this started to happen
> 
> lxmhs45:/var/spool/postfix-bulk/postfix-bulkinhss # touch a
> touch: cannot touch `a': No space left on device
> lxmhs45:/var/spool/postfix-bulk/postfix-bulkinhss # df .
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sdb              10475520   7471160   3004360  72%

So you have a 10GB filesystem, with about 3GB of free space.

> /var/spool/postfix-bulk
> lxmhs45:/var/spool/postfix-bulk/postfix-bulkinhss # df -i .
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/sdb             10485760 1742528 8743232   17% /var/spool/postfix-bulk

And with 1.7 million inodes in it. That's a lot for a tiny
filesystem, and not really a use case that XFS is well suited to.
XFS will work, but it won't age gracefully under these conditions...

As it is, your problem is most likely fragmented free space (an
aging problem). Inodes are allocated in chunks of 64, so require an
-aligned- contiguous 16k extent for the default 256 byte inode size.
If you have no aligned contiguous 16k extents free then inode
allocation will fail.

Running 'xfs_db -r "-c freesp -s" /dev/sdb' will give you a
histogram of free space extents in the filesystem, which will tell
us if you are hitting this problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
