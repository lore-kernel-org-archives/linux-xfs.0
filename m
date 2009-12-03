Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB31KXgC056981 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 19:20:33 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D791A1348DDB
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 17:21:02 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	ayPEsQEmk6tHnWHd for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2009 17:21:02 -0800 (PST)
Date: Thu, 3 Dec 2009 12:05:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Performance problem with multiple parallel rm -rf's
Message-ID: <20091203010526.GR30608@discord.disaster>
References: <4B163B20.6030808@syseleven.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B163B20.6030808@syseleven.de>
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
To: Jens Rosenboom <j.rosenboom@syseleven.de>
Cc: xfs@oss.sgi.com

On Wed, Dec 02, 2009 at 11:02:08AM +0100, Jens Rosenboom wrote:
> On a large 13TB XFS volume that is being used for backups, I am seeing  
> bad performance if multiple "rm -rf" processes are running in parallel.  
> The backups are being done with rsnapshot and the first operation it  
> does is removing the oldest snapshot. A single rsnapshot does this in  
> reasonable time, but if four jobs are started at the same time, all  
> their rm processes run for hours without making much progress.
>
> This seems to be related to the planned optimizations in
>
> http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead

Not directly, I think. More likely is the effect of cold caches
on the inode read rate.

That is, if you are running cold-cache 'rm -rf' operations, there is
a substantial amount of *read* IO executed to pull the inodes into
memory before they are unlinked. (i.e. an unlink is roughly
1 read IO and two write IOs).

If you are doing multiple cold-cache 'rm -rf' in parallel, you
will be causing more disk seeks for reading the inodes you are
trying to unlink, and as such this will slow down the unlink rate
as the unlink can only go as fast as the inodes can be read off
disk.

Effectively there is not much you can do about this - you could try
doing a traversal of the old snapshot first (e.g
ls -lR <snapshot> > /dev/null) to get the cache populated as fast as
possible before doing the unlink traversal, but that requires you
have plenty of memory available (i.e. to hold more inodes than
multiple parallel snapshot traversals will read).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
