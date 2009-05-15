Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4F4n4cg010402 for <xfs@oss.sgi.com>; Thu, 14 May 2009 23:49:05 -0500
Received: from mail-px0-f119.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22D2B1254E67
	for <xfs@oss.sgi.com>; Thu, 14 May 2009 21:54:00 -0700 (PDT)
Received: from mail-px0-f119.google.com (mail-px0-f119.google.com
	[209.85.216.119]) by cuda.sgi.com with ESMTP id
	8J6Is9i69q1mJzHC for <xfs@oss.sgi.com>;
	Thu, 14 May 2009 21:54:00 -0700 (PDT)
Received: by pxi17 with SMTP id 17so868556pxi.20
	for <xfs@oss.sgi.com>; Thu, 14 May 2009 21:49:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090514171558.014747000@bombadil.infradead.org>
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090514171558.014747000@bombadil.infradead.org>
Date: Fri, 15 May 2009 10:19:11 +0530
Message-ID: <921ca19c0905142149m68c9717cg83db37c468769c4d@mail.gmail.com>
Subject: Re: [PATCH 1/7] xfs: split inode data writeback from
	xfs_sync_inodes_ag
From: Sujit Karataparambil <sjt.kar@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

> +STATIC int
> +xfs_sync_inode_data(
> + =A0 =A0 =A0 struct xfs_inode =A0 =A0 =A0 =A0*ip,
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags)
> +{
> + =A0 =A0 =A0 struct inode =A0 =A0*inode =3D VFS_I(ip);
> + =A0 =A0 =A0 struct address_space *mapping =3D inode->i_mapping;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 error =3D 0;
> +
> + =A0 =A0 =A0 if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED=
)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flags & SYNC_TRYLOCK)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_wa=
it;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_ilock(ip, XFS_IOLOCK_SH=
ARED);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D xfs_flush_pages(ip, 0, -1, (flags=
 & SYNC_WAIT) ?
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 0 : XFS_B_ASYNC, FI_NONE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> + =A0 =A0 =A0 }
> +
> + out_wait:
> + =A0 =A0 =A0 if (flags & SYNC_IOWAIT)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_ioend_wait(ip);
> + =A0 =A0 =A0 return error;
> +}
> +
 should not there be an.

 error =3D xfs_flush_pages(ip, 0, -1, (flags & SYNC_WAIT) ?
                       0 : XFS_B_ASYNC, FI_NONE);

for the out_wait. This will ensure flush while the xfs_ioend_wait is being
waited for. Would this be an better way to flush the data than waiting for
the inode to be flushed during power off or scheduler cycles.
Would this be an performance hit.

or better use

  error =3D xfs_sync_inode_data(ip, flags);


-- =

-- Sujit K M

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
