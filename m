Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3H8wXZY035977 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 03:58:33 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id DfsKLTZBlCuQ99Jm for
	<xfs@oss.sgi.com>; Tue, 17 Apr 2012 01:58:31 -0700 (PDT)
Date: Tue, 17 Apr 2012 09:58:28 +0100
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Fragmentation Issue We Are Having
Message-ID: <20120417085828.GA13168@nsrc.org>
References: <CADrkzimg891ZBGK7-UzhGeey16KwH-ZXpEqFr=O3KwD3qA9LwQ@mail.gmail.com>
	<20120412075747.GB30891@nsrc.org>
	<CADrkzi=JNsbXJHkcb=oOZHLEYMBDUkNHu9O8JFT9h+kSArL47A@mail.gmail.com>
	<20120413071905.GA823@nsrc.org> <20120413075634.GD6734@dastard>
	<20120413081725.GA3640@nsrc.org> <20120417002610.GC6734@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120417002610.GC6734@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: David Fuller <dfuller@epoch.com>, xfs@oss.sgi.com

On Tue, Apr 17, 2012 at 10:26:10AM +1000, Dave Chinner wrote:
> > > You can't just blindly assert that something is needed purely on
> > > the size of the filesystem.
> > 
> > Thanks, but then perhaps the XFS FAQ needs updating. It warns that you might
> > have compatibility problems with old clients (NFS) and inode64, but it
> > doesn't say "for some workloads inode32 may perform better than inode64 on
> > large filesystems".
> 
> The FAQ doesn't say anything about whether inode32 performs better
> than inode64 or vice versa.

With respect it does, although in only three words:
"Also, performance sucks".

Maybe it would be useful to expand this. How about:

"Also, performance sucks for many common workloads and benchmarks, such as
sequentially extracting or reading a large hierarchy of files.  This is
because in filesystems >1TB without inode64, files created within the same
parent directory are not created in the same allocation group with adjacent
extents."

If as you say inode32 was just a hack for broken NFS clients, then it seems
to me that the *intended* default performance characteristics are those of
inode64?  That is, the designers considered this to be the most appropriate
performance compromise for typical users?

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
