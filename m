Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 591367F3F
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 19:04:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E6914AC003
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 17:04:26 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	JPyo1TiL5PMDHxHD for <xfs@oss.sgi.com>;
	Sun, 28 Jul 2013 17:04:22 -0700 (PDT)
Date: Mon, 29 Jul 2013 10:04:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: understanding speculative preallocation
Message-ID: <20130729000418.GB13468@dastard>
References: <1374823420041-35002.post@n7.nabble.com>
	<20130726115021.GO13468@dastard>
	<CAA+BczQesNL2VmFmrcBNKXcM-Sfx0bXkXPRP5xMx6=Bv+NWrUA@mail.gmail.com>
	<51F2CD8B.8080207@hardwarefreak.com>
	<CAA+BczQGYoJVL0twvz2GRhH30teFPSJOsKWtofbXBrom4_Q6hg@mail.gmail.com>
	<20130726205018.GM3111@sgi.com>
	<CAA+BczSpn7Cu2rZWJ9Q2b1-Xh0365R9ykGxKHHymtRm2Q7xCuA@mail.gmail.com>
	<CAA+BczTt-ZN7DU8gpWAY0SdL0KWL2Z_y8qKvmxMn7b+T9frK4Q@mail.gmail.com>
	<20130727013024.GS13468@dastard>
	<CAA+BczTywXKd_76dAtT9DkSk=zKdoFOjHfXzF+bhrj_F54DnJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA+BczTywXKd_76dAtT9DkSk=zKdoFOjHfXzF+bhrj_F54DnJQ@mail.gmail.com>
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

On Sat, Jul 27, 2013 at 10:19:17PM -0400, Jason Rosenberg wrote:
> Thanks Dave,
> 
> The automatic prealloc removal, if no new writes after 5 minutes, sounds
> perfect for my use case.  But realistically, I'm not likely to get our org
> to push/find an os update just for this purpose too easily.
> 
> So, in the meantime, the question remains, assuming I have the version I
> have currently (dynamic preallocation, persists indefinitely until the file
> is closed/app quits, etc.), will this idea work (e.g. close the file after
> writing, then re-open read-only?). 

Maybe, maybe not. depends on whether the "don't remove prealloc"
heuristic was triggered at any time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
