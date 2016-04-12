Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C6777CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 16:16:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5F293304067
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 14:16:23 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	VMs5ARNFOu6Cr71m for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 14:16:20 -0700 (PDT)
Date: Wed, 13 Apr 2016 07:16:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Abort intent log item in xfs_iflush() upon error to
	get buf
Message-ID: <20160412211619.GK567@dastard>
References: <23e35813cb097c7b15686852500cbf97@mail.gmail.com>
	<20160412082759.GI9088@dastard>
	<5e9c99552ae829dce9eb574d72085323@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5e9c99552ae829dce9eb574d72085323@mail.gmail.com>
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
To: Shyam Kaushik <shyam@zadarastorage.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 12, 2016 at 11:10:13PM +0530, Shyam Kaushik wrote:
> Hi Dave,
> 
> Your patch needs a minor correction.
> 
> At start of xfs_iflush() either we must initialize "bp = NULL" or else
> xfs_imap_to_bp() when it hits an error need to set "*bpp = NULL".
> Otherwise with your patch we are having an uninitialized bp that
> corrupt_out is trying to do xfs_buf_relse().

Ok, I'll check that - I thought that xfs_trans_buf_read_map() was
initialising it to zero appropriately, but obviously I missed
something.

Thanks for testing!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
