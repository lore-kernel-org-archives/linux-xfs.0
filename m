Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4OGcD6I053708 for <xfs@oss.sgi.com>; Sun, 24 May 2009 11:38:14 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CD3812FBC0C
	for <xfs@oss.sgi.com>; Sun, 24 May 2009 09:44:05 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id YJCnOnxjqeYl1S2f for <xfs@oss.sgi.com>;
	Sun, 24 May 2009 09:44:05 -0700 (PDT)
Message-ID: <4A1977EA.3000604@redhat.com>
Date: Sun, 24 May 2009 11:38:02 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: enable many tests to run on ext2/3/4
References: <4A15B649.70801@redhat.com> <20090524143945.GA32554@infradead.org>
In-Reply-To: <20090524143945.GA32554@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> Wow, that's a nice start.  The only important thing missing is checking
> the filesystems after each test run for the non-xfs case.

Yep, that was in the back of my mind.  Probably needs more abstraction
to make that cleaner.

> Maybe we should put this in in stages?  The _supported_fs generic
> thing is a nice cleanup already for the existing xfs/nfs/udf setup
> and should go in ASAP.

sure, I can break it up.

> The _scratch_mkfs output fix in 069 could also be a separate patch.
> 
> The _setup_generic_testdir should be generalized to match XFS for the
> default case and just set testdir in _setup_testdir instead of
> another function.  Also the comment there should be updated.
> 
> Same for _cleanup_testdir.
> 
> Btw, the way udf and nfs are currently handled look not very nice to me.
> We should not set up the test device by default for any filesystem but
> rather have a -setup or similar option to set it up if needed.

many of them likely fail, too, some of the acl & attr tests have some
assumptions about xfs limits.

> In common I would indeed prefer a new fstype option, but we might aswell
> put the current version in as-is.  Especially if we could tie up a really
> generic fstype= that wouldn't require listing the filesystems if they
> don't require special mount options or similar.

Ok.  I'd even thought that maybe by default, w/o options, it should just
run as whatever $TEST_DEV is formatted to (though that's trickier for
nfs I guess)

> The only thing preventing that is as far as I can see the current difference
> in _require_scratch for xfs and udf vs the rest.  Which looks really weird
> to me, need to investigate what's going on.

I think this is because even for udf etc, it still expects $TEST_DIR to
be xfs, so swizzles around test & scratch. yeah, I agree that's messy.

> As for the generic group I must say I don't like it very much, the
> filtering of notrun (maybe only notrun because of the filesystem type
> mismatch) sounds much better to me.

yeah, after I ran it a bit more I think I tend to agree....

I'll work on breaking this up a bit and tidying up some of the loose
ends, since the basic approach seems sane to more than one person now  :)

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
