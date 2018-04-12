Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:37109 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752170AbeDLXgH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Apr 2018 19:36:07 -0400
Date: Fri, 13 Apr 2018 09:36:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: New rash of fuzzer bugs on kernel.org bugzilla
Message-ID: <20180412233605.GC5572@dastard>
References: <0bdeb0e5-fd1d-a4d8-1a1a-f9371b829026@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bdeb0e5-fd1d-a4d8-1a1a-f9371b829026@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, wen.xu@gatech.edu

On Thu, Apr 12, 2018 at 03:42:41PM -0500, Eric Sandeen wrote:
> behold:
> 
> https://bugzilla.kernel.org/buglist.cgi?bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&component=XFS&email1=wen.xu%40gatech.edu&emailreporter1=1&emailtype1=substring&known_name=XFS%20bugs&list_id=983189&product=File%20System&query_based_on=XFS%20bugs&query_format=advanced
> 
> the return of the fuzzer.
> 
> If you were looking for something to do on xfs and wanted a
> self-contained reproducible bug with a testcase, well, there you
> go!
> 
> (I'm not sure who gets email from kernel.org bugzilla; I'd
> encourage anyone who works on xfs to keep an eye on the kernel.org
> bugzilla one way or another - but anyway, figured I'd highlight
> these.)

Nobody, I think. I'm betting it's still trying to send to the old
list, or maybe even xfs-masters....

> Wen, I think we need to find ways for you to help us help you, as
> well.  Turning a crank on a fuzzer and sending the bugs off to us
> for triage will only go so far and so fast, as we have limited
> resources as well.
> 
> One of the most recent bugs filed, which you say does not
> reproduce on 4.16 but does on 4.15 - honestly, we work on
> upstream.  Distros and others need to look after older kernels if
> they care.  If /you/ care, then I'd propose bisecting to find
> which commit made the problem go away, and propose it for -stable
> if it looks clearly like a bugfix, and cc: the list.  If you
> really don't care, then I'd say close the bug and only file
> against current upstream kernels.
> 
> As for the rest, in general, there are other things that can
> help:
> 
> Use CONFIG_FRAME_POINTER so that backtraces are readable
> Be sure to include the full relevant dmesg, everything after the mount message
> Include your full config so we know which debugging options are on or off
> Put some effort into your "poc.c" so you can say /which/ action triggered the flaw.
> Run with a debug kernel to catch use after free, etc.

FWIW, I'm not that interested in fuzzing v4 filesystems. We know
they have problems with undetected bit errors and are lacking in
information on disk to detect a lot of error types. Hence there's
only so much we can do to harden them.

As such, I'm much more interested in fuzzers that find problems on
v5 filesystems, because they have more substantial validation checks
and random bit errors are caught by CRC validation. V4 formats are
essentially a legacy format at this point, so while they may point
out problems in the format and the limitations of v4 format
verification, those issues might not even exist on v5 format
filesystems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
