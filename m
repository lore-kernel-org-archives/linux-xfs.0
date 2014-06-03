Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E0AD07F58
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 04:18:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6D334AC003
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 02:18:44 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
	by cuda.sgi.com with ESMTP id pBmREUzG705BBq0g (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 02:18:42 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Tue, 03 Jun 2014 11:16:50 +0200
Message-ID: <5502404.8z4rGLMfhs@wuerfel>
In-Reply-To: <20140603084130.GF14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<5082342.alZgfaU1Q0@wuerfel> <20140603084130.GF14410@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, lftan@altera.com, hch@infradead.org, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, xfs@oss.sgi.com, joseph@codesourcery.com

On Tuesday 03 June 2014 18:41:30 Dave Chinner wrote:
> On Tue, Jun 03, 2014 at 09:33:36AM +0200, Arnd Bergmann wrote:
> > On Tuesday 03 June 2014 10:32:27 Dave Chinner wrote:
> > > On Mon, Jun 02, 2014 at 01:43:44PM +0200, Arnd Bergmann wrote:
> > > > On Monday 02 June 2014 10:28:22 Dave Chinner wrote:
> > > > > On Sun, Jun 01, 2014 at 10:24:37AM +1000, Dave Chinner wrote:
> > > > > > On Sat, May 31, 2014 at 05:37:52PM +0200, Arnd Bergmann wrote:
> > > > My patch set
> > > > (at least with the 64-bit tv_sec) just gets 32-bit kernels to behave
> > > > more like 64-bit kernels regarding inode time stamps, which does
> > > > impact all the file systems that the a 64-bit time or the NFS
> > > > unsigned epoch (1970-2106), while your patch extends the file
> > > > system internal epoch (1901-2038 for XFS) so it can be used by
> > > > anything that knows how to handle larger than 32-bit second values
> > > > (either 64-bit kernel or 32-bit with inode_time patch).
> > > 
> > > Right, but the issue is that 64 bit second counters are broken right
> > > now because most filesystems can't support more than 32 bit values.
> > > So it doesn't matter whether it's 32 bit or 64 bit machines, just
> > > adding explicit support for >32 bit second counters without doing
> > > anything else just extends that brokenness into the indefinite
> > > future.
> > 
> > Of course, "most filesystems" are obsolete, and most of the modern
> > file systems already support >32 bit timestamps: ext4, btrfs, cifs,
> > f2fs, 9p, nfsv4, ntfs, gfs2, ocfs2, fuse, ufs2. Everything else
> > except xfs, ext2/3 and exofs uses the nfsv3 interpretation on
> > 64-bit systems, which interprets time stamps with the high bit
> > set as years 2038-2106 rather than 1903-1969.
> 
> I'm not sure that's an entirely correct representation - the
> remainder of the 32 bit-only timestamp filesystems don't actively
> interpret the time stamp at all - it's just an opaque 32 bit value.
> hence the interpretation of the value is dependent on whether the
> kernel treats it as signed or unsigned....

As I mentioned elsewhere in the thread, I don't the way it's handled
is intentional, but it's definitely the file system code that does
the assignment to the timeval and decides on the interpretation, doing
either

	inode->i_mtime.tv_sec = (signed)le32_to_cpu(raw_inode.mtime);

or

	inode->i_mtime.tv_sec = le32_to_cpu(raw_inode.mtime);


	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
