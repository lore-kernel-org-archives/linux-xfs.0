Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBKHdpRL152536 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 11:39:54 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BD7720FC5E
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 09:41:48 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XsYuZuANk4vZ4rQR for
	<xfs@oss.sgi.com>; Mon, 20 Dec 2010 09:41:48 -0800 (PST)
Date: Mon, 20 Dec 2010 12:41:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Add test 248: Check filesystem FITRIM implementation
Message-ID: <20101220174146.GA32680@infradead.org>
References: <1291996407-26251-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1291996407-26251-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: esandeen@redhat.com, xfs@oss.sgi.com

Hi Lukas,

I've looked over it a bit again, and I can't really comment on the code
too much, as my bash fu is nowhere near a level to actually make sense
of most of the testcase.   I have however ran it in a few setups and
can comment based on that.

First your current first discard to check if we actually support it is
not handled correctly.  Running the test on a filesystem that doesn't
support it currently fails the test for me with:

@@ -1,3 +1,2 @@
QA output created by 249
-Checking FITRIM support: done.
-Running the test: done.
+Checking FITRIM support: fstrim: FSTRIM: Inappropriate ioctl for device

This should be easily fixable by redirecting the output of the test
command to /dev/null and do a _notrun if it exited with an error value,
just like other tests that require non-standard behaviour.

Second using data from /usr/share/doc seems a bit non-deterministic to
me, as the content will be different on every system.  Any chance you
could just use the xfstests source code instead?

Third the testcase runs forever, e.g. 93 minutes in my KVM setup, even
using a no-op discard implementation.  While this is useful for burn in
testing having a shorter run time version that can be run automatically
would be really useful.  I tried to figure out what paramters control
the runtime, but as mentioned above my bash skill really aren't enough
to do that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
