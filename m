Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3S2TVoB195643 for <xfs@oss.sgi.com>; Tue, 27 Apr 2010 21:29:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58AB22F8573
	for <xfs@oss.sgi.com>; Tue, 27 Apr 2010 19:31:28 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	tv20vHrUJ7LiEfoW for <xfs@oss.sgi.com>;
	Tue, 27 Apr 2010 19:31:28 -0700 (PDT)
Date: Wed, 28 Apr 2010 12:30:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: Let the broken fiemap work in query mode.
Message-ID: <20100428023058.GD9783@dastard>
References: <1272349065-16383-1-git-send-email-tao.ma@oracle.com>
	<20100428015035.GC9783@dastard> <4BD796A1.7050505@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BD796A1.7050505@oracle.com>
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
To: Tao Ma <tao.ma@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 28, 2010 at 10:00:01AM +0800, Tao Ma wrote:
> Hi Dave,
> 
> Dave Chinner wrote:
> >On Tue, Apr 27, 2010 at 02:17:45PM +0800, Tao Ma wrote:
> >>According to Documentation/filesystems/fiemap.txt, If fm_extent_count
> >>is zero, then the fm_extents[] array is ignored (no extents will be
> >>returned), and the fm_mapped_extents count will hold the number of
> >>extents needed.
> >>
> >>But as the commit 97db39a1f6f69e906e98118392400de5217aa33a has changed
> >>bmv_count to the caller's input buffer, this number query function can't
> >>work any more. As this commit is written to change bmv_count from
> >>MAXEXTNUM because of ENOMEM, we can't find a really suitable number to
> >>set bmv_count now in xfs_vn_fiemap. Since we really have no idea of how
> >>much extents the file has, a big number may cause ENOMEM, while a small
> >>one will mask the real extent no.
> >>
> >>So this patch try to resolve this problem by adding a temporary getbmapx
> >>in xfs_getbmap. If the caller didn't give bmv_count, we don't allocate
> >>the "out" either. Instead, every time we want to use 'out', use '&tmp'
> >>instead.
> >>
> >>I know this solution is a bit ugly, but I can't find a way to resolve
> >>this issue while not changing the codes too much. So any good suggestion
> >>is welcomed.
> >
> >I don't see a need to change xfs_getbmap() to fix this. We can limit
> >the maximum allocation size to something realistic just by setting
> >bm.bmv.count to something sane. e.g, in xfs_vn_fiemap:
> >
> >-	bm.bmv_count = fieinfo->fi_extents_max + 1;
> >+	bm.bmv.count = !fieinfo->fi_extents_max ? MAXEXTNUM :
> >+					fieinfo->fi_extents_max - 1;
> >+	bm.bmv_count = MIN(bm.bmv_count,
> >				(PAGE_SIZE * 16 / sizeof(struct getbmapx)));
> >
> >Unless I'm missing something, that should also prevent the case of
> >an application providing a really large fi_extents_max from
> >triggering ENOMEM in most cases as well.
> I just worry about one thing: What if the real extent number is
> larger than the PAGE_SIZE * 16 / sizeof(struct getbmapx)? In this
> case, we will give up the wrong extent number to the user space.

Applications need to handle mappings changing from query to getting
the mapping, so this should not be a major issue. Especially as the
method of fiemap indicating there are more extents to be extracted
from the inode in the case the kernel can't allocate a buffer large
enough is already documented.

Realistically though, xfs_getbmap() needs a complete rewrite so
right now I'd prefer just to do the minimum to fix the reported
problem that continue to make it into even more of a mess than it is
now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
