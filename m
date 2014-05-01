Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 447A07F55
	for <xfs@oss.sgi.com>; Thu,  1 May 2014 18:34:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3DAC98F8039
	for <xfs@oss.sgi.com>; Thu,  1 May 2014 16:34:14 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Ebm5NEsvR45cne54 for <xfs@oss.sgi.com>;
	Thu, 01 May 2014 16:34:13 -0700 (PDT)
Date: Fri, 2 May 2014 09:33:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfsprog: fix xfs_inode lifetime issue
Message-ID: <20140501233351.GE22353@dastard>
References: <20140430134844.924376330@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140430134844.924376330@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 30, 2014 at 08:48:44AM -0500, Mark Tinguely wrote:
> These patches clean up the xfs(_trans)_iput() and fix the
> xfs_inode life time so that inodes with a extended attribute
> fork can add an attributes.
> 
> Patch 1	removes the unused argument in _iput routines and
> 	introduces the IRELSE define for xfs_iput().
> Patch 2 fixes the xfs_inode lifetime problem.

These look OK, but I'm going to leave them until after the 3.2.0
release. Thanks for doing this, Mark!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
