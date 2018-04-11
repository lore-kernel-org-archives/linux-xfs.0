Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39386 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751946AbeDKBfX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Apr 2018 21:35:23 -0400
Subject: Re: [PATCH 14/14] xfs_scrub_all: use system encoding for lsblk output
 decoding
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
 <152160366773.8288.6721882677866606943.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <31606041-661e-3317-b8e5-413f2edcf062@sandeen.net>
Date: Tue, 10 Apr 2018 20:35:21 -0500
MIME-Version: 1.0
In-Reply-To: <152160366773.8288.6721882677866606943.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 3/20/18 10:41 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't hardcode utf-8 as the decoding scheme for lsblk output, since the
> system could set it to anything else.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Its-all-python-to-me-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/xfs_scrub_all.in |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
> index 83c4e21..d374f92 100644
> --- a/scrub/xfs_scrub_all.in
> +++ b/scrub/xfs_scrub_all.in
> @@ -48,7 +48,7 @@ def find_mounts():
>  	result.wait()
>  	if result.returncode != 0:
>  		return fs
> -	sarray = [x.decode('utf-8') for x in result.stdout.readlines()]
> +	sarray = [x.decode(sys.stdout.encoding) for x in result.stdout.readlines()]
>  	output = ' '.join(sarray)
>  	bdevdata = json.loads(output)
>  	# The lsblk output had better be in disks-then-partitions order
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
