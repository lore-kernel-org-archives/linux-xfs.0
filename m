Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1E8d9v4114575 for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 02:39:10 -0600
MIME-Version: 1.0
In-Reply-To: <1297347904.13370.9.camel@dan>
References: <1297347904.13370.9.camel@dan>
Date: Mon, 14 Feb 2011 16:41:46 +0800
Message-ID: <AANLkTi=BxmspGnK1FLwNswQP34kTU96Q0G2xBNoxypCh@mail.gmail.com>
Subject: Re: [Security] [PATCH] xfs: prevent leaking uninitialized stack
	memory in FSGEOMETRY_V1
From: Eugene Teo <eugeneteo@kernel.org>
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
Cc: security@kernel.org, Eugene Teo <eugeneteo@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, aelder@sgi.com, stable@kernel.org

On Thu, Feb 10, 2011 at 10:25 PM, Dan Rosenberg
<drosenberg@vsecurity.com> wrote:
> The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
> xfs_fs_geometry() with a version number of 3. =A0This code path does not
> fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
> the leaking of four bytes of uninitialized stack data to potentially
> unprivileged callers. =A0Since all other members are filled in all code
> paths and there are no padding bytes in this structure, it's safe to
> avoid an expensive memset() in favor of just clearing this one field.
>
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>

There are three callers to xfs_fs_geometry() with version number 3 and
4. I don't see any for version number 2, so this looks fine.

Reviewed-by: Eugene Teo <eugeneteo@kernel.org>

Thanks, Eugene

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
