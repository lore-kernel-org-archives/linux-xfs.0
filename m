Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p045OYRp181897 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 23:24:34 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 233DB1D0851E
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 21:26:40 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	TOK0qd49Al1HHKxb for <xfs@oss.sgi.com>;
	Mon, 03 Jan 2011 21:26:40 -0800 (PST)
Date: Tue, 4 Jan 2011 16:26:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Accidentally deleted an external log, any recovery options?
Message-ID: <20110104052637.GJ15179@dastard>
References: <41292.59911.qm@web31912.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <41292.59911.qm@web31912.mail.mud.yahoo.com>
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
To: Dean Burrows <dkburrows@yahoo.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 03, 2011 at 08:50:32PM -0800, Dean Burrows wrote:
> Hello,
> 
> 
> I was trying a different distro and in doing so deleted a partition that held an 
> xfs external log. Now I can't mount or repair the drive that was using that 
> external log. Is there a way to get the data off, or to create an internal log 
> without losing the data?

Just create a new partition for the external log, zero it, and tell
XFS to use that. You'll have lost any metadata that was in the log,
so once you have a new external log run xfs_repair -n to check that
everything is consistent. If it isn't, then back up everything you
can and run repair for real to fix whatever problems there are.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
