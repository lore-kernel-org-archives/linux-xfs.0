Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8QCIoRK159112 for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 07:18:50 -0500
Subject: Re: xfstests 258: Test xfs fs creation with fs size close to 4 TB
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110926114458.GA1176@infradead.org>
References: <1316613160.781.8.camel@dhcp-26-208.brq.redhat.com>
	<20110926114458.GA1176@infradead.org>
Date: Mon, 26 Sep 2011 07:18:46 -0500
Message-ID: <1317039526.3030.16.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: Eric Sandeen <sandeen@redhat.com>, Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, 2011-09-26 at 07:44 -0400, Christoph Hellwig wrote:
> This one actually fails for me in a 32-bit userspace VM:

This is my fault, and you busted me doing something I
should not have.

It doesn't matter in this case, but there is a window in
which "testfile" is undefined but gets referenced in
_cleanup() (which could get called due to interrupt).
I "trivially" moved the definition to fix that oversight
and as a result broke the test.

I won't do that any more without taking proper credit
when I commit.

Sorry Boris (and all).

Your fix looks fine, Christoph.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
