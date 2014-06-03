Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B247B7F3F
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 16:38:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2CFC2AC008
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 14:38:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	BTPvj3Apv9WH46oc for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 14:38:17 -0700 (PDT)
Date: Wed, 4 Jun 2014 07:38:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
Message-ID: <20140603213802.GH14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<7175692.dpgYFMbTaP@wuerfel> <538CF346.2070504@zytor.com>
	<5011138.W0gbOc20Qp@wuerfel>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5011138.W0gbOc20Qp@wuerfel>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: hch@infradead.org, linux-mtd@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>, logfs@logfs.org, linux-afs@lists.infradead.org, "Joseph S. Myers" <joseph@codesourcery.com>, linux-arch@vger.kernel.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, coda@cs.cmu.edu, geert@linux-m68k.org, linux-ext4@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu, fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, john.stultz@linaro.org, tglx@linutronix.de, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, lftan@altera.com, linux-btrfs@vger.kernel.org

On Tue, Jun 03, 2014 at 04:22:19PM +0200, Arnd Bergmann wrote:
> On Monday 02 June 2014 14:57:26 H. Peter Anvin wrote:
> > On 06/02/2014 12:55 PM, Arnd Bergmann wrote:
> The possible uses I can see for non-ktime_t types in the kernel are:
> * inodes need 96 bit timestamps to represent the full range of values
>   that can be stored in a file system, you made a convincing argument
>   for that. Almost everything else can fit into 64 bit on a 32-bit
>   kernel, in theory also on a 64-bit kernel if we want that.

Just ot be pedantic, inodes don't *need* 96 bit timestamps - some
filesystems can *support up to* 96 bit timestamps. If the kernel
only supports 64 bit timestamps and that's all the kernel can
represent, then the upper bits of the 96 bit on-disk inode
timestamps simply remain zero.

If you move the filesystem between kernels with different time
ranges, then the filesystem needs to be able to tell the kernel what
it's supported range is.  This is where having the VFS limit the
range of supported timestamps is important: the limit is the
min(kernel range, filesystem range). This allows the filesystems
to be indepenent of the kernel time representation, and the kernel
to be independent of the physical filesystem time encoding....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
