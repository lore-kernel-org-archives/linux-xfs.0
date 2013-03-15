Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BE3677FC2
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 23:19:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5C729AC001
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 21:19:33 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	v8TcEJYL6CtIz4GS for <xfs@oss.sgi.com>;
	Thu, 14 Mar 2013 21:19:29 -0700 (PDT)
Date: Fri, 15 Mar 2013 15:19:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/18] xfstests: Remove owner fields from patches
Message-ID: <20130315041928.GA2559@dastard>
References: <20130314130611.5325F53DEAF2@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130314130611.5325F53DEAF2@polaris-admin.engr.sgi.com>
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
> Back many years ago, the owner field was used to email the test
> owner when auto-qa failed that test. It is not needed anymore - if
> you want to know who wrote the test, look it up in git....
> 
> Script used was:
> 
> $ sed -i -e "/^# creator/d" -e "/^owner/d" [0-2][0-9][0-9]
> -----------------

The reason the commit mssage has the script in it is so it takes
about 30s to rerun the script and update the patch as new tests are
added.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
