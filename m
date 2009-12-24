Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBONjplI132391 for <xfs@oss.sgi.com>; Thu, 24 Dec 2009 17:45:52 -0600
Received: from tservice.net.ru (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3F051C14AD1
	for <xfs@oss.sgi.com>; Thu, 24 Dec 2009 15:46:33 -0800 (PST)
Received: from tservice.net.ru (broadrack.ru [195.178.208.66]) by cuda.sgi.com
	with ESMTP id zGW0WSvAv6Wn3xJz for <xfs@oss.sgi.com>;
	Thu, 24 Dec 2009 15:46:33 -0800 (PST)
Date: Fri, 25 Dec 2009 02:46:31 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [Jfs-discussion] benchmark results
Message-ID: <20091224234631.GA1028@ioremap.net>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	<19251.26403.762180.228181@tree.ty.sabi.co.uk>
	<20091224212756.GM21594@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091224212756.GM21594@thunk.org>
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
Cc: jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org, Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

Hi Ted.

On Thu, Dec 24, 2009 at 04:27:56PM -0500, tytso@mit.edu (tytso@mit.edu) wrote:
> > Unfortunately there seems to be an overproduction of rather
> > meaningless file system "benchmarks"...
> 
> One of the problems is that very few people are interested in writing
> or maintaining file system benchmarks, except for file system
> developers --- but many of them are more interested in developing (and
> unfortunately, in some cases, promoting) their file systems than they
> are in doing a good job maintaining a good set of benchmarks.  Sad but
> true...

Hmmmm.... I suppose here should be a link to such set? :)
No link? Than I suppose benchmark results are pretty much in sync with
what they are supposed to show.

> > * In the "generic" test the 'tar' test bandwidth is exactly the
> >   same ("276.68 MB/s") for nearly all filesystems.
> > 
> > * There are read transfer rates higher than the one reported by
> >   'hdparm' which is "66.23 MB/sec" (comically enough *all* the
> >   read transfer rates your "benchmarks" report are higher).
> 
> If you don't do a "sync" after the tar, then in most cases you will be
> measuring the memory bandwidth, because data won't have been written
> to disk.  Worse yet, it tends to skew the results of the what happens
> afterwards (*especially* if you aren't running the steps of the
> benchmark in a script).

It depends on the size of untarred object, for linux kernel tarball and
common several gigs of RAM it is very valid not to run a sync after the
tar, since writeback will take care about it.

> > BTW the use of Bonnie++ is also usually a symptom of a poor
> > misunderstanding of file system benchmarking.
> 
> Dbench is also a really nasty benchmark.  If it's tuned correctly, you
> are measuring memory bandwidth and the hard drive light will never go
> on.  :-) The main reason why it was interesting was that it and tbench
> was used to model a really bad industry benchmark, netbench, which at
> one point a number of years ago I/T managers used to decide which CIFS
> server they would buy[1].  So it was useful for Samba developers who were
> trying to do competitive benchmkars, but it's not a very accurate
> benchmark for measuring real-life file system workloads.
> 
> [1] http://samba.org/ftp/tridge/dbench/README

Was not able to resist to write a small notice, what no matter what, but
whatever benchmark is running, it _does_ show system behaviour in one
or another condition. And when system behaves rather badly, it is quite
a common comment, that benchmark was useless. But it did show that
system has a problem, even if rarely triggered one :)

Not an ext4 nitpick of course.

-- 
	Evgeniy Polyakov

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
