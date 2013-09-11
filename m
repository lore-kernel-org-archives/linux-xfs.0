Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F372D7F37
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 10:11:33 -0500 (CDT)
Message-ID: <52308821.1080807@sgi.com>
Date: Wed, 11 Sep 2013 10:11:29 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 31/55 V3] libxfs: switch over to xfs_sb.c and remove
	xfs_mount.c
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-32-git-send-email-david@fromorbit.com>
	<522A1BCA.6010500@sgi.com> <20130906214021.GD12541@dastard>
	<522A4C79.1030200@sgi.com> <20130910010241.GZ12779@dastard>
	<522F289E.6070802@sgi.com> <20130910213249.GC19103@dastard>
	<52306F3E.8060409@sgi.com>
In-Reply-To: <52306F3E.8060409@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/11/13 08:25, Mark Tinguely wrote:
> On 09/10/13 16:32, Dave Chinner wrote:
>
>  > libxfs: switch over to xfs_sb.c and remove xfs_mount.c
>  >
>  > From: Dave Chinner <dchinner@redhat.com>
>  >
>  > Now that the kernel code has split the superblock specific code out
>  > of xfs_mount.c, we don't need xfs_mount.c anymore. Copy in xfs_sb.c
>  > and remove xfs_mount.c
>  >
>  > Signed-off-by: Dave Chinner <dchinner@redhat.com>
>  > ---
>
> Applies clean for me.
>
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
>

Oops, on testing V2/V3 of the patch, the libxfs/xfs_mount.c was left
in these reposted patches and libxfs/xfs_sb.c was not and the reposeted
patches won't compile.

My mistake for concentrating on the header file when reviewing and not
the whole re-post.

Looks like everything is fine if using the libxfs/xfs_sb.c from the
first post.

--Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
