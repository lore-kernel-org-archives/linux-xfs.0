Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9J4NE0O082812 for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 23:23:15 -0500
Received: from kaylee.flamingspork.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3341A1936D96
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 21:24:26 -0700 (PDT)
Received: from kaylee.flamingspork.com (kaylee.flamingspork.com
	[74.207.245.61]) by cuda.sgi.com with ESMTP id GwUUuznBVjjpRqgx
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 21:24:26 -0700 (PDT)
From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: XFS use within multi-threaded apps
In-Reply-To: <AANLkTi=w1o8EF6-M7o8Qi9VpY-10m+MCR8U+K1_Aze=g@mail.gmail.com>
References: <AANLkTi=w1o8EF6-M7o8Qi9VpY-10m+MCR8U+K1_Aze=g@mail.gmail.com>
Date: Tue, 19 Oct 2010 15:24:24 +1100
Message-ID: <87eibm4xon.fsf@willster.local.flamingspork.com>
MIME-Version: 1.0
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
To: Angelo McComis <angelo@mccomis.com>, xfs@oss.sgi.com

On Mon, 18 Oct 2010 09:42:04 -0400, Angelo McComis <angelo@mccomis.com> wrote:
> I have a use case where I'd like to forward the use of XFS. This is for
> large (multi-GB, say anywhere from 5GB to 300GB) individual files, such as
> what you'd see under a database's data file / tablespace.

The general advice from not only those of us who hack on database
systems for a living (and hobby), but those that also run it in
production on more systems than you'll ever be able to count is this for
database system performance tuning (i.e. after making your SQL not
completely nuts)

Step 1) Use XFS.

Nothing, and I do mean nothing comes close to reliability and consistent
performance.

We've seen various benchmarks where X was faster.... most of the
time. Then suddenly your filesystem takes a mutex for 15 seconds and
you're database performance goes down the crapper.

> My database vendor (who, coincidentally markets their own filesystems and
> operating systems) says that there are certain problems under XFS with
> specific mention of corruption issues, if a single root or the metadata
> become corrupted, the entire filesystem is gone, and it has performance
> issues on a multi-threaded workload, caused by the single root filesystem
> for metadata becoming a bottleneck.

XFS has anything but performance problems on multithreaded
workloads. It is *the* best of the Linux filesystems
(actually... possibly any file system anywhere) for multithreaded
IO. You can either benchmark it or go and read the source - check out
the direct IO codepaths and what locks get taken (or rather, what locks
aren't taken).

Generally speaking, most DBMSs don't do much filesystem metadata
operations, the most common being extending the data file. So what you
really care about is multithreaded direct IO performance, scalability
and reliability.

> This feedback from the vendor is surely taken with a grain of salt as they
> have marketing motivations of their own product to consider.

If the vendor is who I suspect, and the filesystem being pushed is
starting with two letters down the alphabet than XFS... I
wouldn't. While a great file system for a number of applications, it is
nowhere near ready for big database IO loads - to the extent that last I
heard it still wasn't being recommended for the various DBs I care about
(at least by the DB support guys).
-- 
Stewart Smith

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
