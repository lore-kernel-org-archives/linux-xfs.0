Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F2B1F7F3F
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 17:12:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C9421304032
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 15:12:20 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oC2BSHFrmpTSeSCA for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 15:12:19 -0700 (PDT)
Date: Thu, 10 Oct 2013 09:12:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: handle xfs_quota output w/ long devicenames
Message-ID: <20131009221216.GN4446@dastard>
References: <5251E83B.8060605@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5251E83B.8060605@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Oct 06, 2013 at 05:46:19PM -0500, Eric Sandeen wrote:
> Long device names may be split onto their own line
> on quota output:
> 
> Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
> /dev/mapper/my-very-very-very-long-devicename
>                 48M      0      0  00 [------] /mnt/scratch
> 
> which breaks tests that capture quota output - currently,
> only xfs/107.

xfs/108?

> Add a _filter_quota() which fixes this.

Is this necessary for any other tests? I notice some have their own
filters (e.g. xfs/106), but AFAICT none of them handle wraped
lines...

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> 
> 
> diff --git a/common/filter b/common/filter
> index 066b353..a0d9d2a 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -240,6 +240,15 @@ _filter_spaces()
>         sed -e 's/ [ ]*/ /g'
>  }
>  
> +_filter_quota()
> +{
> +	# Long dev name might be split onto its own line; last
> +	# seds remove that newline if present
> +	_filter_scratch | _filter_test_dir | _filter_spaces | \
> +	sed -e 'N;s/SCRATCH_DEV\n/SCRATCH_DEV/g' | \
> +	sed -e 'N;s/TEST_DEV\n/TEST_DEV/g'

A bit messy, but given that we need to filter SCRATCH_MNT and
TEST_DIR as well I can't see a much more obvious way to do it.
I can think of plenty of line noise equivalents that are much
shorter and more concise, but the comments explaining it would be
longer than the above method. ;) So:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
