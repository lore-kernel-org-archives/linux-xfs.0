Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A59CA7FD4
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 03:47:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8FCEC304043
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 01:47:38 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	XyGz3LqSpC8WQxf7 for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 01:47:34 -0700 (PDT)
Date: Fri, 15 Mar 2013 19:47:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/18] xfstests: remove -x functionality
Message-ID: <20130315084732.GE2559@dastard>
References: <20130314130611.A163253DEAFB@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130314130611.A163253DEAFB@polaris-admin.engr.sgi.com>
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
To: Philip White <pwhite@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 14, 2013 at 06:06:11AM -0700, Philip White wrote:
> From: Phil White <pwhite@sgi.com>
> 
> 
> This is a rebasing & resubmit of a dchinner patch.  His comments on the
> original:
> -----------------
> Now that there are no tests in the top level directory, the exlude
> group functionality no longer works (-x group) as it cannot find
> tests to build an initial list of tests. Rework the the exclude
> group implementation to operate correctly on the new test locations.
> 
> Also, swtich from sed to grep for exclusion because sed has problems
> distnguishing the '/' in path names from regex control...
> -----------------
> This one is mildly different from the original as it modifies infrastructure
> which remains in common.  In Dave's original patch, that had all been moved
> into check.

Why change the patch title? It still does what the original patch
did, so the new patch title is incorrect....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
