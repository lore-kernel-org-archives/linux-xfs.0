Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28JAenk057307 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 13:10:41 -0600
Received: from mx0.pronet.com.pl (mx0.pronet.com.pl [193.108.35.26]) by
	cuda.sgi.com with ESMTP id wndr1thvSlKo4vSo for
	<xfs@oss.sgi.com>; Thu, 08 Mar 2012 11:10:36 -0800 (PST)
Subject: Re: XFS: Assertion failed: bp->b_bn != XFS_BUF_DADDR_NULL, file:
	fs/xfs/xfs_buf.c, line: 598
From: =?UTF-8?Q?Rafa=C5=82?= Kupka <kupson@kupson.net>
In-Reply-To: <20120306203020.GG3592@dastard>
References: <1330539626.7615.73.camel@utemp.mieszkanie>
	<20120302104348.GA22230@infradead.org>
	<1330774627.32457.24.camel@utemp.mieszkanie>
	<20120303114413.GA18748@infradead.org>
	<1330983612.28645.18.camel@utemp.mieszkanie>
	<20120306203020.GG3592@dastard>
Date: Thu, 08 Mar 2012 20:10:17 +0100
Message-ID: <1331233817.20679.18.camel@utemp.mieszkanie>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, 2012-03-07 at 07:30 +1100, Dave Chinner wrote:
> On Mon, Mar 05, 2012 at 10:40:12PM +0100, Rafa=B3 Kupka wrote:
Hi,

> > is good and first bad commit is:
> > =

> > 0e6e847f "xfs: stop using the page cache to back the buffer cache"
> =

> Which changed internals of the buffer cache, but not the external
> interfaces.
> =

> > I double tested it - 704b2907 can do 60+ loops of xfsdump without any
> > trouble and 0e6e847f breaks in <10 iterations.
> =

> What is your test case?

I run xfsdump (to /dev/null) in a loop and execute postmark benchmark at
the same time. It's a minimal Debian/Squeeze installation in KVM guest
but it happened on another system too. An Xen server with 512MB memory
in Dom0.

xfsdump -f /dev/null -l0 -p1 -J -L "test" -M "test" /

and postmark with file (also in loop):
set size 500 1000000
set number 1000
set transactions 1000
run
quit

Typically after few iterations xfsdump is stuck with log messages
mentioned in previous e-mails.

Important thing I recently notice - I'm able to reproduce this bug only
on small memory KVM guests (384M). This very same system started with 1G
memory runs fine for 100+ xfsdump executions.

> Also, it might be worthwhile to capture an event trace (e.g. all the
> xfs_buf events) to see what occurs just before the error is
> triggered. That might tell us exactl what sequence has occurred
> leading up to the error.

I will try to provide this information in a few days.

Best Regards,
Rafal Kupka

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
