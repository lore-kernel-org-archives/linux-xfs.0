Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EC45A7CA0
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 02:26:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B154D8F8033
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 00:26:17 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 8GBfFaW2Kb3CeZ41 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 24 Jun 2016 00:26:15 -0700 (PDT)
Date: Fri, 24 Jun 2016 09:26:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
Message-ID: <20160624072612.GA22205@lst.de>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
	<20160623232446.GA12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160623232446.GA12670@dastard>
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

On Fri, Jun 24, 2016 at 09:24:46AM +1000, Dave Chinner wrote:
> Except we did that *intentionally* - by definition there is no
> cache to bypass with DAX and so all IO is "direct". That, combined
> with the fact that all Linux filesystems except XFS break the POSIX
> exclusive writer rule you are quoting to begin with, it seemed
> pointless to enforce it for DAX....

No file system breaks the exclusive writer rule - most filesystem
don't make writers atomic vs readers.

More importantly every other filesystem (well there only are ext2
and ext4..) exludes DAX writers against other DAX writers.

> So, before taking any patches to change that behaviour in XFS, a
> wider discussion about the policy needs to be had. I don't think
> we should care about POSIX here - if you have an application that
> needs this serialisation, turn off DAX. That's why I made it a
> per-inode inheritable flag and why the mount option will go away
> over time.

Sorry, but this is simply broken - allowing apps to opt-in behavior
(e.g. like we're using O_DIRECT) is always fine.  Requriring
filesystem-specific tuning that has affect outside the app to get
existing documented behavior is not how to design APIs.

Maybe we'll need to opt-in to use DAX for mmap, but giving the same
existing behavior for read and write and avoiding a copy to the pagecache
is an obvious win.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
