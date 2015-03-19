Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 77F397F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 10:07:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 576108F8064
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 08:07:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PK9TiJHeHxIascR0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 08:07:24 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t2JF7Nn3012930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 11:07:23 -0400
Date: Thu, 19 Mar 2015 11:07:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/13] xfs_db: fix inode CRC validity state, and warn on
	read if invalid
Message-ID: <20150319150721.GB11669@laptop.bfoster>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
	<1426624395-8258-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1426624395-8258-3-git-send-email-sandeen@redhat.com>
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
Cc: xfs@oss.sgi.com

On Tue, Mar 17, 2015 at 03:33:04PM -0500, Eric Sandeen wrote:
> Currently, the "ino_crc_ok" field on the io cursor reflects
> overall inode validity, not CRC correctness.  Because it is
> only used when printing CRC validity, change it to reflect
> only that state - and update it whenever we re-write the
> inode (thus updating the CRC).
> 
> In addition, when reading an inode, warn if the CRC is bad.
> 
> Note, when specifying an inode which doesn't actually exist,
> this will claim corruption; I'm not sure if that's good or
> bad. Today, it already issues corruption errors on the way;
> this adds a new message as well:
> 
> xfs_db> inode 129
> Metadata corruption detected at block 0x80/0x2000
> Metadata corruption detected at block 0x80/0x2000
> ...
> Metadata CRC error detected for ino 129
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

So is the objective here to simply give the field an explicit meaning?
E.g., indicate whether the crc is valid, irrespective of whether
something else might be wrong with the inode?

>  db/inode.c       |    7 ++++++-
>  db/io.c          |    4 +++-
>  include/libxfs.h |    2 ++
>  3 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/db/inode.c b/db/inode.c
> index 24170ba..982acb7 100644
> --- a/db/inode.c
> +++ b/db/inode.c
> @@ -684,13 +684,18 @@ set_cur_inode(
>  		numblks, DB_RING_IGN, NULL);
>  	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
>  	dip = iocur_top->data;
> -	iocur_top->ino_crc_ok = libxfs_dinode_verify(mp, ino, dip);
> +	iocur_top->ino_crc_ok = libxfs_verify_cksum((char *)dip,
> +						    mp->m_sb.sb_inodesize,
> +						    XFS_DINODE_CRC_OFF);

With this replaced, it doesn't look like anybody else will call
libxfs_dinode_verify (analogous to xfs_iread() in kernel). Is that
intentional? I guess the magic and version should be checked in the read
verifier, but there are a couple other checks in that helper as well.

>  	iocur_top->ino_buf = 1;
>  	iocur_top->ino = ino;
>  	iocur_top->mode = be16_to_cpu(dip->di_mode);
>  	if ((iocur_top->mode & S_IFMT) == S_IFDIR)
>  		iocur_top->dirino = ino;
>  
> +	if (xfs_sb_version_hascrc(&mp->m_sb) && !iocur_top->ino_crc_ok)
> +		dbprintf(_("Metadata CRC error detected for ino %lld\n"), ino);
> +

Hmm.. if we keep this, could we combine with the hunk above? I ask
simply because I'd rather see the _hascrc() check around the verify_cksum()
check as well, rather than verifying a cksum and ignoring it.

It's also a little confusing how this field is handled without crc
enabled. write_cur() looks like it sets it and calls
libxfs_dinode_calc_crc() blindly, which asserts that crc is enabled. I
guess we just don't print anything if crc=0, but it would be nice if the
flag was consistent.

Brian

>  	/* track updated info in ring */
>  	ring_add();
>  }
> diff --git a/db/io.c b/db/io.c
> index c5898f1..91858e2 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -471,8 +471,10 @@ write_cur(void)
>  		return;
>  	}
>  
> -	if (iocur_top->ino_buf)
> +	if (iocur_top->ino_buf) {
>  		libxfs_dinode_calc_crc(mp, iocur_top->data);
> +		iocur_top->ino_crc_ok = 1;
> +	}
>  	if (iocur_top->dquot_buf)
>  		xfs_update_cksum(iocur_top->data, sizeof(struct xfs_dqblk),
>  				 XFS_DQUOT_CRC_OFF);
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 45a924f..962e319 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -782,6 +782,8 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
>  
>  #include <xfs/xfs_cksum.h>
>  
> +#define libxfs_verify_cksum	xfs_verify_cksum
> +
>  static inline int
>  xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
>  {
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
