Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2MIua8191612 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 17:18:56 -0500
Message-ID: <5094473B.5000801@sgi.com>
Date: Fri, 02 Nov 2012 17:20:43 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: update manpage to match current inode allocation
	behaviour
References: <1350574957-1044-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1350574957-1044-1-git-send-email-cmaiolino@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 10/18/12 10:42, Carlos Maiolino wrote:
> Once inode64 is the default allocator, mkfs man page needs to be updated to
> match the current behaviour.
>
> Signed-off-by: Carlos Maiolino<cmaiolino@redhat.com>
> ---
>   man/man8/mkfs.xfs.8 | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index fa52152..c33cfb2 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -309,16 +309,17 @@ can be allocated to inodes. The default
>   is 25% for filesystems under 1TB, 5% for filesystems under 50TB and 1%
>   for filesystems over 50TB.
>   .IP
> -In the default inode allocation mode, inode blocks are chosen such
> +In the inode32 inode allocation mode, inode blocks are chosen such
>   that inode numbers will not exceed 32 bits, which restricts the inode
>   blocks to the lower portion of the filesystem. The data block
>   allocator will avoid these low blocks to accommodate the specified
>   maxpct, so a high value may result in a filesystem with nothing but
>   inodes in a significant portion of the lower blocks of the filesystem.
> -(This restriction is not present when the filesystem is mounted with
> +(This restriction is not present in the default inode allocation mode,
> +i.e. when the filesystem is mounted with
>   the
>   .I "inode64"
> -option on 64-bit platforms).
> +option).
>   .IP
>   Setting the value to 0 means that essentially all of the filesystem
>   can become inode blocks, subject to inode32 restrictions.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
