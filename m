Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBPGB83X196959 for <xfs@oss.sgi.com>; Fri, 25 Dec 2009 10:11:08 -0600
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BEA381C171CF
	for <xfs@oss.sgi.com>; Fri, 25 Dec 2009 08:11:51 -0800 (PST)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id pekLOZSiIwz7q5ez for <xfs@oss.sgi.com>;
	Fri, 25 Dec 2009 08:11:51 -0800 (PST)
Date: Fri, 25 Dec 2009 11:11:46 -0500
From: tytso@mit.edu
Subject: Re: [Jfs-discussion] benchmark results
Message-ID: <20091225161146.GC32757@thunk.org>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	<19251.26403.762180.228181@tree.ty.sabi.co.uk>
	<20091224212756.GM21594@thunk.org>
	<20091224234631.GA1028@ioremap.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091224234631.GA1028@ioremap.net>
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
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org, Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Fri, Dec 25, 2009 at 02:46:31AM +0300, Evgeniy Polyakov wrote:
> > [1] http://samba.org/ftp/tridge/dbench/README
> 
> Was not able to resist to write a small notice, what no matter what, but
> whatever benchmark is running, it _does_ show system behaviour in one
> or another condition. And when system behaves rather badly, it is quite
> a common comment, that benchmark was useless. But it did show that
> system has a problem, even if rarely triggered one :)

If people are using benchmarks to improve file system, and a benchmark
shows a problem, then trying to remedy the performance issue is a good
thing to do, of course.  Sometimes, though the case which is
demonstrated by a poor benchmark is an extremely rare corner case that
doesn't accurately reflect common real-life workloads --- and if
addressing it results in a tradeoff which degrades much more common
real-life situations, then that would be a bad thing.

In situations where benchmarks are used competitively, it's rare that
it's actually a *problem*.  Instead it's much more common that a
developer is trying to prove that their file system is *better* to
gullible users who think that a single one-dimentional number is
enough for them to chose file system X over file system Y.

For example, if I wanted to play that game and tell people that ext4
is better, I'd might pick this graph:

http://btrfs.boxacle.net/repository/single-disk/2.6.29-rc2/2.6.29-rc2/2.6.29-rc2_Mail_server_simulation._num_threads=32.html

On the other hand, this one shows ext4 as the worst compared to all
other file systems:

http://btrfs.boxacle.net/repository/single-disk/2.6.29-rc2/2.6.29-rc2/2.6.29-rc2_Large_file_random_writes_odirect._num_threads=8.html

Benchmarking, like statistics, can be extremely deceptive, and if
people do things like carefully order a tar file so the files are
optimal for a file system, it's fair to ask whether that's a common
thing for people to be doing (either unpacking tarballs or unpacking
tarballs whose files have been carefully ordered for a particular file
systems).  When it's the only number used by a file system developer
when trying to convince users they should use their file system, at
least in my humble opinion it becomes murderously dishonest.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
