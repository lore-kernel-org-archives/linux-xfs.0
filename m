Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAGGJk2A082802 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 10:19:47 -0600
Received: from mail1.slb.deg.dub.stisp.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 46DBF1852FC
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 08:21:18 -0800 (PST)
Received: from mail1.slb.deg.dub.stisp.net (mail1.slb.deg.dub.stisp.net
	[84.203.253.98]) by cuda.sgi.com with SMTP id b5FGCLhOa2V9WZ4J
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 08:21:18 -0800 (PST)
Message-ID: <4CE2AF5B.7020500@draigBrady.com>
Date: Tue, 16 Nov 2010 16:20:43 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/6] Ext4: fail if we try to use hole punch
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-5-git-send-email-josef@redhat.com>
In-Reply-To: <1289840723-3056-5-git-send-email-josef@redhat.com>
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
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On 15/11/10 17:05, Josef Bacik wrote:
> Ext4 doesn't have the ability to punch holes yet, so make sure we return
> EOPNOTSUPP if we try to use hole punching through fallocate.  This suppor=
t can
> be added later.  Thanks,
> =

> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/ext4/extents.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> =

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 0554c48..35bca73 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3622,6 +3622,10 @@ long ext4_fallocate(struct inode *inode, int mode,=
 loff_t offset, loff_t len)
>  	struct ext4_map_blocks map;
>  	unsigned int credits, blkbits =3D inode->i_blkbits;
>  =

> +	/* We only support the FALLOC_FL_KEEP_SIZE mode */
> +	if (mode && (mode !=3D FALLOC_FL_KEEP_SIZE))
> +		return -EOPNOTSUPP;
> +
>  	/*
>  	 * currently supporting (pre)allocate mode for extent-based
>  	 * files _only_

So for older versions of ext4 or other filesystems, how do we know
that fallocate(...,FALLOC_FL_PUNCH_HOLE) is not supported.
I.E. how do we detect at runtime that the call succeeded
and didn't just do a normal fallocate()?

cheers,
P=E1draig.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
