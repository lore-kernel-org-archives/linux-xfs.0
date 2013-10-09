Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8104F7F7C
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 16:41:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 19FA7AC004
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 14:41:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mSTIymIpMHROoeS5 for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 14:41:18 -0700 (PDT)
Date: Thu, 10 Oct 2013 08:41:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: mkfs scratch device in generic/294
Message-ID: <20131009214115.GL4446@dastard>
References: <5251CB37.2040406@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5251CB37.2040406@redhat.com>
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

On Sun, Oct 06, 2013 at 03:42:31PM -0500, Eric Sandeen wrote:
> test 294 is using the scratch device w/o mkfs-ing it first,
> this runs the risk of following a test which completely
> fills the fs, causing 294 to fail.
> 
> add "rm -f $seqres.full" as well, it was growing on every run.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

*nod*

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
