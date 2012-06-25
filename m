Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5PN5Xcb033994 for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 18:05:33 -0500
Message-ID: <4FE8EEB8.7000101@tlinx.org>
Date: Mon, 25 Jun 2012 16:05:28 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: Strange case of deleting lots of files and "df" not recognizing
	it....(unless I umount/mount) the disk...
References: <4FE7FDF4.6080506@tlinx.org>
	<20120625090211.3c5c2032@galadriel.home>
	<20120625205128.GA29979@sgi.com> <4FE8E14F.3080807@tlinx.org>
	<20120625224554.GQ10196@sgi.com>
In-Reply-To: <20120625224554.GQ10196@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>



Ben Myers wrote:

> 
> Yeah.  13 hours is a long time, esp for something you just removed.  ;)
> 
> Fortunately it's not the data that is cached, it's probably just a pesky dentry
> hanging around on the lru with a single reference on the inode keeping it
> active, preventing xfs from freeing up the blocks.
> 
> I've had some luck on v3.0 with the following patch... it's not yet tested on
> 3.5 so YMMV.  Are you running an NFS server?  Something that often creates
> anonymous dentries?
----
nfs server is running but no clients (usage=rare)
samba server is running and has clients (usage=24/7)...

I wasn't even able to compile the last kernel I tried...my release has been
a bit screwey...

finally got perl to compile, that was another thorn in my side...

(when it rains it pours....)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
