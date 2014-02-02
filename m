Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4EA277F9E
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 16:03:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 292D18F8033
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 14:03:52 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Cle21Ol6JXSG2RE7 for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 14:03:50 -0800 (PST)
Date: Mon, 3 Feb 2014 09:03:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND 0/10] fs: Introduce new
	flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
Message-ID: <20140202220346.GU2212@dastard>
References: <1391319694-3089-1-git-send-email-linkinjeon@gmail.com>
	<20140202151624.GK20939@parisc-linux.org>
	<20140202152106.GL20939@parisc-linux.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140202152106.GL20939@parisc-linux.org>
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
To: Matthew Wilcox <matthew@wil.cx>
Cc: Namjae Jeon <linkinjeon@gmail.com>, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

On Sun, Feb 02, 2014 at 08:21:06AM -0700, Matthew Wilcox wrote:
> On Sun, Feb 02, 2014 at 08:16:24AM -0700, Matthew Wilcox wrote:
> > On Sun, Feb 02, 2014 at 02:41:34PM +0900, Namjae Jeon wrote:
> > > The semantics of this flag are following:
> > > 1) It collapses the range lying between offset and length by removing any data
> > >    blocks which are present in this range and than updates all the logical
> > >    offsets of extents beyond "offset + len" to nullify the hole created by
> > >    removing blocks. In short, it does not leave a hole.
> > > 2) It should be used exclusively. No other fallocate flag in combination.
> > > 3) Offset and length supplied to fallocate should be fs block size aligned
> > >    in case of xfs and ext4.
> > > 4) Collaspe range does not work beyond i_size.
> > 
> > What if the file is mmaped at the time somebody issues this command?
> > Seems to me we should drop pagecache pages that overlap with the
> > removed blocks.  If the removed range is not a multiple of PAGE_SIZE,
> > then we should also drop any pagecache pages after the removed range.
> 
> Oops, forgot to add "and if it is a multiple of page size, then we need
> to update the offsets of any pages after the removed page". 

Yup, that's what the XFS implementation does when it punches the
hole out of the file before shifting the extents down. Check
xfs_free_file_space():

1275         /* wait for the completion of any pending DIOs */
1276         inode_dio_wait(VFS_I(ip));
1277
1278         rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
1279         ioffset = offset & ~(rounding - 1);
1280         error = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
1281                                               ioffset, -1);
1282         if (error)
1283                 goto out;
1284         truncate_pagecache_range(VFS_I(ip), ioffset, -1);

Bonus points for working out why the XFS code doesn't just use
PAGE_CACHE_SIZE for rounding here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
