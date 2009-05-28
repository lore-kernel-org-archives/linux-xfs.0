Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SCpE8Y254488 for <xfs@oss.sgi.com>; Thu, 28 May 2009 07:51:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96BA62B6EEF
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 05:51:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 4q9sTrp6bU3C6FF3 for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 05:51:29 -0700 (PDT)
Date: Thu, 28 May 2009 08:51:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/9] Enable generic filesystems to be fsck'd
Message-ID: <20090528125128.GA13425@infradead.org>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
	<1243450413-12681-9-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1243450413-12681-9-git-send-email-sandeen@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, May 27, 2009 at 01:53:32PM -0500, Eric Sandeen wrote:
> This includes a fair bit of rearranging to avoid code duplication,
> but the goal is to allow 'fsck -n -t $FSTYP $device' to be run on
> any generic filesystem.
> 
> Any FS for which this doesn't work will need it's own fsck routine.

Looks generally good, some comments:

 - I would get rid of _check_generic_test_fs and just opencode the
   _check_generic_filesystem $TEST_DEV in the two callers.
 - why the odd calling convention of _is_mounted which allows to
   optionally pass the fstype?  Currently we only have one caller
   that doesn't pass it, and if we grow one that needs it I would
   rather always pass it explicitly..

Btw, I seems like _check_testdir is never actually called, and I can't
really see a reason why it would be different from _check_test_fs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
