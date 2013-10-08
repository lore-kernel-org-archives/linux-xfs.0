Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 924587F9F
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 17:53:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6CE738F8089
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 15:53:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Axh6zI67XKPfK3Oh for <xfs@oss.sgi.com>;
	Tue, 08 Oct 2013 15:53:40 -0700 (PDT)
Message-ID: <52548CF2.2040000@sandeen.net>
Date: Tue, 08 Oct 2013 17:53:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 02/32] libxfs: fix missing filetype updates to xfs_dir2.c
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
	<1380510944-8571-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 9/29/13 10:15 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> They were missed in the original patch that was committed.

I'm not sure it's required in lookup or remove, at least today
nothing looks at it on those paths, does it?

Anyway, matches kernel, at worst the last 2 are harmless:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libxfs/xfs_dir2.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
> index 010c701..96a3c1d 100644
> --- a/libxfs/xfs_dir2.c
> +++ b/libxfs/xfs_dir2.c
> @@ -194,6 +194,7 @@ xfs_dir_createname(
>  	memset(&args, 0, sizeof(xfs_da_args_t));
>  	args.name = name->name;
>  	args.namelen = name->len;
> +	args.filetype = name->type;
>  	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
>  	args.inumber = inum;
>  	args.dp = dp;
> @@ -268,6 +269,7 @@ xfs_dir_lookup(
>  	memset(&args, 0, sizeof(xfs_da_args_t));
>  	args.name = name->name;
>  	args.namelen = name->len;
> +	args.filetype = name->type;
>  	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
>  	args.dp = dp;
>  	args.whichfork = XFS_DATA_FORK;
> @@ -323,6 +325,7 @@ xfs_dir_removename(
>  	memset(&args, 0, sizeof(xfs_da_args_t));
>  	args.name = name->name;
>  	args.namelen = name->len;
> +	args.filetype = name->type;
>  	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
>  	args.inumber = ino;
>  	args.dp = dp;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
