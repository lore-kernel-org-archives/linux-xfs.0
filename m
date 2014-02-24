Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 821977F52
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 07:47:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6C8D38F8064
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 05:47:18 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qkLnQvlALigGQtav for
	<xfs@oss.sgi.com>; Mon, 24 Feb 2014 05:47:17 -0800 (PST)
Date: Mon, 24 Feb 2014 14:47:10 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
In-Reply-To: <20140224010714.GI4317@dastard>
Message-ID: <alpine.LFD.2.00.1402241446060.2286@localhost.localdomain>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
	<20140224010714.GI4317@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu, xfs@oss.sgi.com

On Mon, 24 Feb 2014, Dave Chinner wrote:

> Date: Mon, 24 Feb 2014 12:07:14 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, linux-fsdevel@vger.kernel.org,
>     xfs@oss.sgi.com
> Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for
>     fallocate
> 
> On Mon, Feb 17, 2014 at 04:08:17PM +0100, Lukas Czerner wrote:
> > Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
> > functionality as xfs ioctl XFS_IOC_ZERO_RANGE.
> > 
> > It can be used to convert a range of file to zeros preferably without
> > issuing data IO. Blocks should be preallocated for the regions that span
> > holes in the file, and the entire range is preferable converted to
> > unwritten extents - even though file system may choose to zero out the
> > extent or do whatever which will result in reading zeros from the range
> > while the range remains allocated for the file.
> > 
> > This can be also used to preallocate blocks past EOF in the same way as
> > with fallocate. Flag FALLOC_FL_KEEP_SIZE which should cause the inode
> > size to remain the same.
> > 
> > You can test this feature yourself using xfstests, of fallocate(1) however
> > you'll need patches for util_linux, xfsprogs and xfstests which you
> > can find here:
> > 
> > http://people.redhat.com/lczerner/zero_range/
> > 
> > I'll post the patches after we agree and merge the kernel functionality.
> 
> Lukas, can you post the xfstests and xfs_io changes so that they can
> be reviewed? Once I can verify the behaviour is the same as
> XFS_IOC_ZERO_RANGE, I'm ahppy to commit the VFS and XFS kernel
> changes along with the xfsprogs and xfstests changes like I've just
> done for the FALLOC_FL_COLLAPSE_RANGE changes.
> 
> I'd like to get all the changes to the VFS into the XFS tree so that
> you can handle the ext4 integration of the two pieces of
> functionilty as you and Ted see fit....
> 
> Cheers,
> 
> Dave.

Hi Dave,

ok, I'll rebase and resend the whole series with the xfstests and
xfsprogs patches as well.

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
