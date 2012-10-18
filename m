Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9IFmlM4198921 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 10:48:47 -0500
Message-ID: <5080253A.9060906@sgi.com>
Date: Thu, 18 Oct 2012 10:50:18 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Update mount options documentation
References: <1350574138-30305-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1350574138-30305-1-git-send-email-cmaiolino@redhat.com>
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

On 10/18/12 10:28, Carlos Maiolino wrote:
> Once inode64 is the default allocation mode now, kernel documentation should be
> updated to match this behaviour.
>
> Signed-off-by: Carlos Maiolino<cmaiolino@redhat.com>
> ---
>   Documentation/filesystems/xfs.txt | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 3fc0c31..1718775 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -72,8 +72,15 @@ When mounting an XFS filesystem, the following options are accepted.
>   	Indicates that XFS is allowed to create inodes at any location
>   	in the filesystem, including those which will result in inode
>   	numbers occupying more than 32 bits of significance.  This is
> -	provided for backwards compatibility, but causes problems for
> -	backup applications that cannot handle large inode numbers.
> +	the default allocation option. Applications which do not handle
> +	inode numbers bigger than 32 bits, should use inode32 option.
> +
> +  inode32
> +	Indicates that XFS is limited to create inodes at locations which
> +	will not result in inode numbers with more than 32 bits of
> +	significance. This is provided for backwards compatibility, since
> +	64 bits inode numbers might cause problems for some applications
> +	that cannot handle large inode numbers.
>
>     largeio/nolargeio
>   	If "nolargeio" is specified, the optimal I/O reported in

An engineer that documents!

Would "Indicates that XFS is allowed to create inodes at locations up to
32 bits of significance .."

Do you want to add that it can still read/write/unlink the inodes 
numbered > 32 bits that were created via inode64?

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
