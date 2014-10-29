Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D06717F47
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 05:37:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 67A4FAC008
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 03:37:09 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	6qZbiHgHFYPfGIXX for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 03:37:07 -0700 (PDT)
Date: Wed, 29 Oct 2014 21:36:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Question]: xfstests test generic/233 failure
Message-ID: <20141029103636.GJ16186@dastard>
References: <1414575977.17402.3.camel@G08JYZSD130126.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1414575977.17402.3.camel@G08JYZSD130126.localdomain>
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
To: Zeng Linggang <zenglg.jy@cn.fujitsu.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 29, 2014 at 05:46:17PM +0800, Zeng Linggang wrote:
> Hello,
> 
> When I take XFS filesystem as test target, the case generic/233 often
> fails in my test machines (RHEL7.0GA: 3.10.0-123) with output like this:
> generic/233  [failed, exit status 1] - output mismatch (see
> /var/lib/xfstests/results//generic/233.out.bad)
> --- tests/generic/233.out       2014-10-22 14:17:06.239461640 +0800
> +++ results/generic/233.out.bad 2014-10-23 14:39:48.210480319 +0800
> @@ -4,4 +4,7 @@
> seed = S
> Comparing user usage
> -Comparing group usage
> +4c4
> +< #1001     --   31348   32000   32000            772  1000  1000
> +---
> +> #1001     --   31144   32000   32000            772  1000  1000
> ...
> generic/231 and generic/270 also have the similar quota accounting mismatch.

fsstress can result in different file and directory layouts, hence
result in different amounts of metadata in the filesystem. Metadata
is also accounted to quotas (e.g. to the user who owns the
directory) and so even if data usage is identical the metadata can
still vary.

I see these test give small variations quite frequently, but they
are are usually only quite small (a handful of blocks) so I've never
really worried about it too much.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
