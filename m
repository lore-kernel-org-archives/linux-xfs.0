Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A61E17F54
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 22:20:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 871F8304032
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 20:20:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ziOBD9mNa3MdX9jA for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 20:20:25 -0700 (PDT)
Date: Thu, 10 Oct 2013 14:20:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfstests: get fsstress DIO working on non-xfs
	filesystems
Message-ID: <20131010032023.GU4446@dastard>
References: <4B54C8AB.6080607@sandeen.net>
 <5256175C.6020000@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5256175C.6020000@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 09, 2013 at 09:56:28PM -0500, Eric Sandeen wrote:
> Pretty sure all DIO IO fails in fsstress today since XFS_IOC_DIOINFO
> fails.  If so, rather than just bailing out on the op, assign
> some sane default DIO parameters, getting min IO size from
> sector size if possible.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> V2: factor out get_alignment, use BLKSSZGET for min DIO size
> rather than guessing at 512.
> 
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 5d5611f..af06059 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -550,6 +550,27 @@ int main(int argc, char **argv)
>  	return 0;
>  }
>  
> +/*
> + * Get alignment via XFS_IOC_DIOINFO, else fall back to
> + * best guess from BLKSSZGET, else return -1.
> + */
> +static int
> +get_alignment(pathname_t *f, int fd, struct dioattr *dio)
> +{
> +	if (xfsctl(f->path, fd, XFS_IOC_DIOINFO, dio) < 0) {
> +		int sectorsize;
> +
> +		if (ioctl(fd, BLKSSZGET, &sectorsize) < 0)
> +			return -1;
> +
> +		dio->d_maxiosz = -1U;
> +		dio->d_miniosz = sectorsize;
> +		dio->d_mem = sectorsize;

To be safe, shouldn't we align d_mem to page size given it is the
alignment of the data within the user page, not the alignment of the
offset of the IO?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
