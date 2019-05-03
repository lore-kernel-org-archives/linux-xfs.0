Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:40834 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726220AbfECFRX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 May 2019 01:17:23 -0400
Date: Fri, 3 May 2019 15:17:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw
 workload
Message-ID: <20190503051718.GM29573@dread.disaster.area>
References: <20190404165737.30889-1-amir73il@gmail.com>
 <20190404211730.GD26298@dastard>
 <20190408103303.GA18239@quack2.suse.cz>
 <1554741429.3326.43.camel@suse.com>
 <20190411011117.GC29573@dread.disaster.area>
 <20190416122240.GN29573@dread.disaster.area>
 <20190418031013.GX29573@dread.disaster.area>
 <1555611694.18313.12.camel@suse.com>
 <20190420235412.GY29573@dread.disaster.area>
 <20190503041727.GL29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503041727.GL29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Davidlohr Bueso <dbueso@suse.com>
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, May 03, 2019 at 02:17:27PM +1000, Dave Chinner wrote:
> Concept proven.
> 
> Next steps are:
....
> 	- work out whether RCU read locking and kfree_rcu() will
> 	  work with the requirement to do memory allocation while
> 	  holding rcu_read_lock(). Alternative is an internal
> 	  garbage collector mechanism, kinda like I've hacked up to
> 	  simulate kfree_rcu() in userspace.

Internal RCU interactions are now solved. Actually very simple in
the end, should be very easy to integrate into the code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
