Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A75547F3F
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 14:27:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23F51AC002
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 12:27:07 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10]) by
	cuda.sgi.com with ESMTP id M6fdiD5mMLw1U708 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Jun 2014 12:27:05 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Date: Wed, 04 Jun 2014 21:24:42 +0200
Message-ID: <8770583.6XeZxCxOY8@wuerfel>
In-Reply-To: <alpine.LFD.2.11.1406041308300.17310@knanqh.ubzr>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<201406041703.47592.arnd@arndb.de>
	<alpine.LFD.2.11.1406041308300.17310@knanqh.ubzr>
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
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: hch@infradead.org, linux-mtd@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>, linux-f2fs-devel@lists.sourceforge.net, ceph-devel@vger.kernel.org, "Joseph S. Myers" <joseph@codesourcery.com>, linux-arch@vger.kernel.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-afs@lists.infradead.org, cluster-devel@redhat.com, coda@cs.cmu.edu, geert@linux-m68k.org, linux-ext4@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu, fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, john.stultz@linaro.org, tglx@linutronix.de, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, logfs@logfs.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, lftan@altera.com, ocfs2-devel@oss.oracle.com

On Wednesday 04 June 2014 13:30:32 Nicolas Pitre wrote:
> On Wed, 4 Jun 2014, Arnd Bergmann wrote:
> 
> > On Tuesday 03 June 2014, Dave Chinner wrote:
> > > Just ot be pedantic, inodes don't need 96 bit timestamps - some
> > > filesystems can *support up to* 96 bit timestamps. If the kernel
> > > only supports 64 bit timestamps and that's all the kernel can
> > > represent, then the upper bits of the 96 bit on-disk inode
> > > timestamps simply remain zero.
> > 
> > I meant the reverse: since we have file systems that can store
> > 96-bit timestamps when using 64-bit kernels, we need to extend
> > 32-bit kernels to have the same internal representation so we
> > can actually read those file systems correctly.
> > 
> > > If you move the filesystem between kernels with different time
> > > ranges, then the filesystem needs to be able to tell the kernel what
> > > it's supported range is.  This is where having the VFS limit the
> > > range of supported timestamps is important: the limit is the
> > > min(kernel range, filesystem range). This allows the filesystems
> > > to be indepenent of the kernel time representation, and the kernel
> > > to be independent of the physical filesystem time encoding....
> > 
> > I agree it makes sense to let the kernel know about the limits
> > of the file system it accesses, but for the reverse, we're probably
> > better off just making the kernel representation large enough (i.e.
> > 96 bits) so it can work with any known file system.
> 
> Depends...  96 bit handling may get prohibitive on 32-bit archs.
> 
> The important point here is for the kernel to be able to represent the 
> time _range_ used by any known filesystem, not necessarily the time 
> _precision_.
> 
> For example, a 64 bit representation can be made of 40 bits for seconds 
> spanning 34865 years, and 24 bits for fractional seconds providing 
> precision down to 60 nanosecs.  That ought to be plenty good on 32 bit 
> systems while still being cheap to handle.

I have checked earlier that we don't do any computation on inode
time stamps in common code, we just pass them around, so there is
very little runtime overhead. There is a small bit of space overhead
(12 byte) per inode, but that structure is already on the order of
500 bytes.

For other timekeeping stuff in the kernel, I agree that using some
64-bit representation (nanoseconds, 32/32 unsigned seconds/nanoseconds,
...) has advantages, that's exactly the point I was making earlier
against simply extending the internal time_t/timespec to 64-bit
seconds for everything.

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
