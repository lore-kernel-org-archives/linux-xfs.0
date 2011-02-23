Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1NLqiQk085889 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 15:52:45 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CD9312E0259
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 13:55:28 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GHT88YORnC7rSohy for <xfs@oss.sgi.com>;
	Wed, 23 Feb 2011 13:55:28 -0800 (PST)
Date: Thu, 24 Feb 2011 08:55:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Input/Output error
Message-ID: <20110223215525.GK3166@dastard>
References: <4D63D9D8.3060204@storegrid.com> <4D641AB1.7010101@sandeen.net>
	<4D64AA28.9050207@storegrid.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D64AA28.9050207@storegrid.com>
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
To: Srinivasan T <srinivasan@storegrid.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Feb 23, 2011 at 12:03:12PM +0530, Srinivasan T wrote:
> Hi Eric,
> 
> There is enough disk space in the fs.
> 
> [root@domU-12-31-39-07-81-36 StoreGrid]# df -lh
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda1             9.9G  2.9G  6.6G  31% /
> /dev/sdb              147G  188M  140G   1% /mnt
> none                  854M     0  854M   0% /dev/shm
> /dev/sdh              5.0G   25M  5.0G   1% /mymountpoint
> 
> Also, the output of modinfo is as follows,
> 
> [root@domU-12-31-39-07-81-36 StoreGrid]# modinfo xfs
> filename:       /lib/modules/2.6.21.7-2.fc8xen/kernel/fs/xfs/xfs.ko
> license:        GPL
> description:    SGI XFS with ACLs, security attributes, large block
> numbers, no debug enabled
> author:         Silicon Graphics, Inc.
> srcversion:     C7114C18263E3067C64F2BC
> depends:
> vermagic:       2.6.21-2952.fc8xen SMP mod_unload 686 4KSTACKS
                                                        ^^^^^^^^

That's another potential cause of the problem, though blowing a
stack normally results in a crash rather than a shutdown...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
