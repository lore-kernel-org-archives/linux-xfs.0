Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 58F5E7F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 20:11:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E090CAC003
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 18:11:16 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id AJJhLXAizt1el9nw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 18:11:15 -0800 (PST)
Date: Tue, 25 Feb 2014 18:11:14 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: clean up xfs_set_maxicount & use in growfs
Message-ID: <20140226021114.GA26022@infradead.org>
References: <530C29C7.90001@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530C29C7.90001@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 24, 2014 at 11:27:35PM -0600, Eric Sandeen wrote:
> xfs_set_maxicount() overflowed fairly easily for large filesystems
> and large maxicount; we started out by multiplying dblocks by
> the percentage, *then* dividing by 100, and never checked for
> an overflow.  The calculations were also, IMHO, a little hard
> to follow.

Would be useful to get this test case into xfstests..

> -STATIC void
> +void
>  xfs_set_maxicount(xfs_mount_t *mp)
>  {
>  	xfs_sb_t	*sbp = &(mp->m_sb);
> -	__uint64_t	icount;
> +	__uint64_t	iblocks;

Seems like this could move into the if clause below.

> @@ -388,6 +388,7 @@ extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
>  extern int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
>  extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
>  extern int	xfs_readsb(xfs_mount_t *, int);
> +void		xfs_set_maxicount(xfs_mount_t *mp);
>  extern void	xfs_freesb(xfs_mount_t *);
>  extern int	xfs_fs_writable(xfs_mount_t *);
>  extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);

A missing extern while all other prototypes around it have one seems
rather odd.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
