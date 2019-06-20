Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46972 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbfFTTw4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 15:52:56 -0400
Subject: Re: [PATCH 10/12] xfs_io: repair_f should use its own name
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
 <156104943322.1172531.14877921651268434165.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0628fbe6-f9ce-6af2-c0e0-0d5bde6d5de9@sandeen.net>
Date: Thu, 20 Jun 2019 14:52:55 -0500
MIME-Version: 1.0
In-Reply-To: <156104943322.1172531.14877921651268434165.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 6/20/19 11:50 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the repair command fails, it should tag the error message with its
> own name ("repair").
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/scrub.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/io/scrub.c b/io/scrub.c
> index 2ff1a6af..052497be 100644
> --- a/io/scrub.c
> +++ b/io/scrub.c
> @@ -293,7 +293,7 @@ repair_ioctl(
>  
>  	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
>  	if (error)
> -		perror("scrub");
> +		perror("repair");
>  	if (meta.sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		printf(_("Corruption remains.\n"));
>  	if (meta.sm_flags & XFS_SCRUB_OFLAG_PREEN)
> 
