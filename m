Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D0D117CBF
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 14:54:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AF8488F8065
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 12:54:53 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	oaduSMzhd3DYyAm7 for <xfs@oss.sgi.com>;
	Tue, 26 Feb 2013 12:54:52 -0800 (PST)
Date: Wed, 27 Feb 2013 07:54:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: FYI: better workaround for updating 'df' info after 'rm' on
	xfs-vols
Message-ID: <20130226205450.GU5551@dastard>
References: <512C12B5.3070908@tlinx.org> <20130226045038.GN5551@dastard>
	<512C4C7A.60002@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <512C4C7A.60002@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 25, 2013 at 09:47:38PM -0800, Linda Walsh wrote:
> 
> >> Someone suggested cat [1|3] >/proc/sys/vm/drop_caches.
> > 
> > echo, not cat. It does work every time, whether you see anything
> > obvious or not. And if you want to reclaim inodes, then you want
> > "echo 2 > ..."
> ----
> 	Erk...meant echo... too much draino on the braino
> (doesn't 3 include '2'? I thought it was a bit mask?)

Yes, it is a bit mask. 1 = page cache, 2 = slab cache, 3 = both.
Inode reclaim is part of the slab cache reclaim, so page cache
reclaim won't make any difference to the behaviour at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
