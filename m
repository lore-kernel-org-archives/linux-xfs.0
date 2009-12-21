Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBLMeIIe079392 for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 16:40:18 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78FE011C6E9
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 14:40:58 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	4L98Cv4joogCC8Y1 for <xfs@oss.sgi.com>;
	Mon, 21 Dec 2009 14:40:58 -0800 (PST)
Date: Tue, 22 Dec 2009 09:40:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] XFS: rename xfs_get_perag
Message-ID: <20091221224055.GK4850@discord.disaster>
References: <1260857477-2368-2-git-send-email-david@fromorbit.com>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE012A68B2@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A68B2@cf--amer001e--3.americas.sgi.com>
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

On Mon, Dec 21, 2009 at 04:21:13PM -0600, Alex Elder wrote:
> Dave Chinner wrote:
> > xfs_get_perag is really getting the perag that an inode
> > belongs to based on it's inode number. Convert the use of this
> > function to just get the perag from a provided ag number.
> > Use this new function to obtain the per-ag structure when
> > traversing the per AG inode trees for sync and reclaim.
> 
> General
> - I like that you now use balanced get/put calls in some places
>   that previously "got" the ag reference directly (i.e., open
>   coded), but then used the put interface to release it.
> - I do prefer the xfs_perag_get/put naming convention you use (FYI)
> 
> But a real question...
> - Why is there no matching xfs_perag_put() in xfs_iflush_cluster()?
>   (It was that way before.  I only superficially read that part
>   of the code so I'm probably just missing something.)

Because this patch is only really converting existing users, not
fixing unbalance bugs in th existing get/put calls. The balancing
bugs are fixed in a later patch ("XFS: convert remaining direct
references to m_perag" IIRC). There are several other balancing bugs
fixed in that patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
