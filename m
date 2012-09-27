Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8R175YQ020654 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 20:07:05 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bymvYlavmWyrWXvU for <xfs@oss.sgi.com>;
	Wed, 26 Sep 2012 18:08:23 -0700 (PDT)
Date: Thu, 27 Sep 2012 11:07:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] add  fallocate/punch_hole vs AIO/DIO stress test
Message-ID: <20120927010749.GG15236@dastard>
References: <1348496601-32637-1-git-send-email-dmonakhov@openvz.org>
	<1348496601-32637-5-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1348496601-32637-5-git-send-email-dmonakhov@openvz.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, hch@lst.de, xfs@oss.sgi.com

On Mon, Sep 24, 2012 at 06:23:20PM +0400, Dmitry Monakhov wrote:
> Run  DIO, fallocate and punch_hole threads on a common file in parallel.
> If race exist old dio request may rewrite punched block after it was
> allocated to another file, we will catch that by verifying blocks content.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Same comments as for the previous patch.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
