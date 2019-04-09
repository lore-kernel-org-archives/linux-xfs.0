Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57674 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbfDIUkK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Apr 2019 16:40:10 -0400
Subject: Re: [PATCH 25/36] xfs_repair: fix uninitialized variable warnings
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259758358.31886.2042156413647033104.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <83e82a3e-0e6f-7913-df39-5336eac2c984@sandeen.net>
Date: Tue, 9 Apr 2019 15:40:09 -0500
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

well, I was concerned that if we get here with an invalid inode type,
we'll use an invalid quota type, and <unknown> will happen.  But
we're relying on the case statement which calls us, which has only
valid types. ... I guess we could s/ASSERT/assert/ so it's there,
or just don't worry be happy.  There doesn't seem to be much
appetite for spot-fixing this, so

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
