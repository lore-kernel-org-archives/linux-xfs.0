Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o04GSm3U128750 for <xfs@oss.sgi.com>; Mon, 4 Jan 2010 10:28:49 -0600
Received: from rcsinet12.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9081D1C283C3
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2010 08:29:30 -0800 (PST)
Received: from rcsinet12.oracle.com (rcsinet12.oracle.com [148.87.113.124]) by
	cuda.sgi.com with ESMTP id 8dXPa4XXXagT0Uyn for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2010 08:29:30 -0800 (PST)
Date: Mon, 4 Jan 2010 11:27:48 -0500
From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Jfs-discussion] benchmark results
Message-ID: <20100104162748.GA11932@think>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	<19251.26403.762180.228181@tree.ty.sabi.co.uk>
	<20091224212756.GM21594@thunk.org>
	<20091224234631.GA1028@ioremap.net>
	<20091225161146.GC32757@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091225161146.GC32757@thunk.org>
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
To: tytso@mit.edu
Cc: xfs@oss.sgi.com, linux-nilfs@vger.kernel.org, reiserfs-devel@vger.kernel.org, Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, ext-users <ext3-users@redhat.com>, jfs-discussion@lists.sourceforge.net, Evgeniy Polyakov <zbr@ioremap.net>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Fri, Dec 25, 2009 at 11:11:46AM -0500, tytso@mit.edu wrote:
> On Fri, Dec 25, 2009 at 02:46:31AM +0300, Evgeniy Polyakov wrote:
> > > [1] http://samba.org/ftp/tridge/dbench/README
> > 
> > Was not able to resist to write a small notice, what no matter what, but
> > whatever benchmark is running, it _does_ show system behaviour in one
> > or another condition. And when system behaves rather badly, it is quite
> > a common comment, that benchmark was useless. But it did show that
> > system has a problem, even if rarely triggered one :)
> 
> If people are using benchmarks to improve file system, and a benchmark
> shows a problem, then trying to remedy the performance issue is a good
> thing to do, of course.  Sometimes, though the case which is
> demonstrated by a poor benchmark is an extremely rare corner case that
> doesn't accurately reflect common real-life workloads --- and if
> addressing it results in a tradeoff which degrades much more common
> real-life situations, then that would be a bad thing.
> 
> In situations where benchmarks are used competitively, it's rare that
> it's actually a *problem*.  Instead it's much more common that a
> developer is trying to prove that their file system is *better* to
> gullible users who think that a single one-dimentional number is
> enough for them to chose file system X over file system Y.

[ Look at all this email from my vacation...sorry for the delay ]

It's important that people take benchmarks from filesystem developers
with a big grain of salt, which is one reason the boxacle.net results
are so nice.  Steve more than willing to take patches and experiment to
improve a given FS results, but his business is a fair representation of
performance and it shows.

> 
> For example, if I wanted to play that game and tell people that ext4
> is better, I'd might pick this graph:
> 
> http://btrfs.boxacle.net/repository/single-disk/2.6.29-rc2/2.6.29-rc2/2.6.29-rc2_Mail_server_simulation._num_threads=32.html
> 
> On the other hand, this one shows ext4 as the worst compared to all
> other file systems:
> 
> http://btrfs.boxacle.net/repository/single-disk/2.6.29-rc2/2.6.29-rc2/2.6.29-rc2_Large_file_random_writes_odirect._num_threads=8.html
> 
> Benchmarking, like statistics, can be extremely deceptive, and if
> people do things like carefully order a tar file so the files are
> optimal for a file system, it's fair to ask whether that's a common
> thing for people to be doing (either unpacking tarballs or unpacking
> tarballs whose files have been carefully ordered for a particular file
> systems).

I tend to use compilebench for testing the ability to create lots of
small files, which puts the file names into FS native order (by
unpacking and then readdiring the results) before it does any timings.

I'd agree with Larry that benchmarking is most useful to test a theory.
Here's a patch that is supposed to do xyz, is that actually true.  With
that said we should also be trying to write benchmarks that show the
worst case...we know some of our design weakness and should be able to
show numbers for how bad it really is (see the random write
btrfs.boxacle.net tests for that one).

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
