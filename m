Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9A4Bvm148165 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 04:04:11 -0600
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 347E8139DD32
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 02:05:36 -0800 (PST)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id ZoIFh8HhQhGQWQvC
	for <xfs@oss.sgi.com>; Tue, 09 Nov 2010 02:05:36 -0800 (PST)
Received: by wyb40 with SMTP id 40so7222241wyb.26
	for <xfs@oss.sgi.com>; Tue, 09 Nov 2010 02:05:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289248327-16308-5-git-send-email-josef@redhat.com>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
	<1289248327-16308-5-git-send-email-josef@redhat.com>
Date: Tue, 9 Nov 2010 10:05:34 +0000
Message-ID: <AANLkTiksTsZqo1yUNVEJSiwE-7ccyWDv+wLvTZaoZOJ0@mail.gmail.com>
Subject: Re: [PATCH 5/6] Btrfs: fail if we try to use hole punch
From: Will Newton <will.newton@gmail.com>
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
Cc: xfs@oss.sgi.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org, cluster-devel@redhat.com, cmm@us.ibm.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Mon, Nov 8, 2010 at 8:32 PM, Josef Bacik <josef@redhat.com> wrote:

Hi Josef,

> Btrfs doesn't have the ability to punch holes yet, so make sure we return
> EOPNOTSUPP if we try to use hole punching through fallocate. =A0This supp=
ort can
> be added later. =A0Thanks,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> =A0fs/btrfs/inode.c | =A0 =A04 ++++
> =A01 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 78877d7..c590add 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6936,6 +6936,10 @@ static long btrfs_fallocate(struct inode *inode, i=
nt mode,
> =A0 =A0 =A0 =A0alloc_start =3D offset & ~mask;
> =A0 =A0 =A0 =A0alloc_end =3D =A0(offset + len + mask) & ~mask;
>
> + =A0 =A0 =A0 /* We only support the FALLOC_FL_KEEP_SIZE mode */
> + =A0 =A0 =A0 if (mode && (mode & FALLOC_FL_KEEP_SIZE))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;
> +

This test looks rather odd. Why do we need to test that mode is
non-zero AND that mode has a specific bit set? Is there a missing !
here?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
