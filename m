Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBE0uYKc181073 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 18:56:35 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D0B315723F6
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 16:56:31 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	LkQHQMh8hUKaF5sg for <xfs@oss.sgi.com>;
	Tue, 13 Dec 2011 16:56:31 -0800 (PST)
Date: Wed, 14 Dec 2011 11:56:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remove unused XBT_FORCE_SLEEP bit
Message-ID: <20111214005629.GK3179@dastard>
References: <4EE7DBED.8090600@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EE7DBED.8090600@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 13, 2011 at 05:12:45PM -0600, Eric Sandeen wrote:
> XBT_FORCE_SLEEP is no longer ever tested; it is only set
> and cleared.  Remove it.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> p.s. I left bt_flags as a bitfield even with only one bit defined now... OK?

Fine by me. The plan is to remove the xfsbufd completely (by doing
all metadata writeback from the AIL), anyway, so leaving it as a bit
field for the moment is not a problem...

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
