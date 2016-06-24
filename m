Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6E17F7CA2
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 18:00:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DE44BAC003
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 16:00:49 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Wa3vAto4VzIZHpbU for <xfs@oss.sgi.com>;
	Fri, 24 Jun 2016 16:00:47 -0700 (PDT)
Date: Sat, 25 Jun 2016 09:00:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
Message-ID: <20160624230045.GG12670@dastard>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
	<20160623232446.GA12670@dastard> <20160624072612.GA22205@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160624072612.GA22205@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, xfs@oss.sgi.com

On Fri, Jun 24, 2016 at 09:26:12AM +0200, Christoph Hellwig wrote:
> On Fri, Jun 24, 2016 at 09:24:46AM +1000, Dave Chinner wrote:
> > Except we did that *intentionally* - by definition there is no
> > cache to bypass with DAX and so all IO is "direct". That, combined
> > with the fact that all Linux filesystems except XFS break the POSIX
> > exclusive writer rule you are quoting to begin with, it seemed
> > pointless to enforce it for DAX....
> 
> No file system breaks the exclusive writer rule - most filesystem
> don't make writers atomic vs readers.
> 
> More importantly every other filesystem (well there only are ext2
> and ext4..) exludes DAX writers against other DAX writers.
> 
> > So, before taking any patches to change that behaviour in XFS, a
> > wider discussion about the policy needs to be had. I don't think
> > we should care about POSIX here - if you have an application that
> > needs this serialisation, turn off DAX. That's why I made it a
> > per-inode inheritable flag and why the mount option will go away
> > over time.
> 
> Sorry, but this is simply broken - allowing apps to opt-in behavior
> (e.g. like we're using O_DIRECT) is always fine.  Requriring
> filesystem-specific tuning that has affect outside the app to get
> existing documented behavior is not how to design APIs.

Using DAX is an *admin decision*, not an application decision.
Indeed, it's a mount option right now, and that's most definitely not
something the application can turn on or off! Inode flags allow the
admin to decide that two apps working on the same filesystem can use
(or not use) DAX independently, rather than needing to put them on
different filesystems.

> Maybe we'll need to opt-in to use DAX for mmap, but giving the same
> existing behavior for read and write and avoiding a copy to the pagecache
> is an obvious win.

You can't use DAX just for mmap. It's an inode scope behaviour -
once it's turned on, all accesses to that inode - regardless of user
interface - must use DAX. It's all or nothing, not a per file
descript/mmap context option.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
