Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5567C7F4E
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 16:07:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 241F2304087
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 14:07:41 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FKLDKlZAUM3vnNwW for <xfs@oss.sgi.com>;
	Tue, 20 May 2014 14:07:36 -0700 (PDT)
Date: Wed, 21 May 2014 07:07:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: a maybe silly question about xfsdump
Message-ID: <20140520210732.GI8554@dastard>
References: <33dfdd6d469a5be58f79cbf0f0222c51@zbfmail.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <33dfdd6d469a5be58f79cbf0f0222c51@zbfmail.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: weber@zbfmail.de
Cc: Xfs <xfs@oss.sgi.com>

On Tue, May 20, 2014 at 05:33:15PM +0200, Marko Weber|8000 wrote:
> 
> hello, again me ;-)
> 
> i use at runtime this command to backup root partition of a server:
> 
> xfsdump -f /var/backup/root2.dump -l 0 -p 5 -L rootdump -M rootdump /
> 
> 
> i googled around alot, cause a question wont get out of my mind:
> is this backup consistent?
> And what about consistency when i backup a mysql partition at runtime?

First, define consistent....

If you define consistent as a point in time snapshot where
everything is from the same point in time, then xfsdump does not
provide you with that. You need to quiese mysql and snapshot the
filesystem, then backup the snapshot to get a consistent point in
time backup of the filesytem from the application data all the way
down to the filesystem metadata.

That's no different to any other backup process - even if you are
using btrfs you still need to quiesce the application to get a
consistent snapshot of the application data in the filesystem
snapshot that you are backing up....

> but my most wondering is abot this:
> 
> bunka ~ # df -h
> Filesystem                     Size  Used Avail Use% Mounted on
> /dev/root                      135G   11G  125G   8% /
> 
> 
> but the saved dump shows:
> 
> 
> bunka ~ # ls -lh /var/backup/
> 
> -rw-r--r-- 1 root root 8.4G May 20 17:29 root2.dump

xfsdump stores information in a more compact form than the
filesystem does on disk. It doesn't need all the metadata the
filesystem has on disk to reference all the data you are backing
up...

Also, they may be some files maked as "no dump" that will be
skipped, and other files that (e.g. iopen, unlinked tmpfiles) can't
be found via a directory traversal and so aren't backed up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
