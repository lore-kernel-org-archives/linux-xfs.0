Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E5CB37F86
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 14:59:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7051BAC002
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 12:59:50 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	bHS4F9rNRl12nKE3 for <xfs@oss.sgi.com>;
	Mon, 04 Nov 2013 12:59:45 -0800 (PST)
Date: Tue, 5 Nov 2013 07:59:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: simplify kmem_{zone_}zalloc
Message-ID: <20131104205943.GQ6188@dastard>
References: <52777511.1020605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52777511.1020605@cn.fujitsu.com>
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
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: bpm@sgi.com, elder@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Nov 04, 2013 at 06:21:05PM +0800, Gu Zheng wrote:
> Introduce flag KM_ZERO which is used to alloc zeroed entry, and convert
> kmem_{zone_}zalloc to call kmem_{zone_}alloc() with KM_ZERO directly,
> in order to avoid the setting to zero step. 
> And following Dave's suggestion, make kmem_{zone_}zalloc static inline
> into kmem.h as they're now just a simple wrapper.
> 
> V2:
>   Make kmem_{zone_}zalloc static inline into kmem.h as Dave suggested.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Looks good. It also results in a slight reduction in code size:

   text    data     bss     dec     hex filename
 792234   99018     632  891884   d9bec fs/xfs/xfs.o.orig
 792090   99018     632  891740   d9b5c fs/xfs/xfs.o

Which means making it inline hasn't cost us anything at individual
call sites.

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
