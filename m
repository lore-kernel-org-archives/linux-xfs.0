Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 359597FB7
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 17:57:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B6912AC002
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 15:57:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dziHTYcvmWaFnEy4 for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2015 15:57:17 -0700 (PDT)
Date: Thu, 6 Aug 2015 08:57:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 10/11] xfsprogs: replace obsolete memalign with
	posix_memalign
Message-ID: <20150805225703.GY16638@dastard>
References: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
	<1438612789-17486-11-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438612789-17486-11-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Mon, Aug 03, 2015 at 04:39:48PM +0200, Jan Tulak wrote:
> Memalign from <malloc.h> was marked obsolete in favor of a posix
> variant from <stdlib.h>. So replace all calls and remove <malloc.h>
> includes. This also enhances support on other posix platforms,
> which doesn't have <malloc.h>.
> 
> Because posix_memalign returns any error as a return code, not in
> errno, change relevant checks in code (and add a missing one).
....
> @@ -74,12 +74,18 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
>  	ssize_t		zsize, bytes;
>  	char		*z;
>  	int		fd;
> +	int ret;
>  
>  	zsize = min(BDSTRAT_SIZE, BBTOB(len));
> -	if ((z = memalign(libxfs_device_alignment(), zsize)) == NULL) {
> +	ret = posix_memalign(
> +						(void **)&z,
> +						libxfs_device_alignment(),
> +						zsize
> +					);

Unusual function call formatting. Please use the form the rest of
the code uses. i.e:

	ret = posix_memalign((void **)&z, libxfs_device_alignment(), zsize);

(same for the rest of the patch).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
