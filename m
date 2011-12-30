Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBUKhHXg164678 for <xfs@oss.sgi.com>; Fri, 30 Dec 2011 14:43:18 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	I957X4eeO0KvNYKq for <xfs@oss.sgi.com>;
	Fri, 30 Dec 2011 12:43:15 -0800 (PST)
Date: Sat, 31 Dec 2011 07:43:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Preallocation with direct IO?
Message-ID: <20111230204307.GN23662@dastard>
References: <4efc665b.d139e30a.2f32.fffff97a@mx.google.com>
	<20111229205745.GH12731@dastard>
	<CADDb1s18XsCRkjq_spMKx0-4g2H51mRJXn=u=boqUe4TXZw-MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADDb1s18XsCRkjq_spMKx0-4g2H51mRJXn=u=boqUe4TXZw-MQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Dec 30, 2011 at 08:37:00AM +0530, Amit Sahrawat wrote:
> On Fri, Dec 30, 2011 at 2:27 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Dec 29, 2011 at 01:10:49PM +0000, amit.sahrawat83@gmail.com wro=
te:
> >> Hi, I am using a test setup which is doing write using multiple
> >> threads using direct IO. The buffer size which is used to write is
> >> 512KB. =A0After continously running this for long duration - i
> >> observe that number of extents in each file is getting
> >> huge(2K..4K..). I observed that each extent is of 512KB(aligned to
> >> write buffer size). I wish to have low number of extents(i.e,
> >> reduce fragmentation)... In case of buffered IO- preallocation
> >> works good alongwith the mount option 'allocsize'. Is there
> >> anything which can be done for Direct IO? =A0Please advice for
> >> reducing fragmentation with direct IO.
> >
> > Direct IO does not do any implicit preallocation. The filesystem
> > simply gets out of the way of direct IO as it is assumed you know
> > what you are doing.
> This is the supporting line I was looking for.
> >
> > i.e. you know how to use the fallocate() or ioctl(XFS_IOC_RESVSP64)
> > calls to preallocate space or to set up extent size hints to use
> > larger allocations than the IO being done during syscalls...
> I tried to make use of preallocating space using
> ioctl(XFS_IOC_RESVSP64) - but over time - this is also not working
> well with the Direct I/O.

Without knowing how you are using preallocation, I cannot comment on
this. Can you describe how your application does IO (size,
frequency, location in file, etc) and preallocation (same again), as
well as xfs_bmap -vp <file> output of fragmented files? That way I
have some idea of what your problem is and so might be able to
suggest fixes...

> Is there any call to set up extent size
> also? please update I can try to make use of that also.

`man xfsctl` and search for XFS_IOC_FSSETXATTR.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
