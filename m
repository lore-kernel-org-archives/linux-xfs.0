Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0EMbg4P005968 for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 16:37:42 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7BF917FE0A2
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 14:37:40 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	2TH36f2rq73YXVJn for <xfs@oss.sgi.com>;
	Wed, 14 Jan 2009 14:37:40 -0800 (PST)
Date: Thu, 15 Jan 2009 09:37:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: fix dentry aliasing issues in open_by_handle
Message-ID: <20090114223737.GZ8071@disturbed>
References: <20090109221104.237540000@bombadil.infradead.org>
	<20090109221259.292773000@bombadil.infradead.org>
	<20090111233306.GH8071@disturbed>
	<20090112153934.GA28382@infradead.org> <496D8E10.4000501@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <496D8E10.4000501@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jan 14, 2009 at 06:02:40PM +1100, Lachlan McIlroy wrote:
> Christoph,
> 
> When I build with this patch it fails with:
> 
>    CC      init/version.o
>    LD      init/built-in.o
>    LD      .tmp_vmlinux1
> fs/built-in.o: In function `xfs_handle_to_dentry':
> /home/lachlan/git/xfs-update/fs/xfs/linux-2.6/xfs_ioctl.c:211: undefined reference to `exportfs_decode_fh'
> make: *** [.tmp_vmlinux1] Error 1

Given:

EXPORT_SYMBOL_GPL(exportfs_decode_fh);

Did you build with EXPORTFS support in your kernel?

If not, then I think that fs/xfs/Kconfig needs to select EXPORTFS
when XFS is configured in (i.e. it's a new dependency).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
