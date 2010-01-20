Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K8Wf9i254378 for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 02:32:41 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D666177CB1
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 00:33:42 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5Mdqf06ARuIoaas9 for
	<xfs@oss.sgi.com>; Wed, 20 Jan 2010 00:33:42 -0800 (PST)
Date: Wed, 20 Jan 2010 03:33:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [RFC] xfstests: deprecate busted log printing tests
Message-ID: <20100120083341.GI6721@infradead.org>
References: <1263967158-7685-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263967158-7685-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 20, 2010 at 04:59:18PM +1100, Dave Chinner wrote:
> Tests 018, 081 and 082 read the contents of the log and assume that the
> contents will always be the same. They are trying to ensure that the
> contents of the log don't change for a given fixed load.
> 
> This has several problems - high level changes to the filesystem and
> VFS code can change the order and contents of the log. Changes to
> the way we sync the filesystem will change the contents of the log.
> background writeback occurring in the middle of the test will change
> the contents of the log by allowing the tail to move. Even changes
> to the default mkfs parameters can break them!
> 
> The tests also assume that unmount leaves a dirty log behind. We've
> fixed lots of problems in sync and the unmount paths over recent
> times, so now a clean unmount leaves a clean log behind. That is,
> there is nothing left in the log print output for these tests to
> check. IOWs, major surgery is required for these tests to be
> returned to their former break-when-something-changes behaviour.
> 
> However, these tests are a maintenance nightmare. They spend more
> time broken and failing than they do passing, and then it's not long
> before they get broken again. They have to cover all sorts of
> different permutations of log configurations and that will continue
> to grow and increase the complexity of making these tests continue
> to work. And to top it all off, I can't remember a bug actually ever
> being found by these tests. Hence I think we should just stop using
> them altogether.
> 
> So this patch deprecates 018, 081 and 082 rather than fixes them.
> It introduces a "deprecated" test group and puts them in it. That
> means the tests can still be run on older systems where they may
> have some use, but will not be run automatically any more, nor
> will any attempt be made to keep them up to date or working.

Sounds fine to me.  Btw, at some point we should switch check to
only run the auto group by default.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
