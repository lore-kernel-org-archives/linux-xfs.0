Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 86B6F7F37
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:29:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 743068F8049
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 03:29:49 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	bincGzW0vJ8frWJS for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 03:29:47 -0700 (PDT)
Date: Fri, 17 May 2013 20:29:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 7/8] xfs: Add xfs_log_rlimit.[c|h]
Message-ID: <20130517102946.GT24635@dastard>
References: <5195C279.3060502@oracle.com> <5195EC13.2060502@gmail.com>
	<5195FB1B.9000803@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5195FB1B.9000803@oracle.com>
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
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, May 17, 2013 at 05:40:43PM +0800, Jeff Liu wrote:
> Hi Michael,
> 
> Are you compiling kernel on 32-bit system?
> 
> Looks this issue is regarding 64-bit division at roundup() on 32-bit if so.

roundup_64() is what you want, then.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
