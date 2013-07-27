Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1CA227F6A
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 20:30:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 013148F8035
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 18:30:29 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	cRfHU0H80ZAPEWvB for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 18:30:28 -0700 (PDT)
Date: Sat, 27 Jul 2013 11:30:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: understanding speculative preallocation
Message-ID: <20130727013024.GS13468@dastard>
References: <1374823420041-35002.post@n7.nabble.com>
	<20130726115021.GO13468@dastard>
	<CAA+BczQesNL2VmFmrcBNKXcM-Sfx0bXkXPRP5xMx6=Bv+NWrUA@mail.gmail.com>
	<51F2CD8B.8080207@hardwarefreak.com>
	<CAA+BczQGYoJVL0twvz2GRhH30teFPSJOsKWtofbXBrom4_Q6hg@mail.gmail.com>
	<20130726205018.GM3111@sgi.com>
	<CAA+BczSpn7Cu2rZWJ9Q2b1-Xh0365R9ykGxKHHymtRm2Q7xCuA@mail.gmail.com>
	<CAA+BczTt-ZN7DU8gpWAY0SdL0KWL2Z_y8qKvmxMn7b+T9frK4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA+BczTt-ZN7DU8gpWAY0SdL0KWL2Z_y8qKvmxMn7b+T9frK4Q@mail.gmail.com>
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
To: Jason Rosenberg <jbr@squareup.com>
Cc: Ben Myers <bpm@sgi.com>, stan@hardwarefreak.com, xfs@oss.sgi.com

On Fri, Jul 26, 2013 at 05:11:55PM -0400, Jason Rosenberg wrote:
> Is it safe to say that speculative preallocation will not be used if a file
> is opened read-only?
> 
> It turns out that the kafka server does indeed write lots of log files, and
> rotate them after they reach a max size, but never closes the files until
> the app exits, or until it deletes the files.  This is because it needs to
> make them available for reading, etc.   So, an obvious change for kafka
> might be to close each log file after rotating, and then re-open it
> read-only for consumers of the data.  Does that sound like a solution that
> would pro-actively release pre-allocated storage?

No need - the mainline code that has a periodic background scan that
stops buildup of unused prealocation. i.e. if the file is clean for
5 minutes, then the prealloc will be removed. Hence it doesn't
matter what the application does with it - if it holds it open and
doesn't write to the file, then the prealloc will get removed. More
will be added the next time the file is written, but until then it
won't use excessive space.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
