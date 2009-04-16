Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3GGbUxE079573 for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 11:37:40 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C7AE30407B
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 09:37:15 -0700 (PDT)
Message-Id: <BC2CA326-C91F-4F2B-9183-236F42E5E224@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090409171412.GB25303@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 2/2] xfs: fix getbmap vs mmap deadlock
Date: Thu, 16 Apr 2009 11:05:46 -0500
References: <20090224133902.GC15820@infradead.org>
	<2B47193B-9486-4500-80C4-E96750BEA54B@sgi.com>
	<20090409171412.GB25303@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Apr 9, 2009, at 12:14 PM, Christoph Hellwig wrote:

> On Mon, Apr 06, 2009 at 07:42:57PM -0500, Felix Blyakher wrote:
>> Actually with the patch we either get all requested extents, or none
>> if we fail to get memory for them.
>> Should we teach the callers to expect ENOMEM and repeat the call
>> to xfs_getbmap with smaller number of extents?
>
> The problem with any of that is that we don't actually get the exact
> extent list but always a racy version.

Agree, but the alternative is ENOMEM, i.e. no bmap
at all.
Since the callers of xfs_getbmap are only ioctl's from
the user apps, we can move the logic of retrying the
call with the smaller number of extents to the app with
the understanding that it may not be exact snapshot of
the file's extents on a very active file. That would mean
that your change in kernel is good as is, but the API for
the GETBMAP[X] is changing by allowing ENOMEM returned.
We'll need to update the man page, and add ENOMEM handling
to xfs_bmap/xfs_io.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
