Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A2F67F6B
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 22:11:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2C97AC002
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 20:11:47 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	I0aNikdxZxlXyWHl for <xfs@oss.sgi.com>;
	Wed, 12 Mar 2014 20:11:45 -0700 (PDT)
Date: Thu, 13 Mar 2014 14:08:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfstests: shared/051: add filter to match the golden
	output for large acls
Message-ID: <20140313030834.GB4263@dastard>
References: <5320FE44.8050000@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5320FE44.8050000@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Mar 13, 2014 at 08:39:32AM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> On old kernel we return EINVAL if hit the limits of maximum number of
> ACLs but return E2BIG on new kernel, which cause the test failes on new
> kernel as the output is mismatch to the goldens. This patch fix it by
> updating the golden output with the new error message and replacing the
> old error message with it via a filter.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
> 
> V3->V2: filter out the old error message to the new and update golden output to match it
> V2->V1: filter out the new error message to the old

Looks good

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
