Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CA3047F56
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 17:15:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 77E43AC04A
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 15:15:45 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	cV6GTLBFkxOSoOlX for <xfs@oss.sgi.com>;
	Mon, 28 Oct 2013 15:15:44 -0700 (PDT)
Date: Tue, 29 Oct 2013 09:15:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfstests: src/feature.c: print a number of online CPUs
Message-ID: <20131028221540.GF2797@dastard>
References: <20131024104042.GT2797@dastard>
	<1382616640-23894-1-git-send-email-stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1382616640-23894-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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
To: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Cc: vasily.isaenko@oracle.com, xfs@oss.sgi.com

On Thu, Oct 24, 2013 at 04:10:40PM +0400, Stanislav Kholmanskikh wrote:
> For this purpose we use sysconf() as it is the
> preferred platform neutral interface for getting this
> sort of information.
> 
> Based on Dave Chinner proposal.
> 
> Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
> ---
....
> +	if (oflag) {
> +		long ncpus;
> +
> +#if defined(_SC_NPROCESSORS_ONLN)
> +		/* Linux */
> +		ncpus = sysconf(_SC_NPROCESSORS_ONLN);
> +#elif defined(_SC_NPROC_ONLN)
> +		/* IRIX */
> +		ncpus = sysconf(_SC_NPROC_ONLN);
> +#else
> +		ncpus = 1;
> +#endif
> +		if (ncpus == -1)
> +			ncpus = 1;

That can be simplified, and there's probably not much point in
listing the OS's that the different calls are for.

	if (oflag) {
		long ncpus = -1;

#if defined(_SC_NPROCESSORS_ONLN)
		ncpus = sysconf(_SC_NPROCESSORS_ONLN);
#elif defined(_SC_NPROC_ONLN)
		ncpus = sysconf(_SC_NPROC_ONLN);
#endif
		if (ncpus == -1)
			ncpus = 1;

		....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
