Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D1Il5M177956 for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 20:18:47 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA472FE4786
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 18:20:40 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	JzrFUQupCf2ZRn1I for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 18:20:40 -0700 (PDT)
Date: Mon, 12 Apr 2010 16:35:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHv2 5/10] xfs: encapsulate bbcount validity checking
Message-ID: <20100412063513.GH2493@dastard>
References: <1270852091.7840.143.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1270852091.7840.143.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 09, 2010 at 05:28:11PM -0500, Alex Elder wrote:
> Define a function that encapsulates checking the validity of a log
> block count.
> 
> (Updated from previous version--no longer includes error reporting in the
> encapsulated validation function.)
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Reviewed-by: Dave Chinner <david@fromorbit.com>

but one small change needed:

>  
> +/*
> + * Verify the given count of basic blocks is valid number of blocks
> + * to specify for an operation involving the given XFS log buffer.
> + * Returns nonzero if the count is valid, 0 otherwise.
> + */
> +
> +inline static int

static inline int

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
