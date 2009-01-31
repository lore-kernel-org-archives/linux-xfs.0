Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0V1FTCO063540 for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 19:15:29 -0600
Date: Fri, 30 Jan 2009 17:14:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs: Add new pre-allocation ioctls to vfs for
	compatibility with legacy xfs ioctls
Message-Id: <20090130171423.f99c88d0.akpm@linux-foundation.org>
In-Reply-To: <200901310138.34164.arnd@arndb.de>
References: <4980C71F.1010804@ankitjain.org>
	<20090130162252.7bf9c1f4.akpm@linux-foundation.org>
	<200901310138.34164.arnd@arndb.de>
Mime-Version: 1.0
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: mfasheh@suse.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org, hch@infradead.org, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On Sat, 31 Jan 2009 01:38:32 +0100 Arnd Bergmann <arnd@arndb.de> wrote:

> On Saturday 31 January 2009, Andrew Morton wrote:
> > On Thu, 29 Jan 2009 02:29:11 +0530 Ankit Jain <me@ankitjain.org> wrote:
> > > +struct space_resv {
> > > +	__s16		l_type;
> > > +	__s16		l_whence;
> > > +	__s64		l_start;
> > > +	__s64		l_len;		/* len == 0 means until end of file */
> > > +	__s32		l_sysid;
> > > +	__u32		l_pid;
> > > +	__s32		l_pad[4];	/* reserve area			    */
> > > +};
> > > +
> > > +#define F_IOC_RESVSP		_IOW('X', 40, struct space_resv)
> > > +#define F_IOC_RESVSP64		_IOW('X', 42, struct space_resv)
> > 
> > Are we sure that the aligment of l_start will be reliably the same
> > across all compilers and versions thereof for all time?
> 
> On x86, the alignment differs between 32 and 64 bit, otherwise it's ok.

Is this written in a standard somewhere?  Is it guaranteed?

If some (perhaps non-gcc) compiler were to lay this out differently
(perhaps with suitable command-line options) then that's liveable
with - as long as the kernel never changes the layout.  Of course
it would be better to avoid this if poss.

The other potential issue with a structure like this is that there's a
risk that it will lead us to copy four bytes of uninitialised kernel
memory out to userspace.

IOW, it seems a generally bad idea to rely upon compiler-added padding
for this sort of thing.

> XFS handles the conversion for compat_ioctl in
> fs/xfs/linux-2.6/xfs_ioctl32.c. If this becomes a generic file ioctl,
> the conversion code should be moved to fs/compat_ioctl.c.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
