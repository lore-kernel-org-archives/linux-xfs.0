Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3325A7F52
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:04:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 247CB304059
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:04:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 7TrfhbFWeCVpsCmH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 03:04:14 -0800 (PST)
Date: Fri, 13 Dec 2013 03:04:07 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/10] xfstests: do not unmount tmpfs during remount.
Message-ID: <20131213110407.GB14884@infradead.org>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-6-git-send-email-jayr@google.com>
	<20131211074615.GE19248@infradead.org>
	<20131211224012.GJ10988@dastard>
	<20131212180130.GA19422@infradead.org>
	<20131212225657.GK10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131212225657.GK10988@dastard>
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
Cc: tytso@mit.edu, Junho Ryu <jayr@google.com>, hughd@google.com, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, branto@redhat.com

On Fri, Dec 13, 2013 at 09:56:57AM +1100, Dave Chinner wrote:
> Yes, but that's not the same situation as tmpfs here.  A generic
> filesystem fits a certain model but the given configuration/kernel
> does not necessarily support the feature being tested. Those
> features are easily testable by a _requires_* line.
> 
> This case with tmpfs is different - it doesn't support *being
> unmounted* during a test because it is volatile. That's a
> fundamental change to the assumptions xfstests makes about
> filesystems being tested.  IOWs, we've got a "generic" filesystem
> that is anything but generic.

It's not really a fundamental change for tests supposed to be run on
the TEST_DIR fs.  In fact I'd go so far to say that one patch that
unmounts and repairs it manually should switch to the scratch fs.

Running the scratch tests on tmpfs is a bit more fragile, but I don't
really see a big problem with the concept.

> Adding "_requires_non_volatile_fs" to all the generic tests that do
> an unmount so that tmpfs can be considered "generic" is just as
> painful as modifying the "_supported_fs generic" lines in all the
> tests. It just leads us to a game of whack-a-mole.

What's the problem?  It's not that bad if you look at the series, and
as long as someone maintains tmpfs support it shouldn't burden anyone
else.  If it stops being maintained we can drop the support after a
while.  Then again we still have utterly bitrotted IRIX support around..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
