Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 837E47F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 00:42:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6B4148F8037
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 22:42:37 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	675238xQEACfvQCs for <xfs@oss.sgi.com>;
	Wed, 26 Feb 2014 22:42:35 -0800 (PST)
Date: Thu, 27 Feb 2014 17:42:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: fix the description of 'allocsize=' mount option
Message-ID: <20140227064221.GJ29907@dastard>
References: <530AE0E5.1090707@jp.fujitsu.com> <20140224120629.GN4317@dastard>
	<530D6FE3.2040406@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530D6FE3.2040406@jp.fujitsu.com>
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
To: sat <takeuchi_satoru@jp.fujitsu.com>
Cc: Rob Landley <rob@landley.net>, xfs@oss.sgi.com

On Wed, Feb 26, 2014 at 01:38:59PM +0900, sat wrote:
> Hi Dave,
> 
> >Actually, it isn't. The initial size of dynamic prealloc is
> >determined by a set of heuristics based on file size, filesystem
> >geometry and the existing extents on the file. It uses a default
> >of 64k if no optimisation heuristics trigger.
> 
> I see. I should have read the code more carefully.
> 
> ---
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Subject: [PATCH] XFS: remove the description about the default value of "allocsize=" mount option
> 
> The end-of-file preallocation size is dynamic by default.
> So there is no static default size specified by "allocsize="
> mount option and the description about the default size
> should be removed.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Rob Landley <rob@landley.net>

Looks good.

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
