Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37441 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932251AbdHWRFk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 13:05:40 -0400
Date: Wed, 23 Aug 2017 10:05:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] fiemap: Introduce get_extent_count
Message-ID: <20170823170533.GY4796@magnolia>
References: <5fc15693-7df3-c1bf-9f78-020eed30b567@sandeen.net>
 <1503501082-16983-1-git-send-email-nborisov@suse.com>
 <1503501082-16983-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1503501082-16983-2-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Wed, Aug 23, 2017 at 06:11:20PM +0300, Nikolay Borisov wrote:
> This function will be used in future patches and will aid in implementing
> ranged fiemap queries
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  io/fiemap.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/io/fiemap.c b/io/fiemap.c
> index d1584aba7818..30c49112e089 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -193,6 +193,22 @@ calc_print_format(
>  	}
>  }
>  
> +/* Use ssize so that we can return also an error code in case the ioctl fails */
> +static ssize_t
> +get_extent_count(int fd, __u64 startoffset, __u64 len)

Argument indentation -- this should be:

static ssize_t
get_extent_count(
	int		fd
	__u64		startoffset,
	__u64		len)
{

to match the rest of the file.

> +{
> +       struct fiemap fiemap = { 0 } ;

Needs space between variable declaration and code.

> +       fiemap.fm_start = startoffset;
> +       fiemap.fm_length = len;
> +       if (ioctl(fd, FS_IOC_FIEMAP, (unsigned long)&fiemap) < 0) {
> +               fprintf(stderr, _("%s: Failed to query fiemap extent count.\n"),
> +                       progname);

perror/strerror to print the exact error code?

--D

> +               return -1;
> +       }
> +
> +       return fiemap.fm_mapped_extents;
> +}
> +
>  int
>  fiemap_f(
>  	int		argc,
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
