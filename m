Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3I1aCgs128332 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 20:36:13 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BgDJi74tEjDCb0HO for <xfs@oss.sgi.com>;
	Tue, 17 Apr 2012 18:36:10 -0700 (PDT)
Date: Wed, 18 Apr 2012 11:36:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Fragmentation Issue We Are Having
Message-ID: <20120418013607.GK6734@dastard>
References: <CADrkzimg891ZBGK7-UzhGeey16KwH-ZXpEqFr=O3KwD3qA9LwQ@mail.gmail.com>
	<20120412075747.GB30891@nsrc.org>
	<CADrkzi=JNsbXJHkcb=oOZHLEYMBDUkNHu9O8JFT9h+kSArL47A@mail.gmail.com>
	<20120413071905.GA823@nsrc.org> <20120413075634.GD6734@dastard>
	<20120413081725.GA3640@nsrc.org> <20120417002610.GC6734@dastard>
	<20120417085828.GA13168@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120417085828.GA13168@nsrc.org>
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
To: Brian Candler <B.Candler@pobox.com>
Cc: David Fuller <dfuller@epoch.com>, xfs@oss.sgi.com

On Tue, Apr 17, 2012 at 09:58:28AM +0100, Brian Candler wrote:
> On Tue, Apr 17, 2012 at 10:26:10AM +1000, Dave Chinner wrote:
> > > > You can't just blindly assert that something is needed purely on
> > > > the size of the filesystem.
> > > 
> > > Thanks, but then perhaps the XFS FAQ needs updating. It warns that you might
> > > have compatibility problems with old clients (NFS) and inode64, but it
> > > doesn't say "for some workloads inode32 may perform better than inode64 on
> > > large filesystems".
> > 
> > The FAQ doesn't say anything about whether inode32 performs better
> > than inode64 or vice versa.
> 
> With respect it does, although in only three words:
> "Also, performance sucks".

I missed that. It's a pretty useless comment.

> Maybe it would be useful to expand this. How about:
> 
> "Also, performance sucks for many common workloads and benchmarks, such as
> sequentially extracting or reading a large hierarchy of files.  This is
> because in filesystems >1TB without inode64, files created within the same
> parent directory are not created in the same allocation group with adjacent
> extents."

Even that generalisation is often wrong. It assumes that
separation of metadata and data causes performance degradation,
which is not a valid assumption for many common storage
configurations. And it assumes that inode32 cannot do locality of
files at all, when in fact it has tunable locality through a syctl.

Indeed, here's some the performance enhancing games SGI play that
can only be achieved by using the inode32 allocator:

http://techpubs.sgi.com/library/tpl/cgi-bin/getdoc.cgi?coll=linux&db=bks&fname=/SGI_Admin/LX_XFS_AG/ch07.html

> If as you say inode32 was just a hack for broken NFS clients, then it seems
> to me that the *intended* default performance characteristics are those of
> inode64?

inode64 was the *only* allocation policy XFS was designed with.
inode32 was grafted on 5 years later. inode32 has found many other
uses since then, though, so it's not just a "NFS hack" anymore.

Indeed, if you have concatenation-based volumes and you don't have
lots of active directories at once, then inode32 is going to smash
inode64 when it comes to raw performance simply because it will keep
all legs of the concat busy instead of just the one that the
directory is located in. IOWs, in such configurations keeping tight
locality of allocation is actively harmful to performance....

> That is, the designers considered this to be the most appropriate
> performance compromise for typical users?

My experience with XFS is there is no such thing as a typical XFS
user.

Sure, inode64 was the way XFS was originally designed to work, but
history has shown that inode32 is actually significantly more
flexible and tunable than inode64 for different workloads. IOWs,
despite waht was considered the best design 20 years ago, the
inode32 hack has proved a great advantage to XFS over the last 10 or
so years.  You can't tune inode64 at all - you get what you get -
while inode32 can be tweaked and the storage subsystem designed
around it to provide much better resource utilisation and
performance than you can get with inode64....

Simply put: you can't make sweeping generalisations about whether
inode64 is better than inode32 regardless of their original
purpose....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
