Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BC13E7F6B
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 18:27:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9A362304032
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 16:27:55 -0800 (PST)
Date: Mon, 25 Feb 2013 19:27:43 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC] [PATCH 0/18] xfstests: move tests out of top level
Message-ID: <20130226002743.GA7007@thunk.org>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
	<5032ABBD.80504@sgi.com> <20120820224306.GF19235@dastard>
	<20120821163337.GC29979@sgi.com> <20120821220926.GP19235@dastard>
	<20120822191642.GF29979@sgi.com> <20120822234219.GR19235@dastard>
	<20120823170025.GG29979@sgi.com> <512B8834.30805@sandeen.net>
	<20130225215220.GG5551@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130225215220.GG5551@dastard>
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
Cc: Ben Myers <bpm@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

If the SGI folks are still resistant to removing the bitrotted
performance tests, I have a much simpler patch which we've been using
inside Google for a while now which allows for alphanumeric tests
"numbers".  This allows us to use tests such as "g001", "g002", etc.,
without having to worry about test number collisions fom upstream.

That would also be useful for ext4 since we could keep a fork of
xfstests with e001, e002, e003, etc., while we wait for the tests to
be reviewed for inclusing in the SGI tree.

I hadn't bothered submitting it since it was clear Dave's changes was
better, but the advantage of the hack we've been using inside Google
is that it's a much less intrusive patch.

The reason why I'm interested in having e001, e002, etc., patches is
that at the moment we've got a number of people using private xfstests
repositories and reporting regressions based on them.  They are using
numbers such as "301", which is very confusing since they aren't
upstream and there's a chance the test may get renumbered by the time
it does go upstream.

The advantage of using a named-based system, or using patch numbers
such as e001, g001, etc., is that it makes it a lot easier to keep
track of tests that haven't made it upstream to the xfstests git
repository.

Cheers,

						- Ted

P.S.  I'm happy to review Dmitry's patches if it will help, but I
wasn't sure whether you were looking for someone more experienced with
the xfstests code base to review them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
