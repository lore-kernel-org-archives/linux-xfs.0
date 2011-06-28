Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5S5941N181539 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 00:09:04 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1407F176D265
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 22:09:03 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Ze2rI2cjkll1nRJS for <xfs@oss.sgi.com>;
	Mon, 27 Jun 2011 22:09:03 -0700 (PDT)
Date: Tue, 28 Jun 2011 15:09:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3 v2] XFS TESTS: Fix 252 Failure: Update 252 Golden
	Output
Message-ID: <20110628050900.GL32466@dastard>
References: <1309235247-32650-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309235247-32650-3-git-send-email-achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309235247-32650-3-git-send-email-achender@linux.vnet.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jun 27, 2011 at 09:27:26PM -0700, Allison Henderson wrote:
> New filtered golden output for test 252
> 
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
> ---
> :100644 100644 930c924... fcfd121... M	252.out
>  252.out |  272 +++++++++++++++++++++++++++++++++++++++------------------------
>  1 files changed, 170 insertions(+), 102 deletions(-)
> 
> diff --git a/252.out b/252.out
> index 930c924..fcfd121 100644
> --- a/252.out
> +++ b/252.out
> @@ -1,239 +1,307 @@
>  QA output created by 252
>  	1. into a hole
> +daa100df6e6711906b61c9ab5aa16032
>  	2. into allocated space
> -0: [0..7]: data
> +0: [0..7]: extent
>  1: [8..23]: hole
> -2: [24..39]: data
> +2: [24..39]: extent
> +cc58a7417c2d7763adc45b6fcd3fa024

I don't really like the way this weakens the test for XFS. With this
change, the test no longer is checking that unwritten extent
behaviour is correct.

Rather than weakening the test, perhaps it would be better to
execute 252 for XFS only (with the md5sums added), and then
duplicate it to a new test for all filesystems to run with the
weaker result checking that using the new filter function gives us.
With the amount of common code the two tests share, it should be
trivial to do this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
