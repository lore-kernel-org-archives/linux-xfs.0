Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5CB5A7F37
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 21:38:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4AB0D8F8035
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 19:38:17 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	mnUDnmeZyJSGr9ox for <xfs@oss.sgi.com>;
	Thu, 11 Jul 2013 19:38:15 -0700 (PDT)
Date: Fri, 12 Jul 2013 12:38:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Corruption of root fs during git bisect of drm system hang
Message-ID: <20130712023812.GB5228@dastard>
References: <20130710090634.GA356@x4> <20130711003122.GR3438@dastard>
	<20130711033621.GB362@x4> <20130711035827.GA3438@dastard>
	<51DE30BC.1050905@hardwarefreak.com> <20130711090755.GA363@x4>
	<20130711112826.GA363@x4> <51DF1463.1070603@hardwarefreak.com>
	<20130711204033.GA355@x4>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130711204033.GA355@x4>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On Thu, Jul 11, 2013 at 10:40:33PM +0200, Markus Trippelsdorf wrote:
> On 2013.07.11 at 15:24 -0500, Stan Hoeppner wrote:
> > On 7/11/2013 6:28 AM, Markus Trippelsdorf wrote:
> > ...
> > >> Looking at the source:
> > >> http://api.kde.org/4.10-api/kdelibs-apidocs/kdecore/html/ksavefile_8cpp_source.html#l00219
> > >> it appears that one can set an environment variable KDE_EXTRA_FSYNC to
> > >> address this issue.
> > >>
> > >> However in my case it doesn't help. Even with KDE_EXTRA_FSYNC=1 I still
> > >> loose my KDE settings in case of a crash. So the whole fsync thing might
> > >> be a red herring.
> > > 
> > > It turned out that the KDE_EXTRA_FSYNC variable doesn't affect KDE
> > > config file handling at all.
> > > So I've added an fsync in kconfigini.cpp (KConfigIniBackend::writeConfig)
> > > and now I don't loose my settings anymore during kernel crash testing.
> > > 
> > > That is until xfs eats my KDE config files (kwinrulesr in this case):
> > 
> > Adding fsync in kconfigini.cpp apparently doesn't force fsync for all
> > KDE file operations.  You also have some Open Office files getting hosed
> > due to lack of fsync.  XFS is not the cause of these problems.
> >
> > The problem is that all of this desktop code was developed atop EXT3
> > which flushed to disk every 5 seconds.  This made programmers sloppy as
> > they didn't have to fsync to make sure data hit disk.  This problem has
> > been covered extensively by many, including Eric in other posts on his
> > blog.  There's a really simple way to test this:  mount with sync.
> > Report results after the next crash.  If no files are corrupted then
> > you've verified the problem lay squarely on the shoulders of these
> > desktop developers who have abdicated their responsibility to make sure
> > their file changes hit the disk, instead of relying on a broken
> > filesystem do it for them.
> > 
> > Worth noting, using EXT4 without the EXT3 flush emulation enabled will
> > yield similar file corruption upon a crash.
> 
> I'm not so sure. Of course a journaled filesystem is not a database
> replacement, but wouldn't it be easier to address this issue in xfs
> directly instead of hoping in vain that application developers will
> fix their code someday?

The problem is that there is a small minority of vocal users who
complain loudly and vigorously that something is slow when
application developers use proper caution and ensure files are
safely written using fsync. Those users yell and scream that they
care more about speed than they do about losing their config
settings on a crash, and demand the problem be fixed. Hence we end
up with special environment variables that nobody knows about that
try to provide some measure of data integrity. As you've found out,
it's not sufficient.

It's not up to the filesystem to enforce a "you must do everything
safely" policy. The filesystem provides mechanisms for users and
developers to decide if they want to be fast or safe. Unfortunately
for us, while XFS is pretty fast even when running in "safe" mode,
other filesystems aren't, and that's where the problem lies.

If you want everything to be safe, mount the filesystem with -o
sync. But it will be slow. The only way to be fast and safe is for
applications to Do The Right Thing - no hacks in the filesystem can
provide both fast and safe with compromising either fast or safe in
some manner for someone.

It's unfortunate that after several years of educating people to use
fsync when data integrity is important that we are seeing a
significant back-slide to trying to avoid fsync again. it appeared
recently on the ext4 list, when a gnome developer said they turned
off fsync because users were complaining, trying to rely on a side
effect of ext4 data=ordered mode for integrity and they failed and
users started reporting that they were losing files on crashes....

This is an application layer problem, not a filesystem layer problem.
The filesystems can provide mechanisms to try to help minimise the
impact of requiring data integrity operations, but we haven't been
able to get any significant set of userspace developers to agree on
a sane set of functionality that filesystems can provide over and
above what POSIX already gives them.

And besides, a filesystem can't fix the problems of applications
that use fsync to write inconsequential data that doesn't need
persistence across crashs. Thats clearly an application problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
