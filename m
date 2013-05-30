Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ADE747F53
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 17:38:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8E6A8304059
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 15:38:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	saMk7fKhttQrKixe for <xfs@oss.sgi.com>;
	Thu, 30 May 2013 15:38:24 -0700 (PDT)
Date: Fri, 31 May 2013 08:38:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfstests: Fix test wildcard expansion.
Message-ID: <20130530223823.GS29466@dastard>
References: <51A7CC6B.3030607@sgi.com>
 <51A7D390.3040108@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A7D390.3040108@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfstests <xfs@oss.sgi.com>

On Thu, May 30, 2013 at 05:32:48PM -0500, Rich Johnston wrote:
> 
> Before commit 38d58591 "xfstests: fix typo in check",
> check xfs/[0-9]?? would execute all tests/xfs/[0-9]?? because:
> 
> Change to use egrep to fix the parsing.
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> ---
> V1-V2
> Use egrep instead of my bulky method

looks like you lost a bit of the commit message. Otherwise it works
fine here ;)

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
