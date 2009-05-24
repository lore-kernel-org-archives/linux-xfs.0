Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4OEdZ7c049964 for <xfs@oss.sgi.com>; Sun, 24 May 2009 09:39:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A454E12FB994
	for <xfs@oss.sgi.com>; Sun, 24 May 2009 07:45:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YuxzSVWITnsPsCNg for
	<xfs@oss.sgi.com>; Sun, 24 May 2009 07:45:27 -0700 (PDT)
Date: Sun, 24 May 2009 10:39:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: enable many tests to run on ext2/3/4
Message-ID: <20090524143945.GA32554@infradead.org>
References: <4A15B649.70801@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A15B649.70801@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

Wow, that's a nice start.  The only important thing missing is checking
the filesystems after each test run for the non-xfs case.

Maybe we should put this in in stages?  The _supported_fs generic
thing is a nice cleanup already for the existing xfs/nfs/udf setup
and should go in ASAP.

The _scratch_mkfs output fix in 069 could also be a separate patch.

The _setup_generic_testdir should be generalized to match XFS for the
default case and just set testdir in _setup_testdir instead of
another function.  Also the comment there should be updated.

Same for _cleanup_testdir.

Btw, the way udf and nfs are currently handled look not very nice to me.
We should not set up the test device by default for any filesystem but
rather have a -setup or similar option to set it up if needed.

In common I would indeed prefer a new fstype option, but we might aswell
put the current version in as-is.  Especially if we could tie up a really
generic fstype= that wouldn't require listing the filesystems if they
don't require special mount options or similar.

The only thing preventing that is as far as I can see the current difference
in _require_scratch for xfs and udf vs the rest.  Which looks really weird
to me, need to investigate what's going on.

As for the generic group I must say I don't like it very much, the
filtering of notrun (maybe only notrun because of the filesystem type
mismatch) sounds much better to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
