Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0A4DE7F3F
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:12:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EFAB58F8066
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:12:39 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id GK0XVu1HO7u4tjhz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 03:12:21 -0800 (PST)
Date: Fri, 13 Dec 2013 03:12:18 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/10] xfstests: do not unmount tmpfs during remount.
Message-ID: <20131213111218.GE14884@infradead.org>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-6-git-send-email-jayr@google.com>
	<20131211074615.GE19248@infradead.org>
	<20131211224012.GJ10988@dastard>
	<20131212180130.GA19422@infradead.org>
	<20131212225657.GK10988@dastard>
	<CAFA30n9ea3A+V7JgCgqO5xOQchgB55oLP4AgtQ3KQpCMr9iEzQ@mail.gmail.com>
	<20131213014131.GP10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213014131.GP10988@dastard>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Junho Ryu <jayr@google.com>, Hugh Dickins <hughd@google.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Boris Ranto <branto@redhat.com>

On Fri, Dec 13, 2013 at 12:41:31PM +1100, Dave Chinner wrote:
> All the generic tests that use dm_flakey are likely to be busted.
> Anything assumes SCRATCH_DEV or TEST_DEV are block devices are
> busted.

These are already busted on nfs, which we've support in some form
forever, and cifs, and btrfs with it's pools if they assume the
actual device is the block device.

> Do loop devices work properly when hosted on tmpfs
> filesystems? And so on...

They do.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
