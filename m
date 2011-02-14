Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1ENbILQ162913 for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 17:37:19 -0600
MIME-Version: 1.0
In-Reply-To: <1297691128.1857.4.camel@dan>
References: <1297347904.13370.9.camel@dan> <20110214114629.GA13052@dastard>
	<1297691128.1857.4.camel@dan>
Date: Tue, 15 Feb 2011 07:39:53 +0800
Message-ID: <AANLkTim7zYvwFyVTEMFDyGBR8d0Ka9ruK+R_+s-Rf5Fa@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: prevent leaking uninitialized stack memory in
	FSGEOMETRY_V1
From: Eugene Teo <eugeneteo@kernel.sg>
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
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: security@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, aelder@sgi.com, stable@kernel.org

On Mon, Feb 14, 2011 at 9:45 PM, Dan Rosenberg <drosenberg@vsecurity.com> w=
rote:
> The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
> xfs_fs_geometry() with a version number of 3. =A0This code path does not
> fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
> the leaking of four bytes of uninitialized stack data to potentially
> unprivileged callers.
>
> v2 switches to memset() to avoid future issues if structure members
> change, on suggestion of Dave Chinner.
>
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>

Reviewed-by: Eugene Teo <eugeneteo@kernel.org>

> ---
> =A0fs/xfs/xfs_fsops.c | =A0 =A03 +++
> =A01 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index cec89dd..85668ef 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -53,6 +53,9 @@ xfs_fs_geometry(
> =A0 =A0 =A0 =A0xfs_fsop_geom_t =A0 =A0 =A0 =A0 *geo,
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_version)
> =A0{
> +
> + =A0 =A0 =A0 memset(geo, 0, sizeof(*geo));
> +
> =A0 =A0 =A0 =A0geo->blocksize =3D mp->m_sb.sb_blocksize;
> =A0 =A0 =A0 =A0geo->rtextsize =3D mp->m_sb.sb_rextsize;
> =A0 =A0 =A0 =A0geo->agblocks =3D mp->m_sb.sb_agblocks;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
