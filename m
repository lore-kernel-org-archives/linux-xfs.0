Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 348927CA1
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 08:11:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E73A2304032
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 06:11:04 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 26jRHzfNwsjJ0bu0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2016 06:11:02 -0700 (PDT)
Date: Tue, 28 Jun 2016 15:10:59 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
Message-ID: <20160628131059.GA30475@lst.de>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
	<20160623232446.GA12670@dastard> <20160624072612.GA22205@lst.de>
	<20160624230045.GG12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160624230045.GG12670@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Sat, Jun 25, 2016 at 09:00:45AM +1000, Dave Chinner wrote:
> > 
> > Sorry, but this is simply broken - allowing apps to opt-in behavior
> > (e.g. like we're using O_DIRECT) is always fine.  Requriring
> > filesystem-specific tuning that has affect outside the app to get
> > existing documented behavior is not how to design APIs.
> 
> Using DAX is an *admin decision*, not an application decision.

Of course - that's exactly my point.

> Indeed, it's a mount option right now, and that's most definitely not
> something the application can turn on or off! Inode flags allow the
> admin to decide that two apps working on the same filesystem can use
> (or not use) DAX independently, rather than needing to put them on
> different filesystems.

Right.  And an existing application can get DAX turned on under its
back, and will now suddently get different synchronization behavior.
That is if it's writes happen to be aligned to the fs block size.

> > Maybe we'll need to opt-in to use DAX for mmap, but giving the same
> > existing behavior for read and write and avoiding a copy to the pagecache
> > is an obvious win.
> 
> You can't use DAX just for mmap. It's an inode scope behaviour -
> once it's turned on, all accesses to that inode - regardless of user
> interface - must use DAX. It's all or nothing, not a per file
> descript/mmap context option.

Right now it is.  But when discussing mmap behavior one option was to
require an opt-in to get DAX-specific mmap semantics.  For plain
read/write we have no such option and thus absolutely need to behave as
all normal reads and writes behave.  If you think the exclusive lock
for writes hurts we have two options:
 
 a) implement range locks (although they might be more expensive for
    typical loads)
 b) add a new O_* or RWF_* option to not require the synchronization
    for apps that don't want it.

Neither of those cases really is DAX-specific.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
