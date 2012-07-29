Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6TM9NDk214658 for <xfs@oss.sgi.com>; Sun, 29 Jul 2012 17:09:23 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	IZonQz2poBfoS4uG for <xfs@oss.sgi.com>;
	Sun, 29 Jul 2012 15:09:21 -0700 (PDT)
Date: Mon, 30 Jul 2012 08:09:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V7] xfs: cleanup the mount options
Message-ID: <20120729220909.GC2877@dastard>
References: <20120724211857.GO23387@dastard>
	<1343178697-3479-1-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1343178697-3479-1-git-send-email-gaowanlong@cn.fujitsu.com>
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
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Zach Brown <zab@zabbo.net>, xfs@oss.sgi.com

On Wed, Jul 25, 2012 at 09:11:37AM +0800, Wanlong Gao wrote:
> remove the mount options macro, use tokens instead.
> 
> change from V6: (Dave)
> 1. switch GFP_NOFS to GFP_KERNEL
> 
> change from V5: (Dave)
> 1. fix a string leak.
> 2. leave the show options to raw numbers.
> 
> change from V4: (as Dave suggested)
> 1. suffix_match_int avoid overflow.
> 2. convert the return style to be consistent with others.
> 3. move the "intarg" init above the switch.
> 4. move match_strdup to a help function.
> 5. collapsed Opt_biosize and Opt_allocsize.
> 6. make a consistent deprecated message.

Looks good now. Thanks for takingthe time to get this right!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
