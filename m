Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3U2RTSM121940 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 21:27:29 -0500
Subject: Re: [PATCH 3/3] xfsqa: build dbtest on debian platforms
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100430012630.GC32515@dastard>
References: <1272500186-29393-1-git-send-email-david@fromorbit.com>
	<1272500186-29393-4-git-send-email-david@fromorbit.com>
	<20100429064943.GB3774@dastard> <20100429104611.GA17317@infradead.org>
	<20100430012630.GC32515@dastard>
Date: Thu, 29 Apr 2010 21:28:40 -0500
Message-ID: <1272594520.3221.154.camel@doink>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, 2010-04-30 at 11:26 +1000, Dave Chinner wrote:
> On Thu, Apr 29, 2010 at 06:46:11AM -0400, Christoph Hellwig wrote:
> > Spoken too soon.  While this second patch at least compiles on my Debian
> > testing  system it doesn't link:
> > 
> > /tmp/ccWcHXtY.o: In function `CleanupDbmLookup': /root/xfstests-dev/src/dbtest.c:304: undefined reference to `dbm_close'
> > /tmp/ccWcHXtY.o: In function `DoDbmLookup':
> > /root/xfstests-dev/src/dbtest.c:220: undefined reference to `dbm_fetch'
> > /root/xfstests-dev/src/dbtest.c:264: undefined reference to `dbm_fetch' /tmp/ccWcHXtY.o: In function `InitDbmLookup':
> > /root/xfstests-dev/src/dbtest.c:144: undefined reference to `dbm_open'
> > /root/xfstests-dev/src/dbtest.c:178: undefined reference to `dbm_store'
> > /root/xfstests-dev/src/dbtest.c:191: undefined reference to `dbm_close'
> > /root/xfstests-dev/src/dbtest.c:196: undefined reference to `dbm_open'
> > collect2: ld returned 1 exit status
> > make[2]: *** [dbtest] Error 1
> > make[1]: *** [src] Error 2
> > make: *** [default] Error 2
> 
> Where is libgdbm-compat on your system?

I think we need to do a better job of defining what's required
for this stuff--building and running.  I know I had trouble
the first time I set things up, and now that it works I
have no recollection of the stuff that I did.  It would be
good to make it easier for people to get testing going,
we might get more people actually running them in a wider
variety of environments.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
