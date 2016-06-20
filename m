Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA79D7CA0
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2016 21:14:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B3BDAC001
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2016 19:14:42 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	PJVEKui70ewnFucG for <xfs@oss.sgi.com>;
	Sun, 19 Jun 2016 19:14:39 -0700 (PDT)
Date: Mon, 20 Jun 2016 12:12:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] Move to more stdint types
Message-ID: <20160620021226.GI26977@dastard>
References: <20160618145330.GD17768@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160618145330.GD17768@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Sat, Jun 18, 2016 at 04:53:30PM +0200, Felix Janda wrote:
> The uint*_t and int*_t are defined by C99 and should be prefered
> over the less portable __uint*_t and __int*_t variants. The
> necessary <stdint.h> include is in platformdefs.h, which gets
> included in most places via libxfs.h.
> 
> For now, only replace all __uint*_t types to uint*_t and likewise for
> __int*_t outside the directories include/ and libxfs/.
> 
> Signed-off-by: Felix Janda <felix.janda@posteo.de>
.....
>  58 files changed, 502 insertions(+), 502 deletions(-)

Because of the amount of churn this will cause outstanding patchsets
(e.g. the rmap/reflink work), this isn't the best time for us to be
committing tree-wide cleanups like this. Once we get the major
changes that are pending reviewed and committed I have no problems
with making these changes, so perhaps you could regenerate the patch
once those are merged?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
