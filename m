Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4F4qOhT010548 for <xfs@oss.sgi.com>; Thu, 14 May 2009 23:52:24 -0500
Received: from mail-pz0-f122.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 05FB7125500F
	for <xfs@oss.sgi.com>; Thu, 14 May 2009 21:57:20 -0700 (PDT)
Received: from mail-pz0-f122.google.com (mail-pz0-f122.google.com
	[209.85.222.122]) by cuda.sgi.com with ESMTP id
	5aUoKCfb1pVqvcvo for <xfs@oss.sgi.com>;
	Thu, 14 May 2009 21:57:20 -0700 (PDT)
Received: by pzk28 with SMTP id 28so881591pzk.20
	for <xfs@oss.sgi.com>; Thu, 14 May 2009 21:52:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090514171558.298098000@bombadil.infradead.org>
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090514171558.298098000@bombadil.infradead.org>
Date: Fri, 15 May 2009 10:22:31 +0530
Message-ID: <921ca19c0905142152u2a8012a9jba6f1d5b856df7ad@mail.gmail.com>
Subject: Re: [PATCH 2/7] xfs: split inode flushing from xfs_sync_inodes_ag
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
> +xfs_sync_inode_attr(
> + =A0 =A0 =A0 struct xfs_inode =A0 =A0 =A0 =A0*ip,
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags)
> +{
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D 0;
> +
> + =A0 =A0 =A0 xfs_ilock(ip, XFS_ILOCK_SHARED);
> + =A0 =A0 =A0 if (xfs_inode_clean(ip))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_unlock;
> + =A0 =A0 =A0 if (!xfs_iflock_nowait(ip)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(flags & SYNC_WAIT))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_unlock;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_iflock(ip);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (xfs_inode_clean(ip)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_ifunlock(ip);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_unlock;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 error =3D xfs_iflush(ip, XFS_IFLUSH_SYNC);
> +
> + out_unlock:
> + =A0 =A0 =A0 xfs_iunlock(ip, XFS_ILOCK_SHARED);
> + =A0 =A0 =A0 return error;

here also should there be an
xfs_sync_inode_data(ip, flags);
xfs_iflush(ip, XFS_IFLUSH_SYNC);

in out_unlock.



-- =

-- Sujit K M

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
