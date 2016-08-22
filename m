Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0AA707CA0
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 19:38:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B3D5C8F8033
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 17:38:05 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WHddRiHW5rGUrG6F for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2016 17:38:03 -0700 (PDT)
Date: Mon, 22 Aug 2016 10:38:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V5] xfs_db: add crc manipulation commands
Message-ID: <20160822003800.GN19025@dastard>
References: <8cb34b7c-5154-ebb4-7706-1375e94abd74@redhat.com>
	<0bb88897-3dfc-de4e-05fb-b737221f0d80@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0bb88897-3dfc-de4e-05fb-b737221f0d80@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Sun, Aug 14, 2016 at 07:30:51PM -0500, Eric Sandeen wrote:
> This adds a new "crc" command to xfs_db for CRC-enabled filesystems.
....
> diff --git a/db/io.c b/db/io.c
> index 91cab12..240b129 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -27,6 +27,7 @@
>  #include "output.h"
>  #include "init.h"
>  #include "malloc.h"
> +#include "crc.h"
>  =

>  static int	pop_f(int argc, char **argv);
>  static void     pop_help(void);
> @@ -473,12 +474,15 @@ xfs_verify_recalc_crc(
>  void
>  write_cur(void)
>  {
> +	int skip_crc =3D (iocur_top->bp->b_ops->verify_write =3D=3D xfs_dummy_v=
erify);
> +
>  	if (iocur_sp < 0) {
>  		dbprintf(_("nothing to write\n"));
>  		return;
>  	}
>  =

> -	if (xfs_sb_version_hascrc(&mp->m_sb) && iocur_top->ino_buf) {
> +	if (xfs_sb_version_hascrc(&mp->m_sb) && iocur_top->ino_buf &&
> +	    !skip_crc) {
>  		libxfs_dinode_calc_crc(mp, iocur_top->data);
>  		iocur_top->ino_crc_ok =3D 1;
>  	}
> @@ -489,6 +493,19 @@ write_cur(void)
>  		write_cur_bbs();
>  	else
>  		write_cur_buf();
> +
> +	/* If we didn't write the crc automatically, re-check validity */
> +	if (iocur_top->ino_buf && skip_crc) {
> +		xfs_dinode_t	*dip;
> +		xfs_ino_t	ino;
> +
> +		dip =3D iocur_top->data;
> +		ino =3D iocur_top->ino;
> +		iocur_top->ino_crc_ok =3D xfs_verify_cksum((char *)dip,
> +						mp->m_sb.sb_inodesize,
> +						XFS_DINODE_CRC_OFF);
> +	}
> +

io.c: In function =BFwrite_cur=BF:
io.c:500:13: warning: variable =BFino=BF set but not used [-Wunused-but-set=
-variable]
   xfs_ino_t ino;

I've just removed the unused xfs_ino_t here, because it doesn't seem
to have any purpose here.


> diff --git a/db/write.h b/db/write.h
> index 31e2665..664ddcc 100644
> --- a/db/write.h
> +++ b/db/write.h
> @@ -20,5 +20,5 @@ struct field;
>  =

>  extern void	write_init(void);
>  extern void	write_block(const field_t *fields, int argc, char **argv);
> -extern void	write_string(const field_t *fields, int argc, char **argv);
>  extern void	write_struct(const field_t *fields, int argc, char **argv);
> +extern void	write_string(const field_t *fields, int argc, char **argv);

Stray hunk? (removed)

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
