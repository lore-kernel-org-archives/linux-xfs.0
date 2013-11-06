Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D11D629E30
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 16:59:04 -0600 (CST)
Date: Wed, 6 Nov 2013 16:59:00 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH V2] xfs: simplify kmem_{zone_}zalloc
Message-ID: <20131106225900.GW1935@sgi.com>
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
Cc: elder@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

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

Applied.  Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
