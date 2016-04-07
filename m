Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F2F057CB3
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 18:50:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CBA91304039
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 16:50:45 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ovamOmzEU6jm1gaK (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2016 16:50:44 -0700 (PDT)
Date: Thu, 7 Apr 2016 16:50:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: Don't wrap growfs AGFL indexes
Message-ID: <20160407235043.GB1439@infradead.org>
References: <1459836310-12619-1-git-send-email-david@fromorbit.com>
	<1459836310-12619-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459836310-12619-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 05, 2016 at 04:05:07PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit 96f859d ("libxfs: pack the agfl header structure so
> XFS_AGFL_SIZE is correct") allowed the freelist to use the empty
> slot at the end of the freelist on 64 bit systems that was not
> being used due to sizeof() rounding up the structure size.
> 
> This has caused versions of xfs_repair prior to 4.5.0 (which also
> has the fix) to report this as a corruption once the filesystem has
> been grown. Older kernels can also have problems (seen from a whacky
> container/vm management environment) mounting filesystems grown on a
> system with a newer kernel than the vm/container it is deployed on.
> 
> To avoid this problem, change the initial free list indexes not to
> wrap across the end of the AGFL, hence avoiding the initialisation
> of agf_fllast to the last index in the AGFL.

I have to admit that it's been a while that I looked at the AGFL
code, but I simply don't understand what's happening in this patch.
Diff slightly reorder:

> -		agf->agf_flfirst = 0;
> +		agf->agf_flfirst = cpu_to_be32(1);

So flfirst moves from 0 to 1.

> -		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
> +		agf->agf_fllast = 0;

And last from size - 1 to 0.  In my naive reading this introduces
wrapping and doesn't remove it.  What do I miss?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
