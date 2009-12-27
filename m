Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBRMWWmN212282 for <xfs@oss.sgi.com>; Sun, 27 Dec 2009 16:32:33 -0600
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FE24EA1E57
	for <xfs@oss.sgi.com>; Sun, 27 Dec 2009 14:33:17 -0800 (PST)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id KZFz67wrZnhyos3a for <xfs@oss.sgi.com>;
	Sun, 27 Dec 2009 14:33:17 -0800 (PST)
Date: Sun, 27 Dec 2009 17:33:07 -0500
From: tytso@mit.edu
Subject: Re: [Jfs-discussion] benchmark results
Message-ID: <20091227223307.GA4429@thunk.org>
References: <19251.26403.762180.228181@tree.ty.sabi.co.uk>
	<20091224212756.GM21594@thunk.org>
	<alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
	<20091225161453.GD32757@thunk.org>
	<20091225162238.GB19303@bitmover.com>
	<alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de>
	<4B36333B.3030600@hp.com> <4B365EBE.5050804@nerdbynature.de>
	<4B37BA76.7050403@hp.com>
	<alpine.DEB.2.01.0912271346240.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0912271346240.3483@bogon.housecafe.de>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-ext4@vger.kernel.org, Larry McVoy <lm@bitmover.com>, reiserfs-devel@vger.kernel.org, ext-users <ext3-users@redhat.com>, jim owens <jowens@hp.com>, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

On Sun, Dec 27, 2009 at 01:55:26PM -0800, Christian Kujau wrote:
> On Sun, 27 Dec 2009 at 14:50, jim owens wrote:
> > And I don't even care about comparing 2 filesystems, I only care about
> > timing 2 versions of code in the single filesystem I am working on,
> > and forgetting about hardware cache effects has screwed me there.  
> 
> Not me, I'm comparing filesystems - and when the HBA or whatever plays 
> tricks and "sync" doesn't flush all the data, it'll do so for every tested 
> filesystem. Of course, filesystem could handle "sync" differently, and 
> they probably do, hence the different times they take to complete. That's 
> what my tests are about: timing comparision (does that still fall under 
> the "benchmark" category?), not functional comparision. That's left as a 
> task for the reader of these results: "hm, filesystem xy is so much faster 
> when doing foo, why is that? And am I willing to sacrifice e.g. proper 
> syncs to gain more speed?"

Yes, but given many of the file systems have almost *exactly* the same
bandwidth measurement for the "cp" test, and said bandwidth
measurement is 5 times the disk bandwidith as measured by hdparm, it
makes me suspect that you are doing this:

/bin/time /bin/cp -r /source/tree /filesystem-under-test
sync
/bin/time /bin/rm -rf /filesystem-under-test/tree
sync

etc.

It is *a* measurement, but the question is whether it's a useful
comparison.  Consider two different file systems.  One file system
which does a very good job making sure that file writes are done
contiguously to disk, minimizing seek overhead --- and another file
system which is really crappy at disk allocation, and writes the files
to random locations all over the disk.  If you are only measuring the
"cp", then the fact that filesystem 'A' has a very good layout, and is
able to write things to disk very efficiently, and filesystem 'B' has
files written in a really horrible way, won't be measured by your
test.  This is especially true if, for example, you have 8GB of memory
and you are copying 4GB worth of data.

You might notice it if you include the "sync" in the timing, i.e.:

/bin/time /bin/sh -c "/bin/cp -r /source/tree /filesystem-under-test;/bin/sync"

> Again, I don't argue with "hardware caches will have effects", but that's 
> not the point of these tests. Of course hardware is different, but 
> filesystems are too and I'm testing filesystems (on the same hardware).

The question is whether your tests are doing the best job of measuring
how good the filesystem really is.  If your workload is one where you
will only be copying file sets much smaller than your memory, and you
don't care about when the data actually hits the disk, only when
"/bin/cp" returns, then sure, do whatever you want.  But if you want
the tests to have meaning if, for example, you have 2GB of memory and
you are copying 8GB of data, or if later on will be continuously
streaming data to the disk, and sooner or later the need to write data
to the disk will start slowing down your real-life workload, then not
including the time to do the sync in the time to copy your file set
may cause you to assume that filesystems 'A' and 'B' are identical in
performance, and then your filesystem comparison will end up
misleading you.

The bottom line is that it's very hard to do good comparisons that are
useful in the general case.

Best regards,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
