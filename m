Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46592 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731755AbfCZT4E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Mar 2019 15:56:04 -0400
Subject: Re: [PATCH 25/36] xfs_repair: fix uninitialized variable warnings
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259758358.31886.2042156413647033104.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <86dce7d4-e637-8a94-e210-cdc804c6f0dc@sandeen.net>
Date: Tue, 26 Mar 2019 14:56:02 -0500
MIME-Version: 1.0
In-Reply-To: <155259758358.31886.2042156413647033104.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/14/19 4:06 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix some uninitialized variable warnings because ASSERT disappears if
> DEBUG is not defined.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Fixes: commit 5857dce9e ("xfs_repair: check and repair quota metadata")

which was mine ;)

But, I wonder if we should really just happily carry on w/ an invalid
quota type 0 on a non-debug build.  I don't know how that will end.

Maybe we should just switch it to a hard assert(0) because it really
can only happen on a programming error today.


> ---
>  repair/dinode.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index f670bf87..c0a56daa 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -1176,8 +1176,8 @@ process_quota_inode(
>  	struct xfs_buf		*bp;
>  	xfs_filblks_t		dqchunklen;
>  	uint			dqperchunk;
> -	int			quota_type;
> -	char			*quota_string;
> +	int			quota_type = 0;
> +	char			*quota_string = NULL;
>  	xfs_dqid_t		dqid;
>  	xfs_fileoff_t		qbno;
>  	int			i;
> 
