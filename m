Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6D0A17F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 05:48:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5AA668F8039
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 03:48:09 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Y5AIPJYOAuCT0Ldf for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 03:48:03 -0700 (PDT)
Date: Mon, 8 Sep 2014 20:47:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs/051: test buffer use after free race on I/O
	failure in XFS log recovery
Message-ID: <20140908104749.GI30012@dastard>
References: <1409667761-50248-1-git-send-email-bfoster@redhat.com>
	<1409667761-50248-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1409667761-50248-3-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 02, 2014 at 10:22:41AM -0400, Brian Foster wrote:
> A buffer use after free race was discovered in the XFS log recovery
> codepath if I/O failures occur during recovery. The I/O submission path
> can abort the mount and release the only reference held on some buffers
> before I/O completion processing (e.g., async workqueue processing)
> might have completed. Badness ensues if the I/O completion path
> subsequently attempts to access said buffers.
.....
> 
> case goes to Alex Lyakas.
> index 4d35df5..9784dea 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -47,6 +47,7 @@
>  048 other auto quick
>  049 rw auto quick
>  050 quota auto quick
> +051 dangerous

I'm going to consider this auto/log/metadata rather than dangerous.
Once the bug is fixed, we want to continue running this test as a
regression test, and nobody does that with the dangerous group....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
