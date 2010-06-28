Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SM1Ujo044121 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 17:01:31 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C75328F80D3
	for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 15:04:13 -0700 (PDT)
Subject: [PATCH 00/15] xfs: minimize DMAPI footprint
From: Alex Elder <aelder@sgi.com>
Date: Mon, 28 Jun 2010 17:04:13 -0500
Message-ID: <1277762653.2040.554.camel@doink>
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
To: xfs@oss.sgi.com

Back in the early part of May, Christoph Hellwig sent a patch
to the list proposing to drop the remaining DMAPI support
code from XFS.  He said:

    Dmapi support was never merged upstream, but we still
    have a lot of hooks bloating XFS for it, all over the
    fast pathes of the filesystem.
    
    This patch drops over 700 lines of dmapi overhead.  If
    we'll ever get HSM support in mainline at least the
    namespace events can be done much saner in the VFS
    instead of the individual filesystem, so it's not like
    this is much help for future work.

SGI has a product that uses the DMAPI support code that's
included in mainline XFS, along with some additional code
(the "never merged" stuff Christoph refers to) that we
maintain separately.  To our customers that need it, this
is an extremely important feature.

I was concerned that the outright removal of the code
would make it very difficult for us to continue to offer
our DMAPI support, especially given the rate at which code
has been getting refactored in XFS lately.  Specifically,
DMAPI relies on the file system to send it messages when
certain events occur, and I don't want to lose track of
the specific spots in the XFS code where this needs to
occur.

I agree with Christoph that the DMAPI-specific definitions,
etc., have no place in the top-of-tree code right now.
However I wanted to provide an alternative to Christoph's
patch, one which preserves some very specific hooks that
allow DMAPI support to remain, but which otherwise minimizes
the footprint and visibility of DMAPI definitions in
environments where it is not used (and which furthermore
incurs little or no run-time overhead in non-DMAPI
builds).

What follows is a set of patches that I think accomplishes
these goals.  The net result of these changes is:
- DMAPI calls, along with almost all supporting logic,
  have been replaced with a set of 21 function calls
  that are used to signal events.  The information
  supplied to these functions is exactly what is
  required--no more--and their syntactic interfaces
  do not rely on any internal DMAPI definitions.
- Two files remain in top-of-tree code to support DMAPI:
  "xfs_dmops.c" and "xfs_dmapi.h".  The former still
  defines the two functions called at mount and unmount
  time to attach/detach a vector of DMAPI operations to
  the mount point.  I've simplified this though, so a
  null pointer is used if DMAPI is not present.  The
  header file now only declares the two functions, and
  defines a set of no-op macros to be used for DMAPI event
  generation when DMAPI is not configured in the build.
  Everything else will now be defined elsewhere.

The "dmapi" mount option remains, but the rest of the
details have been moved into separate patches that we
can continue to maintain out-of-tree, and I've been able
to verify that with those patches applied, the result
still implements the DMAPI support we need.

I would like to get some feedback on these changes, and
hopefully get agreement that the result is an acceptable
compromise that *nearly* eliminates the DMAPI code from
top-of-tree XFS.  I think there are a few more small things
that are DMAPI-specific that may need to be pulled out,
but what I have here gives a pretty good idea of what
I've set out to do.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
