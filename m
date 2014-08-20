Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 474137F3F
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 19:16:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 33F198F8039
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2014 17:16:28 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	lHt5VD69BrdZhczx for <xfs@oss.sgi.com>;
	Tue, 19 Aug 2014 17:16:26 -0700 (PDT)
Date: Wed, 20 Aug 2014 10:16:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: XFS fixes needed in stable kernels
Message-ID: <20140820001623.GT20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: stable@vger.kernel.org
Cc: Fanael Linithien <fanael4@gmail.com>, xfs@oss.sgi.com

Hi Stable Kernel Gurus!

The following XFs fixes need to be pushed back to stable kernels.
The commits weren't all tagged in the recent 3.17-rc1 merge, so
you're getting an email from me instead. The commits required
from 3.17-rc1 are:

67dc288 xfs: ensure verifiers are attached to recovered buffers
5fd364f xfs: quotacheck leaves dquot buffers without verifiers
ad3714b xfs: dquot recovery needs verifiers

These are definitely needed for 3.16.y and 3.15.y, but aren't
critical for 3.14 and 3.13 because it only affects configurations
marked "experimetal: use at your own risk" and probably won't apply
easily.  They aren't necessary at all for older kernels than
3.13....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
