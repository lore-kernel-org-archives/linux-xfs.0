Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 80D4F7F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 16:40:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0F531AC019
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 14:40:18 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ObFpmbv5v7xqR9k5 for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 14:40:16 -0800 (PST)
Date: Thu, 12 Dec 2013 09:40:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/10] xfstests: do not unmount tmpfs during remount.
Message-ID: <20131211224012.GJ10988@dastard>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-6-git-send-email-jayr@google.com>
	<20131211074615.GE19248@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131211074615.GE19248@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Junho Ryu <jayr@google.com>, hughd@google.com, tytso@mit.edu, branto@redhat.com, xfs@oss.sgi.com

On Tue, Dec 10, 2013 at 11:46:15PM -0800, Christoph Hellwig wrote:
> On Tue, Dec 10, 2013 at 12:11:56PM -0800, Junho Ryu wrote:
> > Several tests unmount then re-mount the scratch filesystem, to check
> > that the content is unchanged; but unmounting a tmpfs is designed to
> > lose its content, which causes such tests to fail unnecessarily.  Add
> > _scratch_remount(), which instead uses remount on a tmpfs to preserve
> > its contents.  Also add _test_remount() to do the same for the test
> > device.
> 
> All these tests don't make sense if you never unmount the filesystem.
> Istead they should exit with _notrun for tmpfs.

IOWs, adding tmpfs changes the definition of a "generic" test.

i.e. instead of:

_supported_fs generic

these tests are now:

_supported_fs xfs ext2 ext3 ext4 ext4dev btrfs gfs2 nfs udf reiserfs

and by that definition should be in the tests/shared directory....

That's a bit of a pain, but I really don't like the idea of having
"generic" tests that aren't actually generic by having to define
exceptions for them...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
