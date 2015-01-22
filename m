Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 07DBF7F4E
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 19:05:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 980FCAC003
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 17:05:49 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	W1qIbHgXBFqEceKT for <xfs@oss.sgi.com>;
	Wed, 21 Jan 2015 17:05:47 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YE6DQ-0005Qa-IQ
	for xfs@oss.sgi.com; Thu, 22 Jan 2015 12:05:44 +1100
Date: Thu, 22 Jan 2015 12:05:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: beginners project: RENAME_WHITEOUT
Message-ID: <20150122010544.GL16552@dastard>
References: <20141107190959.GB21021@infradead.org>
	<20141108234232.GJ28565@dastard>
	<CAJfpegsvZtCxV-GSJ4ON7=JeNkZ7o2=+fmbOTrxDAfm==b1XBw@mail.gmail.com>
	<20141110135249.GR28565@dastard>
	<20150109133019.GD28570@sh-el6.eng.rdu2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150109133019.GD28570@sh-el6.eng.rdu2.redhat.com>
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
To: xfs@oss.sgi.com

On Fri, Jan 09, 2015 at 08:30:19AM -0500, Carlos Maiolino wrote:
> So, giving this conversation, should we implement WHITEOUTS in XFS
> already, or is this isn't decided yet?

Sure, we have to implement whiteouts to support overlayfs.

Though internally we'll do it with DT_WHT in dirents, so we don't
need inodes on disk for them. lookups will just have to allocate in
memory chardev inodes so the rest of the world will function
appropriately if they access whiteouts from the lower filesystems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
