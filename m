Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 82EED29DF8
	for <xfs@oss.sgi.com>; Sun,  5 May 2013 19:07:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 059C5AC004
	for <xfs@oss.sgi.com>; Sun,  5 May 2013 17:07:17 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	iybhaSYXuiBMs5zG for <xfs@oss.sgi.com>;
	Sun, 05 May 2013 17:07:16 -0700 (PDT)
Date: Mon, 6 May 2013 10:07:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V4] xfstests: make install support common/ and tests/ dirs
Message-ID: <20130506000714.GJ19978@dastard>
References: <20130503173918.138615197@cxfsxe4.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130503173918.138615197@cxfsxe4.americas.sgi.com>
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
To: rjohnston@sgi.com
Cc: Wang Sheng-Hui <shhuiw@gmail.com>, xfs@oss.sgi.com

On Fri, May 03, 2013 at 12:39:18PM -0500, rjohnston@sgi.com wrote:
> xfstests have some change on the organization of the testcases
> and common* files:
>      * The common* scripts have been reorganized into the common/ dir.
>      * The testcases have been reorganized into sub test dirs under tests/.
>      * The run.* scripts have been removed.
> 
> This patch uses the simple way to make install support above changes:
>      Make up one Makefile for each newly created subdirs, which can control
>      'make install' separately.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> [rjohnston@sgi.com Reposted for current top of tree changes]

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
