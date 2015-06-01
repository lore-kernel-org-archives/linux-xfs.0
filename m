Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A4C27F5D
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 15:50:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C7C00AC005
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 13:50:07 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EhJ1ln2vFoGXxb9t for <xfs@oss.sgi.com>;
	Mon, 01 Jun 2015 13:50:05 -0700 (PDT)
Date: Tue, 2 Jun 2015 06:50:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Overwritten partition
Message-ID: <20150601205003.GJ24666@dastard>
References: <556A3E25.6010706@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <556A3E25.6010706@gmail.com>
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
To: hallexh@gmail.com
Cc: xfs@oss.sgi.com

On Sun, May 31, 2015 at 12:48:05AM +0200, hallexh@gmail.com wrote:
> Hello,
> 
> I accidentally overwritten first 40GB of 36TB XFS partition. I ran
> xfs_repair then, which resets the superblocks (I'm sorry i didn't copied
> the output of it) and after I mounted the partition, there was no files.
> Empty file system, but It should be almost 90% full.

SOunds like a case of using inode32 allocator, and losing the entire
inode btree (i.e. the index that tracks allocated inodes) as well as
the root inode, hence there being no way to easily discover and
reconstruct the directory tree at all.

> Am I really screwed or there's a chance to recover the data
> somehow?

disaster recovery tools are your only real hope at this point. go
searching for xfs_irecover as a good starting point for scraping
inodes out of the corpse and hence hopefully being able to
reconstruct some of the directory structure...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
