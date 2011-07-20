Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6KJ8NPb244423 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 14:08:23 -0500
Received: from a.mail.sonic.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42B161E683FD
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 12:08:21 -0700 (PDT)
Received: from a.mail.sonic.net (a.mail.sonic.net [64.142.16.245]) by
	cuda.sgi.com with ESMTP id mUEaHI2jRHxB2aNd for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2011 12:08:21 -0700 (PDT)
Received: from localhost.localdomain (wombat.san-francisco.ca.us
	[75.101.60.64])
	by a.mail.sonic.net (8.13.8.Beta0-Sonic/8.13.7) with ESMTP id
	p6KJ8KuE001880 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 12:08:21 -0700
Date: Wed, 20 Jul 2011 12:08:19 -0700
From: Keith Keller <kkeller@sonic.net>
Subject: Re: xfs_growfs doesn't resize (update)
Message-ID: <20110720190819.GA14910@sonic.net>
References: <20110707182532.GA31319@sonic.net> <4E160A34.20902@sandeen.net>
	<20110707222350.GA776@sonic.net> <4E163396.2010707@sandeen.net>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E163396.2010707@sandeen.net>
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
To: xfs@oss.sgi.com

Hello again list!

Back from my vacation, with no problems on the filesystem I
potentially messed up by running xfs_growfs with an old kernel
a few weeks ago.  I was able to take a metadump of the filesystem
by remounting ro, running xfs_metadump, and remounting rw, which did
not seem to cause any obvious problems.  Since then I have been 
throwing the various xfs tools at it to see what I could find out.

The last thing I tried gave an interesting result: I simply
did an mdrestore and attempted a mount over loopback, on a
different machine that is running the latest kernel available
from the CentOS repository (2.6.18-238.9.1.el5).  To my great 
surprise, it mounted cleanly, and reported the correct filesystem
size!  A very cursory glance at the filesystem didn't uncover
any glaring errors (though I forgot to use -o when I ran
xfs_metadump, so filenames are mangled).

The reason I tried this at all was that I got some unexpected
results from xfs_repair in various permutations.  First, just
running it against the restored fs image, I got this error (using
a locally-compiled xfsprogs-3.1.5, not the xfsprogs CentOS
package--all references to xfsprogs programs will be this version
unless stated otherwise):

Phase 1 - find and verify superblock...
would write modified primary superblock
Primary superblock would have been modified.
Cannot proceed further in no_modify mode.
Exiting now.

That wasn't a huge surprise, so I reran xfs_repair without -n, and
got many errors like so:

bad directory block magic # 0 in block 0 for directory inode 16359537
corrupt block 0 in directory inode 16359537
        will junk block

When I examined the files added to lost+found, there were a large number
of them, but they all were owned by the same user and generated within
a few days of each other.  (Are owner and group UIDs preserved by a
metadump?  It would seem so.)  I thought this was curious, and wasn't
sure exactly what was going on, so I ran the xfs_db alterations that
I asked about in a previous post (basically resetting dblocks and agcount
to the values from sb 1) and ran xfs_repair on the modified image.  This
time, running with -n succeeded fine, but reported that it would fix
almost the same set of errors that the first xfs_repair did report that
it tried to fix.  So, I am wondering if those files are truly damaged,
and something else caused the filesystem inconsistency, not xfs_growfs.
(The dates on the files in lost+found are about a week after we had a
power outage, but months before my failed xfs_growfs attempt.)

At this point, I really don't know what to try next.  I still have the
metadump, so I can do pretty much anything I want to it to try to narrow
down the best course of action on the actual filesystem.  What information
would be most helpful for me to report?  If it would help to see the
actual output from xfs_repair, it's almost certainly too big to post to
the list, but I can make them available over http.

Just for posterity's sake, xfs_metadump on my almost-full 11TB filesystem
took about 15 minutes, and generated a ~6.7GB dump file.  Restoring this
dump to a sparse file takes about 4 minutes.  xfs_repair takes about 30-45
minutes on these images (I haven't been tracking the times that
carefully).  I'm sure running these tools on an actual 11TB filesystem
would take a whole lot longer, so having the metadump is really a great
tool for this kind of work.

Thanks for reading!

--keith



-- 
kkeller@sonic.net

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
